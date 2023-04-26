#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

brew install node
brew install nvm
mkdir ~/.nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install --lts
nvm use --lts
nvm alias default node

declare -a npms = (
  "typescript"
  "eslint"
  "npm-check-updates"
  "depcheck"
  "serverless"
  "mysql2"
  "sequelize"
  "vercel"
  "concurrent"
  "create-react-app"
  "bundlesize"
  "webpack"
  "ncc"
  "jest"
  "mocha"
  "git-split-diffs"
  "doctoc"
)

for npm in "${npms[@]}"; do
  npm install -g "$npm"
done

brew cleanup

# Install latest ruby
rvm install ruby
rvm --default use ruby
gem install bundler --no-rdoc --no-ri
gem install colorls
gem install travis

echo "Please enter your email: "
read -r email

ssh-keygen -t ed25519 -C "$email"
eval "$(ssh-agent -s)"
ssh-add -K ~/.ssh/id_ed25519
echo ~/.ssh/id_ed25519.pub
pbcopy < ~/.ssh/id_ed25519.pub
echo "SSH Key Copied to Clipboard. Please add to GitHub / GitLab"

# Install Monokai Refined theme for Vim
curl -o ~/.vim/colors/monokai-refined.vim https://raw.githubusercontent.com/jaromero/vim-monokai-refined/master/colors/Monokai-Refined.vim

# Install Rust
curl https://sh.rustup.rs -sSf | sh
