#!/usr/bin/env bash
#
# Ponto de entrada dos dotfiles: instala o Ansible e roda ansible/site.yml.
#
# Uso (como usuário comum; a senha do sudo é pedida uma vez):
#   ./bootstrap.sh                         # tudo
#   ./bootstrap.sh --tags dotfiles         # só uma parte (veja --list-tags)
#   ./bootstrap.sh -e desktop=none         # sobrescreve opções de ansible/group_vars/all.yml
#   ./bootstrap.sh --check --diff          # simula
# Qualquer argumento é repassado ao ansible-playbook.
#
# WSL recém-instalado (abre como root, sem usuário comum nem sudo):
#   1. como root:    ./bootstrap.sh --user <nome>
#      (instala sudo/python, gera locales, cria o usuário e o define como padrão no WSL)
#   2. no Windows:   wsl --terminate <distro>   e abra o Arch de novo
#   3. como usuário: ~/dotenvs/bootstrap.sh

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info() { printf '\n\033[1;35m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m[aviso] %s\033[0m\n' "$*" >&2; }
die() {
	printf '\033[1;31m[erro] %s\033[0m\n' "$*" >&2
	exit 1
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
	sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'
	exit 0
fi

command -v pacman &>/dev/null || die "Este repositório é para Arch Linux (pacman não encontrado)."

IS_WSL=false
if [[ -n "${WSL_DISTRO_NAME:-}" ]] || grep -qi microsoft /proc/sys/kernel/osrelease 2>/dev/null; then
	IS_WSL=true
fi

# ---------------------------------------------------------------------------
# WSL novo: bootstrap como root (cria o usuário que vai rodar o Ansible)
# ---------------------------------------------------------------------------
wsl_root_bootstrap() {
	local user="$1"

	info "WSL: inicializando chaves do pacman"
	if [[ ! -f /etc/pacman.d/gnupg/pubring.gpg && ! -f /etc/pacman.d/gnupg/pubring.kbx ]]; then
		pacman-key --init
		pacman-key --populate archlinux
	fi
	pacman -Sy --needed --noconfirm archlinux-keyring

	info "WSL: atualizando o sistema e instalando sudo, git e python"
	pacman -Syu --needed --noconfirm sudo base-devel git python

	info "WSL: gerando locales (en_US.UTF-8 e pt_BR.UTF-8)"
	sed -i -E 's/^#(en_US\.UTF-8 UTF-8)/\1/; s/^#(pt_BR\.UTF-8 UTF-8)/\1/' /etc/locale.gen
	locale-gen
	[[ -f /etc/locale.conf ]] || echo "LANG=en_US.UTF-8" >/etc/locale.conf

	info "WSL: criando o usuário $user"
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

	info "WSL: configurando /etc/wsl.conf (systemd e usuário padrão)"
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
	echo "No PowerShell do Windows:  wsl --terminate ${WSL_DISTRO_NAME:-<distro>}"
	echo "Abra o Arch de novo (já como $user) e rode:  ~/dotenvs/bootstrap.sh"
}

if [[ $EUID -eq 0 ]]; then
	if $IS_WSL && [[ "${1:-}" == "--user" && -n "${2:-}" ]]; then
		wsl_root_bootstrap "$2"
		exit 0
	fi
	$IS_WSL && warn "WSL recém-instalado? Rode primeiro como root: $0 --user <nome>"
	die "Rode como usuário comum (o Ansible usa sudo quando precisa)."
fi

if $IS_WSL && [[ "$DOTFILES_DIR" == /mnt/* ]]; then
	warn "Os dotfiles estão em $DOTFILES_DIR (disco do Windows): o Neovim ficará lento."
	warn "Prefira clonar o repositório dentro do Linux, ex.: ~/dotenvs"
fi

# ---------------------------------------------------------------------------
# Ansible
# ---------------------------------------------------------------------------
if ! command -v ansible-playbook &>/dev/null; then
	info "Instalando o Ansible"
	sudo pacman -S --needed --noconfirm ansible-core python
fi

cd "$DOTFILES_DIR/ansible"

info "Instalando as coleções do Ansible (requirements.yml)"
ansible-galaxy collection install -r requirements.yml

# Pede a senha do sudo uma vez, a menos que o comando não precise dela
ask_pass=(--ask-become-pass)
for arg in "$@"; do
	case "$arg" in
	-K | --ask-become-pass | --list-tags | --list-tasks | --syntax-check) ask_pass=() ;;
	esac
done

info "Rodando o playbook"
exec ansible-playbook site.yml "${ask_pass[@]}" "$@"
