library(targets)
library(tarchetypes)
library(here)

tar_option_set(
    packages = c(
        "glue",
        "here"
    )
)

tar_source(here("R"))

tar_plan(
    # ...
)
