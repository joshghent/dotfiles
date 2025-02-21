# 🏡 Dotfiles

> A set of scripts I use to setup new machines as well as my dotfiles.

## Screenshots
![code](code.png)

![terminal](terminal.png)

## 🔧 Install

Run the following - **THIS WILL OVERWRITE YOUR BASH PROFILE, BE CAREFUL. YOU HAVE BEEN WARNED.**

```bash
$ sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:joshghent/dotfiles.git
```

To update...
```
$ chezmoi git pull
```
