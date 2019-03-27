if [[ -f ~/settings.sh ]]; then
	source ~/settings.sh
fi

for bashfile in `ls --ignore '.*~' -A ~/bash/`
do
	source ~/bash/$bashfile
done



if [[ "$OSTYPE" = "msys" ]]; then
	# nvm command to give the basics of nvm that is available on linux.
	# source nodejs versions need to be placed in the NVM_ROOT directory and then can be called with this.
	# Since this makes use of symlinks and a specific NODE_PATH,
	# it will persist with the installed choice between sessions.
	nvm () {
		command=$1
		options=$2
		if [[ "$command" = "list" ]]; then
			echo "list all in nvm_root"
			ls $NVM_ROOT
		elif [[ "$command" -eq "use" ]]; then
			if [[ -n "$options"  ]]; then
				if [[ -d $NODE_PATH ]]; then
					rm $NODE_PATH
				fi
				~/win_link.bat `windir $NODE_PATH` `windir $NVM_ROOT`\\$options
				echo "using node $options"
			fi
		fi
	}
fi

echo "(OK) .bash_profile"
