#!/usr/bin/env bash

# Add git alias'

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

git config --global alias.fancylog 'log --graph --all --decorate --stat --date=iso'
git config --global alias.praise blame
