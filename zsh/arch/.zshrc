# inspired : https://github.com/z0rc/dotfiles/tree/main/zsh

if [[ ! -f "$HOME/.gitconfig" ]]; then
	ln -s "$ZDOTDIR/.gitconfig" "$HOME/.gitconfig"
fi



for conffile in "${ZDOTDIR}"/rc.d/*; do
	source "${conffile}"
done

# conffile is remained after completion of for statement
unset conffile







