# 🏡 Cross-Platform Dotfiles

> My personal dotfiles and machine setup scripts managed with Chezmoi - supports both macOS and Fedora Linux!

## Screenshots

![code](code.png)

![terminal](terminal.png)

## 🚀 Features

- **Cross-Platform**: Seamlessly works on both macOS and Fedora Linux
- **Package Management**: Automatic package installation via Homebrew (macOS) and DNF/Flatpak (Fedora)
- **Modern Tools**: Fish shell, Neovim, Git Delta, and more
- **Window Management**:
  - macOS: Aerospace + Sketchybar
  - Fedora: Hyprland + Waybar
- **Consistent Experience**: Shared configurations where possible, platform-specific where necessary

## 📥 Installation

### Prerequisites

Install Chezmoi:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
```

### Clone and Apply

```bash
chezmoi init git@github.com:joshghent/dotfiles.git
chezmoi apply
```

### Post-Installation

#### macOS
The installation script will automatically:
- Install Homebrew packages and casks
- Configure Aerospace window manager
- Setup Sketchybar

#### Fedora
The installation script will automatically:
- Enable RPM Fusion and Flathub repositories
- Install DNF packages and Flatpak applications
- Setup Hyprland window manager
- Configure Waybar status bar

**First login**: After installation, log out and select "Hyprland" from your display manager (GDM/SDDM)

## 🛠️ Platform-Specific Configurations

### macOS
- **Window Manager**: Aerospace (tiling window manager)
- **Status Bar**: Sketchybar
- **Package Manager**: Homebrew
- **Container Runtime**: Colima

### Fedora
- **Window Manager**: Hyprland (Wayland compositor)
- **Status Bar**: Waybar
- **Launcher**: Rofi
- **Package Managers**: DNF + Flatpak
- **Container Runtime**: Podman

## 📦 Key Tools Included

### Common (Both Platforms)
- **Shell**: Fish with custom functions and aliases
- **Editor**: Neovim with modern plugins
- **Git**: Enhanced with Delta diff viewer
- **Terminal**: Kitty
- **File Navigation**: Yazi, Ranger
- **CLI Tools**: ripgrep, bat, fzf, lazygit, lazydocker

### Development Tools
- Version managers (mise)
- Docker/Podman
- Various language toolchains (Go, Rust, Python, Node.js)

## 🔧 Customization

The dotfiles use Chezmoi templates for cross-platform compatibility. Key template files:
- `dot_config/fish/config.fish.tmpl` - Fish shell configuration
- `dot_gitconfig.tmpl` - Git configuration
- `run_once_before_install-packages-*.sh.tmpl` - Package installation scripts

## 📝 Notes

- First-time setup may take 10-30 minutes depending on your internet connection
- On Fedora, you may need to enable additional COPR repositories for some packages
- GPU drivers for Wayland/Hyprland should be installed separately if needed
