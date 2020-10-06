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
brew tap homebrew/cask-fonts

declare -a brews=(
	"ansible"
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
	"php-cs-fixer"
	"lazydocker"
	"zsh"
	"rbenv"
	"hub"
	"imagemagick"
	"git-delta"
    "deno"
    "gh"
    "pyenv"
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
	"robo-3t"
	"spectacle"
	"spotify"
	"docker"
	"postman"
	"bartender"
	"vercel"
	"discord"
	"visual-studio-code"
	"visual-studio"
	"teamviewer"
	"tunnelblick"
	"rescuetime"
	"pocketcasts"
	"font-fira-code"
	"font-hack-nerd-font"
	"slack"
	"keka"
	"dotnet-sdk"
	"zoomus"
	"gpg-suite-pinentry"
	"gpg-suite"
	"rocket"
	"keybase"
	"telegram"
	"skype"
	"toggl-track"
	"whatsapp"
	"tableplus"
)

# Install casks in a loop
for i in "${casks[@]}"
do
	brew cask install "$i"
done

code --install-extension Shan.code-settings-sync

# Install laravel and valet
composer global require laravel/installer
composer global require laravel/valet
valet domain app
# shellcheck disable=SC2164
cd ~/Projects && valet park && cd ~

curl -sSL https://get.rvm.io | bash -s stable --ruby

brew cleanup
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
curl -L git.io/antigen > ~/antigen.zsh
