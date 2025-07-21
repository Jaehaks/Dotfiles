## aliases

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ls='ls -a --color=auto'
alias ll='eza -Al --no-user --git --git-repos-no-status --icons=auto --sort=extension --time-style "+%Y-%m-%d "'
alias rc="yazi $ZDOTDIR/rc.d/"
alias sc="source $ZDOTDIR/.zshrc"
alias grep='grep --color=auto'
alias fd='fd -H'
alias mkdir='mkdir -p -v'
alias cp='cp --preserve=all'
alias cpv='cp --preserve=all -v'
alias cpr='cp --preserve=all -R'
alias tmux="tmux -f $ZDOTDIR/.tmux.conf"

alias gp='git add . && git commit -m "mobile update" && git push origin main'
alias gu='git pull origin main'
alias pg='pkg update && pkg upgrade -y'
alias ag='apt update && apt upgrade -y'
alias plu='proot-distro login ubuntu --isolated'
alias pla='proot-distro login archlinux --isolated --user wogkr'
alias q='exit'
