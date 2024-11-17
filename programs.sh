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

brew tap homebrew/cask-fonts

declare -a brews=(
    "ansible"
    "git"
    "yarn"
    "php"
    "composer"
    "nmap"
    "wget"
    "gpg"
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
    "the_silver_searcher"
    "cmake"
    "neofetch"
    "tfenv"
    "trufflehog"
    "pre-commit"
    "detect-secrets"
    "terraform-docs"
    "rust"
    "nvm"
    "rvm"
)

# Install brews in a loop
for i in "${brews[@]}"
do
	brew install "$i"
done

# We installed the new shell, now we have to activate it
echo "🐟 Installing Fish shell. This will prompt for your password."
# Prompts for password
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
# Change to the new shell, prompts for password
chsh -s /opt/homebrew/bin/fish

declare -a casks=(
    "iterm2"
    "spotify"
    "docker"
    "discord"
    "font-fira-code"
    "font-hack-nerd-font"
    "slack"
    "zoom"
    "gpg-suite-pinentry"
    "gpg-suite"
    "firefox"
    "font-inter"
    "wireguard"
    "rectangle"
    "bruno"
    "vscodium"
    "zed"
    "cursor"
    "hiddenbar"
    "google-drive"
)

# Install casks in a loop
for i in "${casks[@]}"
do
	brew install "$i" --cask
done

brew cleanup

# Install latest LTS Node
mkdir ~/.nvm
export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
nvm install --lts
nvm use --lts
nvm alias default node

# TablePlus Install
wget https://tableplus.com/release/osx/tableplus_latest -o ~/Downloads/tableplus.dmg
hdiutil attach ~/Downloads/tableplus.dmg

# Install Playwright
npx playwright install --with-deps

# Install latest Terraform
tfenv install latest && tfenv use latest

# Install latest ruby
rvm install ruby
rvm --default use ruby

# Install Monokai Refined theme for Vim
curl -o ~/.vim/colors/monokai-refined.vim https://raw.githubusercontent.com/jaromero/vim-monokai-refined/master/colors/Monokai-Refined.vim

# Change the theme and prompt for fish
fish && fish_config theme choose nord && fish_config prompt choose arrow && fish_config prompt save && fish_config theme save
