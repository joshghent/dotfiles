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

sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

brew tap jesseduffield/lazydocker
brew tap homebrew/cask-fonts

declare -a brews=(
	"ansible"
	"git"
	"yarn"
	"mysql"
	"redis"
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
	"zsh"
	"rbenv"
	"imagemagick"
	"git-delta"
  "deno"
  "gh"
  "pyenv"
  "diff-so-fancy"
  "terraform"
  "telnet"
  "tmate"
  "ffmpeg"
  "tmux"
  "mas"
  "the_silver_searcher"
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
	"iterm2"
	"spectacle"
	"spotify"
	"docker"
	"postman"
	"bartender"
	"discord"
	"visual-studio-code"
	"rescuetime"
	"font-fira-code"
	"font-hack-nerd-font"
	"slack"
	"zoom"
	"gpg-suite-pinentry"
	"gpg-suite"
	"rocket"
	"toggl-track"
	"signal"
	"hazel"
  "firefox"
  "crossover"
)

# Install casks in a loop
for i in "${casks[@]}"
do
	brew install "$i" --cask
done

curl -sSL https://get.rvm.io | bash -s stable --ruby

brew cleanup


declare -a appstore=(
  "1176895641" # Spark Email
  "585829637" # Todoist
  "568494494" # Pocket
  "1451685025" # Wireguard
  "926036361" # Lastpass
  "1440147259" # AdGuard
)

# TablePlus Install
wget https://tableplus.com/release/osx/tableplus_latest -o ~/Downloads/tableplus.dmg
hdiutil attach ~/Downloads/tableplus.dmg

# Notion Install
wget https://www.notion.so/desktop/apple-silicon/download -o ~/Downloads/notion.dmg
hdiutil attach ~/Downloads/notion.dmg
