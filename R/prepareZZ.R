## prepareZZ


#' @title Prepare a Dataset For All Possible Formats
#' @description
#' This function modifies a dataset to the format required by a training function: 
#' data.frame, matrix or vector (numeric), pre-normalization. The output is a list with
#' the following items:
#' \itemize{
#' \item{Zxy: the original or scaled Z in the desired format (data.frame, matrix).}
#' \item{x: the original or scaled x in the desired format (data.frame, matrix, vector).}
#' \item{y: the original or scaled y in the desired format (data.frame, matrix, vector).}
#' \item{xory: the original x or y (as vector).}
#' \item{y0: the original y (as vector).}
#' \item{xm0: the mean(s) of the original x.}
#' \item{ym0: the mean of the original y.}
#' \item{xsd0: the standard deviation(s) of the original x.}
#' \item{ysd0: the standard deviation of the original y.}
#' \item{uni: the univariate (TRUE) or multivariate (FALSE) status of x (Z).}
#' \item{fmla: the formula \code{y ~ x} or \code{y ~ x1 + x2 + .. + xn} where n is the 
#'       number of inputs variables.}
#' }
#' The use of \code{attach()} and \code{detach()} gives direct access to the modified 
#' values of ZZ. See the examples.
#' 
#' @param  Z       a matrix or a data.frame representing a dataset.
#' @param  xdmv    character, either "d", "m" or "v". The prefered output format for x: 
#'                 data.frame, matrix, vector (numeric).
#' @param  ydmv    character, either "d", "m" or "v". The prefered output format for y: 
#'                 data.frame, matrix, vector (numeric).
#' @param  zdm     character, either "d" or "m". The prefered output format for Zxy: 
#'                 data.frame or matrix.
#' @param  scale   logical. Scale x, y and Zxy with their respective means and standard  
#'                 deviations.
#' 
#' @examples
#' library("brnn")
#' library("validann")
#' 
#' 
#' ### UNIVARIATE DATASET
#' Z    <- uGauss2
#' neur <- 4
#' runs <- 10
#' TF   <- TRUE
#' 
#' ## brnn
#' ZZ <- prepareZZ(Z, xdmv = "m", ydmv= "v", scale = FALSE) ; ht(ZZ) 
#' attach(ZZ)
#' y_pred <- ym0 + ysd0*predict(brnn(x, y, neur))
#' plotNN(xory, y0, uni, TF)
#' lipoNN(xory, y_pred, uni, TF, lwd = 4, col = 2)
#' ym0 ; ysd0
#' detach(ZZ) ; rm(y_pred)
#' 
#' ## validann
#' ZZ <- prepareZZ(Z, xdmv = "m", ydmv= "v", scale = TRUE) ; ht(ZZ)
#' attach(ZZ)
#' y_pred <- ym0 + ysd0*predict(validann::ann(x, y, neur))
#' lipoNN(xory, y_pred, uni, TF, lwd = 4, col = 3)
#' ym0 ; ysd0
#' detach(ZZ) ; rm(y_pred)
#' 
#' 
#' 
#' ### UNIVARIATE DATASET + LOOP
#' ## brnn
#' ZZ <- prepareZZ(Z, xdmv = "m", ydmv= "v", scale = FALSE) ; ht(ZZ) 
#' attach(ZZ)
#' Zreg <- list() ; Zreg
#' for (i in 1:runs) Zreg[[i]] <- brnn::brnn(x, y, neur) 
#' m      <- matrix(sapply(Zreg, function(x) x$Ed) , ncol=1) ; m
#' best   <- which(min(m) == m)[1] ; best
#' y_pred <- ym0 + ysd0*predict(Zreg[[best]])
#' plotNN(xory, y0, uni, TF)
#' lipoNN(xory, y_pred, uni, TF, lwd = 4, col = 2)
#' detach(ZZ) ; rm(y_pred)
#' 
#' ## validann
#' ZZ <- prepareZZ(Z, xdmv = "m", ydmv= "v", scale = TRUE) ; ht(ZZ)
#' attach(ZZ)
#' Zreg <- list()
#' for (i in 1:runs) Zreg[[i]] <- validann::ann(x, y, size = neur) 
#' m      <- matrix(sapply(Zreg, function(x) x$value), ncol=1) ; m
#' best   <- which(min(m) == m)[1] ; best
#' y_pred <- ym0 + ysd0*predict(Zreg[[best]])
#' lipoNN(xory, y_pred, uni, TF, lwd = 4, col = 4)
#' detach(ZZ) ; rm(y_pred)
#' 
#' 
#' 
#' ### MULTIVARIATE DATASET
#' Z    <- mDette
#' neur <- 4
#' runs <- 10
#' 
#' ## brnn
#' ZZ <- prepareZZ(Z, xdmv = "m", ydmv= "v", scale = FALSE) ; ht(ZZ)
#' attach(ZZ)
#' y_pred <- ym0 + ysd0*predict(brnn::brnn(x, y, neur))
#' plotNN(xory, y0, uni, TF)
#' lipoNN(xory, y_pred, uni, TF, lwd = 4, col = 2)
#' ym0 ; ysd0
#' detach(ZZ) ; rm(y_pred)
#' 
#' ## validann
#' ZZ <- prepareZZ(Z, xdmv = "m", ydmv= "v", scale = TRUE) ; ht(ZZ)
#' attach(ZZ)
#' y_pred <- ym0 + ysd0*predict(validann::ann(x, y, neur))
#' lipoNN(xory, y_pred, uni, TF, lwd = 4, col = 3)
#' ym0 ; ysd0
#' detach(ZZ) ; rm(y_pred)
#' 
#' 
#' 
#' ### INSIDE A FUNCTION
#' plotds <- function(Z, xdmv = "m", ydmv = "v", scale = FALSE, neurons = 3, col = 2) {
#'     ZZ <- prepareZZ(Z, xdmv = xdmv, ydmv= ydmv, scale = scale) 
#'     attach(ZZ) ; on.exit(detach(ZZ))
#'     y_pred <- ym0 + ysd0*predict(brnn::brnn(x, y, neurons))
#'     plotNN(xory, y0, uni, TF)
#'     lipoNN(xory, y_pred, uni, TF, lwd = 4, col = col)
#'     print(ht(x))
#'     print(ht(y))
#' }
#' plotds(uNeuroOne, scale = FALSE, neurons = 2, col = 2)
#' plotds(uNeuroOne, scale = TRUE,  neurons = 3, col = 3)
#' 
#' plotds(mFriedman, scale = TRUE,  neurons = 5, col = 4)
#' 
#' 
#' @export
#' @name prepareZZ
prepareZZ <- function(Z, xdmv = "m", ydmv = "v", zdm = "d", scale = FALSE) {
    if (any(c(is.null(dimnames(Z)), lengths(dimnames(Z)) == 0))) { 
        stop("Z must have dimnames.")
    }
    ncZ   <- ncol(Z) 
    uni   <- (ncol(Z) == 2)
    if (ncZ < 2) stop("Z must have at least 2 columns with y in the last column.")
    cn    <- colnames(Z)
    if (cn[ncZ] != "y") stop('Last column must be "y".')
    ftxt  <- paste("y ~", paste(cn[!grepl("y", cn)], collapse = " + "))
    fmla  <- stats::formula(ftxt)
    xory  <- if (uni) { as.numeric(Z[,   1, drop = TRUE]) 
             } else   { as.numeric(Z[, ncZ, drop = TRUE]) }
    y0    <- as.numeric(Z[, ncZ, drop = TRUE]) 
    MEAN  <- round(apply(Z, 2, mean), 10)
    SD    <- round(apply(Z, 2, stats::sd),   10)
    names(MEAN) <- NULL
    names(SD)   <- NULL
    xm0   <- if (scale) MEAN[-ncZ] else rep(0, ncZ-1)
    ym0   <- if (scale) MEAN[ ncZ] else 0
    xsd0  <- if (scale) SD[-ncZ]   else rep(1, ncZ-1)
    ysd0  <- if (scale) SD[ ncZ]   else 1
    Zd    <- if (scale) as.data.frame(scale(Z)) else as.data.frame(Z)
    Zxy   <- switch(zdm, 
                "d" = Zd,
                "m" = as.matrix(Zd),
                stop('zdm must be either "d" or "m".')
                ) 
    x <- switch(xdmv, 
                "d" = Zd[, -ncZ, drop = FALSE],
                "m" = as.matrix( Zd[, -ncZ, drop = FALSE]),
                "v" = as.numeric(Zd[, -ncZ, drop = TRUE]),
                stop('xdmv must be either "d", "m" or "v".')
                ) 
    y <- switch(ydmv, 
                "d" = Zd[, ncZ, drop = FALSE],
                "m" = as.matrix( Zd[, ncZ, drop = FALSE]),
                "v" = as.numeric(Zd[, ncZ, drop = TRUE]),
                stop('ydmv must be either "d", "m" or "v".')
                )
    list(Zxy = Zxy, x = x, y = y, xory = xory, y0 = y0, 
         xm0 = xm0, ym0 = ym0, xsd0 = xsd0, ysd0 = ysd0, uni = uni,
         fmla = fmla)
}



