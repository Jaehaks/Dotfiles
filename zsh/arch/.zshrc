################################
####### option #############
################################
setopt GLOB_DOTS	# include dot files
setopt EXTENDED_GLOB	# it can use (.) pattern for file



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
HISTFILE=~/.zsh_history # 히스토리 파일 경로 설정
SAVEHIST=1000 # 저장할 히스토리 라인 수 (파일에 저장)
HISTSIZE=1000 # 세션당 기억할 히스토리 라인 수 (메모리)
# 히스토리 중복 제거 및 검색 관련 옵션
setopt INC_APPEND_HISTORY    # 명령어를 실행할 때마다 히스토리 파일에 추가
setopt HIST_IGNORE_ALL_DUPS  # 모든 중복된 명령어는 히스토리에 저장하지 않음
setopt HIST_REDUCE_BLANKS    # 여러 공백을 하나의 공백으로 축소하여 저장
setopt HIST_NO_STORE         # history, ! 등과 같은 히스토리 명령어 자체를 히스토리에 저장하지 않음
setopt HIST_SAVE_NO_DUPS     # 히스토리 파일에 저장할 때 중복된 명령어는 저장하지 않음
setopt HIST_EXPIRE_DUPS_FIRST # 중복된 히스토리 중 가장 오래된 것을 먼저 삭제



################################
####### prompt #############
################################

# prompt 설정
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vsc_info:git:*' formats '%F{magenta}%b%f'

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
    "openssh" # openssh install both server and client in arch
    "eza" 
    "fd" # for yazi
    "bat"
    "zoxide" # for yazi, user
    "neovim"
    "which"
    "man"
    "git" 
    "base-devel" # base development tools like build-essential, for `paru`
    "yazi" # for yazi
    "ffmpeg" # for yazi
    "7zip" # for yazi
    "jq" # for yazi
    "poppler" # for yazi
    "ripgrep" # for yazi
    "fzf" # for yazi
    "imagemagick" # for yazi
    "reflector" # for mirrorlist
    "rsync" # for mirrorlist
    "curl" # for mirrorlist
    "fontconfig" # fonts, it may be installed already
    "ttf-firacode-nerd" # fonts
#    "noto-fonts-cjk" # fonts
    "noto-fonts-emoji" # fonts
)
sudo pacman -S --noconfirm --needed "${packages[@]}"

# update fonts
if ! fc-list | grep -i "FiraCode Nerd Font" &>/dev/null; then
    fc-cache -v
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
)
paru -S --noconfirm --needed "${paru_packages[@]}"

	
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

if [ ! -d ~/.plugins/zsh-autosuggestions ]; then
    cd ~/.plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions
fi

if [ ! -d ~/.plugins/zsh-syntax-highlighting ]; then
    cd ~/.plugins
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
fi

cd "$current_dir"

################################
####### plugin settings #############
################################
#zoxide
export _ZO_DATA_DIR="$HOME"
eval "$(zoxide init zsh)"


# zsh-autosuggestions 로딩
source ~/.plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 
bindkey '^[[Z' autosuggest-accept

# zsh-syntax-highlighting 로딩 
source ~/.plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
