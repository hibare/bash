SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c

.PHONY: help install lint shellcheck test update

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Install configs and packages
	@bash install.sh

lint: shellcheck ## Run all linters

shellcheck: ## Run shellcheck on all shell files
	@shellcheck --shell=bash install.sh installers/*/*.sh shells/bash/.bash_aliases \
		shells/bash/.bash_functions shells/bash/.bash_env shells/bash/.bash_profile \
		scripts/*.sh shells/shared/*

test: ## Run tests (requires npm install first — see package.json)
	@npx bats tests/

update: ## Run update scripts (Discord only if on Debian)
	@bash scripts/hadolint.sh || true
	@test -f /usr/bin/apt-get && bash scripts/update_discord.sh || true
