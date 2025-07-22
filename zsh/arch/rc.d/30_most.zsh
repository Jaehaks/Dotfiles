if (( ${+commands[most]} )); then
	most_config_file=${HOME}/.mostrc
	if [ ! -f ${most_config_file} ]; then
		ln -s $ZDOTCONFIG/most/.mostrc $most_config_file
	fi
fi
