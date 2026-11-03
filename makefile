.ONESHELL:

DATE := 2026-11-03

MAKEFILE_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

PROJECT_DIR  := $(notdir $(MAKEFILE_DIR))

STATUS := .status

$(STATUS):
	@mkdir -p $(STATUS)

RPROJ_FILE	:= $(wildcard *.Rproj)

$(STATUS)/Rproj: $(RPROJ_FILE) | $(STATUS)
	@echo "Updating project name in $(RPROJ_FILE)..."
	perl -pi -e 's/^(ProjectName:\s*)project\b/\1$(PROJECT_DIR)/' "$(RPROJ_FILE)"
	@touch $@
	@echo "Success!"

$(STATUS)/setup:	$(STATUS)/Rproj \
					$(STATUS)/Rlang \
					$(STATUS)/singularity \
					| $(STATUS)
	@touch $@

$(STATUS)/Rlang: | $(STATUS)
	@echo "Installing R..."
	@touch $@
	@echo "Success!"

$(STATUS)/singularity: | $(STATUS)
	@echo "Installing singularity"
	@touch $@
	@echo "Success!"

.DEFAULT: help
.PHONY: help
help:

.PHONY: setup
setup: $(STATUS)/setup


.PHONY: lint
lint: | setup
	@echo "Linting files in R/..."
	@Rscript -e 'install.packages("lintr"); lintr::lint_dir(here::here("R"))'

.PHONY: run
run: | setup

.PHONY: clean
clean:
	@echo "Removing $(STATUS)/..."
	@rm -rf $(STATUS)
	@echo "Success!"

