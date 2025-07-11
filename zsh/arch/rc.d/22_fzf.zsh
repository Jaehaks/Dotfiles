# fzf
export FZF_DEFAULT_OPTS="
--layout=reverse
--border
--color=hl:#FF0000,hl+:#00FF00
--preview='bat --color=always {}'
--preview-window='down,50%,hidden'
--bind='\
ctrl-j:up,\
ctrl-k:down,\
ctrl-d:half-page-down,\
ctrl-u:half-page-up,\
ctrl-l:forward-char,\
ctrl-h:backward-char,\
ctrl-a:beginning-of-line,\
ctrl-e:end-of-line,\
ctrl-i:toggle-preview,\
alt-k:preview-half-page-down,\
alt-j:preview-half-page-up\
'"
