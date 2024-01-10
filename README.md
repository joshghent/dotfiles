# 🏡 Dotfiles

> A set of scripts I use to setup new machines as well as my dotfiles.

## 🔧 Install

Run the following - **THIS WILL OVERWRITE YOUR BASH PROFILE, BE CAREFUL. YOU HAVE BEEN WARNED.**

```bash
$ git clone https://github.com/joshghent/dotfiles.git && cd dotfiles
$ make
```

After install, run `:call mkdp#util#install()` inside vim to install markdown preview

## ✅ TODO

- [] Automatically generate SSH key
- [] Get rid of bash file and use Makefile to coordinate and recover steps
- [x] Change to github actions
- [] Automate import of Iterm schema
- [] Add install via Curl - [like this](https://github.com/wookayin/dotfiles/blob/master/etc/install)
- [x] Add app installs
- [] Add all accounts (without passwords)
- [] Add colored output
- [] Silence the output of various commands
- [] Trim down 1to1 template
- [] Add header of the date to plan file automatically
