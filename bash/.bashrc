#
# ~/.bashrc
#

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

fastfetch

setxkbmap -model abnt-2 -layout br

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias grep='grep --color=auto'
PS1='[\u@\h \W]\$'

# Envvars
if [ -e ~/.bashrc.envvars ] ; then
    source ~/.bashrc.envvars
fi

# Aliases
if [ -e ~/.bashrc.aliases ] ; then
    source ~/.bashrc.aliases
fi

# Evals
if [ -e ~/.bashrc.evals ] ; then
    source ~/.bashrc.evals
fi

# Function
if [ -e ~/.bashrc.functions ] ; then
    source ~/.bashrc.functions
fi
