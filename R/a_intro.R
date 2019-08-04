## a_intro = NNbenchmark-package



#' @title Package NNbenchmark
#' @description
#' Datasets and functions to benchmark neural network functions and training algorithms 
#' (convergence, speed, ease of use) in 69 R packages.
#' @examples
#' ds <- grep("^[m,u]", ls("package:NNbenchmark"), value = TRUE); ds
#' t(sapply(ds, function(x) dim(get(x))))
#' plot(uGauss2)
#' pairs(mIshigami)
#' ht(NNdatasets, n = 2, l = 6)
#' @import      R6
#' @import      graphics
#' @import      utils
#' @importFrom  stats  sd  formula
#' @importFrom  pkgload  unload
#' @aliases NNbenchmark
#' @name    NNbenchmark-package
#' @docType package
NULL


