# Taken from termux, most of default zsh configurations don't do this
# Skip it on macOS to disallow path_helper run
if [[ -r /data/data/com.termux/files/usr/etc/profile ]] && [[ "${OSTYPE}" != darwin* ]]; then
    emulate sh -c '/data/data/com.termux/files/usr/etc/profile'
fi
