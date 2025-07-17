

bindkey -e # set emacs keybinding even thought EDITOR=vi
bindkey -r "^S" # remove existing keymap (history-incremental-search-forward)
bindkey "^T" history-incremental-search-forward
bindkey "^O" clear-screen
bindkey "^H" backward-char
bindkey "^L" forward-char

