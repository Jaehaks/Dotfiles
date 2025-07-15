## use romkatv/gitstatus utility to get git status faster
source "$ZDOTDIR/plugins/gitstatus/gitstatus.plugin.zsh"

function git_check() {

	local p=""
	local nl=$'\n'	# new line

	# set colors
	local      added='%88F' # red3 foreground
	local   modified='%196F' # red3 foreground
	local     commit='%76F'  # Charteuses3 green foreground
	local    stashes='%75F'  # SteelBlue1 foreground
	local  untracked='%249F' # Grey70 foreground
	local conflicted='%226F' # yellow1 foreground
	local     branch='%201F' # magenta1 foreground

	# default prompt outside of git repo
	PROMPT="%F{yellow}%D{%Y/%m/%d} %D{%H:%M:%S}%f %F{green}%~%f${nl}>> "

	# check gitstatus
	gitstatus_query 'MY'                  || return 1  # error
	[[ $VCS_STATUS_RESULT == 'ok-sync' ]] || return 0  # not a git repo

	# set branch name. or commit hash / tag
	local where  # branch name, tag or commit
	p+="${branch}"
	if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
		p+=''
		where="$VCS_STATUS_LOCAL_BRANCH"
	elif [[ -n $VCS_STATUS_TAG ]]; then
		p+='#'
		where="$VCS_STATUS_TAG"
	else
		p+='@'
		where="${VCS_STATUS_COMMIT[1,8]}"	# cut hash by 8 characters
	fi

	(( $#where > 32 )) && where[13,-13]="…"  # truncate long branch names and tags
	p+="${where//\%/%%}"             # escape %


	# set marks for git status
	(( VCS_STATUS_NUM_UNSTAGED   )) && p+=" ${modified}M${VCS_STATUS_NUM_UNSTAGED}"           # modified
	(( VCS_STATUS_NUM_STAGED     )) && p+=" ${added}A${VCS_STATUS_NUM_STAGED}"             # added
	(( VCS_STATUS_NUM_UNTRACKED  )) && p+=" ${untracked}?${VCS_STATUS_NUM_UNTRACKED}"         # untracked
	(( VCS_STATUS_STASHES        )) && p+=" ${stashes}S${VCS_STATUS_STASHES}"                 # stashes
	(( VCS_STATUS_COMMITS_AHEAD  )) && p+=" ${commit}+${VCS_STATUS_COMMITS_AHEAD}"            # local commit
	(( VCS_STATUS_COMMITS_BEHIND )) && p+=" ${commit}-${VCS_STATUS_COMMITS_BEHIND}"           # behind the remote
	(( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && p+=" ${commit}⇢${VCS_STATUS_PUSH_COMMITS_AHEAD}"  # commit to different remote
	(( VCS_STATUS_PUSH_COMMITS_BEHIND )) && p+=" ${commit}⇠${VCS_STATUS_PUSH_COMMITS_BEHIND}" # behind to different remote
	[[ -n $VCS_STATUS_ACTION     ]] && p+=" ${conflicted}${VCS_STATUS_ACTION}"                # merge action
	(( VCS_STATUS_NUM_CONFLICTED )) && p+=" ${conflicted}E${VCS_STATUS_NUM_CONFLICTED}"       # merge conflicts

	# GITSTATUS_PROMPT="${p}%f"

	## final prompt
	PROMPT="%F{yellow}%D{%Y/%m/%d} %D{%H:%M:%S}%f %F{green}%~%f ${p}%f${nl}>> "

	setopt no_prompt_{bang,subst} prompt_percent  # enable/disable correct prompt expansions
}

gitstatus_stop 'MY' && gitstatus_start -s -1 -u -1 -c -1 -d -1 'MY'
autoload -Uz add-zsh-hook
add-zsh-hook precmd git_check










## for git branch (old ver)
## git status --porcelain=v2 --branch --ignored=matching --show-stash
## https://medium.com/@swindlers-inc/vcs-info-on-zsh-prompt-cfa9629fcd82

# autoload -Uz vcs_info
# setopt PROMPT_SUBST

## when I set zstyle of specific vcs style(ex. git), vcs_info triggers when current dir is in the vcs repo
## it makes `git rev-parse` needless
## check-for-changes doesn't be needed because all status is confirmed in hook function
##
## zstyle ':vcs_info:git:*' check-for-changes true # activate confirm changes

# zstyle ':vcs_info:git:*' formats '%F{magenta}%b%f %m'

## :git* - this zstyle will be applied if current directory is in git repo
## 		  git* means all vcs starting with 'git' like git-svn.
## +set-message:* - while gather vcs information,  event with '+' prefix is defined at each step.
## 				 'set-message' is the final step to set message which is displayed in prompt.
## 				 '+' means hook executes after this 'set-message' event.
## 				 ':*' means it is applied to all set-messages event
## 				 After this event, 'git-check' function is executed. 'git-check' naming is user defined
##
## +vi- prefix - conventional prefix when hook function is defined.
## 				it has effect like namespace to prevent to conflict with other plugins functions

# zstyle ':vcs_info:git*+set-message:*' hooks git-check
# +vi-git-check() {
# 	GIT_STATUS=$(git status --porcelain=v2 --ignored=matching --show-stash)
# 	# Staged files
# 	STAGED=$(echo $GIT_STATUS | grep -c '#')
# 	if [[ -n $STAGED ]] && [[ $STAGED != '0' ]]; then
# 		hook_com[misc]+=" +$STAGED"
# 	fi
# 	# Unstaged files
# 	UNSTAGED=$(echo $GIT_STATUS | grep -v '??' | grep "^ " | wc -l)
# 	if [[ -n $UNSTAGED ]] && [[ $UNSTAGED != '0' ]]; then
# 		hook_com[misc]+=" !$UNSTAGED"
# 	fi
# 	# Untracked files
# 	UNTRACKED=$(echo $GIT_STATUS | grep '??' | wc -l)
# 	if [[ -n $UNTRACKED ]] && [[ $UNTRACKED != '0' ]]; then
# 		hook_com[misc]+=" ?$UNTRACKED"
# 	fi
# }
# precmd() { vcs_info } # executes vcs_info() before prompt

## final prompt
# PROMPT='%F{yellow}%D{%Y/%m/%d} %D{%H:%M:%S}%f %F{green}%~%f ${vcs_info_msg_0_}
# >> '
