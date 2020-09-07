## prepareZZ


#' @title Prepare a Dataset For All Possible Formats
#' @description
#' This function modifies a dataset to the format required by a training function: 
#' data.frame, matrix or vector (numeric), pre-normalization. The output is a list with
#' the folowing items:
#' \itemize{
#' \item{x: the original or normalized x in the desired format (data.frame, matrix, vector).}
#' \item{y: the original or normalized y in the desired format (data.frame, matrix, vector).}
#' \item{xory: the original x or y (as vector).}
#' \item{y0: the original y (as vector).}
#' \item{xm0: the mean(s) of original x.}
#' \item{ym0: the mean of original y.}
#' \item{xsd0: the standard deviation(s) of original x.}
#' \item{ysd0: the standard deviation of original y.}
#' }
#' The use of \code{attach()} and \code{detach()} gives direct access to the modified 
#' values of ZZ. See the examples.
#' 
#' @param  Z          a matrix or a data.frame representing a dataset.
#' @param  xdmv       character, either "d", "m" or "v". The prefered output format for x: 
#'                    data.frame, matrix, vector (numeric).
#' @param  ydmv       character, either "d", "m" or "v". The prefered output format for y: 
#'                    data.frame, matrix, vector (numeric).
#' @param  normalize  logical. Normalize x and y with their respective means and standard deviations.
#' 
#' @examples
#' ### HIDDEN NEURONS + LOOP
#' library("brnn")
#' library("validann")
#' neur <- 4
#' runs <- 10
#' 
#' 
#' ### UNIVARIATE DATASET
#' ## brnn
#' ZZ <- prepareZZ(uGauss2, xdmv = "m", ydmv= "v", normalize = FALSE) ; ht(ZZ) 
#' attach(ZZ)
#' plot(xory, y0, las = 1)
#' lines(xory, ym0 + ysd0*predict(brnn::brnn(x, y, neur)), lwd = 4, col = 2)
#' ym0 ; ysd0
#' detach(ZZ)
#' 
#' ## validann
#' ZZ <- prepareZZ(get("uGauss2"), xdmv = "m", ydmv= "v", normalize = TRUE) ; ht(ZZ)
#' attach(ZZ)
#' lines(xory, ym0 + ysd0*predict(validann::ann(x, y, neur)), lwd = 4, col = 4)
#' ym0 ; ysd0
#' detach(ZZ)
#' 
#' 
#' ### MULTIVARIATE DATASET
#' ## brnn
#' ZZ <- prepareZZ(mDette, xdmv = "m", ydmv= "v", normalize = FALSE) ; ht(ZZ)
#' attach(ZZ)
#' plot(xory, y0, col = 0, las = 1) ; abline(a = 0, b = 1, lty = 5)
#' points(xory, ym0 + ysd0*predict(brnn::brnn(x, y, neur)), lwd = 2, col = 2)
#' ym0 ; ysd0
#' detach(ZZ)
#' 
#' ## validann
#' ZZ <- prepareZZ(get("mDette"), xdmv = "m", ydmv= "v", normalize = TRUE) ; ht(ZZ)
#' attach(ZZ)
#' points(xory, ym0 + ysd0*predict(validann::ann(x, y, neur)), lwd = 2, col = 4)
#' ym0 ; ysd0
#' detach(ZZ)
#' 
#' 
#' ### UNIVARIATE DATASET + LOOP
#' ## brnn
#' ZZ <- prepareZZ(uGauss2, xdmv = "m", ydmv= "v", normalize = FALSE) ; ht(ZZ) 
#' attach(ZZ)
#' Zreg <- list() ; Zreg
#' for (i in 1:runs) Zreg[[i]] <- brnn::brnn(x, y, neur) 
#' m    <- matrix(sapply(Zreg, function(x) x$Ed) , ncol=1) ; m
#' best <- which(min(m) == m)[1] ; best
#' plot(xory, y0, las = 1)
#' lines(xory, ym0 + ysd0*predict(Zreg[[best]]), lwd = 4, col = 2)
#' detach(ZZ)
#' 
#' ## validann
#' ZZ <- prepareZZ(get("uGauss2"), xdmv = "m", ydmv= "v", normalize = TRUE) ; ht(ZZ)
#' attach(ZZ)
#' Zreg <- list()
#' for (i in 1:runs) Zreg[[i]] <- validann::ann(x, y, size = neur) 
#' m    <- matrix(sapply(Zreg, function(x) x$value), ncol=1) ; m
#' best <- which(min(m) == m)[1] ; best
#' lines(xory, ym0 + ysd0*predict(Zreg[[best]]), lwd = 4, col = 4)
#' detach(ZZ)
#' 
#' 
#' ### WITHIN A FUNCTION, USE on.exit(detach()) 
#' plotZ <- function(Z, xdmv = "m", ydmv = "v", normalize = FALSE, neurons = 3, col = 2) {
#'     ZZ <- prepareZZ(Z, xdmv = xdmv, ydmv= ydmv, normalize = normalize) 
#'     attach(ZZ) ; on.exit(detach(ZZ))
#'     plot(xory, y0, las = 1)
#'     lines(xory, ym0 + ysd0*predict(brnn::brnn(x, y, neurons)), lwd = 4, col = col)
#'     print(ht(x))
#'     print(ht(y))
#' }
#' plotZ(uNeuroOne, normalize = FALSE, neurons = 2, col = 2)
#' plotZ(uNeuroOne, normalize = TRUE,  neurons = 3, col = 4)
#' 
#' 
#' @export
#' @name prepareZZ
prepareZZ <- function(Z, xdmv = "m", ydmv = "v", normalize = FALSE) {
    if (any(c(is.null(dimnames(Z)), lengths(dimnames(Z)) == 0))) { 
        stop("Z must have dimnames.")
    }
    ncZ  <- ncol(Z) 
    if (ncZ < 2) stop("Z must have at least 2 columns with y in the last column.")
    if (colnames(Z)[ncZ] != "y") stop('Last column must be "y".')
    xory  <- if (ncZ == 2) { as.numeric(Z[,   1, drop = TRUE]) 
             } else {        as.numeric(Z[, ncZ, drop = TRUE]) }
    y0    <- as.numeric(Z[, ncZ, drop = TRUE]) 
    MEAN  <- round(apply(Z, 2, mean), 10)
    SD    <- round(apply(Z, 2, stats::sd),   10)
    names(MEAN) <- NULL
    names(SD)   <- NULL
    xm0   <- if (normalize) MEAN[-ncZ] else rep(0, ncZ-1)
    ym0   <- if (normalize) MEAN[ ncZ] else 0
    xsd0  <- if (normalize) SD[-ncZ]   else rep(1, ncZ-1)
    ysd0  <- if (normalize) SD[ ncZ]   else 1
    Z     <- if (normalize) as.data.frame(scale(Z)) else as.data.frame(Z)
    x <- switch(xdmv, 
                "d" = Z[, -ncZ, drop = FALSE],
                "m" = as.matrix( Z[, -ncZ, drop = FALSE]),
                "v" = as.numeric(Z[, -ncZ, drop = TRUE]),
                stop('xdmv must be either "d", "m" or "v".')
                ) 
    y <- switch(ydmv, 
                "d" = Z[, ncZ, drop = FALSE],
                "m" = as.matrix( Z[, ncZ, drop = FALSE]),
                "v" = as.numeric(Z[, ncZ, drop = TRUE]),
                stop('ydmv must be either "d", "m" or "v".')
                )
    list(x = x, y = y, xory = xory, y0 = y0, 
         xm0 = xm0, ym0 = ym0, xsd0 = xsd0, ysd0 = ysd0)
}



