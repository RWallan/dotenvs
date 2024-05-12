#
# ~/.bashrc
#
neofetch

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

if [ -x "$(command -v tmux)" ] && [ -n "${DISPLAY}" ] && [ -z "${TMUX}" ]; then
    exec tmux new-session -A -s ${USER} >/dev/null 2>&1
fi
