## compleiton
autoload -Uz compinit
compinit -d "$HOME/.zcompdump"

# case-insensitive + ignore hipen & underbar + fuzzy search
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
_comp_options+=(globdots) # include dotfiles when auto completion
