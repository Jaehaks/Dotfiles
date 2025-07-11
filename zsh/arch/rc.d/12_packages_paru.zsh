# update mirrorlist
if [ ! -f "/etc/pacman.d/mirrorlist.bak" ]; then
    sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
    sudo reflector --country KR --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
fi

# paru install
if [ ! -d "$HOME/.plugins/paru" ]; then
	cd "$HOME/.plugins"
	git clone https://aur.archlinux.org/paru.git
	cd paru
	makepkg -si
fi

# add packages from paru
paru_packages=(
    "resvg" # for yazi
    "ttf-nanumgothic_coding"	# fonts for korean
)
for package in "${paru_packages[@]}"; do
	if ! pacman -Q "$package" &> /dev/null; then
		paru -S --noconfirm --needed "${paru_packages[@]}"
	fi
done
