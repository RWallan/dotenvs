#!/usr/bin/env bash
#
# Prepara um Arch Linux novo (nativo ou WSL) para estes dotfiles:
#   - instala o yay (se faltar), as ferramentas de dev e os pré-requisitos dos plugins
#   - Python (pyenv + uv + pipx: poetry, posting, harlequin), Rust (rustup), Go, Node
#   - lazygit, lazydocker, docker, yazi (com previews), gh, terraform, oh-my-posh...
#   - linka os dotfiles com GNU stow (fazendo backup do que já existir)
#   - instala plugins do Neovim (lockfile), parsers do treesitter e ferramentas do Mason
#   - instala os plugins do tmux via TPM
#
# Uso: ./setup_arch.sh [opções]
#   --desktop      também instala/linka o ambiente gráfico (i3, polybar...); ignorado no WSL
#   --cloud        instala aws-cli, azure-cli e google-cloud-cli
#   --no-docker    não instala o docker nativo (ex.: vai usar o Docker Desktop no WSL)
#   --no-link      não cria os symlinks dos dotfiles
#   --no-nvim      não roda o bootstrap headless do Neovim/tmux
#
# Versões do Python (a primeira vira a global):
#   PYTHON_VERSIONS="3.14 3.13 3.12" ./setup_arch.sh
#
# WSL recém-instalado (abre como root, sem usuário comum):
#   1. como root:    ./setup_arch.sh --user <nome>
#      (instala sudo, gera locale, cria o usuário e o define como padrão no WSL)
#   2. no Windows:   wsl --terminate <distro>   e abra o Arch de novo
#   3. como usuário: ~/dotenvs/setup_arch.sh

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
PYTHON_VERSIONS="${PYTHON_VERSIONS:-3.14 3.13 3.12}"
PIPX_TOOLS=(poetry posting harlequin)

WITH_DESKTOP=false
WITH_CLOUD=false
WITH_DOCKER=true
WITH_LINK=true
WITH_NVIM=true
NEW_USER=""

while (($#)); do
	case "$1" in
	--desktop) WITH_DESKTOP=true ;;
	--cloud) WITH_CLOUD=true ;;
	--no-docker) WITH_DOCKER=false ;;
	--no-link) WITH_LINK=false ;;
	--no-nvim) WITH_NVIM=false ;;
	--user)
		NEW_USER="${2:-}"
		[[ -n "$NEW_USER" ]] || {
			echo "--user precisa de um nome" >&2
			exit 1
		}
		shift
		;;
	-h | --help)
		sed -n '2,25p' "$0" | sed 's/^# \{0,1\}//'
		exit 0
		;;
	*)
		echo "Opção desconhecida: $1" >&2
		exit 1
		;;
	esac
	shift
done

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
info() { printf '\n\033[1;35m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m[aviso] %s\033[0m\n' "$*"; }
FAILED=()
NOTES=()

IS_WSL=false
if [[ -n "${WSL_DISTRO_NAME:-}" ]] || grep -qi microsoft /proc/sys/kernel/osrelease 2>/dev/null; then
	IS_WSL=true
fi

if ! command -v pacman &>/dev/null; then
	echo "Este script é para Arch Linux (pacman não encontrado)." >&2
	exit 1
fi

# ---------------------------------------------------------------------------
# WSL: bootstrap como root (imagem nova não tem usuário comum nem sudo)
# ---------------------------------------------------------------------------
wsl_root_bootstrap() {
	local user="$1"

	info "WSL: inicializando chaves do pacman"
	if [[ ! -f /etc/pacman.d/gnupg/pubring.gpg && ! -f /etc/pacman.d/gnupg/pubring.kbx ]]; then
		pacman-key --init
		pacman-key --populate archlinux
	fi
	pacman -Sy --needed --noconfirm archlinux-keyring

	info "WSL: atualizando sistema e instalando sudo/base-devel/git"
	pacman -Syu --needed --noconfirm sudo base-devel git

	info "WSL: gerando locales (en_US.UTF-8 e pt_BR.UTF-8)"
	sed -i -E 's/^#(en_US\.UTF-8 UTF-8)/\1/; s/^#(pt_BR\.UTF-8 UTF-8)/\1/' /etc/locale.gen
	locale-gen
	[[ -f /etc/locale.conf ]] || echo "LANG=en_US.UTF-8" >/etc/locale.conf

	info "WSL: criando usuário $user"
	if ! id "$user" &>/dev/null; then
		useradd -m -G wheel -s /bin/bash "$user"
		echo "Defina a senha de $user (usada pelo sudo):"
		passwd "$user"
	else
		usermod -aG wheel "$user"
	fi
	echo '%wheel ALL=(ALL:ALL) ALL' >/etc/sudoers.d/10-wheel
	chmod 440 /etc/sudoers.d/10-wheel
	visudo -cf /etc/sudoers.d/10-wheel >/dev/null

	info "WSL: configurando /etc/wsl.conf (usuário padrão e systemd)"
	cat >/etc/wsl.conf <<-EOF
		[boot]
		systemd=true

		[user]
		default=$user
	EOF

	local dest="/home/$user/dotenvs"
	if [[ "$DOTFILES_DIR" != "$dest" && ! -e "$dest" ]]; then
		info "WSL: copiando os dotfiles para $dest"
		cp -a "$DOTFILES_DIR" "$dest"
		chown -R "$user:$user" "$dest"
	fi

	info "Bootstrap concluído"
	echo "Agora, no PowerShell/CMD do Windows:  wsl --terminate ${WSL_DISTRO_NAME:-<distro>}"
	echo "Abra o Arch novamente (já como $user) e rode:  ~/dotenvs/setup_arch.sh"
}

if [[ $EUID -eq 0 ]]; then
	if $IS_WSL && [[ -n "$NEW_USER" ]]; then
		wsl_root_bootstrap "$NEW_USER"
		exit 0
	fi
	echo "Rode como usuário normal (o script usa sudo quando precisa)." >&2
	$IS_WSL && echo "No WSL recém-instalado, rode primeiro como root: $0 --user <nome>" >&2
	exit 1
fi

if $IS_WSL; then
	if $WITH_DESKTOP; then
		warn "--desktop ignorado no WSL"
		WITH_DESKTOP=false
	fi
	if [[ "$DOTFILES_DIR" == /mnt/* ]]; then
		warn "Os dotfiles estão em $DOTFILES_DIR (disco do Windows): o Neovim ficará lento."
		warn "Prefira clonar o repositório dentro do Linux, ex.: ~/dotenvs"
	fi
fi

# ---------------------------------------------------------------------------
# Pacotes
# ---------------------------------------------------------------------------

# Ferramentas básicas de build/download (Mason, lazy.nvim, treesitter, yay)
BASE_PKGS=(
	base-devel git curl wget unzip zip tar gzip
	stow lsof procps-ng which less
)

# Neovim e dependências dos plugins
NVIM_PKGS=(
	neovim
	tree-sitter-cli # nvim-treesitter (branch main) compila os parsers com ele
	gcc make        # telescope-fzf-native, parsers do treesitter
	ripgrep fd      # telescope live_grep / find_files
	opencode        # opencode.nvim
)

# Linguagens
LANG_PKGS=(
	# Python: pyenv compila as versões (precisa das libs abaixo); uv e pipx para ferramentas
	python python-pip pyenv uv python-pipx
	openssl zlib xz bzip2 readline sqlite libffi tk
	# Rust: toolchain via rustup (blink.cmp também compila com cargo)
	rustup
	# Go: gopls/gofumpt/goimports/golangci-lint vêm do Mason
	go
	# Node: Svelte e LSPs do Mason (ts_ls, svelte, eslint, prettierd...)
	nodejs npm pnpm
)

# Ferramentas de terminal
TOOLS_PKGS=(
	tmux bash-completion
	eza bat fzf zoxide fastfetch
	lazygit lazydocker github-cli terraform
	# yazi + dependências de preview (imagens, vídeo, pdf, arquivos compactados)
	yazi file 7zip jq poppler ffmpeg imagemagick resvg chafa
)

DOCKER_PKGS=(docker docker-compose docker-buildx)

CLOUD_PKGS=(aws-cli-v2 azure-cli)

# AUR
AUR_PKGS=(
	claude-code    # claude-code.nvim
	oh-my-posh-bin # prompt (bash/.bashrc.evals)
)
$WITH_CLOUD && AUR_PKGS+=(google-cloud-cli)

if $IS_WSL; then
	# Clipboard via Windows (o Neovim detecta win32yank.exe sozinho) e
	# wslview para abrir links/login (claude, opencode, gh) no navegador do Windows.
	# A Nerd Font precisa ser instalada no Windows, não aqui.
	AUR_PKGS+=(win32yank-bin wslu)
else
	NVIM_PKGS+=(
		xclip wl-clipboard # clipboard=unnamedplus
		ttf-meslo-nerd     # vim.g.have_nerd_font / ícones
	)
	TOOLS_PKGS+=(xorg-setxkbmap)
fi

# Ambiente gráfico (i3, polybar, picom, alacritty)
DESKTOP_PKGS=(
	i3-wm i3lock xss-lock dex dmenu
	polybar picom feh alacritty
	network-manager-applet brightnessctl libpulse
	gnome-screenshot qutebrowser
	xorg-xrandr
)

STOW_PKGS=(bash nvim tmux posh yazi)
DESKTOP_STOW_PKGS=(alacritty i3 polybar picom backgrounds)

# Mantém o sudo vivo durante a execução
sudo -v
while true; do
	sudo -n true
	sleep 50
	kill -0 "$$" 2>/dev/null || exit
done 2>/dev/null &

# ---------------------------------------------------------------------------
# Sistema + yay
# ---------------------------------------------------------------------------
info "Atualizando o sistema e instalando o básico"
sudo pacman -Syu --needed --noconfirm "${BASE_PKGS[@]}"

if ! command -v yay &>/dev/null; then
	info "Instalando yay"
	tmp="$(mktemp -d)"
	git clone --depth 1 https://aur.archlinux.org/yay-bin.git "$tmp/yay-bin"
	(cd "$tmp/yay-bin" && makepkg -si --noconfirm)
	rm -rf "$tmp"
	yay -Y --gendb
fi

# ---------------------------------------------------------------------------
# Pacotes
# ---------------------------------------------------------------------------
info "Instalando Neovim, linguagens e ferramentas"
REPO_PKGS=("${NVIM_PKGS[@]}" "${LANG_PKGS[@]}" "${TOOLS_PKGS[@]}")
$WITH_DESKTOP && REPO_PKGS+=("${DESKTOP_PKGS[@]}")
$WITH_CLOUD && REPO_PKGS+=("${CLOUD_PKGS[@]}")
yay -S --needed --noconfirm "${REPO_PKGS[@]}"

info "Instalando pacotes do AUR"
for pkg in "${AUR_PKGS[@]}"; do
	if ! yay -S --needed --noconfirm "$pkg"; then
		warn "Falha ao instalar $pkg"
		FAILED+=("$pkg")
	fi
done

# ---------------------------------------------------------------------------
# Docker
# ---------------------------------------------------------------------------
if $WITH_DOCKER; then
	if command -v docker &>/dev/null && ! pacman -Qq docker &>/dev/null; then
		info "Docker já disponível fora do pacman (ex.: Docker Desktop); pulando"
	else
		info "Instalando Docker"
		yay -S --needed --noconfirm "${DOCKER_PKGS[@]}"
		if [[ -d /run/systemd/system ]]; then
			sudo systemctl enable --now docker.service
		else
			warn "systemd não está ativo: o serviço do docker não foi habilitado"
			$IS_WSL && warn "No WSL, adicione '[boot] systemd=true' em /etc/wsl.conf e reinicie a distro"
		fi
		if ! id -nG "$USER" | grep -qw docker; then
			sudo usermod -aG docker "$USER"
			NOTES+=("Você foi adicionado ao grupo docker: faça logout/login para usar sem sudo.")
		fi
	fi
fi

# ---------------------------------------------------------------------------
# Rust
# ---------------------------------------------------------------------------
info "Configurando Rust (stable + rust-analyzer, rustfmt, clippy, rust-src)"
if ! rustup default &>/dev/null; then
	rustup default stable
else
	rustup update stable
fi
rustup component add rust-analyzer rustfmt clippy rust-src

# ---------------------------------------------------------------------------
# Python
# ---------------------------------------------------------------------------
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin:$PATH"

info "Python: instalando versões via pyenv ($PYTHON_VERSIONS)"
GLOBAL_PY=""
for v in $PYTHON_VERSIONS; do
	full="$(pyenv latest -k "$v" 2>/dev/null || true)"
	if [[ -z "$full" ]]; then
		warn "pyenv não conhece a versão $v"
		FAILED+=("python:$v")
		continue
	fi
	if pyenv install -s "$full"; then
		[[ -n "$GLOBAL_PY" ]] || GLOBAL_PY="$full"
	else
		FAILED+=("python:$full")
	fi
done
[[ -n "$GLOBAL_PY" ]] && pyenv global "$GLOBAL_PY" && echo "  pyenv global: $GLOBAL_PY"

info "Python: instalando ferramentas via pipx (${PIPX_TOOLS[*]})"
# Usa o Python do sistema (não o do pyenv), para não quebrar quando uma versão do pyenv for removida
for tool in "${PIPX_TOOLS[@]}"; do
	if pipx list --short 2>/dev/null | grep -q "^$tool "; then
		pipx upgrade "$tool" || true
	else
		pipx install --python /usr/bin/python "$tool" || FAILED+=("pipx:$tool")
	fi
done

if command -v poetry &>/dev/null; then
	poetry config virtualenvs.prompt "{project_name}"
	poetry config virtualenvs.in-project true
fi

$IS_WSL || fc-cache -f >/dev/null

# ---------------------------------------------------------------------------
# Dotfiles
# ---------------------------------------------------------------------------
link_pkg() {
	local pkg="$1" rel target
	# Move arquivos reais que conflitariam com o stow para o backup
	while IFS= read -r -d '' file; do
		rel="${file#"$DOTFILES_DIR/$pkg/"}"
		target="$HOME/$rel"
		if [[ -e "$target" && ! -L "$target" ]]; then
			mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
			mv "$target" "$BACKUP_DIR/$rel"
			echo "  backup: ~/$rel"
		fi
	done < <(find "$DOTFILES_DIR/$pkg" \( -type f -o -type l \) -not -name .gitkeep -print0)

	stow --dir="$DOTFILES_DIR" --target="$HOME" --restow --ignore='\.gitkeep' "$pkg"
	echo "  linkado: $pkg"
}

if $WITH_LINK; then
	info "Linkando dotfiles com stow"
	# Garante que ~/.config seja um diretório real (senão o stow o transformaria num symlink)
	mkdir -p "$HOME/.config"
	PKGS=("${STOW_PKGS[@]}")
	$WITH_DESKTOP && PKGS+=("${DESKTOP_STOW_PKGS[@]}")
	for pkg in "${PKGS[@]}"; do
		link_pkg "$pkg" || {
			warn "Falha ao linkar $pkg"
			FAILED+=("stow:$pkg")
		}
	done
	if [[ -d "$BACKUP_DIR" ]]; then
		NOTES+=("Arquivos antigos salvos em $BACKUP_DIR (leve o que for da máquina para ~/.bashrc.local).")
	fi

	if [[ ! -e "$HOME/.bashrc.local" ]]; then
		cat >"$HOME/.bashrc.local" <<-'EOF'
			# Configurações desta máquina e segredos (tokens, senhas, PATHs específicos).
			# Este arquivo NÃO é versionado: é carregado no fim do ~/.bashrc.
		EOF
		chmod 600 "$HOME/.bashrc.local"
	fi
fi

# ---------------------------------------------------------------------------
# tmux (TPM)
# ---------------------------------------------------------------------------
if $WITH_NVIM; then
	info "Instalando plugins do tmux (TPM)"
	TPM_DIR="$HOME/.tmux/plugins/tpm"
	[[ -d "$TPM_DIR" ]] || git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
	if [[ -f "$HOME/.tmux.conf" ]]; then
		"$TPM_DIR/bin/install_plugins" || FAILED+=("tpm")
	else
		warn "~/.tmux.conf não encontrado; rode prefix + I dentro do tmux depois"
	fi
fi

# ---------------------------------------------------------------------------
# Neovim
# ---------------------------------------------------------------------------
if $WITH_NVIM; then
	if [[ ! -f "$HOME/.config/nvim/init.lua" ]]; then
		warn "~/.config/nvim não está configurado; pulando bootstrap do Neovim"
	else
		info "Neovim: instalando plugins na versão do lazy-lock.json (inclui build do blink.cmp)"
		nvim --headless "+Lazy! restore" +qa || FAILED+=("nvim:lazy")

		info "Neovim: instalando parsers do treesitter (lua/parsers.lua)"
		nvim --headless \
			-c "lua require('nvim-treesitter').install(require('parsers')):wait(600000)" \
			-c qa || FAILED+=("nvim:treesitter")

		info "Neovim: instalando LSPs, formatters e linters via Mason"
		nvim --headless \
			-c "Lazy! load nvim-lspconfig" \
			-c "MasonToolsInstallSync" \
			-c qa || FAILED+=("nvim:mason")
	fi
fi

# ---------------------------------------------------------------------------
# Resumo
# ---------------------------------------------------------------------------
info "Concluído"
if $IS_WSL; then
	NOTES+=("WSL: instale a fonte 'MesloLGS Nerd Font Mono' no Windows e selecione-a no perfil do Arch no Windows Terminal.")
fi
NOTES+=("Abra um novo terminal (ou faça logout/login) para carregar o PATH e o .bashrc.")
NOTES+=("Valide com ':checkhealth' no Neovim.")
for note in "${NOTES[@]}"; do
	echo "- $note"
done

if ((${#FAILED[@]})); then
	warn "Etapas com falha: ${FAILED[*]}"
	exit 1
fi
