#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

brew install node
brew install nvm
mkdir ~/.nvm
nvm install node
nvm use node
nvm alias default node

npm i -g typescript tslint eslint create-react-app

brew cleanup

# Install latest ruby
rvm install ruby
rvm --default use ruby
gem install bundler --no-rdoc --no-ri

echo "Please enter your email: "
read -r email

ssh-keygen -t rsa -b 4096 -C "$email"
eval "$(ssh-agent -s)"
ssh-add -K ~/.ssh/id_rsa
pbcopy < ~/.ssh/id_rsa.pub
echo "SSH Key Copied to Clipboard. Please add to GitHub / GitLab"
