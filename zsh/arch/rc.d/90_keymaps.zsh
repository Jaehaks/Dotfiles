# this file called after plugins loading to prevent unwanted changes by plugins

bindkey -r "^S" # remove existing keymap (history-incremental-search-forward)
bindkey "^T" history-incremental-search-forward
bindkey "^O" clear-screen
bindkey "^H" backward-char
bindkey "^L" forward-char
