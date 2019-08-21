## plotNN 2019-08-04



#' @title Create a Plot, Add Lines or Points Depending The Context
#' @description 
#' \code{plotNN} uses the parameter \code{uni} to launch the \code{plot()} function either 
#' for a univariate dataset (x, y_pred) or for a multivariate dataset (y, y_pred).
#' 
#' \code{lipoNN} uses the parameter \code{uni} to launch either \code{lines()} for an
#' univariate dataset or \code{points()} for a multivariate dataset.
#' 
#' See the examples in \code{\link{prepareZZ}}.
#' 
#' @param   xory     vector of numeric. The original x values for an univariate dataset 
#'                   or the original y values for a multivariate dataset.
#' @param   y0       vector of numeric. The original y values.
#' @param   uni      logicial. TRUE for an univariate dataset. FALSE for a multivariate dataset.
#'                   \code{...} fails or if you call the function from another function.
#' @param   TF       logical. TRUE executes the instruction. FALSE ignores the instruction.
#'                   Equivalent to \code{if (TRUE/FALSE) plot()}.
#' @param   ...      parameters passed to \code{plot()}, \code{lines()} or \code{points()}.
#' @param   y_pred   vector of numeric. The values returned by the \code{predict()} function.
#' @return
#' NULL in the console. An initial plot or some added lines/points.
#' 
#' @export
#' @name plotNN
plotNN <- function(xory, y0, uni, TF = TRUE, ...) {
    if (TF) {
        if (uni) {
            graphics::plot(xory, y0, las = 1, ...)
        } else {
            graphics::plot(xory, y0, las = 1, col = 0, ...) 
            graphics::abline(a = 0, b = 1, lty = 5)
        }
    }
}

#' @export
#' @rdname plotNN
lipoNN <- function(xory, y_pred, uni, TF = TRUE, ...) {
    if (TF) {
        if (uni) {
            graphics::lines(xory, y_pred, ...)
        } else {
            graphics::points(xory, y_pred, ...)
        }
    }
}


