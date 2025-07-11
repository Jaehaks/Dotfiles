# ssh agent for client start if there is no process
if ! pgrep ssh-agent > /dev/null; then
    eval "$(ssh-agent -s > /dev/null)"
fi
