## npm install
npm_packages=(
	"tree-sitter-cli" # neovim (nvim-treesitter) to install parser
	"neovim"
)
npm_packages_toinstall=()
npm_global_root=$(npm root -g)
if [[ -d "$npm_global_root" ]]; then
	for pkg in "${npm_packages[@]}"; do
		if [[ ! -d "${npm_global_root}/${pkg}" ]]; then
			npm_packages_toinstall+=("${pkg}")
		fi
	done
fi
if [[ ${#npm_packages_toinstall[@]} -gt 0 ]]; then
	sudo npm install -g "${npm_packages_toinstall[@]}"
	echo "[ ${npm_packages_toinstall[@]} ] are installed from npm"
fi

# neovim python provider install
nvim_venv_dir="$HOME/.config/.Nvim_venv"
if [ ! -d "$nvim_venv_dir" ]; then
	mkdir -p "$nvim_venv_dir"
	python3 -m venv "$nvim_venv_dir" # create virtual env to dir
	"$nvim_venv_dir/bin/pip" install --upgrade pip
	"$nvim_venv_dir/bin/pip" install pynvim	 # install pynvim using pip in Nvim_venv
fi
