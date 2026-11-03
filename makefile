.DEFAULT_GOAL := help


#========================
# MAKE CONFIG
#========================

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

DATE := 2026-11-03

MAKEFILE_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

PROJECT_DIR  := $(notdir $(MAKEFILE_DIR))

#========================
# TARGETS
#========================

STATUS := .status

$(STATUS):
	@mkdir -p $(STATUS)

RPROJ_FILE	:= $(wildcard *.Rproj)

$(STATUS)/Rproj: $(RPROJ_FILE) | $(STATUS)
	@echo "Updating project name in $(RPROJ_FILE)..."
	@perl -pi -e 's/^(ProjectName:\s*).*/$${1}$(PROJECT_DIR)/' "$(RPROJ_FILE)"
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
	@echo "Installing singularity..."
	@touch $@
	@echo "Success!"

#========================
# PHONY TARGETS
#========================

.PHONY: help
help:
	@echo "help"
	@echo "\tsetup\t-"
	@echo "\tclean\t-"

.PHONY: setup
setup: $(STATUS)/setup

.PHONY: clean
clean:
	@echo "Removing $(STATUS)/..."
	@rm -rf $(STATUS)
	@echo "Success!"

