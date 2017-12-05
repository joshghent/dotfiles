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

brew cleanup

npm i -g gulp
npm i -g eslint

curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer.phar

# Install latest ruby
rvm install ruby
rvm --default use ruby
gem install bundler --no-rdoc --no-ri

# Install git-up
gem install git-up

# git up - Will update all local branches with remote, autostash and rebase
git config --global alias.up '!git fetch && git rebase --autostash $(git for-each-ref --format "%(upstream:short)" $(git symbolic-ref -q HEAD))'
