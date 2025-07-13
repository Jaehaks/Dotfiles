## for git branch
autoload -Uz vcs_info
# git status --porcelain=v2 --branch --ignored=matching --show-stash
# https://medium.com/@swindlers-inc/vcs-info-on-zsh-prompt-cfa9629fcd82
setopt PROMPT_SUBST
zstyle ':vcs_info:git:*' check-for-changes true # activate confirm changes
zstyle ':vcs_info:git:*' formats '%F{magenta}%b%f'

precmd() { vcs_info } # executes vcs_info() before prompt

## final prompt
PROMPT='%F{yellow}%D{%Y/%m/%d} %D{%H:%M:%S}%f %F{green}%~%f ${vcs_info_msg_0_}
>> '
