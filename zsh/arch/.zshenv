# this .zshenv is linked to $HOME

# $ZDOTDIR is set by finding linked location of .zshenv
local homezshenv="${HOME}/.zshenv"
if [[ -z "${ZDOTDIR}" || -L "${homezshenv}" ]]; then
	export ZDOTDIR="${homezshenv:A:h}" # parent dir of absolute path of homezshenv
fi

# don't load global config like `/etc/z~`
unsetopt GLOBAL_RCS

