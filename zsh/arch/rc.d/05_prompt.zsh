## for git branch
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%F{magenta}%b%f'
setopt PROMPT_SUBST

## final prompt
PROMPT='%F{yellow}%D{%Y/%m/%d} %D{%H:%M:%S}%f %F{green}%~%f ${vcs_info_msg_0_}
>> '
