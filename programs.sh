#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade --all

# Install GNU core utilities (those that come with OS X are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names
# Install Bash 4.
brew install bash
brew tap homebrew/versions
brew install bash-completion2
# We installed the new shell, now we have to activate it
echo "Adding the newly installed shell to the list of allowed shells"
# Prompts for password
sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
# Change to the new shell, prompts for password
chsh -s /usr/local/bin/bash

# Nmap has a bunch of useful network tools
brew install nmap

# #obvi
brew install git

brew install yarn
brew install mysql
brew install redis
brew install php71
brew install postgresql

sh -c "$(curl -fsSL https://raw.githubusercontent.com/guarinogabriel/mac-cli/master/mac-cli/tools/install)"

# Install Cask
brew install caskroom/cask/brew-cask
brew tap caskroom/versions

brew tap homebrew/science
brew install wget
brew install gpg

brew cask install google-chrome
brew cask install basecamp
brew cask install iterm2
brew cask install filezilla
brew cask install google-backup-and-sync
brew cask install mamp
brew cask install sequel-pro
brew cask install sonos
brew cask install spectacle
brew cask install spotify
brew cask install mojibar
brew cask install virtualbox
brew cask install vagrant
brew cask install vagrant-manager
brew cask install docker
brew cask install kitematic
brew cask install postman

# Install the Sonos Controller app
rm ~/Downloads/sonos.dmg
wget -O ~/Downloads/sonos.dmg "https://www.sonos.com/redir/controller_software_mac"
open ~/Downloads/sonos.dmg

curl -sSL https://get.rvm.io | bash -s stable --ruby

echo "------------------------------"
echo "We will now ask you which editors you would like. Feel free to chose, all, one or none as is your preference."
echo "------------------------------"


echo "Do you wish to install VSCode?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) brew cask install vscode; break;;
        No ) break;;
    esac
done

echo "Do you wish to install Sublime Text?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) brew cask install sublime-text; break;;
        No ) break;;
    esac
done

echo "Do you wish to install Atom?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) brew cask install atom; break;;
        No ) break;;
    esac
done

brew cleanup

cd ~/Downloads
wget https://download.panic.com/coda/Coda%202.6.6.zip -O ~/Downloads/Coda.zip
unzip Coda.zip
rm Coda.zip
mv "Coda 2.app" /Application
