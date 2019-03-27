#!/bin/bash
if [[ "$OSTYPE" = 'msys' ]]; then
	if [[ ! -f ./win_settings ]]; then
		echo "No Settings file found for $OSTYPE"
		exit 1
	fi
	source ./win_settings.sh
	
	PACMAN_URL='http://www2.futureware.at/~nickoe/msys2-mirror/msys/x86_64/'	
	if [[ ! -f pacman.list ]]; then
		echo "no external packages installed."
	else
		mkdir ./tmp
		cd ./tmp
		while read -r package
		do
			curl $PACMAN_URL/$package -O
			tar -xvJf $package usr/bin/ 
		echo $package
		done < ../pacman.list

		if [[ -d usr/bin ]]; then
			if [[ ! -d /c/dev/bin ]]; then
				mkdir -p /c/dev/bin
			fi
			mv usr/bin/* $DEV_BIN 
			if [[ $? -eq 0 ]]; then
				echo "moved new packages to package bin"
				export PATH=$DEV_BIN:$PATH
			fi
		fi
	fi

fi
