.PHONY: help
help:

.PHONY: setup
setup:

.PHONY: lint
lint:
	@echo "Linting files in R/..."
	@Rscript -e 'install.packages("lintr"); lintr::lint_dir(here::here("R"))'

.PHONY: run
run:

.PHONY: clean
clean:
