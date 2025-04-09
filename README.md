# 🏡 Dotfiles

> My personal dotfiles and machine setup scripts managed with Chezmoi

## Screenshots
![code](code.png)

![terminal](terminal.png)

## 🚀 Features

- 📦 Automated package installation via Homebrew
- 🔄 Idempotent installation (can run multiple times safely)
- 🔐 Secure configuration management
- 🖥️ Work/Personal machine distinction
- 🐟 Fish shell configuration with custom functions and aliases
- ⌨️ Neovim configuration with custom plugins
- 🔧 macOS system preferences configuration

## 📥 Installation

1. Clone the repository:
```bash
git clone https://github.com/joshghent/dotfiles.git && cd dotfiles
```

2. Run the installation:
```bash
make install
```

3. Follow the prompts to configure:
   - Your name and email
   - Whether this is a personal or work machine

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

## 📁 Structure

```
dotfiles/
├── config/                 # Configuration files
│   └── packages.yaml      # Package definitions
├── home/                  # Dotfiles managed by chezmoi
│   └── dot_config/       # Configuration files
│       ├── fish/        # Fish shell configuration
│       ├── nvim/        # Neovim configuration
│       └── ...
├── scripts/              # Installation scripts
└── Makefile             # Command interface
```

## ⚙️ Customization

### Adding New Packages

Edit `config/packages.yaml` to add:
- Homebrew packages
- Cask applications
- Post-install tasks

### Personal vs Work Setup
The installation automatically handles different setups for work and personal machines:
- Work machines skip certain applications that require admin rights
- Personal machines get additional applications and configurations
- A list of manual installations is generated for work machines
