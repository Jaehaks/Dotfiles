## directories which must be created
# caution: use $HOME instead of '~'
directories=(
	"$HOME/.config"
	"$HOME/.local/bin"
	"$HOME/.local/opt"
	"$HOME/Obsidian_Nvim/Personal" # for neovim
	"$HOME/Obsidian_Nvim/Project" # form neovim
)
for dir in "${directories[@]}"; do
	if [ ! -d "$dir" ]; then
		mkdir -p "$dir"
	fi
done

export LOCALBIN="$HOME/.local/bin"
export LOCALOPT="$HOME/.local/opt"
