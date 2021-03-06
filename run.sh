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

	echo ""
  echo "------------------------------"
  echo "Overwriting bash_profile"
  echo "------------------------------"
  echo ""
  cp .ssh ~/
  cp -R .vim ~/
  ./link.sh

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

	echo ""
  echo "------------------------------"
  echo "Installing Pathogen (VIM)"
  echo "------------------------------"
  echo ""
	mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  vim +PluginInstall +qall

  echo ""
  echo "------------------------------"
  echo "Installing ZSH"
  echo "------------------------------"
  echo ""
  zsh
  source ~/.zshrc

  echo "Fixing Comp Init errors - please review this file if you still experience issues"
  compaudit | xargs -I % chmod g-w "%"
  rm ~/.zcompdump*


  echo ""
  echo "------------------------------"
  echo "Generate SSH Keys and Configure Git"
  echo "------------------------------"
  echo ""
  git config --global user.name $name;
  git config --global user.email $email;
  ssh-keygen -t ed25519 -C "$email"


  echo ""
  echo "------------------------------"
  echo "ALL DONE!"
  echo "PLEASE REBOOT YOUR MACHINE NOW. WHY AM I SHOUTING?"
  echo "------------------------------"
  echo ""
}

read -p "This script may overwrite existing files in your home directory. Are you sure? (y/n) " -r -n 1 confirm;
echo "";

read -p "Please enter your Email" -r -n 1 email;
read -p "Please enter your Name" -r -n 1 name;

if [[ $confirm =~ ^[Yy]$ ]]; then
    doIt "$@"
fi;

unset runDots;
