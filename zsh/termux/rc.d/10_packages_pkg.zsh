################################
####### packages #############
################################

# 1. install zsh
# 2. run this .zshrc
# termux has 'apt' also. it means that it supports packages in apt


packages=(
	"openssh"           # openssh install both server and client in arch
	"eza"
	"fd"                # for yazi
	"bat"
	"zoxide"            # for yazi, user
	"neovim"
	"which"
	"mandoc"            # man command for command
	"manpages"          # man command for kernel and c library
	"git"
	"build-essential"   # base development tools like build-essential, for `paru`
	# "xdg-utils"			# for yazi , utility like xdg-open, xdg-mime (default in termux)
	# "xclip"				# for tmux/neovim, copy mode/systemcopy (not support in termux)
	"termux-api"		# use termux-clipboard-set command instead of xclip
	"ruby"				# for tmux-jump

	"yazi"              # for yazi
	"ffmpeg"            # for yazi
	"7zip"              # for yazi
	"jq"                # for yazi
	"poppler"           # for yazi
	"ripgrep"           # for yazi
	"fzf"               # for yazi
	"imagemagick"       # for yazi
	"unar"				# for yazi (lsar.yazi)
	"p7zip"				# for yazi/neovim, 7zip porting version
	# "trash-cli"		# to manage trash in ~/.local/share/Trash/
						# it doesn't be supported in pkg, use `pip install trash-cli` instead of it.
	# "reflector"       # for mirrorlist (it doesn't support)
	"rsync"             # for mirrorlist
	"curl"              # for mirrorlist

	"unzip"             # neovim
	"lua54"             # neovim
	"nodejs"            # neovim (nvim-treesitter) / npm is installed automatically
	"wget"              # neovim (mason)
	"uv"
)
# search these packages are installed to not use `pkg list-installed` for fast loading
valid_installed_packages=$(pkg list-installed | awk -F'/' '{print $1}' | grep -F -w -f <(printf "%s\n" "${packages[@]}"))
packages_toinstall=()
for package in "${packages[@]}"; do
	if ! echo "${valid_installed_packages}" | grep -q -x -F "$package"; then
		packages_toinstall+=("$package")
	fi
done
if [[ ${#packages_toinstall[@]} -gt 0 ]]; then
	pkg install -y "${packages_toinstall[@]}"
fi

