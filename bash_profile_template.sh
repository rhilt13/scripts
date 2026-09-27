export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

export PROMPT_COMMAND='if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history 1)" >> ~/.logs/bash-history-$(date "+%Y-%m-%d").log; fi'

alias ls='ls -GFh'
alias ll='ls -ltrh'
alias c='clear'
alias kn='ssh rtaujale@172.22.150.45'
alias kn_gpu='ssh rahil@172.22.150.191'

shopt -s histappend
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
HISTCONTROL=ignoreboth:ignoredups:erasedups
HISTIGNORE="pwd:ls:ls -ltrh:clear:"
HISTSIZE=1000000
HISTFILESIZE=1000000
HISTTIMEFORMAT='%F %T'

export PATH="~/bin:$PATH:~/git/scripts:~/git/scripts/GT_scripts"
