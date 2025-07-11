## directories which must be created
# caution: use $HOME instead of '~'
directories=(
	"$HOME/.plugins"
	"$HOME/.config"
	"$HOME/.local/bin"
	"$HOME/Obsidian_Nvim/Personal" # for neovim
	"$HOME/Obsidian_Nvim/Project" # form neovim
)
for dir in "${directories[@]}"; do
	if [ ! -d "$dir" ]; then
		mkdir -p "$dir"
	fi
done
