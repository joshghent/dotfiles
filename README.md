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

After the initial install make sure to configure VSCode with Settings sync from [this gist](https://gist.github.com/joshghent/f1d8dd0f1750a7f66e405c5a513a94da)
Then generate ssh keys and gpg keys and add them to git and you're done!

Please also run
```bash
# Setup Git
$ git config --global user.name "Josh Ghent"
$ git config --global user.email "youremail@example.com"
```

Install TablePlus and Notion as the casks do not work

## Updating
```
$ gfo && git rebase origin/master master
$ make
```

## What it does
### MacOS
* Updated and installs Homebrew for managing packages
* Install XCode command line tools
* A bunch of sensible defaults - review macos.sh and review any you are not sure of

### Programs
Please see [programs.sh](programs.sh) for a full list of install programs

### Git
* Adds various aliases - see `.gitconfig` for a full list
