#========================
# MAKE OPTIONS
#========================

# set default target
.DEFAULT_GOAL := help
# use bash
SHELL := /bin/bash
# use single shell per target
.ONESHELL:
# commands fail fast
.SHELLFLAGS := -eu -o pipefail -c
# delete target on failure
.DELETE_ON_ERROR:
# disable implicit c rules
.SUFFIXES:
# make fails fast
MAKEFLAGS += --warn-undefined-variables --no-builtin-rules



#========================
# MISC
#========================

# absolute path to makefile directory
MAKEFILE_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

PROJECT_DIR  := $(notdir $(MAKEFILE_DIR))



#========================
# TARGETS
#========================

# status directory ----

STATUS := .status

$(STATUS):
	@mkdir -p $(STATUS)

# date ----

DATE := $(shell cat $(STATUS)/date 2>/dev/null || date +'%Y-%m-%d')

$(STATUS)/date: | $(STATUS)
	@echo "Pinning '$(DATE)' as project date..."
	@date +'%Y-%m-%d' > "$@"
	@touch $@
	@echo "Success!"

# Rproj ----

RPROJ_FILE	:= $(wildcard *.Rproj)

$(STATUS)/Rproj: $(RPROJ_FILE) | $(STATUS)
	@echo "Updating project name to '$(PROJECT_DIR)' in $(RPROJ_FILE)..."
	@perl -pi -e 's/^(ProjectName:\s*).*/$${1}$(PROJECT_DIR)/' "$(RPROJ_FILE)"
	@touch $@
	@echo "Success!"

# singularity ----

$(STATUS)/singularity:
	@echo "Detecting 'singularity'..."
	@command -v singularity >/dev/null 2>&1 || { \
		echo "Required command 'singularity' not found."; \
	    echo "Please install it to continue.";
	    exit 1; \
	}
	@touch $@
	@echo "Success!"

# setup ----

$(STATUS)/setup:	$(STATUS)/date \
					$(STATUS)/Rproj \
					$(STATUS)/singularity \
					| $(STATUS)
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
	@echo -e "$(ARG)clean$(DSC)Resets project template status.$(END)"
	@echo -e "$(ARG)reset$(DSC)Runs 'clean' then 'setup'.$(END)"

.PHONY: setup
setup: $(STATUS)/setup
	@echo "Setup complete!"

.PHONY: reset
reset: clean setup

.PHONY: clean
clean:
	@echo "Removing $(STATUS)/..."
	@rm -rf $(STATUS)
	@echo "Success!"
