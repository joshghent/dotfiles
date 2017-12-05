# Dotfiles
A set of scripts I use to setup new machines as well as my dotfiles.

## Install
Run the following - **THIS WILL OVERWRITE YOUR BASH PROFILE, BE CAREFUL. YOU HAVE BEEN WARNED.**
  ```bash
  $ git clone https://github.com/joshghent/dotfiles.git
  $ chmod -R 777 dotfiles
  $ cd dotfiles
  $ bash run.sh
  ```

## What it does
### MacOS
* Updated and installs Homebrew for managing packages
* Install XCode command line tools
* A bunch of sensible defaults - review macos.sh and review any you are not sure of

### Javascript
* NodeJS + NPM
* NVM
* Gulp
* ESLint

### Programs
* Basecamp - Project management/messaging tool
* Google Drive - All files live here
* iTerm2 - It's just better than terminal.app. Period.
* Filezilla - FTP Client
* MAMP PRO - For local PHP Development
* SequelPro - Nice GUI for viewing, querying DB's
* Chrome - Browser
* Sonos - Music player for the office sonos
* Spectacle - A window manger
* Spotify - La musique
* VirtualBox - Required by Vagrant + useful if you want to play WinXP Pinball :smile:
* Vagrant - Needed for doing Laravel development
* Vagrant manager - Nice GUI for managing vagrant boxes
* Docker
* Kitematic - A nice GUI for your docker containers

### PHP
* Composer - package manager for PHP

### Git
* Add aliases for the following
  * gc - git commit
  * gpo - git push origin
  * ga - git add -A
  * git praise - git blame
  * git fancylog - git log --graph --all --decorate --stat --date=iso
  * git-up - autostash and rebase all local branches with remote
