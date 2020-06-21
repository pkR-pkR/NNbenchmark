## NNTrain_Predict 2020-06-19


#' @title Generic Functions for Training and Predicting
#' @description
#' An implementation of \code{do.call} so any neural network function that fits 
#' the format can be tested. 
#' 
#' In \code{train_predict_1mth_1data}, a neural network is trained on one dataset
#' and then used for predictions, with several functionalities. Then, the performance 
#' of the neural network is summarized.
#' 
#' \code{train_predict_1data} serves a wrapper function for \code{train_predict_1mth_1data} 
#' for multiple methods.
#' 
#' 
#' @param   dset            a number or string indicating which dataset to use, see \code{\link{NNdataSummary}} 
#' @param   method          a method for a particular function
#' @param   methodlist      list of methods per package/function
#' @param   trainFUN        the training function used
#' @param   hyperparamFUN   the function resulting in parameters needed for training
#' @param   predictFUN      the prediction function used
#' @param   summaryFUN      measure performance by observed and predicted y values, \code{\link{NNSummary}} is ready to use 
#' @param   closeFUN        a function to detach packages or other necessary environment clearing
#' @param   startNN         a function to start needed outside libraries, for example, h2o
#' @param   prepareZZ.arg   list of arguments for \code{\link{prepareZZ}}
#' @param   nrep            a number for how many times a neural network should be trained
#' @param   doplot          logical value, TRUE executes plots and FALSE does not
#' @param   plot.arg        list of arguments for plots
#' @param   pkgname         package name
#' @param   pkgfun          package function to train neural network
#' @param   rdafile         logical value, 
#' @param   odir            directory
#' @param   echo            logical value, print summary if TRUE
#' @param   echoreport      separates training between packages with some text
#' @param   ...             additional arguments
#' @return  
#' A vector as in NNSummary for train_predict_1mth_1data and an array for train_predict_1data
#' 
#' @example 
#' Available at 
#'
#' @importFrom stats lm
#' @export
#' @name NNTrain_Predict
train_predict_1mth_1data <- function(dset, method, trainFUN, hyperparamFUN, predictFUN, summaryFUN,
                                     prepareZZ.arg=list(),
                                     nrep=5, doplot=FALSE, plot.arg=list(col1=1:nrep, lwd1=1, col2=4, lwd2=3),
                                     pkgname, pkgfun, rdafile=FALSE, odir="~/", echo=FALSE, echoreport=1, ...)
{
  method <- method[1]
  if(!is.list(plot.arg) || any(!names(plot.arg) %in% c("col1", "lwd1", "col2", "lwd2")))
    plot.arg <- list(col1=1:nrep, lwd1=1, col2=4, lwd2=3)
  
  plot.arg$col1 <- rep(plot.arg$col1, length.out=nrep)
  
  if(!exists(hyperparamFUN))
    stop(paste("function", hyperparamFUN, "does not exist"))
  if(!exists(trainFUN))
    stop(paste("function", trainFUN, "does not exist"))
  if(!exists(predictFUN))
    stop(paste("function", predictFUN, "does not exist"))
  
  timer  <- createTimer(verbose = FALSE)
  
  ds     <- NNbenchmark::NNdatasets[[dset]]$ds
  Z      <- NNbenchmark::NNdatasets[[dset]]$Z
  neur   <- NNbenchmark::NNdatasets[[dset]]$neur
  nparNN <- NNbenchmark::NNdatasets[[dset]]$nparNN
  fmlaNN <- NNbenchmark::NNdatasets[[dset]]$fmlaNN
  
  descr <- paste0(ds, "_", pkgname, "::", pkgfun, "_", method)
  if(echo)
  {
    cat(paste0(rep("_",80),collapse=""),"\n")
    cat("***\t", descr, "***\n")
  }
  if(length(prepareZZ.arg) != 4 || any(!names(prepareZZ.arg) %in% c("xdmv", "ydmv", "zdm", "scale")))
    prepareZZ.arg <- list(xdmv = "d", ydmv = "v", zdm = "d", scale = TRUE)
  ZZ <- do.call("prepareZZ", c(list(Z), prepareZZ.arg))    
  
  if(echo && echoreport > 1)
  {
    cat("prepareZZ\n")
    print(str(ZZ))
  }
  
  Ypred <- list()
  allsummary <- list()
  for(i in 1:nrep)
  {
    timer$start(descr)
    tempfit <- tryCatch(
      do.call(trainFUN, list(ZZ$x, ZZ$y, ZZ$Zxy, ZZ$fmla, neur, method,  hyperparamFUN, fmlaNN, nparNN)),
      error = function(y) {lm(y ~ 0, data = ZZ$Zxy)}
    ) 
    if(echo && echoreport > 1)
    {
      cat("\n\t\t--- debug : structure of fitted model ***\n")
      print(str(tempfit))
      cat("\n\t\t--- debug : summary of fitted model ***\n")
      print(summary(tempfit))
      
    }
    if(inherits(tempfit, "lm") || inherits(tempfit, "try-error"))
    {
      if(echo && echoreport > 1)
      {
        cat("\n--- \tdebug : training lead to error \t***\n")
        cat(pkgname, "::", pkgfun, "_", method, "\n")
      }
      
      Ypred[[i]] <- rep(ZZ$ym0, length.out=NROW(ZZ$x))
    }else
    {
      if(echo && echoreport > 1)
      {
        localpred <- try(do.call(predictFUN, list(tempfit, head(ZZ$x), head(ZZ$xy))), silent=echoreport > 2)
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
      temppred <- try(do.call(predictFUN, list(tempfit, ZZ$x, ZZ$Zxy)), silent=echoreport > 2)
      if(!inherits(temppred, "try-error"))
        Ypred[[i]] <- ZZ$ym0 + ZZ$ysd0 * temppred
      else
        Ypred[[i]] <- rep(ZZ$ym0, length.out=NROW(ZZ$x))
      
    }
    timer$stop(descr, RMSE = NA, MAE = NA, params = NA, printmsg = FALSE)
    allsummary[[i]] <- summaryFUN(Ypred[[i]], ZZ$y0, 4, round(getTimer(timer)[ ,4], 5))
    
    if(echo && i %% 5 == 0)
      cat(pkgname, pkgfun, method, "i", i, "summary statistics", allsummary[[i]][1:3], "time", allsummary[[i]]["time"], "\n")
    
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
  
  best <- which.min(allsummary["RMSE",])
  
  #outputs to file
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
    op <- par(mfcol = c(1,2))
    plotNN(ZZ$xory, ZZ$y0, ZZ$uni, doplot, main = descr)
    for (i in 1:nrep) 
      lipoNN(ZZ$xory, Ypred[,i], ZZ$uni, doplot, col = plot.arg$col1[i], lwd = plot.arg$lwd1)
    
    plotNN(ZZ$xory, ZZ$y0, ZZ$uni, doplot, main = descr)
    lipoNN(ZZ$xory, Ypred[,best], ZZ$uni, doplot, col = plot.arg$col2, lwd = plot.arg$lwd2)
    par(op)
  }
  if(echo)
    cat("\n")
  allsummary[,best]
}

#' @export
#' @rdname NNTrain_Predict
train_predict_1data <- function(dset, methodlist, trainFUN, hyperparamFUN, predictFUN, summaryFUN, 
                                closeFUN, startNN=NA, prepareZZ.arg=list(),
                                nrep=5, doplot=FALSE, plot.arg=list(),
                                pkgname="pkg", pkgfun="train", rdafile=FALSE, odir="~/", echo=FALSE, ...)
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
      #cat("blii\n")
      #print(pkgname[1])
      #print(search())
      x <- require(pkgname[1], character.only = TRUE)
      #print(search())
      #print(x)
    }
    
    resallmethod <- sapply(1:length(methodlist), function(i)
      train_predict_1mth_1data(dset=dset, method=methodlist[i], trainFUN=trainFUN, hyperparamFUN=hyperparamFUN, 
                                   predictFUN=predictFUN, summaryFUN=summaryFUN, 
                                   prepareZZ.arg=prepareZZ.arg, nrep=nrep, doplot=doplot,
                                   pkgname=pkgname, pkgfun=pkgfun, rdafile=rdafile, odir=odir, 
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
        train_predict_1mth_1data(dset=dset, method=mymethod[i], trainFUN=trainFUN[j], hyperparamFUN=hyperparamFUN[j], 
                                     predictFUN=predictFUN[j], 
                                     summaryFUN=summaryFUN, prepareZZ.arg=prepareZZ.arg[[j]], 
                                     nrep=nrep, doplot=doplot, pkgname=pkgname[j], pkgfun=pkgfun[j], rdafile=rdafile, 
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



