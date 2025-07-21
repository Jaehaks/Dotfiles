
## firefox
export MOZ_ENABLE_WAYLAND=0	# for proper operation scroll down box in firefox

## config
export XDG_CONFIG_HOME="$HOME/.config"
# export XDG_DATA_HOME="$HOME/.config/nvim-data"
# export XDG_CACHE_HOME="$HOME/.config/nvim-data"
# export XDG_STATE_HOME="$HOME/.config/nvim-data"

## editor
export EDITOR="nvim"
export SUDO_EDITOR="nvim"
export VISUAL="nvim"
bindkey -e # set emacs keybinding even thought EDITOR=vi
		   # it must be called before other bindkey setting

## timezone
export TZ='Asia/Seoul' #timezome setting


## locale
# termux-locale ko_KR.UTF-8 -- set locale
# but it doesn't neeed yet
