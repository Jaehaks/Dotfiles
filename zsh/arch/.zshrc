# inspired : https://github.com/z0rc/dotfiles/tree/main/zsh

for conffile in "${ZDOTDIR}"/rc.d/*; do
	source "${conffile}"
done

# conffile is remained after completion of for statement
unset conffile







