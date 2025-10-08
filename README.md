# 🏡 Cross-Platform Dotfiles

> My personal dotfiles and machine setup scripts managed with Chezmoi, supporting both macOS and Arch/EndeavourOS

## Screenshots

![code](code.png)

![terminal](terminal.png)

## 🚀 Features

- 🖥️ **Cross-Platform Support**: Works on macOS and Arch/EndeavourOS
- 📦 **Automated Package Installation**: Homebrew (macOS) and Pacman/AUR (Arch)
- 🔄 **Idempotent Installation**: Can run multiple times safely
- 🔐 **Secure Configuration Management**: GPG encryption support
- 🏢 **Work/Personal Machine Distinction**: Automatic configuration based on machine type
- 🐟 **Fish Shell Configuration**: Custom functions and aliases
- ⌨️ **Neovim Configuration**: Custom plugins and settings
- 🔧 **System-Specific Configuration**: macOS and Linux system preferences
- 🎯 **Chezmoi Templating**: Platform-specific configurations using built-in templating

## 📥 Installation

### Prerequisites

1. **Install Chezmoi**:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
```

2. **Clone the repository**:

```bash
chezmoi init git@github.com:joshghent/dotfiles.git
```

### Quick Start

1. **First-time setup** (interactive):

```bash
make first-time
```

2. **Full installation**:

```bash
make install
```

3. **Install prerequisites only**:

```bash
make prerequisites
```

## 🔄 Updates

To update your configuration and packages:

```bash
make update
```

To check what would change:

```bash
make check
```

To update user configuration:

```bash
make config
```

To see current configuration:

```bash
make status
```

## 📁 Structure

```
dotfiles/
├── config/                 # Configuration files
│   └── packages.yaml      # Cross-platform package definitions
├── scripts/               # Installation scripts
│   ├── install.sh        # Main installation script
│   ├── configure.sh      # User configuration
│   ├── packages.sh       # Cross-platform package installer
│   ├── macos.sh          # macOS-specific configuration
│   ├── linux.sh          # Linux-specific configuration
│   └── setup_gpg.sh      # GPG setup
├── dot_config/           # Dotfiles managed by chezmoi
│   ├── fish/            # Fish shell configuration
│   ├── nvim/            # Neovim configuration
│   └── ...
└── Makefile             # Command interface
```

## 🖥️ Platform Support

### macOS

- **Package Manager**: Homebrew
- **Applications**: Cask applications
- **System Configuration**: macOS preferences
- **Shell**: Fish shell with macOS-specific paths

### Arch/EndeavourOS with Omarchy

- **Package Manager**: Pacman + AUR (yay/paru)
- **Applications**: Omarchy pre-installed + additional packages
- **System Configuration**: Omarchy-managed + systemd services
- **Shell**: Fish shell (Omarchy default)
- **Window Manager**: Hyprland (Omarchy default)
- **UI Components**: Waybar, Walker, Mako (Omarchy defaults)

## ⚙️ Customization

### Adding New Packages

Edit `config/packages.yaml` to add packages for both platforms:

```yaml
# macOS Homebrew packages
{{ if eq .chezmoi.os "darwin" }}
homebrew:
  packages:
    base:
      - "your-package"
{{ end }}

# Arch/EndeavourOS Pacman packages
{{ if eq .chezmoi.os "linux" }}
pacman:
  packages:
    base:
      - "your-package"
  aur_packages:
    base:
      - "your-aur-package"
{{ end }}
```

### Personal vs Work Setup

The installation automatically handles different setups:

- **Work machines**: Skip applications requiring admin rights
- **Personal machines**: Get additional applications and configurations
- **Configuration**: Set via `make config` or during first-time setup

### Platform-Specific Configuration

Use Chezmoi's templating for platform-specific files:

```bash
# macOS-specific file
{{ if eq .chezmoi.os "darwin" }}
# macOS configuration here
{{ end }}

# Linux-specific file
{{ if eq .chezmoi.os "linux" }}
# Linux configuration here
{{ end }}
```

## 🔧 Available Commands

```bash
make first-time     # Initial setup (interactive)
make install        # Full installation
make update         # Update existing configuration
make config         # Update user configuration
make apply          # Apply dotfiles changes
make check          # Check for differences
make status         # Show current configuration
make prerequisites  # Install prerequisites only
make help           # Show all commands
```

## 🛠️ Development

### Testing

```bash
make test           # Run shellcheck tests
```

### Adding New Scripts

1. Create script in `scripts/` directory
2. Make it executable: `chmod +x scripts/your-script.sh`
3. Add to `Makefile` if needed
4. Update documentation

## 📋 Requirements

### macOS

- Homebrew (installed automatically)
- yq (installed automatically)

### Arch/EndeavourOS with Omarchy

- **Omarchy** (recommended): Complete Arch + Hyprland setup
- Pacman package manager
- yq (installed automatically)
- Git (installed automatically)

### Both Platforms

- Chezmoi
- Fish shell (installed automatically)
- Neovim (installed automatically)

## 🎯 Omarchy Integration

This dotfiles setup is optimized for [Omarchy](https://github.com/omamix/omarchy), an opinionated Arch + Hyprland distribution. Omarchy provides:

- **Pre-configured Hyprland**: Tiling window manager with beautiful themes
- **Essential tools**: Fish shell, Neovim, fzf, zoxide, ripgrep, and more
- **Development environment**: Node.js, Python, Go, Rust, Docker
- **UI components**: Waybar, Walker (app launcher), Mako (notifications)
- **Multiple themes**: Tokyo Night, Catppuccin, Everforest, and more
- **Keyboard-first navigation**: Everything accessible via hotkeys

### Installing Omarchy

1. **Install Arch Linux** first (see [Omarchy manual](https://manuals.omamix.org/2/the-omarchy-manual))
2. **Install Omarchy** on top of Arch
3. **Run this dotfiles setup** to add your personal configurations

### What This Setup Adds

- **Additional packages**: Tools not included in Omarchy (Ansible, Terraform, etc.)
- **Personal applications**: Cursor, Dropbox, ProtonMail Bridge, etc.
- **Custom configurations**: Your personal dotfiles and preferences
- **Development tools**: Additional language tools and utilities

The setup automatically detects Omarchy and installs only the additional packages you need.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on both platforms
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
