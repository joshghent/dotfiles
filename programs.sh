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
    "imagemagick"
    "git-delta"
    "deno"
    "gh"
    "pyenv"
    "diff-so-fancy"
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
    "colima"
    "docker"
    "docker-credential-helper"
    "lazydocker"
    "pnpm"
    "mise"
    "nvim"
    "ripgrep" # required for nvim file searching
    "qemu" # required for colima
)

# Install brews in a loop
for i in "${brews[@]}"
do
	brew install "$i"
done

declare -a casks=(
    "spotify"
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
    "protonmail-bridge"
    "google-drive"
    "dropbox"
    "steam"
    "protonvpn"
    "calibre"
    "tailscale"
    "vlc"
    "deluge"
    "leapp"
    "font-jetbrains-mono-nerd-font"
    "ghostty"
    "nikitabobko/tap/aerospace"
)

# Install casks in a loop
for i in "${casks[@]}"
do
	brew install "$i" --cask
done

brew cleanup

# We installed the new shell, now we have to activate it
echo "🐟 Installing Fish shell. This will prompt for your password."
# Prompts for password
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
# Change to the new shell, prompts for password
chsh -s /opt/homebrew/bin/fish

# Change the theme and prompt for fish
fish && fish_config theme choose nord && fish_config prompt choose arrow && fish_config prompt save && fish_config theme save

# Install Node and other dependencies with mise
mise use -g node
mise use -g rust
mise use -g ruby

# Configure Neovim
git clone https://github.com/NvChad/starter ~/.config/nvim && nvim # Install nvchad
rm -rf ~/.config/nvim/.git # Remove the .git folder for nvim

# TablePlus Install
wget https://tableplus.com/release/osx/tableplus_latest -o ~/Downloads/tableplus.dmg
hdiutil attach ~/Downloads/tableplus.dmg

# Install Playwright
npx playwright install --with-deps

# Install latest Terraform
tfenv install latest && tfenv use latest

# Autostart docker
brew services start colima
