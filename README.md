# NNbenchmark

NNbenchmark was created during the Google Summer of Code, 2019 as a part of The R Project for Statistical Computing, to verify the convergence of the training algorithms provided in 69 Neural Network R packages available on CRAN to date. Neural networks must be trained with second order algorithms and not with first order algorithms as many packages seem to do. 


The purpose of this project is to verify the quality of the training algorithms in R packages that provide neural network of perceptron type (one input layer, one normalized layer, one hidden layer with nonlinear activation function usually tanh(), 
one normalized layer, one output output layer) for regression purpose i.e. NN(X1, ..., Xn) = E[Y].


## Installation

```
install.packages('NNbenchmark')
```

## Documentation

[Reference manual on CRAN](https://cran.r-project.org/web/packages/NNbenchmark/NNbenchmark.pdf).


## Packages Tested  

This GSoC project will conduct a comprehensive survey of all packages that have the “neural network” keyword in thepackage title or in the package description. There are currently 69 packages on CRAN with this keyword.  

|    []()       |               |               |               |               |               |
|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:| 
|   AMORE       |    ANN2       |  appnn        |   automl      |  brnn         |  CaDENCE      |
|   DALEX2      |    DamiaNN    |  deepnet      |   elmNNrcpp   |   ELMR        | EnsembleBase  |                
|   h2o         |   keras       |  MachineShop  |   minpack.lm  |  monmlp       |  neuralnet    |
|  nlsr         |  nnet         |  qrnn         | radiant.model | rminer        | RSNNS         | 
| snnR          |  TraineR      | validann      |



## Evaluation Criteria
***
The algorithms were tested on 12 regression datasets (both univariate and multivariate) of varying complexity.  

The score for each package was based on the following parameters:  

* Documentation (0-3 stars or a binary value of 0/1)
* UtilFunction (0-3 stars or a binary value of 0/1)
* ConvergenceQuality (0-3 stars based on percentile method)
* ConvergenceTime (0-3 stars based on percentile method)


To obtain the final rating, we take a weighted average of these 4 columns (giving more weight to ConvergenceQuality and ConvergenceTime).


## Example Usage

An example usage using the `nnet` package.

### Load packages

```
library(NNbenchmark)
library(kableExtra)
options(scipen = 999)
```

### Datasets to test

```
NNdataSummary(NNdatasets)
```

### nnet trainPredict arguments - inputs x, y

```
if(dir.exists("D:/GSoC2020/Results/2020run03/"))
{  
  odir <- "D:/GSoC2020/Results/2020run03/"
}else if(dir.exists("~/Documents/recherche-enseignement/code/R/NNbenchmark-project/NNtempresult/"))
{  
  odir <- "~/Documents/recherche-enseignement/code/R/NNbenchmark-project/NNtempresult/"
}else
  odir <- "~"

nrep <- 10
maxit2ndorder  <-    200
maxit1storderA <-   1000
maxit1storderB <-  10000
maxit1storderC <- 100000

#library(nnet)
nnet.method <- "none"
hyperParams.nnet <- function(...) {
    return (list(iter=maxit2ndorder, trace=FALSE))
}
NNtrain.nnet <- function(x, y, dataxy, formula, neur, method, hyperParams, ...) {
    
    hyper_params <- do.call(hyperParams, list(...))
    
    NNreg <- nnet::nnet(x, y, size = neur, linout = TRUE, maxit = hyper_params$iter, trace=hyper_params$trace)
    return(NNreg)
}
NNpredict.nnet <- function(object, x, ...)
    predict(object, newdata=x)
NNclose.nnet <- function()
  if("package:nnet" %in% search())
    detach("package:nnet", unload=TRUE)
nnet.prepareZZ <- list(xdmv = "d", ydmv = "v", zdm = "d", scale = TRUE)
if(FALSE)
res <- trainPredict_1data(1, nnet.method, "NNtrain.nnet", "hyperParams.nnet", "NNpredict.nnet", 
                               NNsummary, "NNclose.nnet", NA, nnet.prepareZZ, nrep=5, echo=TRUE, doplot=FALSE,
                               pkgname="nnet", pkgfun="nnet", csvfile=TRUE, rdafile=TRUE, odir=odir)
```

### Launch package's `trainPredict`

```
res <- trainPredict_1pkg(1:12, pkgname = "nnet", pkgfun = "nnet", nnet.method,
  prepareZZ.arg = nnet.prepareZZ, nrep = nrep, doplot = TRUE,
  csvfile = TRUE, rdafile = TRUE, odir = odir, echo = FALSE)
```


### Result

```
kable(t(apply(res, c(1,4), min)))%>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed"))
```


## Authors  

### Selected Students:

- Akshaj Verma
- Salsabila Mahdi

### Mentors:

- Patrice Kiener  
- Christophe Dutang
- John C. Nash
