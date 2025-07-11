# update fonts (it seems don't need)
if ! fc-list | grep -i "FiraCode Nerd Font" &>/dev/null; then
    fc-cache -v
fi
