## clearNN 2019-08-04


#' @title Clean the .GlobalEnv and Detach the Loaded Packages
#' @description
#' Clean the first environment \code{ls(.GlobalEnv)} from objects not listed in 
#' \code{donotremove} and detach the loaded packages and their dependencies not listed 
#' in \code{donotdetach}.
#' 
#' \code{clearNN()} replaces
#' 
#' \code{detach(ZZ)} 
#' 
#' \code{detach("package:nameNNpackage", unload = TRUE)} 
#' 
#' \code{remove(list = ls()[!(ls() \%in\% donotremove)])}
#' 
#' @param  donotremove  a vector of characters representing objects in \code{ls()}.
#' @param  donotdetach  a vector of packages and environments that are not detached.
#'                      \code{donotdetach = NULL} protects the packages and environments 
#'                      \code{".GlobalEnv"}, \code{"package:NNbenchmark"}, 
#'                      \code{"package:rmarkdown"}, \code{"package:knitr"}, \code{"package:captioner"},
#'                      \code{"package:pkgload"}, \code{"package:R6"}, \code{"tools:rstudio"}, 
#'                      \code{"package:RWsearch"}, \code{"package:pacman"}, 
#'                      \code{"package:stats"}, \code{"package:graphics"}, 
#'                      \code{"package:grDevices"}, \code{"package:utils"}, 
#'                      \code{"package:datasets"}, \code{"package:methods"}, 
#'                      \code{"Autoloads"}, \code{"package:base"}.
#' 
#' @export
#' @name clearNN
clearNN <- function (donotremove, donotdetach = NULL) { 
    if (is.null(donotdetach)) donotdetach <- c(".GlobalEnv", "package:rmarkdown",
           "package:knitr", "package:captioner",
           "package:NNbenchmark", "package:R6", "package:pkgload", 
           "tools:rstudio", "package:RWsearch", "package:pacman", 
           "package:stats", "package:graphics", "package:grDevices", "package:utils",
           "package:datasets", "package:methods", "Autoloads", "package:base")           
    if (!is.element("ZZ",  donotdetach)) {    
        while ("ZZ" %in% search()) detach("ZZ", character.only = TRUE)
    }
    if (length(setdiff(search(), donotdetach)) > 0) {
        vecns   <- setdiff(search(), donotdetach)
        strpkgs <- strsplit(vecns, ":", fixed = TRUE)
        lpkgs   <- lengths(strpkgs)
        fun     <- function(l, pkg) {if (l == 2) pkg[2] else NULL}
        pkgs    <- unlist(mapply(fun, lpkgs, strpkgs))
        lapply(pkgs, pkgload::unload, quiet = TRUE)
    }
    if (length(setdiff(search(), donotdetach)) > 0) tryCatch(
           lapply(setdiff(search(), donotdetach), detach, unload = TRUE, 
                  character.only = TRUE, force = TRUE),
           warning = function(w) {})
    while (length(setdiff(ls(.GlobalEnv), donotremove)) > 0) remove(           
           list = setdiff(ls(.GlobalEnv), donotremove), envir = .GlobalEnv)
}


