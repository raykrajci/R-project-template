.errors <- function(...){
    require("targets")

    tar_meta(...,
             fields = error,
             complete_only = TRUE)
}

.iterate <- function(...){

    dots <- enquos(...)

    suppressWarnings(
        rm(list = tar_manifest()$name, envir = globalenv())
    )

    tar_make()

    tar_prune()

    inject(
        tar_load(c(!!!dots), envir = globalenv())
    )

    tar_visnetwork()

    tar_meta(fields = error, complete_only = TRUE)

}
