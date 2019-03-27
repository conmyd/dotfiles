
function windir() {
	echo $1 | sed -E 's;^/c/;C:\\;' | sed -e 's;/;\\;'
}

if [[ "$OSTYPE" = "msys" ]]; then
	NVM_ROOT='/c/dev/nvm'
	NODE_PATH='/c/dev/nodejs'
	nvm () {
		echo "$1"
		if [[ "$1" = "list" ]]; then
			echo "list all in node_root"
			ls $NVM_ROOT
		elif [[ "$1" -eq "use" ]]; then
			if [[ -n "$2"  ]]; then
				if [[ -d $NODE_PATH ]]; then
					rm $NODE_PATH
				fi
				/c/dev/dotfiles/home/nvm4w.bat `windir $NODE_PATH` `windir $NVM_ROOT`\\$2 
				echo "using node $2"
			fi
		fi
	}
	export PATH="$NODE_PATH:$PATH";
fi

echo "(OK) /c/Users/i059151/.bash_profile"
