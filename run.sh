#!/usr/bin/env bash

function doIt() {
  sudo -v

  # Keep-alive: update existing `sudo` time stamp until the script has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

  # Run the prep.sh Script
  echo ""
  echo "------------------------------"
  echo "Updating OSX and installing Xcode command line tools"
  echo "------------------------------"
  echo ""
  ./prep.sh

  # Run the programs.sh Script
  echo ""
  echo "------------------------------"
  echo "Installing Programs"
  echo "------------------------------"
  echo ""
  ./programs.sh

  # Run the code.sh Script
  echo ""
  echo "------------------------------"
  echo "Install JS and PHP"
  echo "------------------------------"
  echo ""
  ./code.sh

  # Run the macos.sh Script
  echo ""
  echo "------------------------------"
  echo "Configuring MacOS Options"
  echo "------------------------------"
  echo ""
  ./macos.sh

  # Run the gitalias.sh Script
  echo ""
  echo "------------------------------"
  echo "Configuring Git Alias'"
  echo "------------------------------"
  echo ""
  ./gitalias.sh

  echo ""
  echo "------------------------------"
  echo "Overwriting bash_profile"
  echo "------------------------------"
  echo ""
  cp .bash_profile ~/
  cp .profile ~/
  cp .editorconfig ~/
	cp .vimrc ~/
	cp .gitconfig ~/

	echo ""
  echo "------------------------------"
  echo "Installing Pathogen (VIM)"
  echo "------------------------------"
  echo ""
	mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

  echo ""
  echo "------------------------------"
  echo "ALL DONE!"
  echo "PLEASE REBOOT YOUR MACHINE NOW. WHY AM I SHOUTING?"
  echo "------------------------------"
  echo ""
}

read -p "This script may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
    doIt $@
fi;

unset runDots;
