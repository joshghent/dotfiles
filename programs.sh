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
  "cmake"
  "ipfs"
  "neofetch"
  "tfenv"
  "act"
  "trufflehog"
  "pre-commit"
  "detect-secrets"
  "terraform-docs"
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
	"spotify"
	"docker"
	"bartender"
	"discord"
	"font-fira-code"
	"font-hack-nerd-font"
	"slack"
	"zoom"
	"gpg-suite-pinentry"
	"gpg-suite"
	"hazel"
  "firefox"
  "font-inter"
  "wireguard"
  "rectangle"
  "bruno"
  "vscodium"
  "zed"
)

# Install casks in a loop
for i in "${casks[@]}"
do
	brew install "$i" --cask
done

brew cleanup

# TablePlus Install
wget https://tableplus.com/release/osx/tableplus_latest -o ~/Downloads/tableplus.dmg
hdiutil attach ~/Downloads/tableplus.dmg

# Oh my ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


# Antigen install
curl -L git.io/antigen > antigen.zsh

# Install Playwright
npx playwright install --with-deps

# Install latest Terraform
tfenv install latest && tfenv use latest

# Set Iterm2 settings to pull from dotfiles
# Please note: you probably need to update the projects path
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "~/dotfiles"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
