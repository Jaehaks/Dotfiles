## make link for gitconfig
if [[ ! -f "$HOME/.gitconfig" ]]; then
	ln -s "$ZDOTCONFIG/gitconfig/.gitconfig" "$HOME/.gitconfig"
fi
