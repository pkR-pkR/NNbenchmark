

## =======================================
## 2019-06-30 TEMPLATE FOR OUR FUTURE CODE
## (MUCH INSPIRED BY B005*.R AND A007*.R)
## =======================================
library(NNbenchmark)


rm(list=ls(all=TRUE))
setwd("D:/DevGSoC/results") ; getwd()
options(scipen = 9999)
options("digits.secs" = 2)


## ============
## ALL DATASETS
## ============
# ht(NNdatasets, n = 2, l = 6)
# names(NNdatasets)

## [1] "mDette"    "mFriedman" "mIshigami" "mRef153"   "uDmod1"    "uDmod2"   
## [7] "uDreyfus1" "uDreyfus2" "uGauss1"   "uGauss2"   "uGauss3"   "uNeuroOne"



## =================================================
## NO LOOP OR LOOP ON DATASETS + ATTACH THE DATASET
## SEE AT THE END OF THIS PAGE THE detach() FUNCTION
## =================================================
## NO LOOP OR LOOP => QUOTE OR UNQUOTE THE 3 LINES BELOW
## THE { IS CLOSED AT THE THE END OF THIS PAGE!
## HENCE, A VERY LARGE LOOP OVER THE 70 PACKAGES.

dset  <- "uGauss2"
# dsets <- names(NNdatasets)[3:6]
# for (dset in dsets) {

ds    <- NNdatasets[[dset]]$ds
Z     <- NNdatasets[[dset]]$Z
neur  <- NNdatasets[[dset]]$neur

TF    <- TRUE
nrep  <- 10
timer <- createTimer()

donotremove  <- c("dset", "dsets", "ds", "Z", "neur", "TF", "nrep", "timer",
                  "donotremove", "donotremove2")
donotremove2 <- c("dset", "dsets") 



## ==============
## PACKAGE monmlp
## ==============
# source("package-monmlp.R")
library(monmlp)

### ATTACH
ZZ <- prepareZZ(Z, xdmv = "m", ydmv = "m", scale = TRUE)
attach(ZZ)


### METHOD BFGS
method <- "BFGS"
iter   <- 200
descr  <- "momlp::monmlp.fit_BFGS"

descr  <- paste(dset, descr, sep = "_")
plotNN(xory, y0, uni, TF, main = descr)
Ypred <- list()
Rmse  <- numeric(length = nrep)
for(i in 1:nrep){
    event    <- paste0(descr, sprintf("_%.2d", i))
    timer$start(event)
    ## ADJUST THESE TWO LINES TO THE PACKAGE::ALGORITHM
    NNreg  <- monmlp.fit(x, y, hidden1 = neur, method = method, iter.max = iter)
    y_pred <- ym0 + ysd0*attr(NNreg, "y.pred", TF) 
    ##
    Ypred[[i]] <- y_pred
    Rmse[i]  <- sqrt(sum((y_pred - y0)^2)/(length(y_pred)))
    timer$stop(event, RMSE = round(Rmse[i], 4))
    lipoNN(xory, y_pred, uni, TF, col = i)
}
best <- which(Rmse == min(Rmse))[1] ; best
lipoNN(xory, Ypred[[best]], uni, TF, col = 4, lwd = 4, pch = 3, cex = 1.4)
getTimer(timer)



### METHOD Nelder-Mead
method <- "Nelder-Mead"
iter   <- 10000
descr  <- "momlp::monmlp.fit_Nelder-Mead"

descr  <- paste(dset, descr, sep = "_")
plotNN(xory, y0, uni, TF, main = descr)
Ypred <- list()
Rmse  <- numeric(length = nrep)
for(i in 1:nrep){
    event     <- paste0(descr, sprintf("_%.2d", i))
    timer$start(event)
    ## ADJUST THESE TWO LINES TO THE PACKAGE::ALGORITHM
    NNreg  <- monmlp.fit(x, y, hidden1 = neur, method = method, iter.max = iter)
    y_pred <- ym0 + ysd0*attr(NNreg, "y.pred", TF) 
    ##
    Ypred[[i]] <- y_pred
    Rmse[i]  <- sqrt(sum((y_pred - y0)^2)/(length(y_pred)))
    timer$stop(event, RMSE = round(Rmse[i], 4))
    lipoNN(xory, y_pred, uni, TF, col = i)
}
best <- which(Rmse == min(Rmse))[1] ; best
lipoNN(xory, Ypred[[best]], uni, TF, col = 4, lwd = 4, pch = 3, cex = 1.4)
# getTimer(timer)


### DETACH
detach(ZZ)
detach("package:monmlp", unload = TRUE)
remove(list= ls()[!(ls() %in% donotremove)])
ls()




## =================
## PACKAGE neuralnet
## =================
# source("package-neuralnet.R")
# source("P135-package-neuralnet.R") # on my computer





## ============
## PACKAGE qrnn
## ============
# source("package-qrnn.R")
library(qrnn)

### ATTACH
ZZ <- prepareZZ(Z, xdmv = "m", ydmv = "m", scale = TRUE)
attach(ZZ)


### 
iter   <- 2000
descr  <- "qrnn::qrnn.fit"


descr  <- paste(dset, descr, sep = "_")
plotNN(xory, y0, uni, TF, main = descr)
Ypred <- list()
Rmse  <- numeric(length = nrep)
for(i in 1:nrep){
    event     <- paste0(descr, sprintf("_%.2d", i))
    timer$start(event)
    ## ADJUST THESE TWO LINES TO THE PACKAGE::ALGORITHM
    NNreg  <- qrnn.fit(x, y, n.hidden = neur, iter.max = iter, n.trials = 1,
                       init.range = c(-0.1, 0.1, -0.1, 0.1))
    y_pred <- ym0 + ysd0*qrnn.predict(x, NNreg)
    ##
    Ypred[[i]] <- y_pred
    Rmse[i]  <- sqrt(sum((y_pred - y0)^2)/(length(y_pred)))
    timer$stop(event, RMSE = round(Rmse[i], 4))
    lipoNN(xory, y_pred, uni, TF, col = i)
}
best <- which(Rmse == min(Rmse))[1] ; best
lipoNN(xory, Ypred[[best]], uni, TF, col = 4, lwd = 4, pch = 3, cex = 1.4)
getTimer(timer)


### DETACH
detach(ZZ) 
detach("package:qrnn", unload = TRUE)
remove(list= ls()[!(ls() %in% donotremove)])
ls()




## ===========================================================
## SAVE THE timer DATA.FRAME WITH THE RESULTS FOR ALL PACKAGES
## IT CAN BE LATER MANIPULATED WITH dplyr
## ===========================================================
dfr <- getTimer(timer) ; dfr
csv::as.csv(dfr, paste0(dset, "-timer.csv"))


remove(list= ls()[!(ls() %in% donotremove2)])


## ===========
## END OF LOOP
## =========== 
}



## END
## END


