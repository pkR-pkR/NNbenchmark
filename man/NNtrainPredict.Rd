% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/NNtrainPredict.R
\name{NNtrainPredict}
\alias{NNtrainPredict}
\alias{trainPredict_1mth1data}
\alias{trainPredict_1data}
\alias{trainPredict_1pkg}
\title{Generic Functions for Training and Predicting}
\usage{
trainPredict_1mth1data(dset, method, trainFUN, hyperparamFUN, predictFUN,
  summaryFUN, prepareZZ.arg = list(), nrep = 5, doplot = FALSE,
  plot.arg = list(col1 = 1:nrep, lwd1 = 1, col2 = 4, lwd2 = 3), pkgname,
  pkgfun, csvfile = FALSE, rdafile = FALSE, odir = ".", echo = FALSE,
  echoreport = FALSE, appendcsv = TRUE, ...)

trainPredict_1data(dset, methodlist, trainFUN, hyperparamFUN, predictFUN,
  summaryFUN, closeFUN, startNN = NA, prepareZZ.arg = list(), nrep = 5,
  doplot = FALSE, plot.arg = list(), pkgname = "pkg", pkgfun = "train",
  csvfile = FALSE, rdafile = FALSE, odir = ".", echo = FALSE,
  lib.loc = NULL, ...)

trainPredict_1pkg(dsetnum, pkgname = "pkg", pkgfun = "train", methodvect,
  prepareZZ.arg = list(), summaryFUN, nrep = 5, doplot = FALSE,
  plot.arg = list(), csvfile = FALSE, rdafile = FALSE, odir = ".",
  echo = FALSE, appendcsv = TRUE, parallel = "no", ncpus = 1,
  cl = NULL, lib.loc = NULL, ...)
}
\arguments{
\item{dset}{a number or string indicating which dataset to use, see \code{\link{NNdataSummary}}}

\item{method}{a method for a particular function}

\item{trainFUN}{the training function used}

\item{hyperparamFUN}{the function resulting in parameters needed for training}

\item{predictFUN}{the prediction function used}

\item{summaryFUN}{measure performance by observed and predicted y values, \code{\link{NNsummary}} is ready to use}

\item{prepareZZ.arg}{list of arguments for \code{\link{prepareZZ}}}

\item{nrep}{a number for how many times a neural network should be trained with a package/function}

\item{doplot}{logical value, TRUE executes plots and FALSE does not}

\item{plot.arg}{list of arguments for plots}

\item{pkgname}{package name}

\item{pkgfun}{name of the package function to train neural network}

\item{csvfile}{logical value, adds summary to csv files per dataset if TRUE}

\item{rdafile}{logical value, outputs rdafile of predictions and summary if TRUE}

\item{odir}{output directory}

\item{echo}{logical value, separates training between packages with some text and enables echoreport if TRUE}

\item{echoreport}{logical value, detailed reports are printed (such as model summaries and str(data)) if TRUE, will not work if echo is FALSE}

\item{appendcsv}{logical value, if \code{TRUE}, the csv output is appended to the csv file.}

\item{...}{additional arguments}

\item{methodlist}{list of methods per package/function}

\item{closeFUN}{a function to detach packages or other necessary environment clearing}

\item{startNN}{a function to start needed outside libraries, for example, h2o}

\item{lib.loc}{A character vector describing the location of R library trees to search through, or \code{NULL}. The default value of \code{NULL} corresponds to all libraries currently known to \code{\link[base]{.libPaths}()}. Non-existent library trees are silently ignored.}

\item{dsetnum}{a vector of numbers indicating which dataset to use in \code{\link{NNdataSummary}}}

\item{methodvect}{vector of methods per package/function}

\item{parallel}{The type of parallel operation to be used (if any). If missing, the default is \code{"no"}.}

\item{ncpus}{integer: number of processes to be used in parallel operation: typically one would chose this to the number of available CPUs.}

\item{cl}{An optional parallel or snow cluster for use if \code{parallel = "snow"}. If not supplied, a cluster on the local machine is created for the duration of the call.}
}
\value{
An array with values as in NNsummary including each repetition, with options for plots and output files
}
\description{
An implementation with \code{\link{do.call}} so that any neural network function that fits 
the format can be tested. 

In \code{trainPredict_1mth1data}, a neural network is trained on one dataset
and then used for predictions, with several functionalities. Then, the performance 
of the neural network is summarized.

\code{trainPredict_1data} serves as a wrapper function for \code{trainPredict_1mth1data} 
for multiple methods.

\code{trainPredict_1pkg} serves as a wrapper function for \code{trainPredict_1mth1data} 
for multiple datasets.
}
\examples{
nrep <- 2       
odir <- tempdir()

### Package with one method/optimization algorithm
library("brnn")
brnn.method <- "gaussNewton"
hyperParams.brnn <- function(optim_method, ...) {
  return(list(iter = 200))
  }
brnn.prepareZZ <- list(xdmv = "m", ydmv = "v", zdm = "d", scale = TRUE)

NNtrain.brnn   <- function(x, y, dataxy, formula, neur, optim_method, hyperParams,...) {
  hyper_params <- do.call(hyperParams.brnn, list(brnn.method))
  iter  <- hyper_params$iter
  
  NNreg <- brnn::brnn(x, y, neur, normalize = FALSE, epochs = iter, verbose = FALSE)
  return(NNreg)
  }
NNpredict.brnn <- function(object, x, ...) { predict(object, x) }
NNclose.brnn <- function(){
  if("package:brnn" \%in\% search())
    detach("package:brnn", unload=TRUE)
  }

\donttest{
res <- trainPredict_1pkg(1:2, pkgname = "brnn", pkgfun = "brnn", brnn.method,
                         prepareZZ.arg = brnn.prepareZZ, nrep = nrep, doplot = TRUE,
                         csvfile = FALSE, rdafile = FALSE, odir = odir, echo = FALSE)
                         
### Package with more than one method/optimization algorithm
library(validann)
validann.method <- c("Nelder-Mead", "BFGS", "CG", "L-BFGS-B", "SANN")
hyperParams.validann <- function(optim_method, ...) {
  if(optim_method == "Nelder-Mead")  { maxiter <- 10000 } 
  if(optim_method == "BFGS")         { maxiter <- 200   }
  if(optim_method == "CG")           { maxiter <- 1000  }
  if(optim_method == "L-BFGS-B")     { maxiter <- 200   }
  if(optim_method == "SANN")         { maxiter <- 1000  }
  return(list(iter = maxiter, method = optim_method, params))
  }
validann.prepareZZ <- list(xdmv = "m", ydmv = "m", zdm = "d", scale = TRUE)

NNtrain.validann <- function(x, y, dataxy, formula, neur, optim_method, hyperParams, ...) {
  hyper_params <- do.call(hyperParams, list(optim_method, ...))
  iter <- hyper_params$iter
  method <- hyper_params$method
  
  NNreg <- validann::ann(x, y, size = neur, method = method, maxit = iter)
  return (NNreg)
  }
NNpredict.validann <- function(object, x, ...) { predict(object, x) }
NNclose.validann <- function() {
  if("package:validann" \%in\% search())
  detach("package:validann", unload=TRUE)
  }

res <- trainPredict_1pkg(1:2, pkgname = "validann", pkgfun = "ann", validann.method,
                         repareZZ.arg = validann.prepareZZ, nrep = nrep, doplot = FALSE,
                         csvfile = TRUE, rdafile = TRUE, odir = odir, echo = FALSE)
}                        

}
