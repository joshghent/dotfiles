#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew,
# Install if we don't have it
if test ! "$(command -v brew)"; then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade --all

sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

brew tap jesseduffield/lazydocker

sh -c "$(curl -fsSL https://raw.githubusercontent.com/guarinogabriel/mac-cli/master/mac-cli/tools/install)"

declare -a brews=(
	"git"
	"yarn"
	"mysql"
	"redis"
	"mongodb"
	"php"
	"composer"
	"postgresql"
	"nmap"
	"wget"
	"gpg"
	"bash"
	"bash-completion2"
	"coreutils"
	"moreutils"
	"findutils"
	"awscli"
	"docker"
	"go"
	"tree"
	"bat"
	"php-cs-fixer",
	"lazydocker",
)

# Install brews in a loop
for i in "${brews[@]}"
do
	brew install "$i"
done

# We installed the new shell, now we have to activate it
echo "Adding the newly installed shell to the list of allowed shells"
# Prompts for password
sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
# Change to the new shell, prompts for password
chsh -s /usr/local/bin/bash

declare -a casks=(
	"google-chrome"
	"iterm2"
	"filezilla"
	"google-backup-and-sync"
	"sequel-pro"
	"robo-3t"
	"spectacle"
	"spotify"
	"docker"
	"kitematic"
	"postman"
	"beardedspice"
	"bartender"
	"now"
	"backblaze"
	"discord"
	"visual-studio-code"
	"visual-studio"
	"teamviewer"
	"visual-studio"
	"tunnelblick"
	"rescuetime"
	"pocketcasts"
	"font-fira-code"
	"font-hack-nerd-font"
	"slack"
	"keka"
	"dotnet-sdk"
	"aerial"
)

# Install casks in a loop
for i in "${casks[@]}"
do
	brew cask install "$i"
done

mas install 803453959 # slack
mas install 585829637 # todoist
mas install 1147396723 # whatsapp
mas install 409183694 # keynote

# Install laravel and valet
composer global require laravel/installer
composer global require laravel/valet
valet domain app
# shellcheck disable=SC2164
cd ~/Projects && valet park && cd ~

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable --ruby

brew cleanup
