# This ensures that we can call `make <target>` even if `<target>` exists as a file or
# directory.
.PHONY: docs help

# Exports all variables defined in the makefile available to scripts
.EXPORT_ALL_VARIABLES:

# Create .env file if it does not already exist
ifeq (,$(wildcard .env))
  $(shell touch .env)
endif

# Create poetry env file if it does not already exist
ifeq (,$(wildcard ${HOME}/.poetry/env))
  $(shell mkdir ${HOME}/.poetry)
  $(shell touch ${HOME}/.poetry/env)
endif

# Includes environment variables from the .env file
include .env

# Set gRPC environment variables, which prevents some errors with the `grpcio` package
export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install-poetry:
	@if [ ! "$(shell poetry --version)" = "Poetry (version 1.4.0)" ]; then \
		pip3 install --force --quiet poetry==1.4.0; \
		echo "Installed Poetry."; \
	fi

uninstall-poetry:
	@echo "Uninstalling poetry..."
	@pip3 uninstall poetry

install: ## Install dependencies
	@if [ "$(shell which gpg)" = "" ]; then \
		echo "GPG not installed. Install GPG on MacOS with `brew install gnupg` or "; \
			 "on Ubuntu with `apt install gnupg` and run `make install` again."; \
	else \
		echo "Installing the 'alexandra_ai_data' project..."; \
		$(MAKE) --quiet install-poetry; \
		$(MAKE) --quiet setup-poetry; \
		$(MAKE) --quiet setup-environment-variables; \
		$(MAKE) --quiet setup-git; \
		$(MAKE) --quiet add-repo-to-git; \
		echo "Installed the 'alexandra_ai_data' project."; \
	fi

setup-poetry:
	@poetry env use python3.11 && poetry install --quiet

setup-environment-variables:
	@poetry run python src/scripts/fix_dot_env_file.py

setup-environment-variables-non-interactive:
	@poetry run python src/scripts/fix_dot_env_file.py --non-interactive

setup-git:
	@git init
	@git config --local user.name ${GIT_NAME}
	@git config --local user.email ${GIT_EMAIL}
	@if [ ${GPG_KEY_ID} = "" ]; then \
		echo "No GPG key ID specified. Skipping GPG signing."; \
		git config --local commit.gpgsign false; \
	else \
		git config --local commit.gpgsign true; \
		git config --local user.signingkey ${GPG_KEY_ID}; \
		echo "Signed with GPG key ID ${GPG_KEY_ID}."; \
	fi
	@poetry run pre-commit install

add-repo-to-git:
	@export GPG_TTY=$(tty)
	@gpgconf --kill gpg-agent
	@git add .
	@if [ ! "$(shell git status --short)" = "" ]; then \
		git commit --quiet -m "Initial commit"; \
	fi
	@if [ "$(shell git remote)" = "" ]; then \
		git remote add origin git@github.com:alexandrainst/alexandra_ai_data.git; \
	fi

docs:  ## Generate documentation
	@poetry run pdoc --docformat google src/alexandra_ai_data -o docs
	@echo "Saved documentation."

view-docs:  ## View documentation
	@echo "Viewing API documentation..."
	@uname=$$(uname); \
		case $${uname} in \
			(*Linux*) openCmd='xdg-open'; ;; \
			(*Darwin*) openCmd='open'; ;; \
			(*CYGWIN*) openCmd='cygstart'; ;; \
			(*) echo 'Error: Unsupported platform: $${uname}'; exit 2; ;; \
		esac; \
		"$${openCmd}" docs/alexandra_ai_data.html

bump-major:
	@poetry run python src/scripts/versioning.py --major
	@echo "Bumped major version!"

bump-minor:
	@poetry run python src/scripts/versioning.py --minor
	@echo "Bumped minor version!"

bump-patch:
	@poetry run python src/scripts/versioning.py --patch
	@echo "Bumped patch version!"

publish:
	@if [ ${PYPI_API_TOKEN} = "" ]; then \
		echo "No PyPI API token specified in the '.env' file, so cannot publish."; \
	else \
		echo "Publishing to PyPI..."; \
		poetry publish --build --username "__token__" --password ${PYPI_API_TOKEN}; \
	fi
	@echo "Published!"

publish-major: bump-major publish  ## Publish a major version

publish-minor: bump-minor publish  ## Publish a minor version

publish-patch: bump-patch publish  ## Publish a patch version

test:  ## Run tests
	@poetry run pytest && poetry run readme-cov

docker:  ## Build Docker image and run container
	@docker build -t alexandra_ai_data .
	@docker run -it --rm alexandra_ai_data

tree:  ## Print directory tree
	@tree -a \
		-I .git \
		-I .mypy_cache \
		-I .env \
		-I .venv \
		-I poetry.lock \
		-I .ipynb_checkpoints \
		-I dist \
		-I .gitkeep \
		-I docs \
		-I .pytest_cache \
		-I outputs \
		-I .DS_Store \
		-I .cache \
		-I raw \
		-I processed \
		-I final \
		-I checkpoint-* \
		-I .coverage* \
		-I .DS_Store \
		-I __pycache__ \
		-I .ruff_cache \
		.
