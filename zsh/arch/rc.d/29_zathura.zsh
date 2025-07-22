## make link for zathura
# -- '+'commands means that parameter expansion of commands variable
# -- ${commans[zathura]} returns the location of execution file
# -- ${+commands[zathura]} returns 1 or 0 whether the existence of command
if (( ${+commands[zathura]} )); then
	zathura_config_dir="${XDG_CONFIG_HOME}/zathura"
	if [ ! -d ${zathura_config_dir} ]; then
		ln -s $ZDOTCONFIG/zathura $zathura_config_dir
	fi
fi
