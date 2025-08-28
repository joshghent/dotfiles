#!/usr/bin/env bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}INFO:${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}WARN:${NC} $1"
}

log_error() {
    echo -e "${RED}ERROR:${NC} $1"
}

log_debug() {
    echo -e "${BLUE}DEBUG:${NC} $1"
}

# Detect operating system
detect_os() {
    case "$(uname -s)" in
        Darwin*) echo "darwin" ;;
        Linux*) echo "linux" ;;
        *) echo "unknown" ;;
    esac
}

# Detect package manager
detect_package_manager() {
    local os=$(detect_os)
    case "$os" in
        darwin) echo "homebrew" ;;
        linux) echo "pacman" ;;
        *) echo "unknown" ;;
    esac
}

# Install Homebrew packages (macOS)
install_homebrew_packages() {
    local is_personal="$1"
    local update_only="$2"
    local failed_packages=()

    log_info "Installing Homebrew packages..."

    # Install Homebrew if needed
    if ! command -v brew >/dev/null; then
        if [ "$update_only" = true ]; then
            log_warn "Homebrew not found but running in update-only mode"
            return 0
        else
            log_info "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
    fi

    # Update Homebrew
    log_info "Updating Homebrew..."
    brew update

    if [ "$update_only" = true ]; then
        log_info "Updating existing packages only..."
        brew upgrade
        brew upgrade --cask
        return 0
    fi

    # Process packages using yq
    for category in "base" "development" "security" "tools"; do
        local category_packages
        category_packages=$(yq e ".homebrew.packages.${category}[]" "$REPO_DIR/config/packages.yaml" 2>/dev/null)

        if [ -n "$category_packages" ]; then
            log_info "Installing $category packages..."
            for package in $category_packages; do
                if ! brew_install "$package"; then
                    failed_packages+=("$package")
                fi
            done
        fi
    done

    # Add personal packages if enabled
    if [ "$is_personal" = "true" ]; then
        local personal_packages
        personal_packages=$(yq e '.homebrew.packages.personal.packages[]' "$REPO_DIR/config/packages.yaml" 2>/dev/null)

        if [ -n "$personal_packages" ]; then
            log_info "Installing personal packages..."
            for package in $personal_packages; do
                if ! brew_install "$package"; then
                    failed_packages+=("$package")
                fi
            done
        fi
    fi

    # Process casks
    process_homebrew_casks "$is_personal"

    # Report failed packages
    if [ ${#failed_packages[@]} -ne 0 ]; then
        log_error "Failed to install the following packages:"
        printf '%s\n' "${failed_packages[@]}"
        return 1
    fi
}

# Install or upgrade a Homebrew package
brew_install() {
    if ! brew list "$1" &>/dev/null; then
        log_info "Installing $1..."
        if ! brew install "$1"; then
            log_error "Failed to install $1"
            return 1
        fi
    else
        log_info "Upgrading $1..."
        brew upgrade "$1" || true
    fi
}

# Process Homebrew casks
process_homebrew_casks() {
    local is_personal="$1"
    local is_work=$([ "$is_personal" = "false" ] && echo "true" || echo "false")
    local failed_casks=()

    # Clear previous manual installations list
    echo "# The following applications need to be installed manually:" > "$REPO_DIR/manual_installs.txt"

    log_info "Installing casks..."

    # Process each category separately
    for category in "base" "development" "fonts" "communication"; do
        local category_casks
        category_casks=$(yq e ".homebrew.casks.${category}[]" "$REPO_DIR/config/packages.yaml" 2>/dev/null)

        if [ -n "$category_casks" ]; then
            for cask in $category_casks; do
                if ! cask_install "$cask" "$is_work"; then
                    failed_casks+=("$cask")
                fi
            done
        fi
    done

    # Add personal casks if enabled
    if [ "$is_personal" = "true" ]; then
        local personal_casks
        personal_casks=$(yq e '.homebrew.casks.personal.packages[]' "$REPO_DIR/config/packages.yaml" 2>/dev/null)

        if [ -n "$personal_casks" ]; then
            for cask in $personal_casks; do
                if ! cask_install "$cask" "$is_work"; then
                    failed_casks+=("$cask")
                fi
            done
        fi
    fi

    # Report failed casks
    if [ ${#failed_casks[@]} -ne 0 ]; then
        if [ "$is_work" = "true" ]; then
            log_warn "Some casks could not be installed automatically."
            log_info "Please check manual_installs.txt for the list of applications to install manually."
        else
            log_error "Failed to install the following casks:"
            printf '%s\n' "${failed_casks[@]}"
            return 1
        fi
    fi
}

# Install or upgrade a Homebrew cask
cask_install() {
    local cask="$1"
    local is_work="$2"

    if ! brew list --cask "$cask" &>/dev/null; then
        log_info "Installing cask $cask..."
        if ! brew install --cask "$cask" 2>/dev/null; then
            if [ "$is_work" = "true" ]; then
                log_warn "Failed to install cask $cask. This is expected on work machines with admin restrictions."
                log_warn "Please install $cask manually through your admin account."
                echo "$cask" >> "$REPO_DIR/manual_installs.txt"
            else
                log_error "Failed to install cask $cask"
                return 1
            fi
        fi
    else
        log_info "Upgrading cask $cask..."
        brew upgrade --cask "$cask" || true
    fi
}

# Install Pacman packages (Arch/EndeavourOS with Omarchy)
install_pacman_packages() {
    local is_personal="$1"
    local update_only="$2"
    local failed_packages=()

    log_info "Installing Pacman packages (Omarchy-compatible)..."

    # Check if Omarchy is installed
    local has_omarchy=false
    if [ -d "$HOME/.local/share/omarchy" ]; then
        has_omarchy=true
        log_info "Omarchy detected - installing only additional packages"
    else
        log_warn "Omarchy not detected - consider installing Omarchy for the best experience"
    fi

    # Update system first
    log_info "Updating system packages..."
    sudo pacman -Syu --noconfirm

    if [ "$update_only" = true ]; then
        log_info "Updating existing packages only..."
        sudo pacman -Syu --noconfirm
        return 0
    fi

    # Process packages using yq (only base category for Omarchy)
    local category_packages
    category_packages=$(yq e ".pacman.packages.base[]" "$REPO_DIR/config/packages.yaml" 2>/dev/null)

    if [ -n "$category_packages" ]; then
        log_info "Installing additional packages (not included in Omarchy)..."
        for package in $category_packages; do
            if ! pacman_install "$package"; then
                failed_packages+=("$package")
            fi
        done
    fi

    # Add personal packages if enabled
    if [ "$is_personal" = "true" ]; then
        local personal_packages
        personal_packages=$(yq e '.pacman.packages.personal.packages[]' "$REPO_DIR/config/packages.yaml" 2>/dev/null)

        if [ -n "$personal_packages" ]; then
            log_info "Installing personal packages..."
            for package in $personal_packages; do
                if ! pacman_install "$package"; then
                    failed_packages+=("$package")
                fi
            done
        fi
    fi

    # Install AUR packages
    install_aur_packages "$is_personal"

    # Report failed packages
    if [ ${#failed_packages[@]} -ne 0 ]; then
        log_error "Failed to install the following packages:"
        printf '%s\n' "${failed_packages[@]}"
        return 1
    fi
}

# Install or upgrade a Pacman package
pacman_install() {
    if ! pacman -Q "$1" &>/dev/null; then
        log_info "Installing $1..."
        if ! sudo pacman -S --noconfirm "$1"; then
            log_error "Failed to install $1"
            return 1
        fi
    else
        log_info "Package $1 is already installed"
    fi
}

# Install AUR packages
install_aur_packages() {
    local is_personal="$1"
    local aur_helper=""

    # Try to find an AUR helper (Omarchy includes yay)
    if command -v yay >/dev/null; then
        aur_helper="yay"
    elif command -v paru >/dev/null; then
        aur_helper="paru"
    else
        log_warn "No AUR helper found. Installing yay..."
        if ! install_yay; then
            log_error "Failed to install yay. AUR packages will be skipped."
            return 1
        fi
        aur_helper="yay"
    fi

    log_info "Installing AUR packages using $aur_helper..."

    # Process AUR packages (only personal category for Omarchy)
    if [ "$is_personal" = "true" ]; then
        local personal_packages
        personal_packages=$(yq e '.pacman.aur_packages.personal.packages[]' "$REPO_DIR/config/packages.yaml" 2>/dev/null)

        if [ -n "$personal_packages" ]; then
            log_info "Installing personal AUR packages..."
            for package in $personal_packages; do
                if ! aur_install "$package" "$aur_helper"; then
                    log_warn "Failed to install AUR package $package"
                fi
            done
        fi
    fi
}

# Install yay AUR helper
install_yay() {
    log_info "Installing yay AUR helper..."
    sudo pacman -S --needed git base-devel --noconfirm
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd "$REPO_DIR"
    rm -rf /tmp/yay
}

# Install or upgrade an AUR package
aur_install() {
    local package="$1"
    local aur_helper="$2"

    if ! pacman -Q "$package" &>/dev/null; then
        log_info "Installing AUR package $package..."
        if ! $aur_helper -S --noconfirm "$package"; then
            log_error "Failed to install AUR package $package"
            return 1
        fi
    else
        log_info "AUR package $package is already installed"
    fi
}

# Run post-install tasks
run_post_install() {
    local os=$(detect_os)
    local is_personal="$1"

    if [ "$os" = "darwin" ]; then
        run_homebrew_post_install "$is_personal"
    elif [ "$os" = "linux" ]; then
        run_pacman_post_install "$is_personal"
    fi
}

# Run Homebrew post-install tasks
run_homebrew_post_install() {
    local is_personal="$1"

    log_info "Running Homebrew post-install tasks..."

    # Get all task names first
    local task_names
    task_names=$(yq e '.homebrew.post_install.tasks[].name' "$REPO_DIR/config/packages.yaml" 2>/dev/null)

    # Process each task
    while IFS= read -r task_name; do
        if [ -n "$task_name" ]; then
            log_info "Running task: $task_name"
            # Get commands for this task
            yq e ".homebrew.post_install.tasks[] | select(.name == \"$task_name\") | .commands[]" "$REPO_DIR/config/packages.yaml" 2>/dev/null | \
            while IFS= read -r cmd; do
                if [ -n "$cmd" ]; then
                    log_info "Executing: $cmd"
                    if ! eval "$cmd"; then
                        log_error "Failed to execute command in task: $task_name"
                        log_error "Command: $cmd"
                    fi
                fi
            done
        fi
    done <<< "$task_names"

    # Run personal post-install tasks if enabled
    if [ "$is_personal" = "true" ]; then
        log_info "Running personal Homebrew post-install tasks..."

        # Get all personal task names
        local personal_task_names
        personal_task_names=$(yq e '.homebrew.post_install.personal.tasks[].name' "$REPO_DIR/config/packages.yaml" 2>/dev/null)

        # Process each personal task
        while IFS= read -r task_name; do
            if [ -n "$task_name" ]; then
                log_info "Running task: $task_name"
                # Get commands for this task
                yq e ".homebrew.post_install.personal.tasks[] | select(.name == \"$task_name\") | .commands[]" "$REPO_DIR/config/packages.yaml" 2>/dev/null | \
                while IFS= read -r cmd; do
                    if [ -n "$cmd" ]; then
                        log_info "Executing: $cmd"
                        if ! eval "$cmd"; then
                            log_error "Failed to execute command in task: $task_name"
                            log_error "Command: $cmd"
                        fi
                    fi
                done
            fi
        done <<< "$personal_task_names"
    fi
}

# Run Pacman post-install tasks
run_pacman_post_install() {
    local is_personal="$1"

    log_info "Running Pacman post-install tasks..."

    # Get all task names first
    local task_names
    task_names=$(yq e '.pacman.post_install.tasks[].name' "$REPO_DIR/config/packages.yaml" 2>/dev/null)

    # Process each task
    while IFS= read -r task_name; do
        if [ -n "$task_name" ]; then
            log_info "Running task: $task_name"
            # Get commands for this task
            yq e ".pacman.post_install.tasks[] | select(.name == \"$task_name\") | .commands[]" "$REPO_DIR/config/packages.yaml" 2>/dev/null | \
            while IFS= read -r cmd; do
                if [ -n "$cmd" ]; then
                    log_info "Executing: $cmd"
                    if ! eval "$cmd"; then
                        log_error "Failed to execute command in task: $task_name"
                        log_error "Command: $cmd"
                    fi
                fi
            done
        fi
    done <<< "$task_names"

    # Run personal post-install tasks if enabled
    if [ "$is_personal" = "true" ]; then
        log_info "Running personal Pacman post-install tasks..."

        # Get all personal task names
        local personal_task_names
        personal_task_names=$(yq e '.pacman.post_install.personal.tasks[].name' "$REPO_DIR/config/packages.yaml" 2>/dev/null)

        # Process each personal task
        while IFS= read -r task_name; do
            if [ -n "$task_name" ]; then
                log_info "Running task: $task_name"
                # Get commands for this task
                yq e ".pacman.post_install.personal.tasks[] | select(.name == \"$task_name\") | .commands[]" "$REPO_DIR/config/packages.yaml" 2>/dev/null | \
                while IFS= read -r cmd; do
                    if [ -n "$cmd" ]; then
                        log_info "Executing: $cmd"
                        if ! eval "$cmd"; then
                            log_error "Failed to execute command in task: $task_name"
                            log_error "Command: $cmd"
                        fi
                    fi
                done
            fi
        done <<< "$personal_task_names"
    fi
}

main() {
    local update_only=false
    local os=$(detect_os)
    local package_manager=$(detect_package_manager)

    # Parse arguments
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --update-only) update_only=true ;;
            *) log_error "Unknown parameter: $1"; exit 1 ;;
        esac
        shift
    done

    # Check if yq is available
    if ! command -v yq >/dev/null; then
        log_error "yq is required but not installed. Please install yq first."
        exit 1
    fi

    # Get personal setting from chezmoi data
    local is_personal
    is_personal=$(chezmoi data | yq e '.personal' 2>/dev/null || echo "false")

    log_info "Detected OS: $os"
    log_info "Package manager: $package_manager"
    log_info "Personal mode: $is_personal"

    # Install packages based on OS
    case "$os" in
        darwin)
            install_homebrew_packages "$is_personal" "$update_only"
            ;;
        linux)
            install_pacman_packages "$is_personal" "$update_only"
            ;;
        *)
            log_error "Unsupported operating system: $os"
            exit 1
            ;;
    esac

    # Run post-install tasks
    run_post_install "$is_personal"

    # Cleanup
    log_info "Cleaning up..."
    if [ "$os" = "darwin" ]; then
        brew cleanup
    fi

    # Final status report
    if [ -f "$REPO_DIR/manual_installs.txt" ] && [ -s "$REPO_DIR/manual_installs.txt" ]; then
        log_warn "Some applications need to be installed manually."
        log_info "Please check manual_installs.txt for the list of applications to install manually."
    fi

    log_info "Package installation completed!"
}

main "$@"
