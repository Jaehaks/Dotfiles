# check the matlab command is valid
which matlab &> /dev/null
local isValidMatlab=$?

# set directory
local dirMpm="$HOME/Downloads/"
local dirMatlab="$LOCALOPT/MATLAB"

# if there are no matlab command & if you select 'n', don't ask anymore until restart
if [[ "$isValidMatlab" -ne 0 && "$install_confirm" == 'n' ]]; then

	read "install_confirm?Do you want to install matlab? (y/n): "
	install_confirm=$(echo "$install_confirm" | tr '[:upper:]' '[:lower:]')

	if [[ "$install_confirm" == "y" ]]; then
		# download mpm, if there are existed file already, it skipped
		wget -P "$dirMpm" -nc https://www.mathworks.com/mpm/glnxa64/mpm
		chmod +x "$dirMpm/mpm"

		# install matlab
		"$dirMpm"/mpm install --release=R2024b --destination="$dirMatlab" MATLAB Simulink

		# make symlink
		if [[ -e "$LOCALBIN/matlab" ]]; then
			ln -s "$dirMatlab/bin/matlab" "$LOCALBIN/matlab"
		fi
	fi
fi
