## executes tmux at startup
# -- 1) check whether tmux command exists
# -- 2) check current session is out of TMUX
# -- 3) check current session is not in SSH remote access state
# -- 4) check current user is not root
# -- 5) check current shell is interactive
if (( ${+commands[tmux]} )) && [[ ! -v TMUX && ! -v SSH_TTY && ${EUID} != 0 && $- == *i* ]]; then
	# attach tmux if it is exists or start new session
	tmux attach-session -t main 2>/dev/null || tmux new-session -s main
fi

