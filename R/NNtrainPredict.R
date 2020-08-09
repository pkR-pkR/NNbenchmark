## NNTrain_Predict 2020-07-03 | 08-09 added large datasets


#' @title Generic Functions for Training and Predicting
#' @description
#' An implementation with \code{\link{do.call}} so that any neural network function that fits 
#' the format can be tested. 
#' 
#' In \code{trainPredict_1mth1data}, a neural network is trained on one dataset
#' and then used for predictions, with several functionalities. Then, the performance 
#' of the neural network is summarized.
#' 
#' \code{trainPredict_1data} serves as a wrapper function for \code{trainPredict_1mth1data} 
#' for multiple methods.
#' 
#' \code{trainPredict_1pkg} serves as a wrapper function for \code{trainPredict_1mth1data} 
#' for multiple datasets.
#' 
#' 
#' @param   dset            a number or string indicating which dataset to use, see \code{\link{NNdataSummary}} 
#' @param   dsetnum         a vector of numbers indicating which dataset to use in \code{\link{NNdataSummary}} 
#' @param   method          a method for a particular function
#' @param   methodlist      list of methods per package/function
#' @param   methodvect      vector of methods per package/function
#' @param   trainFUN        the training function used
#' @param   hyperparamFUN   the function resulting in parameters needed for training
#' @param   predictFUN      the prediction function used
#' @param   summaryFUN      measure performance by observed and predicted y values, \code{\link{NNsummary}} is ready to use 
#' @param   closeFUN        a function to detach packages or other necessary environment clearing
#' @param   startNN         a function to start needed outside libraries, for example, h2o
#' @param   prepareZZ.arg   list of arguments for \code{\link{prepareZZ}}
#' @param   nrep            a number for how many times a neural network should be trained with a package/function
#' @param   doplot          logical value, TRUE executes plots and FALSE does not
#' @param   plot.arg        list of arguments for plots
#' @param   pkgname         package name
#' @param   pkgfun          name of the package function to train neural network
#' @param   csvfile         logical value, adds summary to csv files per dataset if TRUE
#' @param   rdafile         logical value, outputs rdafile of predictions and summary if TRUE
#' @param   odir            output directory
#' @param   echo            logical value, separates training between packages with some text and enables echoreport if TRUE
#' @param   echoreport      logical value, detailed reports are printed (such as model summaries and str(data)) if TRUE, will not work if echo is FALSE
#' @param   appendcsv       logical value, if \code{TRUE}, the csv output is appended to the csv file. 
#' @param   ...             additional arguments
#' @return  
#' An array with values as in NNsummary including each repetition, with options for plots and output files
#' 
#' 
#' @examples 
#' nrep <- 2       
#' odir <- getwd()
#' 
#' ### Package with one method/optimization algorithm
#' library("brnn")
#' brnn.method <- "gaussNewton"
#' hyperParams.brnn <- function(optim_method, ...) {
#'   return(list(iter = 200))
#'   }
#' brnn.prepareZZ <- list(xdmv = "m", ydmv = "v", zdm = "d", scale = TRUE)
#' 
#' NNtrain.brnn   <- function(x, y, dataxy, formula, neur, optim_method, hyperParams,...) {
#'   hyper_params <- do.call(hyperParams.brnn, list(brnn.method))
#'   iter  <- hyper_params$iter
#'   
#'   NNreg <- brnn::brnn(x, y, neur, normalize = FALSE, epochs = iter, verbose = FALSE)
#'   return(NNreg)
#'   }
#' NNpredict.brnn <- function(object, x, ...) { predict(object, x) }
#' NNclose.brnn <- function(){
#'   if("package:brnn" %in% search())
#'     detach("package:brnn", unload=TRUE)
#'   }
#' 
#' res <- trainPredict_1pkg(1:2, pkgname = "brnn", pkgfun = "brnn", brnn.method,
#'                          prepareZZ.arg = brnn.prepareZZ, nrep = nrep, doplot = TRUE,
#'                          csvfile = FALSE, rdafile = FALSE, odir = odir, echo = FALSE)
#'                          
#' ### Package with more than one method/optimization algorithm
#' library(validann)
#' validann.method <- c("Nelder-Mead", "BFGS", "CG", "L-BFGS-B", "SANN")
#' hyperParams.validann <- function(optim_method, ...) {
#'   if(optim_method == "Nelder-Mead")  { maxiter <- 10000 } 
#'   if(optim_method == "BFGS")         { maxiter <- 200   }
#'   if(optim_method == "CG")           { maxiter <- 1000  }
#'   if(optim_method == "L-BFGS-B")     { maxiter <- 200   }
#'   if(optim_method == "SANN")         { maxiter <- 1000  }
#'   return(list(iter = maxiter, method = optim_method, params))
#'   }
#' validann.prepareZZ <- list(xdmv = "m", ydmv = "m", zdm = "d", scale = TRUE)
#' 
#' NNtrain.validann <- function(x, y, dataxy, formula, neur, optim_method, hyperParams, ...) {
#'   hyper_params <- do.call(hyperParams, list(optim_method, ...))
#'   iter <- hyper_params$iter
#'   method <- hyper_params$method
#'   
#'   NNreg <- validann::ann(x, y, size = neur, method = method, maxit = iter)
#'   return (NNreg)
#'   }
#' NNpredict.validann <- function(object, x, ...) { predict(object, x) }
#' NNclose.validann <- function() {
#'   if("package:validann" %in% search())
#'   detach("package:validann", unload=TRUE)
#'   }
#'
#' res <- trainPredict_1pkg(1:2, pkgname = "validann", pkgfun = "ann", validann.method,
#'                          repareZZ.arg = validann.prepareZZ, nrep = nrep, doplot = FALSE,
#'                          csvfile = TRUE, rdafile = TRUE, odir = odir, echo = FALSE)
#'
#' @importFrom stats lm
#' @export
#' @name NNtrainPredict
trainPredict_1mth1data <- function(dset, method, trainFUN, hyperparamFUN, predictFUN, summaryFUN,
                                   prepareZZ.arg=list(),
                                   nrep=5, doplot=FALSE, plot.arg=list(col1=1:nrep, lwd1=1, col2=4, lwd2=3),
                                   pkgname, pkgfun, csvfile=FALSE, rdafile=FALSE, odir="~/", 
                                   echo=FALSE, echoreport=FALSE, appendcsv=TRUE, ...)
{
  method <- method[1]
  if(!is.list(plot.arg) || any(!names(plot.arg) %in% c("col1", "lwd1", "col2", "lwd2")))
    plot.arg <- list(col1=1:nrep, lwd1=1, col2=4, lwd2=3)
  
  if(!exists(hyperparamFUN))
    stop(paste("function", hyperparamFUN, "does not exist"))
  if(!exists(trainFUN))
    stop(paste("function", trainFUN, "does not exist"))
  if(!exists(predictFUN))
    stop(paste("function", predictFUN, "does not exist"))
  
  if(dset > 12 || dset=="mWoodN1"){
    dset   <- 12 - dset
    ds     <- NNbenchmark::NNlargedatasets[[dset]]$ds
    Z      <- NNbenchmark::NNlargedatasets[[dset]]$Z
    neur   <- NNbenchmark::NNlargedatasets[[dset]]$neur
    nparNN <- NNbenchmark::NNlargedatasets[[dset]]$nparNN
    fmlaNN <- NNbenchmark::NNlargedatasets[[dset]]$fmlaNN 
  } else {
    ds     <- NNbenchmark::NNdatasets[[dset]]$ds
    Z      <- NNbenchmark::NNdatasets[[dset]]$Z
    neur   <- NNbenchmark::NNdatasets[[dset]]$neur
    nparNN <- NNbenchmark::NNdatasets[[dset]]$nparNN
    fmlaNN <- NNbenchmark::NNdatasets[[dset]]$fmlaNN 
  }
  
  descr <- paste0(ds, "_", pkgname, "::", pkgfun, "_", method)
  if(echo)
  {
    cat(paste0(rep("_",80),collapse=""),"\n")
    cat("***\t", descr, "***\n")
  }
  if(length(prepareZZ.arg) != 4 || any(!names(prepareZZ.arg) %in% c("xdmv", "ydmv", "zdm", "scale")))
    prepareZZ.arg <- list(xdmv = "d", ydmv = "v", zdm = "d", scale = TRUE)
  ZZ <- do.call("prepareZZ", c(list(Z), prepareZZ.arg))    
  
  if(echo && echoreport == TRUE)
  {
    cat("prepareZZ\n")
    print(str(ZZ))
  }
  
  Ypred <- list()
  allsummary <- list()
  for(i in 1:nrep)
  {
    timestart()
    tempfit <- tryCatch(
      do.call(trainFUN, list(ZZ$x, ZZ$y, ZZ$Zxy, ZZ$fmla, neur, method,  hyperparamFUN, fmlaNN, nparNN)),
      error = function(y) {lm(y ~ 0, data = ZZ$Zxy)}
    ) 
    if(echo && echoreport == TRUE)
    {
      cat("\n\t\t--- debug : structure of fitted model ***\n")
      print(str(tempfit))
      cat("\n\t\t--- debug : summary of fitted model ***\n")
      print(summary(tempfit))
      
    }
    if(inherits(tempfit, "lm") || inherits(tempfit, "try-error"))
    {
      if(echo && echoreport == TRUE)
      {
        cat("\n--- \tdebug : training lead to error \t***\n")
        cat(pkgname, "::", pkgfun, "_", method, "\n")
      }
      
      Ypred[[i]] <- rep(ZZ$ym0, length.out=NROW(ZZ$x))
    }else
    {
      if(echo && echoreport == TRUE)
      {
        localpred <- try(do.call(predictFUN, list(tempfit, head(ZZ$x), head(ZZ$xy))), silent = echoreport)
        if(!inherits(localpred, "try-error"))
        {
          cat("\n\t\t--- debug : first predictions ***\n")
          print(str(localpred))
        }else
        {
          cat("\n--- \tdebug : first predictions lead to error \t***\n")
          cat(pkgname, "::", pkgfun, "_", method, "\n")
          print(localpred)
        }
      }
      temppred <- try(do.call(predictFUN, list(tempfit, ZZ$x, ZZ$Zxy)), silent = echoreport)
      if(!inherits(temppred, "try-error"))
        Ypred[[i]] <- ZZ$ym0 + ZZ$ysd0 * temppred
      else
        Ypred[[i]] <- rep(ZZ$ym0, length.out=NROW(ZZ$x))
      
    }
    time <- timediff()
    allsummary[[i]] <- summaryFUN(Ypred[[i]], ZZ$y0, time, 4)
    
    if(echo && i %% 5 == 0)
      cat(pkgname, pkgfun, method, "i", i, "summary statistics", allsummary[[i]][1:4], "time", allsummary[[i]]["time"], "\n")
    
  }
  names(Ypred) <- names(allsummary) <- paste0("replicate", 1:nrep)
  Ypred <- simplify2array(Ypred)
  
  if(length(dim(Ypred)) >= 2)
    if(dim(Ypred)[2] == 1)
    {
      if(length(dim(Ypred)) == 3)
        Ypred <- Ypred[,1,]
      else if(length(dim(Ypred)) == 2)
        Ypred <- Ypred[,1]
    }
  allsummary <- simplify2array(allsummary)
  
  #outputs to csv files
  if(csvfile){
    descr  <- paste0(ds, "_", pkgname, "::", pkgfun, "_", method)
    event <- c(paste0(descr, sprintf("_%.2d", 1:nrep)))
    csvsummary <- cbind.data.frame(event, t(allsummary))
    
    if(appendcsv)
      fname <- paste0(odir, ds, "-results.csv")
    else
      fname <- paste0(odir, ds, "_", pkgname, "_", pkgfun, "_", method, "-results.csv")
    
    add2csv(csvsummary, file = fname)
  }
  #outputs to rda files
  if(rdafile)
  {
    descr <- paste0(ds, "_", pkgname, "_", pkgfun, "_", method)
    myfile <- paste0(odir, descr, ".RData")
    save(Ypred, allsummary, file=myfile)
  }
  
  #plot
  if(doplot)
  {
    #shorter description
    descr  <- paste0(ds, "_", pkgname, "::", pkgfun, "_", method)
    if(nrep == 1) {
      plotNN(ZZ$xory, ZZ$y0, ZZ$uni, doplot, main = descr)
      lipoNN(ZZ$xory, Ypred, ZZ$uni, doplot, col = plot.arg$col1, lwd = plot.arg$lwd1)
    } else {
      op <- par(mfcol = c(1,2))
      plotNN(ZZ$xory, ZZ$y0, ZZ$uni, doplot, main = descr)
      for (i in 1:nrep)
        lipoNN(ZZ$xory, Ypred[,i], ZZ$uni, doplot, col = plot.arg$col1[i], lwd = plot.arg$lwd1)
      best <- which.min(allsummary["RMSE",])
      plotNN(ZZ$xory, ZZ$y0, ZZ$uni, doplot, main = descr)
      lipoNN(ZZ$xory, Ypred[,best], ZZ$uni, doplot, col = plot.arg$col2, lwd = plot.arg$lwd2)
      par(op)
    }
  }
  
  if(echo)
    cat("\n")
  allsummary
}

#' @export
#' @rdname NNtrainPredict
trainPredict_1data <- function(dset, methodlist, trainFUN, hyperparamFUN, predictFUN, summaryFUN, 
                                closeFUN, startNN=NA, prepareZZ.arg=list(),
                                nrep=5, doplot=FALSE, plot.arg=list(),
                                pkgname="pkg", pkgfun="train", csvfile = FALSE, rdafile=FALSE, odir="~/", echo=FALSE, ...)
{
  nbpkg <- length(pkgname)
  #sanity check
  if(nbpkg > 1)
  {
    if(length(pkgfun) != nbpkg )
      stop("wrong pkgfun")
    if(length(trainFUN) != nbpkg  || length(hyperparamFUN) != nbpkg || length(predictFUN) != nbpkg || length(closeFUN) != nbpkg)
      stop("wrong function names among trainFUN, hyperparamFUN, predictFUN, closeFUN")
    if(length(methodlist) != nbpkg || !is.list(methodlist))
      stop("wrong methodlist: too short")
    if(length(prepareZZ.arg) != nbpkg || !is.list(prepareZZ.arg))
      stop("wrong prepareZZ.arg: too short")
  }
  if(any(!sapply(methodlist, is.character)))
    stop("methvect should be a list of vector of characters")
  if(any(!is.character(trainFUN)))
    stop("trainFUN should be a vector of characters")
  if(any(!is.character(hyperparamFUN)))
    stop("hyperparamFUN should be a vector of characters")
  if(any(!is.character(predictFUN)))
    stop("predictFUN should be a vector of characters")
  if(any(!is.character(closeFUN)))
    stop("predictFUN should be a vector of characters")
  if(any(!is.character(pkgname)))
    stop("pkgname should be a vector of characters")
  if(any(!is.character(pkgfun)))
    stop("pkgfun should be a vector of characters")
  
  if(nbpkg == 1)
  {
    if(!exists(trainFUN))
      stop(paste(trainFUN, "does not exist"))
    if(!exists(hyperparamFUN))
      stop(paste(hyperparamFUN, "does not exist"))
    if(!exists(predictFUN))
      stop(paste(predictFUN, "does not exist"))
    if(!is.null(startNN) && !is.na(startNN))
    {
      if(!exists(startNN))
        stop(paste("function", startNN, "does not exist"))
      do.call(startNN, list())
    }else
    {
      #print(search())
      x <- require(pkgname[1], character.only = TRUE)
      #print(search())
      #print(x)
    }
    
    resallmethod <- sapply(1:length(methodlist), function(i)
      trainPredict_1mth1data(dset=dset, method=methodlist[i], trainFUN=trainFUN, hyperparamFUN=hyperparamFUN, 
                                   predictFUN=predictFUN, summaryFUN=summaryFUN, 
                                   prepareZZ.arg=prepareZZ.arg, nrep=nrep, doplot=doplot,
                                   pkgname=pkgname, pkgfun=pkgfun, csvfile=csvfile, rdafile=rdafile, odir=odir, 
                                   echo=echo, ...))
    
    if(!exists(closeFUN))
      stop(paste("function", closeFUN, "does not exist"))
    do.call(closeFUN, list())
    colnames(resallmethod) <- methodlist
    return(resallmethod)
  }else
  {
    for(j in 1:nbpkg)
    {
      if(!exists(trainFUN[j]))
        stop(paste(trainFUN[j], "does not exist"))
      if(!exists(hyperparamFUN[j]))
        stop(paste(hyperparamFUN[j], "does not exist"))
      if(!exists(predictFUN[j]))
        stop(paste(predictFUN[j], "does not exist"))
      if(!exists(closeFUN[j]))
        stop(paste(closeFUN[j], "does not exist"))
    }
    if(!is.null(startNN))
      stopifnot(length(startNN) == nbpkg)
    
    res1pkg <- function(j)
    {
      mymethod <- methodlist[[j]]
      if(!is.null(startNN[j]) && !is.na(startNN[j]))
      {
        if(!exists(startNN[j]))
          stop(paste("function", startNN[j], "does not exist"))
        do.call(startNN[j], list())
      }else
        require(pkgname[j], character.only = TRUE)
      
      resallmethod <- sapply(1:length(mymethod), function(i)
        trainPredict_1mth1data(dset=dset, method=mymethod[i], trainFUN=trainFUN[j], hyperparamFUN=hyperparamFUN[j], 
                                     predictFUN=predictFUN[j], 
                                     summaryFUN=summaryFUN, prepareZZ.arg=prepareZZ.arg[[j]], 
                                     nrep=nrep, doplot=doplot, pkgname=pkgname[j], pkgfun=pkgfun[j], 
                                     csvfile = csvfile, rdafile=rdafile, 
                                     odir=odir, echo=echo, ...))
      
      if(!exists(closeFUN[j]))
        stop(paste("function", closeFUN[j], "does not exist"))
      do.call(closeFUN[j], list())
      colnames(resallmethod) <- paste0(pkgname[j], "::", mymethod)
      resallmethod
    }
    res <- sapply(1:nbpkg, res1pkg)
    resfinal <- res[[1]]
    for(i in 2:nbpkg)
      resfinal <- cbind(resfinal, res[[i]])    
    return(resfinal)
  }
  
}



#' @export
#' @rdname NNtrainPredict
trainPredict_1pkg <- function(dsetnum, pkgname="pkg", pkgfun="train", methodvect, prepareZZ.arg=list(),
                              summaryFUN, nrep=5, doplot=FALSE, plot.arg=list(),
                              csvfile = FALSE, rdafile=FALSE, odir="~/", echo=FALSE, 
                              appendcsv=TRUE, ...)
{
  #sanity check
  if(length(pkgname) != 1 )
    stop("wrong pkgname")
  
  trainFUN <- paste("NNtrain", pkgname, sep=".")
  hyperparamFUN <- paste("hyperParams", pkgname, sep=".")
  predictFUN <- paste("NNpredict", pkgname, sep=".")
  closeFUN <- paste("NNclose", pkgname, sep=".")
  startNN <- paste("NNstart", pkgname, sep=".")
  if(missing(summaryFUN))
    summaryFUN <- NNsummary

  if(!exists(trainFUN))
    stop(paste(trainFUN, "does not exist"))
  if(!exists(hyperparamFUN))
    stop(paste(hyperparamFUN, "does not exist"))
  if(!exists(predictFUN))
    stop(paste(predictFUN, "does not exist"))
  if(!exists(startNN))
    startNN <- NA
  if(!is.na(startNN))
  {
    if(!exists(startNN))
      stop(paste("function", startNN, "does not exist"))
    do.call(startNN, list())
  }else
  {
    #print(search())
    x <- require(pkgname[1], character.only = TRUE)
    #print(search())
    #print(x)
  }
  if(!exists(closeFUN))
    stop(paste("function", closeFUN, "does not exist"))
  
  nbdata <- length(dsetnum)
  #sanity check 
  if(nbdata <= 0)
    stop("no dataset to be tested")
  
  resallmethod <- function(j)
  {
    res <- lapply(1:length(methodvect), function(i)
      trainPredict_1mth1data(dset=dsetnum[j], method=methodvect[i], trainFUN=trainFUN, hyperparamFUN=hyperparamFUN, 
                           predictFUN=predictFUN, summaryFUN=summaryFUN, 
                           prepareZZ.arg=prepareZZ.arg, nrep=nrep, doplot=doplot,
                           pkgname=pkgname, pkgfun=pkgfun, csvfile=csvfile, rdafile=rdafile, odir=odir, 
                           echo=echo, appendcsv=appendcsv, ...))
    if(is.list(res))
    {
      names(res) <- methodvect
      res <- simplify2array(res)
    }
    return(res)
  }
  res <- lapply(1:nbdata, resallmethod)
  mydatanames <- c("mDette","mFriedman","mIshigami","mRef153","uDmod1",   
    "uDmod2","uDreyfus1","uDreyfus2","uGauss1","uGauss2","uGauss3","uNeuroOne","mWoodN1")
  names(res) <- mydatanames[dsetnum]
  res <- simplify2array(res)
  if(is.list(res))
    res <- simplify2array(res)
    
  do.call(closeFUN, list())
  
  return(res)
}

