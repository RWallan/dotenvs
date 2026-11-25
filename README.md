# dotenvs

Meu ambiente de desenvolvimento em **Arch Linux**, nativo (desktop **Hyprland**) ou no
**WSL**. Os pacotes são provisionados com **Ansible** e os dotfiles são gerenciados com
**dotdrop**.

Inspirações:

- [O Melhor Setup de Desenvolvimento com Arch Linux + Hyprland](https://www.youtube.com/watch?v=CpUUTC68rLA)
  (Caio Perlin): Hyprland, kitty, wofi, waybar, hyprpaper, Starship, fzf, JetBrains Mono.
- [Ansible lab](https://ansible.dunossauro.com/) (dunossauro): inventário, playbooks,
  variáveis, `when` com fatos, `import_tasks`, handlers e Ansible Galaxy.

## Estrutura

```
dotenvs/
├── bootstrap.sh            # ponto de entrada: instala o Ansible e roda o playbook
├── archinstall/config.json # instalação mínima do Arch nativo, pronta para o bootstrap
├── config.yaml             # dotdrop: dotfiles e perfis (base, wsl, hyprland)
├── dotfiles/
│   ├── home/               # -> ~/        (bashrc, bash_profile, inputrc, tmux.conf...)
│   └── config/             # -> ~/.config (nvim, hypr, waybar, kitty, ripgrep...)
└── ansible/
    ├── site.yml            # playbook principal (roles + tags)
    ├── group_vars/all.yml  # opções: desktop, docker, cloud, versões do Python...
    ├── inventory/          # localhost (dá para adicionar máquinas via SSH)
    ├── requirements.yml    # coleções do Galaxy (community.general, kewlfft.aur...)
    └── roles/              # base, wsl, languages, cli, docker, cloud,
                            # hyprland, dotfiles, neovim
```

### Perfis do dotdrop

Todo dotfile é instalado como **symlink relativo** para o repositório: editar
`~/.config/...` edita o repositório.

| Perfil | Dotfiles |
| --- | --- |
| `base` | bash, readline (`~/.inputrc`), tmux, Neovim, yazi, Starship, ripgrep |
| `wsl` | `base` |
| `hyprland` | `base` + hypr, waybar, wofi, kitty, papel de parede |

O Ansible grava `DOTDROP_CONFIG` e `DOTDROP_PROFILE` no `~/.bashrc.local`, então no
dia a dia basta:

```bash
dotdrop compare     # o que difere entre a $HOME e o repositório
dotdrop install     # (re)instala os dotfiles do perfil
dotdrop files       # lista os dotfiles do perfil
```

Para adicionar um dotfile novo: `dotdrop import ~/.config/<app> -l relative`.
Depois inclua a chave criada no perfil certo do `config.yaml`.

### Roles do Ansible

| Role (tag) | O que faz |
| --- | --- |
| `base` | `pacman -Syu`, pacotes básicos, usuário `aur_builder` e `yay` |
| `wsl` | `wslu` (abrir links no Windows), `win32yank` (clipboard), `/etc/wsl.conf` |
| `languages` | pyenv + versões do Python, uv, pipx (posting, harlequin), Rust, Go, Node |
| `cli` | tmux, starship, eza, bat, fzf, fd, ripgrep, zoxide, lazygit, gh, terraform, yazi (previews leves)... |
| `docker` | Arch nativo: instala o Docker. WSL: verifica o Docker Desktop. Falhas viram **aviso** e o playbook segue |
| `cloud` | aws-cli, azure-cli, google-cloud-cli (desligado por padrão) |
| `hyprland` (`desktop`) | Hyprland e o equivalente de cada peça do i3 (ver abaixo); previews pesados do yazi |
| `dotfiles` | dotdrop: backup do que conflitar, instalação do perfil, `~/.bashrc.local`; remove o oh-my-posh antigo |
| `neovim` (`nvim`) | Neovim, plugins do lazy-lock, treesitter, Mason, TPM do tmux, Claude Code |

O que já foi instalado por fora não é reinstalado pelo pacman: `pyenv` via git, `uv` e
`rustup` via `curl | sh`, o `claude` nativo, o `yay` e o tarball do Google Cloud SDK.
Ferramentas na `~/.local/bin`, como o `agy`, continuam no PATH.

## Passo a passo

### A) WSL que já está em uso (esta máquina)

> O repositório precisa estar **dentro do Linux** (ex.: `~/dotenvs`), não em `/mnt/c`.

1. **Atualize o repositório**

   ```bash
   cd ~/dotenvs && git pull
   ```

2. **(Opcional) Simule antes**: mostra o que mudaria, sem mudar nada

   ```bash
   ./bootstrap.sh --check --diff
   ```

3. **Rode o bootstrap**: a senha do sudo é pedida uma vez

   ```bash
   ./bootstrap.sh
   ```

   - O desktop é ignorado no WSL e o Docker é pulado (vem do Docker Desktop).
   - O que estiver no caminho dos dotfiles vai para `~/.dotfiles-backup/<data>/`:
     `~/.bashrc`, `~/.bash_profile` e links antigos.
   - Os `export` de segredos do `.bashrc` antigo são copiados para o `~/.bashrc.local`
     (permissão `600`, fora do git). Contam os nomes com `TOKEN`, `KEY`, `SECRET`, `PASS`
     ou `PWD`.

4. **Revise o que foi para o backup**

   ```bash
   cat ~/.bashrc.local
   diff ~/.dotfiles-backup/*/.bashrc ~/.bashrc
   ```

   Não precisa levar o que já está no repositório: pyenv, `~/.local/bin`,
   `~/.cargo/env`, Google Cloud SDK, `EDITOR`/`VISUAL`, aliases `lg`, `d` e `pshell`.
   O `~/.profile` deixa de ser lido e pode ser apagado.

5. **Abra um terminal novo** (feche as abas antigas do WSL). O tmux abre sozinho.

6. **Windows Terminal**: instale a **JetBrainsMono Nerd Font** (ou MesloLGS) no Windows e
   selecione-a no perfil do Arch (Configurações → Arch → Aparência → Fonte).

7. **Valide**

   ```bash
   echo "$PATH" | tr : '\n'          # sem /mnt/c; termina em ~/.local/share/wsl-winbin
   time (compgen -c > /dev/null)      # < 1 s (antes: ~28 s)
   type cd ls cat                     # cd = função do zoxide; ls = eza; cat = bat
   dotdrop compare                    # nada a mostrar
   ```

   No Neovim: `:checkhealth`.

### B) WSL novo (do zero)

```bash
# 1. como root (a imagem do Arch no WSL não tem usuário nem sudo)
pacman -Sy --needed git
git clone https://github.com/RWallan/dotenvs.git
./dotenvs/bootstrap.sh --user <nome>

# 2. no PowerShell do Windows
wsl --terminate archlinux

# 3. abra o Arch de novo (já como <nome>)
~/dotenvs/bootstrap.sh
```

### C) Arch nativo com Hyprland (do zero, com archinstall)

O `archinstall/config.json` instala só o mínimo para o Ansible assumir no primeiro login:

- **Sistema:** perfil `Minimal`, kernel `linux`, systemd-boot (UEFI) e zram.
- **Rede:** NetworkManager, para ter internet no primeiro boot.
- **Pacotes extras:** apenas `git` e `ansible-core`.
- **Ajustes:** teclado ABNT2, fuso de São Paulo e locales `en_US`/`pt_BR`.
- **Repositório:** já clonado em `~/dotenvs`.

Desktop, áudio, fontes e ferramentas ficam com o Ansible. **Disco e senhas não estão no
arquivo**: o archinstall pede esses dados no menu, para nunca apagar o disco errado nem
publicar senha.

1. **Dê boot na ISO do Arch** e conecte-se à internet. No cabo é automático; no Wi-Fi:

   ```bash
   iwctl station wlan0 connect "<rede>"
   ```

2. **Rode o archinstall com a config do repositório** (atualize-o antes; a config é da
   versão 4.5):

   ```bash
   pacman -Sy archinstall
   archinstall --config-url https://raw.githubusercontent.com/RWallan/dotenvs/main/archinstall/config.json
   ```

3. **No menu, preencha só o que falta:**
   - **Disk configuration** → *Use a best-effort default partition layout* → escolha o
     disco (ext4 ou btrfs).
   - **Authentication** → senha do root e **um usuário marcado como superuser** (sudo).
     O usuário criado é o que recebe o `~/dotenvs`.
   - **Install**.

4. **Reinicie, entre com o seu usuário no TTY** e rode o bootstrap:

   ```bash
   nmtui                  # só se for Wi-Fi: conecta a rede pelo NetworkManager
   ~/dotenvs/bootstrap.sh
   ```

5. **Saia e entre de novo no TTY1**: o `~/.bash_profile` abre o Hyprland
   (`start-hyprland`). Para não abrir, use outro TTY (Ctrl+Alt+F2).
6. Ajuste o monitor em `dotfiles/config/hypr/hyprland.lua` se precisar (`hyprctl monitors`).

> O perfil `Minimal` não instala driver de vídeo. Intel e AMD funcionam com o `mesa`, que
> vem como dependência do Hyprland. Para NVIDIA, instale `nvidia-open` (placas Turing ou
> mais novas) e veja a página de NVIDIA do wiki do Hyprland.

## Desktop Hyprland = o antigo i3

O i3 foi removido do repositório (está no histórico do git). A config
(`dotfiles/config/hypr/hyprland.lua`) o replica e foi conferida automaticamente contra a
config antiga:

- **Atalhos:** todos os 58 atalhos globais existem, menos `SUPER+A`.
- **Modos:** os de resize e de saída são idênticos.
- **Visual:** sem gaps, borda de 1 px mauve, sem animações.
- **Mínimo como o i3:** sem daemon de notificações, sem agente polkit, sem tray.
- **Barra:** a waybar replica a polybar (embaixo, `VOL`/`BAT`/`RAM`/`CPU`, rede e hora).

| i3 | Hyprland |
| --- | --- |
| picom | embutido |
| polybar | waybar |
| dmenu_run | wofi |
| feh | hyprpaper |
| xss-lock + i3lock | hypridle + hyprlock |
| gnome-screenshot | hyprshot |
| alacritty | kitty |
| qutebrowser | Waterfox |
| `setxkbmap abnt-2 br` | `kb_layout = br`, `kb_model = abnt2` |

| Atalho | Ação |
| --- | --- |
| `SUPER + Enter` / `D` / `B` | terminal / executar (wofi) / navegador |
| `SUPER + SHIFT + Q` | fecha a janela |
| `SUPER + H J K L` (ou setas) | foco; com `SHIFT`, move a janela |
| `SUPER + 1..0` | workspace; com `SHIFT`, move a janela (sem segui-la) |
| `SUPER + F` / `SHIFT + espaço` | fullscreen / flutuante |
| `SUPER + E` | alterna a orientação do split |
| `SUPER + S` / `W` | stacking / tabbed (viram abas do Hyprland) |
| `SUPER + R` | modo resize (`HJKL`/setas; `Enter`, `Esc` ou `SUPER+R` sai) |
| `SUPER + SHIFT + E` | modo saída: (S)uspend, (L)ogout, (R)eboot, (P)oweroff |
| `SUPER + SHIFT + C` / `R` | recarrega a config |
| `SUPER` + arrastar com o mouse | move (botão esquerdo) / redimensiona (direito) |
| `Print` / `SUPER + Print` | screenshot da tela / de uma área (`~/Pictures/Screenshots`) |

Única diferença: `SUPER+A` (*focus parent*) não existe no Hyprland.

## Neovim

Um plugin, o **snacks.nvim**, faz o papel de busca, explorador de arquivos, dashboard,
guias de indentação, fechar buffers e lazygit, no lugar de telescope, neo-tree, alpha,
indent-blankline, bufdelete, bufferline e lazygit.nvim. Os atalhos continuam os mesmos:

- `<leader>f*`: busca (com `<leader>ft` para TODOs);
- `<leader>ee`: explorador;
- `<leader>gg`: lazygit;
- `<leader>bc` / `bC` / `ba`: fecha o buffer / os outros / todos;
- `[b` / `]b`: buffer anterior / próximo (nativos do Neovim 0.11+).

Deixaram de existir `<leader>bl`/`bh` (fechar à direita/esquerda), que dependiam da
bufferline.

## Shell: ferramentas no lugar dos comandos padrão

As substituições valem só no shell interativo (scripts usam os comandos originais). Cada
uma só é ativada se a ferramenta estiver instalada.

| Comando | Vira | Como usar |
| --- | --- | --- |
| `cd` | zoxide | `cd proj` pula para o diretório mais usado que casa com "proj"; `cdi` escolhe no fzf; caminhos normais funcionam como antes |
| `ls`, `ll`, `la`, `lt`, `tree` | eza | diretórios primeiro, ícones e status do git (`ll`); em pipes vira texto puro |
| `cat` | bat | syntax highlight no terminal; em pipes se comporta como `cat` |
| `man` | bat | man pages coloridas |
| `Ctrl-R` | fzf | busca difusa no histórico (`Ctrl-/` mostra o comando inteiro) |
| `Ctrl-T` / `Alt-C` | fzf + fd | escolhe um arquivo (com preview) / entra em um diretório (com árvore) |
| `<comando> **<Tab>` | fzf + fd | completa caminhos em qualquer comando (`nvim **<Tab>`, `cd **<Tab>`) |
| `↑` / `↓` | readline | buscam no histórico pelo que já foi digitado (`git ↑`) |
| `Tab` | readline | sem diferenciar maiúsculas, lista as opções na primeira vez |
| `Alt-Y` | yazi | abre o gerenciador de arquivos; ao sair, o shell fica na pasta escolhida |
| `rg` | ripgrep | smart-case e arquivos ocultos (menos `.git`); vale também no Neovim |

Dentro do tmux, o fzf abre como **popup**. Tudo usa o tema Catppuccin Mocha.

## Como o bash está organizado

| Arquivo | Função |
| --- | --- |
| `bash_profile` | shell de login: no TTY1 abre o Hyprland; senão carrega o `.bashrc` |
| `bashrc` | abre o tmux, carrega os arquivos abaixo e o `~/.bashrc.local` |
| `bashrc.envvars` | `PATH`, integração com o Windows (WSL), histórico, fzf, bat, less |
| `bashrc.aliases` | substitutos (eza, bat), `lg`, `pshell`... |
| `bashrc.functions` | `activate` (ativa o `.venv` mais próximo), `y` (yazi), fzf + fd |
| `bashrc.evals` | pyenv, fzf, zoxide, completions (uv, gcloud) e Starship, com cache |
| `inputrc` | readline: completion e busca no histórico |
| `~/.bashrc.local` | **não versionado**: segredos, ajustes da máquina e perfil do dotdrop |

Otimizações:

- **WSL: PATH do Windows fora do shell.** O WSL anexa todo o PATH do Windows
  (`/mnt/c/...`), e o tab-completion de comandos levava ~28 s. Agora só os `.exe` usados
  ficam disponíveis, via symlinks em `~/.local/share/wsl-winbin`. Completion: ~0,2 s.
- **Startup em ~40 ms** (antes ~180 ms): init e completions ficam em cache em
  `~/.cache/bash-evals`. O cache é refeito quando a ferramenta é atualizada ou quando o
  comando de init muda.
- **Histórico** de 50 mil comandos, sem duplicatas e gravado a cada comando.

## Usando o Ansible no dia a dia

```bash
./bootstrap.sh --list-tags              # tags disponíveis
./bootstrap.sh --tags dotfiles          # só os dotfiles (dotdrop)
./bootstrap.sh --tags hyprland          # só o desktop
./bootstrap.sh --tags python            # só versões do Python e ferramentas do pipx
./bootstrap.sh --skip-tags nvim         # tudo menos o bootstrap do Neovim (o mais lento)
./bootstrap.sh -e install_cloud=true    # liga uma opção de ansible/group_vars/all.yml
./bootstrap.sh -e desktop=none          # Arch nativo sem ambiente gráfico
./bootstrap.sh --check --diff           # simula
```

## Manutenção

| Situação | O que fazer |
| --- | --- |
| Init/completion desatualizado | `bashrc_cache_clear` e abra um shell novo |
| Expor outro `.exe` do Windows | adicione-o em `bashrc.envvars` e rode `rm -rf ~/.local/share/wsl-winbin` |
| Pasta do usuário Windows errada | apague `~/.cache/wsl-winhome` |
| Novo segredo ou variável da máquina | `~/.bashrc.local` (nunca nos arquivos versionados) |
| Instalador anexou linhas ao `.bash_profile` (aparece no `git status`) | `git checkout dotfiles/home/bash_profile`; se precisar de algo, use o `~/.bashrc.local` |
| Desfazer os links | `dotdrop uninstall` e restaure o backup de `~/.dotfiles-backup/` |
