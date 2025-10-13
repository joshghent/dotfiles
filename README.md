# 🏡 Cross-Platform Dotfiles

> My personal dotfiles and machine setup scripts managed with Chezmoi - support for MacOS. Coming soon on Fedora.

## Screenshots

![code](code.png)

![terminal](terminal.png)

## 📥 Installation

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
chezmoi init git@github.com:joshghent/dotfiles.git
chezmoi apply
```
