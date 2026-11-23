if(interactive()){

    message("Running `.Rprofile`...")

    packages <- c(
        "arrow",
        "beepr",
        "broom",
        "cli",
        "conflicted",
        "glue",
        "gt",
        "fs",
        "here",
        "lintr",
        "magrittr",
        "tarchetypes",
        "targets",
        "tidyverse",
        "yaml12"
    )

    succeeded <- sapply(X = packages,
                           FUN = library,
                           simplify = TRUE,
                           quietly = TRUE,
                           logical.return = TRUE)
    message(c("Loaded: ",
              paste(packages[succeeded], collapse = ", ")))

    if(!all(succeeded)){
        warn(c("Not Loaded: ",
               paste(packages[!succeeded], collapse = ", ")))
    }

    scripts <- c(
        ""
    )
}
