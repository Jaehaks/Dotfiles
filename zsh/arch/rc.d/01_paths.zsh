add_paths=(
    "$HOME/.local/bin"
)

for p in "${add_paths[@]}"; do
    # if there are no directory, create it
    if [[ ! -d "$p" ]]; then
		mkdir -p "$p"
    fi
done

path=("${add_paths[@]}" "${path[@]}")

export PATH # explicit declaration
