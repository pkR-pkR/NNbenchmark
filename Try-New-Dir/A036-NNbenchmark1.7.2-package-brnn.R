
## ============
## PACKGE brnn
## ============
library(brnn)

### ATTACH
ZZ <- prepareZZ(Z, xdmv = "m", ydmv = "v", scale = TRUE)
attach(ZZ)


### METHOD brnn
method <- "gaussNewton"
iter   <- 80
descr  <- "brnn::brnn_gaussNewton"
descr  <- paste(dset, descr, sep = "_")

plotNN(xory, y0, uni, TF, main = descr)
Ypred <- list()
Rmse  <- numeric(length = nrep)
Mae  <- numeric(length = nrep)

for(i in 1:nrep){
    event     <- paste0(descr, sprintf("_%.2d", i))
    timer$start(event)
    ## ADJUST THESE TWO LINES TO THE PACKAGE::ALGORITHM
    NNreg <- brnn::brnn(x, y, neur, normalize = FALSE, epochs = iter, verbose = FALSE)
    y_pred <- ym0 + ysd0 * predict(NNreg, x)
    ##
    Ypred[[i]] <- y_pred
    Rmse[i]  <- funRMSE(y_pred, y0)
    Mae[i]  <- funMAE(y_pred, y0)
    timer$stop(event, RMSE = Rmse[i], MAE = Mae[i])
    lipoNN(xory, y_pred, uni, TF, col = i)
}
best <- which(Rmse == min(Rmse))[1] ; best
lipoNN(xory, Ypred[[best]], uni, TF, col = 4, lwd = 4)
getTimer(timer)



### DETACH
clearNN(donotremove)
ls()
