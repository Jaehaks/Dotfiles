################################
####### packages #############
################################

# 1. install zsh
# 2. run this .zshrc
#


packages=(
	"openssh"           # openssh install both server and client in arch
	"eza"
	"fd"                # for yazi
	"bat"
	"zoxide"            # for yazi, user
	"neovim"
	"which"
	"man-db"            # man, mandb apropos, whatis command
	"man-pages"         # documents for man
	"git"
	"base-devel"        # base development tools like build-essential, for `paru`
	"xdg-utils"			# for yazi , utility like xdg-open, xdg-mime
	"xclip"				# for tmux/neovim, copy mode/systemcopy
	"ruby"				# for tmux-jump

	"yazi"              # for yazi
	"ffmpeg"            # for yazi
	"7zip"              # for yazi
	"jq"                # for yazi
	"poppler"           # for yazi
	"ripgrep"           # for yazi
	"fzf"               # for yazi
	"imagemagick"       # for yazi
	"unarchiver"		# for yazi (lsar.yazi)
	"trash-cli"			# to manage trash in ~/.local/share/Trash/

	"reflector"         # for mirrorlist
	"rsync"             # for mirrorlist
	"curl"              # for mirrorlist

	"fontconfig"        # fonts, it may be installed already
	"ttf-firacode-nerd" # fonts
	# "noto-fonts-cjk"    # fonts
	"noto-fonts-emoji"  # fonts

	"unzip"             # neovim
	"lua"               # neovim
	# "python"            # neovim (default)
	"nodejs"            # neovim (nvim-treesitter)
	"npm"               # neovim (nvim-treesitter)
	"github-cli"        # neovim(blink-cmp-git)
	"wget"              # neovim (mason)
	"python-pip"        # neovim(mason), pip
	"python-virtualenv" # neovim(provider), venv
	"python-uv" 		# neovim(uv), python package manager

	"zathura"			# pdf viewer
	"zathura-pdf-mupdf" # pdf backend, which is support pdf/epub over than poppler)
)
# search these packages are installed to not use `pacman -Q` for fast loading
valid_installed_packages=$(pacman -Q | awk '{print $1}' | grep -F -w -f <(printf "%s\n" "${packages[@]}"))
packages_toinstall=()
for package in "${packages[@]}"; do
	if ! echo "${valid_installed_packages}" | grep -q -x -F "$package"; then
		packages_toinstall+=("$package")
	fi
done
if [[ ${#packages_toinstall[@]} -gt 0 ]]; then
	sudo pacman -S --noconfirm --needed "${packages_toinstall[@]}"
	sudo mandb # update man cache
fi

