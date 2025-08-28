.PHONY: all install update check diff config first-time prerequisites

all: first-time

# First time setup
first-time:
	@echo "🔧 First time setup..."
	@echo "This will configure your machine from scratch."
	@read -p "Are you sure? (y/n) " answer; \
	if [ "$$answer" = "y" ]; then \
		./scripts/install.sh; \
	fi

# Install prerequisites only
prerequisites:
	@echo "📦 Installing prerequisites..."
	@./scripts/install.sh prerequisites

# Safe update for existing machines
update:
	@echo "🔄 Updating existing configuration..."
	@./scripts/configure.sh
	@chezmoi apply
	@./scripts/packages.sh --update-only

# Full installation
install:
	@echo "📦 Running full installation..."
	@./scripts/install.sh

# Check for differences
check:
	@echo "🔍 Checking for differences..."
	@chezmoi diff

diff: check

# Update configuration
config:
	@echo "⚙️ Updating configuration..."
	@./scripts/configure.sh

# Apply changes
apply:
	@echo "✨ Applying changes..."
	@chezmoi apply

# Show current configuration
status:
	@echo "📊 Current configuration:"
	@chezmoi data | yq e '.name' 2>/dev/null && echo "Name: $$(chezmoi data | yq e '.name')" || echo "Name: Not set"
	@chezmoi data | yq e '.email' 2>/dev/null && echo "Email: $$(chezmoi data | yq e '.email')" || echo "Email: Not set"
	@chezmoi data | yq e '.personal' 2>/dev/null && echo "Personal: $$(chezmoi data | yq e '.personal')" || echo "Personal: false"
	@chezmoi data | yq e '.os' 2>/dev/null && echo "OS: $$(chezmoi data | yq e '.os')" || echo "OS: Not detected"

# Show help
help:
	@echo "Available commands:"
	@echo "  first-time    - Initial setup (interactive)"
	@echo "  install       - Full installation"
	@echo "  update        - Update existing configuration"
	@echo "  config        - Update user configuration"
	@echo "  apply         - Apply dotfiles changes"
	@echo "  check         - Check for differences"
	@echo "  status        - Show current configuration"
	@echo "  prerequisites - Install prerequisites only"
	@echo "  omarchy       - Install Omarchy (Arch Linux only)"
	@echo "  help          - Show this help"

# Testing
.PHONY: test
test: shellcheck ## Runs all the tests on the files in the repository.

# if this session isn't interactive, then we don't want to allocate a
# TTY, which would fail, but if it is interactive, we do want to attach
# so that the user can send e.g. ^C through.
INTERACTIVE := $(shell [ -t 0 ] && echo 1 || echo 0)
ifeq ($(INTERACTIVE), 1)
	DOCKER_FLAGS += -t
endif

.PHONY: shellcheck
shellcheck: ## Runs the shellcheck tests on the scripts.
	docker run --rm -i $(DOCKER_FLAGS) \
		--name shellcheck \
		-v $(CURDIR):/usr/src:ro \
		--workdir /usr/src \
		jess/shellcheck ./test.sh
