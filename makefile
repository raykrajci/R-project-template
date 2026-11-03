.ONESHELL:
STATUS_DIR := .status

MAKEFILE_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

PROJECT_DIR  := $(notdir $(MAKEFILE_DIR))

.PHONY: help
help:

.PHONY: setup
setup: | $(STATUS_DIR) $(STATUS_DIR)/Rproj
	@touch $(STATUS_DIR)/$@

.PHONY: lint
lint: | setup $(STATUS_DIR) $(STATUS_DIR)/Rproj
	@echo "Linting files in R/..."
	@Rscript -e 'install.packages("lintr"); lintr::lint_dir(here::here("R"))'

.PHONY: run
run: | $(STATUS_DIR) $(RPROJ)

.PHONY: clean
clean:
	@echo "Removing $(STATUS_DIR)/..."
	@rm -rf $(STATUS_DIR)
	@echo "Success!"




$(STATUS_DIR):
	@echo "making $(STATUS_DIR)/..."
	@mkdir -p $(STATUS_DIR)
	@echo "Success!"

RPROJ_FILE	:= $(wildcard *.Rproj)

$(STATUS_DIR)/Rproj: | $(STATUS_DIR)
	@echo "Updating project name in $(RPROJ_FILE)..."
	@perl -pi -e 's/\bproject\b/$(PROJECT_DIR)/g' $(RPROJ_FILE)
	@touch $(STATUS_DIR)/Rproj
	@echo "Success!"
