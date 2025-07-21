## executes tmux at startup
# -- check current session is out of tmux && current shell is interactive
if [ -z "$TMUX" ] && [[ $- == *i* ]]; then
	# attach tmux if it is exists or start new session
	tmux attach-session -t main 2>/dev/null || tmux new-session -s main
fi

