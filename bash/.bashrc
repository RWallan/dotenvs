#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Abre o tmux automaticamente (exceto dentro do tmux, do Neovim e do VS Code)
if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [ -z "$NVIM" ] \
  && [[ ! "$TERM" =~ screen|tmux ]] && [ "$TERM_PROGRAM" != "vscode" ]; then
  exec tmux
fi

# No WSL o layout do teclado é controlado pelo Windows
if [ -z "$WSL_DISTRO_NAME" ] && [ -n "$DISPLAY" ] && command -v setxkbmap &> /dev/null; then
  setxkbmap -model abnt-2 -layout br
fi

alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

for file in ~/.bashrc.envvars ~/.bashrc.aliases ~/.bashrc.functions ~/.bashrc.evals; do
  [ -e "$file" ] && source "$file"
done
unset file

# Configurações específicas desta máquina e segredos (não versionado)
[ -e ~/.bashrc.local ] && source ~/.bashrc.local

command -v fastfetch &> /dev/null && fastfetch
