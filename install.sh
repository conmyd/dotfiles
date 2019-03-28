#!/bin/bash

# Windows specific configuration
if [[ "$OSTYPE" = 'msys' ]]; then
	if [[ ! -f ./win_settings.sh ]]; then
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
        if [[ ! -d ./tmp ]]; then
            mkdir ./tmp
        fi
		cd ./tmp

		# Download and extract packages not usually packaged with git for windows
		while read -r package
		do
			curl $PACMAN_URL/$package -O
			tar -xvJf $package usr/bin/
			echo "Extracted $package to ./tmp directory"
		done < ../pacman.list

		if [[ -d usr/bin ]]; then
			if [[ ! -d $DEV_BIN ]]; then
				mkdir -p $DEV_BIN
            fi
			mv usr/bin/* $DEV_BIN
			if [[ $? -eq 0 ]]; then
				echo "SUCCESS: Moved new packages to package bin"
			else
				echo "FAILED to move new packages to the package bin"
			fi
		fi
        cd ~-
	fi

    # Kubectl variables
    kube_binary=kubectl.exe
    kube_arch=windows/amd64

    helm_options='--no-sudo'
else
	# OTHER OS SPECIFIC CONFIG GOES HERE
    echo ""

    # Assuming Linux
    kube_binary=kubectl
    kube_arch=linux/amd64
fi

# Install vim_runtime for awesome vim
if [[ ! -d ~/.vim_runtime ]]; then
    echo "Installing awesome vim"
	git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
	sh ~/.vimruntime/install_awesome_vimrc.sh
fi

# Install kubectl
## TODO: Add check for existance of variables before executing this code?
if [[ ! -f $DEV_BIN/$kube_binary ]]; then

    echo "Downloading kubectl and placing it in $DEV_BIN"
    kubelatest=`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`
    curl -L https://storage.googleapis.com/kubernetes-release/release/$kubelatest/bin/$kube_arch/$kube_binary -o $DEV_BIN/$kube_binary
else
    echo "kubectl already installed"
    # Include upgrade steps here for kubectl.
fi

# Install helm
if [[ ! -f $DEV_BIN/helm ]]; then
    export HELM_INSTALL_DIR=$DEV_BIN
    ./install_helm.sh $helm_options
else
    echo "Helm is already installed"
    # Include steps for an upgrade here?
fi

# move the home files to the home directory of the user.
echo "Moving home dotfiles to the user's home directory"
cp -burv ./home/* ~/
if [[ $? -eq 0 ]]; then
    echo "SUCCESS: dotfiles moved to user's home directory"
else
    echo "FAILED to move dotfiles to the user's home directory"
    exit 1;
fi
