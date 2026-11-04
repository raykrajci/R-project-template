#========================
# MAKE OPTIONS
#========================

.DEFAULT_GOAL := help
SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
.SUFFIXES:
MAKEFLAGS += --warn-undefined-variables --no-builtin-rules



#========================
# MAKE VARIABLES
#========================

# misc
DATE = $(shell cat $(STATUS_DIR)/date 2>/dev/null || date +'%Y-%m-%d')

# absolute path to makefile directory
MAKEFILE_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
DIR_NAME  := $(notdir $(MAKEFILE_DIR))

# directories
STATUS_DIR := $(MAKEFILE_DIR)/.status

# files
RPROJ_FILE	:= $(wildcard $(MAKEFILE_DIR)/*.Rproj)
DEF_FILE	:= $(MAKEFILE_DIR)/singularity/container.def
SIF_FILE	:= $(MAKEFILE_DIR)/singularity/container.sif
PKG_FILE	:= $(MAKEFILE_DIR)/R/packages.R



#========================
# TARGETS
#========================

$(STATUS_DIR):
	@mkdir -p $(STATUS_DIR)

$(STATUS_DIR)/date: | $(STATUS_DIR)
	@echo "Pinning '$(DATE)' as project date..."
	@date +'%Y-%m-%d' > "$@"
	@touch $@
	@echo "Success!"

$(STATUS_DIR)/Rproj: $(RPROJ_FILE) | $(STATUS_DIR)
	@echo "Updating project name to '$(DIR_NAME)' in $(RPROJ_FILE)..."
	@perl -pi -e 's/^(ProjectName:\s*).*/$${1}$(DIR_NAME)/' "$(RPROJ_FILE)"
	@touch $@
	@echo "Success!"

$(STATUS_DIR)/singularity:
	@echo "Detecting 'singularity'..."
	@command -v singularity >/dev/null 2>&1 || { \
		echo "Required command 'singularity' not found."; \
	    echo "Please install it to continue.";
	    exit 1; \
	}
	@touch $@
	@echo "Success!"

$(SIF_FILE): $(DEF_FILE) $(PKG_FILE) $(STATUS_DIR)/date
	@echo "Building $@..."
	@sudo -E \
		singularity build \
		--force \
		--build-arg PPM_DATE=$(DATE) \
		$(SIF_FILE) $(DEF_FILE)
	@echo "Success!"

$(STATUS_DIR)/setup:	$(STATUS_DIR)/date \
					$(STATUS_DIR)/Rproj \
					$(STATUS_DIR)/singularity \
					$(SIF_FILE) \
					| $(STATUS_DIR)
	@touch $@



#========================
# PHONY TARGETS
#========================

ARG := \t\e[1m
DSC := \e[0m\t
END :=\e[0m

.PHONY: help
help:
	@echo "help"
	@echo -e "$(ARG)setup$(DSC)Prepares the project template for use.$(END)"
	@echo -e "$(ARG)clean$(DSC)Resets project template STATUS_DIR.$(END)"
	@echo -e "$(ARG)reset$(DSC)Runs 'clean' then 'setup'.$(END)"

.PHONY: setup
setup: $(STATUS_DIR)/setup
	@echo "Setup complete!"

.PHONY: reset
reset: clean setup

.PHONY: clean
clean:
	@echo "Removing $(STATUS_DIR)/..."
	@rm -rf $(STATUS_DIR)
	@echo "Success!"
