#!/bin/bash

# Windows specific configuration 
if [[ "$OSTYPE" = 'msys' ]]; then
	if [[ ! -f ./win_settings ]]; then
		echo "No Settings file found for $OSTYPE"
		exit 1
	fi
	# Copy settings to home directory
	cp ./win_settings.sh ~/settings.sh
	# Have the settings envs available for the rest of the script
	source ./win_settings.sh
	
	if [[ ! -f pacman.list ]]; then
		echo "no external packages installed."
	else
		mkdir ./tmp
		cd ./tmp

		# Download and extract packages not usually packaged with git for windows
		while read -r package
		do
			curl $PACMAN_URL/$package -O
			tar -xvJf $package usr/bin/ 
			echo "Extracted $package to ./tmp directory"
		echo $package
		done < ../pacman.list

		if [[ -d usr/bin ]]; then
			if [[ ! -d $DEV_BIN ]]; then
				mkdir -p $DEV_BIN 
			fi
			mv usr/bin/* $DEV_BIN 
			if [[ $? -eq 0 ]]; then
				echo "SUCCESS: Moved new packages to package bin"
				export PATH=$DEV_BIN:$PATH
			else
				echo "Failed to move new packages to the package bin"
			fi
		fi
	fi
else
	# OTHER OS SPECIFIC CONFIG GOES HERE
fi


