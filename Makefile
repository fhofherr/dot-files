.PHONY: install
install:
	./scripts/dotfiles.sh install --parallel 4

.PHONY: update
update:
	./scripts/dotfiles.sh update --parallel 4

.PHONY: test
test: ## Test the installer code but not the modules.
	poetry run pytest \
		-m "not module_test" \
		--cov-report html \
		--cov-report term \
		--cov=dotfiles \
		tests

.PHONY: fulltest
fulltest: ## Test everything.
	poetry run pytest \
		--cov-report html \
		--cov-report term \
		--cov=dotfiles \
		--cov=modules \
		tests

.PHONY: help
help: ## Show this help.
	@awk -F ':|##' '/^[^\t].+?:.*?##/ {\
		printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF \
	}' $(MAKEFILE_LIST)
