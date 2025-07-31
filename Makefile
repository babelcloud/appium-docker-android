.PHONY: help build buildx
.DEFAULT_GOAL := help

BASE_TAG := main
TAG := latest
NO_CACHE := false
PROGRESS := auto

help: ## Print help message
	@printf "\nUsage: make <command>\n"
	@grep -F -h "##" $(MAKEFILE_LIST) | grep -F -v grep -F | sed -e 's/\\$$//' | awk 'BEGIN {FS = ":*[[:space:]]*##"}; \
	{ \
		if($$2 == "") \
			pass; \
		else if($$0 ~ /^#/) \
			printf "\n%s\n", $$2; \
		else if($$1 == "") \
			printf "     %-28s%s\n", "", $$2; \
		else \
			printf "    \033[34m%-28s\033[0m %s\n", $$1, $$2; \
	}'

build: ## Build image locally
	@bash app.sh build $(TAG)

buildx: ## Build image for multiple architectures and push to registry
	@bash app.sh buildx $(TAG)
