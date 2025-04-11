#!/usr/bin/env bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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
                # Add to list of manual installations needed
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

process_packages() {
    local is_personal
    local failed_packages=()

    # Get personal setting
    is_personal=$(yq e '.homebrew.packages.personal.enabled' "$REPO_DIR/config/packages.yaml")

    log_info "Installing Homebrew packages..."

    # Process each category separately
    for category in "base" "development" "security" "tools"; do
        # Get packages from this category
        local category_packages
        category_packages=$(yq e ".homebrew.packages.${category}[]" "$REPO_DIR/config/packages.yaml")

        # Install each package in this category
        for package in $category_packages; do
            if ! brew_install "$package"; then
                failed_packages+=("$package")
            fi
        done
    done

    # Add personal packages if enabled
    if [ "$is_personal" = "true" ]; then
        local personal_packages
        personal_packages=$(yq e '.homebrew.packages.personal.packages[]' "$REPO_DIR/config/packages.yaml")

        for package in $personal_packages; do
            if ! brew_install "$package"; then
                failed_packages+=("$package")
            fi
        done
    fi

    # Report failed packages
    if [ ${#failed_packages[@]} -ne 0 ]; then
        log_error "Failed to install the following packages:"
        printf '%s\n' "${failed_packages[@]}"
        return 1
    fi
}

process_casks() {
    local is_personal
    local is_work
    local failed_casks=()

    # Get personal setting
    is_personal=$(yq e '.homebrew.casks.personal.enabled' "$REPO_DIR/config/packages.yaml")
    is_work=$([ "$is_personal" = "false" ] && echo "true" || echo "false")

    # Clear previous manual installations list
    echo "# The following applications need to be installed manually:" > "$REPO_DIR/manual_installs.txt"

    log_info "Installing casks..."

    # Process each category separately
    for category in "base" "development" "fonts" "communication"; do
        # Get casks from this category
        local category_casks
        category_casks=$(yq e ".homebrew.casks.${category}[]" "$REPO_DIR/config/packages.yaml")

        # Install each cask in this category
        for cask in $category_casks; do
            if ! cask_install "$cask" "$is_work"; then
                failed_casks+=("$cask")
            fi
        done
    done

    # Add personal casks if enabled
    if [ "$is_personal" = "true" ]; then
        local personal_casks
        personal_casks=$(yq e '.homebrew.casks.personal.packages[]' "$REPO_DIR/config/packages.yaml")

        for cask in $personal_casks; do
            if ! cask_install "$cask" "$is_work"; then
                failed_casks+=("$cask")
            fi
        done
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

run_post_install() {
    local is_personal
    is_personal=$(yq e '.homebrew.post_install.personal.enabled' "$REPO_DIR/config/packages.yaml")

    # Run base post-install tasks
    log_info "Running base post-install tasks..."

    # Get all task names first
    local task_names
    task_names=$(yq e '.homebrew.post_install.tasks[].name' "$REPO_DIR/config/packages.yaml")

    # Process each task
    while IFS= read -r task_name; do
        if [ -n "$task_name" ]; then
            log_info "Running task: $task_name"
            # Get commands for this task
            yq e ".homebrew.post_install.tasks[] | select(.name == \"$task_name\") | .commands[]" "$REPO_DIR/config/packages.yaml" | \
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
        log_info "Running personal post-install tasks..."

        # Get all personal task names
        local personal_task_names
        personal_task_names=$(yq e '.homebrew.post_install.personal.tasks[].name' "$REPO_DIR/config/packages.yaml")

        # Process each personal task
        while IFS= read -r task_name; do
            if [ -n "$task_name" ]; then
                log_info "Running task: $task_name"
                # Get commands for this task
                yq e ".homebrew.post_install.personal.tasks[] | select(.name == \"$task_name\") | .commands[]" "$REPO_DIR/config/packages.yaml" | \
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

    # Parse arguments
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --update-only) update_only=true ;;
            *) log_error "Unknown parameter: $1"; exit 1 ;;
        esac
        shift
    done

    # Install Homebrew if needed
    if ! command -v brew >/dev/null; then
        if [ "$update_only" = true ]; then
            log_warn "Homebrew not found but running in update-only mode"
        else
            log_info "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
    fi

    # Update Homebrew
    log_info "Updating Homebrew..."
    brew update

    # Process installations
    if [ "$update_only" = true ]; then
        log_info "Updating existing packages only..."
        brew upgrade
        brew upgrade --cask
    else
        process_packages
        process_casks
    fi

    # Run post-install tasks
    run_post_install

    # Cleanup
    log_info "Cleaning up..."
    brew cleanup

    # Final status report
    if [ -f "$REPO_DIR/manual_installs.txt" ] && [ -s "$REPO_DIR/manual_installs.txt" ]; then
        log_warn "Some applications need to be installed manually."
        log_info "Please check manual_installs.txt for the list of applications to install manually."
    fi
}

main "$@"
