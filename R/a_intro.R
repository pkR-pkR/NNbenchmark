## a_intro = NNbenchmark-package 2019-08-04 + 2019-08-22 + 2020-08-24 + 2021-03-08



#' @title Package NNbenchmark
#' @description
#' Datasets and functions to benchmark (convergence, speed, ease of use) R packages 
#' dedicated to regression with neural networks (no classification in this version).
#' The templates for the tested packages are available at 
#' <https://github.com/pkR-pkR/NNbenchmarkTemplates> and 
#' <https://theairbend3r.github.io/NNbenchmarkWeb/index.html>. The submitted article 
#' to the R-Journal can be read at <https://www.inmodelia.com/gsoc2020.html>.
#' @examples
#' ds <- grep("^[m,u]", ls("package:NNbenchmark"), value = TRUE); ds
#' t(sapply(ds, function(x) dim(get(x)))) 
#' NNdataSummary(NNdatasets)
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


