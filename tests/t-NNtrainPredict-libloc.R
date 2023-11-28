
templib <- paste0(getwd(), "/templib")
dir.create(templib)
install.packages("brnn_0.9.3.tar.gz", lib = templib)

require(NNbenchmark)

nrep <- 2       
odir <- tempdir()

### Package with one method/optimization algorithm
library("brnn")
brnn.method <- "gaussNewton"
hyperParams.brnn <- function(optim_method, ...) 
  return(list(iter = 200))
brnn.prepareZZ <- list(xdmv = "m", ydmv = "v", zdm = "d", scale = TRUE)

NNtrain.brnn   <- function(x, y, dataxy, formula, neur, optim_method, hyperParams,...) {
  hyper_params <- do.call(hyperParams.brnn, list(brnn.method))
  iter  <- hyper_params$iter
  
  NNreg <- brnn::brnn(x, y, neur, normalize = FALSE, epochs = iter, verbose = FALSE)
  return(NNreg)
}
NNpredict.brnn <- function(object, x, ...) { predict(object, x) }
NNclose.brnn <- function(){
  if("package:brnn" %in% search())
    detach("package:brnn", unload=TRUE)
}

#sequential call
res1 <- trainPredict_1pkg(1:2, pkgname = "brnn", pkgfun = "brnn", brnn.method,
                          prepareZZ.arg = brnn.prepareZZ, nrep = nrep, doplot = FALSE,
                          csvfile = TRUE, rdafile = TRUE, odir = odir, echo = FALSE,
                          lib.loc = templib)
list.files(odir)
file.remove(list.files(odir, full.names = TRUE))

file.remove(list.files(templib, full.names = TRUE, recursive = TRUE))

