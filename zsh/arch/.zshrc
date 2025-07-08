################################
####### option #############
################################
setopt GLOB_DOTS	# include dot files
setopt EXTENDED_GLOB	# it can use (.) pattern for file


export MOZ_ENABLE_WAYLAND=0	# for proper operation scroll down box in firefox
export XDG_CONFIG_HOME="$HOME/.config"
# export XDG_DATA_HOME="$HOME/.config/nvim-data"
# export XDG_CACHE_HOME="$HOME/.config/nvim-data"
# export XDG_STATE_HOME="$HOME/.config/nvim-data"
export EDITOR="nvim"
bindkey -e
bindkey -r "^S"
bindkey "^T" history-incremental-search-forward

################################
####### path #############
################################
add_paths=(
    "$HOME/.local/bin"
)

for p in "${add_paths[@]}"; do
    # 해당 경로가 실제로 디렉토리인지 확인 후 추가
    if [[ -d "$p" ]]; then
        path=( "$p" "${path[@]}")
    fi
done

# path 배열에서 중복 제거 및 PATH 환경 변수에 반영
typeset -U path
export PATH # 명시적 export는 좋은 습관
export TZ='Asia/Seoul' #timezome 설정

################################
####### locale #############
################################

# 1) set locale as what you want
# 	localectl set-locale LANG=ko_KR.UTF-8
# 2) In wsl, booting procedure cannot set locale along with /etc/locale.conf
# 	so these chunks are needed
unset LANG
source /etc/profile.d/locale.sh

################################
####### completion #############
################################
autoload -Uz compinit
compinit

# case-insensitive + ignore hipen & underbar + fuzzy search
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

_comp_options+=(globdots) # include dotfiles when auto completion


################################
####### history #############
################################

# history
HISTFILE=~/.zsh_history       # set path for history file
SAVEHIST=1000                 # Number of history lines to save (to file)
HISTSIZE=1000                 # Number of history lines to remember per session (memory)
# Options for deduplication and search of history
setopt INC_APPEND_HISTORY     # Append to history file each time a command is executed
setopt HIST_IGNORE_ALL_DUPS   # Do not save all duplicate commands to history
setopt HIST_REDUCE_BLANKS     # Reduce multiple spaces to a single space and save
setopt HIST_NO_STORE          # Do not store history commands themselves, such as history, !, etc., in the history.
setopt HIST_SAVE_NO_DUPS      # Do not save duplicate commands when saving to the history file.
setopt HIST_EXPIRE_DUPS_FIRST # Delete oldest duplicate history first



################################
####### prompt #############
################################

# prompt 설정
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%F{magenta}%b%f'

setopt PROMPT_SUBST
PROMPT='%F{yellow}%D{%Y/%m/%d} %D{%H:%M:%S}%f %F{green}%~%f ${vcs_info_msg_0_}
>> '

################################
####### directories #############
################################
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

	"yazi"              # for yazi
	"ffmpeg"            # for yazi
	"7zip"              # for yazi
	"jq"                # for yazi
	"poppler"           # for yazi
	"ripgrep"           # for yazi
	"fzf"               # for yazi
	"imagemagick"       # for yazi

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

# update fonts (it seems don't need)
if ! fc-list | grep -i "FiraCode Nerd Font" &>/dev/null; then
    fc-cache -v
fi

# npm install
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


# ssh agent for client start if there is no process
if ! pgrep ssh-agent > /dev/null; then
    eval "$(ssh-agent -s > /dev/null)"
fi







################################
####### aliases #############
################################
alias ll='eza -al --git --git-repos --time-style="+%Y-%m-%d"'
alias ls='ls --color=auto'
alias rc='nvim ~/.zshrc'
alias sc='source ~/.zshrc'
alias ag='sudo pacman -Syu'
alias grep='grep --color=auto'
alias fd='fd -H'



################################
####### plugins install #############
################################
current_dir=$(pwd)

# zsh-autosuggestions
if [ ! -d ~/.plugins/zsh-autosuggestions ]; then
    cd ~/.plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions
fi

# zsh-syntax-highlighting
if [ ! -d ~/.plugins/zsh-syntax-highlighting ]; then
    cd ~/.plugins
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
fi

cd "$current_dir"

################################
####### plugin settings #############
################################

#yazi
export YAZI_CONFIG_HOME="$HOME/.config/Dotfiles/yazi"
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# fzf
export FZF_DEFAULT_OPTS="
--layout=reverse
--border
--color=hl:#FF0000,hl+:#00FF00
--preview='bat --color=always {}'
--preview-window='down,50%,hidden'
--bind='\
ctrl-j:up,\
ctrl-k:down,\
ctrl-d:half-page-down,\
ctrl-u:half-page-up,\
ctrl-l:forward-char,\
ctrl-h:backward-char,\
ctrl-a:beginning-of-line,\
ctrl-e:end-of-line,\
ctrl-i:toggle-preview,\
alt-k:preview-half-page-down,\
alt-j:preview-half-page-up\
'"

# bat : do `bat cache --build`
export BAT_CONFIG_DIR="$HOME/.config/Dotfiles/bat"
export BAT_CONFIG_PATH="$HOME/.config/Dotfiles/bat/config"

#zoxide
export _ZO_DATA_DIR="$HOME"
eval "$(zoxide init zsh)"

# the fuck
eval $(thefuck --alias)

# zsh-autosuggestions 로딩
source ~/.plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey "^[[Z" autosuggest-accept

# zsh-syntax-highlighting 로딩
source ~/.plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

