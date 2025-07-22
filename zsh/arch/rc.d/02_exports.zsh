
## firefox
export MOZ_ENABLE_WAYLAND=0	# for proper operation scroll down box in firefox

## config
export XDG_CONFIG_HOME="$HOME/.config"
# export XDG_DATA_HOME="$HOME/.config/nvim-data"
# export XDG_CACHE_HOME="$HOME/.config/nvim-data"
# export XDG_STATE_HOME="$HOME/.config/nvim-data"
export ZDOTCONFIG="$ZDOTDIR/configs"

## editor
export EDITOR="nvim"
bindkey -e # set emacs keybinding even thought EDITOR=vi
		   # it must be called before other bindkey setting

## timezone
export TZ='Asia/Seoul' #timezome setting


## locale
# 1) set locale as what you want
# 	localectl set-locale LANG=ko_KR.UTF-8
# 2) In wsl, booting procedure cannot set locale along with /etc/locale.conf
# 	so these chunks are needed
unset LANG
source /etc/profile.d/locale.sh
