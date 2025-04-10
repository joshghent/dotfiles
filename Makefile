.PHONY: all install update check diff config first-time

all: first-time

# First time setup
first-time:
	@echo "🔧 First time setup..."
	@echo "This will configure your machine from scratch."
	@read -p "Are you sure? (y/n) " answer; \
	if [ "$$answer" = "y" ]; then \
		./scripts/install.sh; \
	fi

# Safe update for existing machines
update:
	@echo "🔄 Updating existing configuration..."
	./scripts/configure.sh
	chezmoi apply
	./scripts/packages.sh --update-only

# Full installation
install:
	@echo "📦 Running full installation..."
	./scripts/install.sh

check:
	@echo "🔍 Checking for differences..."
	chezmoi diff

diff: check

config:
	@echo "⚙️ Updating configuration..."
	./scripts/configure.sh

apply:
	@echo "✨ Applying changes..."
	chezmoi apply

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
