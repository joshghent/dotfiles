#!/usr/bin/env bash

function doIt() {
	sudo -v

	# Keep-alive: update existing `sudo` time stamp until the script has finished
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

	# Run the prep.sh Script
	if [ ! -f ~/.setup_progress ]; then
			echo "0" > ~/.setup_progress
	fi
	progress=$(cat ~/.setup_progress)

	if [ "$progress" -lt 1 ]; then
			echo ""
			echo "------------------------------"
			echo "Updating OSX and installing Xcode command line tools"
			echo "------------------------------"
			echo ""
			sudo systemsetup -setcomputersleep Never
			# Install all available updates
			sudo softwareupdate -i -a --install-rosetta

			mkdir -p ~/Projects

			echo "1" > ~/.setup_progress
	fi

	if [ "$progress" -lt 2 ]; then
			echo ""
			echo "------------------------------"
			echo "Overwriting dotfiles"
			echo "------------------------------"
			echo ""
			if [ ! -f ~/.ssh/config ]; then
				cp .ssh ~/
			fi

			echo "2" > ~/.setup_progress
	fi

	if [ "$progress" -lt 3 ]; then
			# Run the programs.sh Script
			echo ""
			echo "------------------------------"
			echo "Installing Programs"
			echo "------------------------------"
			echo ""
			if ./programs.sh; then
					echo "3" > ~/.setup_progress
			else
					echo "Program installation failed. Please rerun the script to continue from this point."
					exit 1
			fi
	fi

	if [ "$progress" -lt 4 ]; then
			# Run the macos.sh Script
			echo ""
			echo "------------------------------"
			echo "Configuring MacOS Options"
			echo "------------------------------"
			echo ""
			./macos.sh

			echo "4" > ~/.setup_progress
	fi

	if [ "$progress" -lt 5 ]; then
			echo ""
			echo "------------------------------"
			echo "Installing Pathogen (VIM)"
			echo "------------------------------"
			echo ""
			git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
			vim +PluginInstall +qall

			echo "5" > ~/.setup_progress
	fi

	if [ "$progress" -lt 6 ]; then
			echo ""
			echo "------------------------------"
			echo "Configure Git and Check SSH Keys"
			echo "------------------------------"
			echo ""
			git config --global user.name "$name"
			git config --global user.email "$email"

			if [ ! -f ~/.ssh/id_ed25519 ]; then
					echo "Generating new SSH key..."
					ssh-keygen -t ed25519 -C "$email"
					eval "$(ssh-agent -s)"
					ssh-add -K ~/.ssh/id_ed25519
					echo "~/.ssh/id_ed25519.pub"
					pbcopy < ~/.ssh/id_ed25519.pub
					echo "New SSH Key generated and copied to clipboard. Please add to GitHub / GitLab"
			else
					echo "SSH key already exists. Skipping key generation."
			fi

			echo "6" > ~/.setup_progress
	fi

	echo ""
	echo "------------------------------"
	echo "ALL DONE!"
	echo "PLEASE REBOOT YOUR MACHINE NOW. WHY AM I SHOUTING?"
	echo "------------------------------"
	echo ""

	rm ~/.setup_progress
}

read -p "This script may overwrite existing files in your home directory. Are you sure? (y/n) " -r -n 1 confirm;
echo "";

read -p "Please enter your Email" -r -n 1 email;
read -p "Please enter your Name" -r -n 1 name;

if [[ $confirm =~ ^[Yy]$ ]]; then
	doIt "$@"
fi;

unset runDots;
