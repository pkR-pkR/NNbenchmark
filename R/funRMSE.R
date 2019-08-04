## funRMSe, funMAE 2019-08-04


#' @title Calculate the RMSE and MAE, Round to 4 digits 
#' @description
#' Calculate the Root Means Square Error (RMSE) and the Mean Absoluter Error (MAE)
#' and round the result, by default to 4 digits. Apply \code{na.rm = TRUE}
#' 
#' @param   y_pred  vector of numeric. The predicted values.
#' @param   y0      vector of numeric. The original values. 
#' @param   dgts    integer. The rounding.  
#' 
#' @examples
#' y0 <- 1:19
#' y_pred <- y0 + rnorm(length(y0), sd = 0.3)
#' funRMSE(y_pred, y0)
#' funMAE( y_pred, y0)
#' 
#' @export
#' @name funRMSE
funRMSE <- function (y_pred, y0, dgts = 4) {
    y_pred <- as.numeric(y_pred)
    y0     <- as.numeric(y0) 
    res2   <- (y_pred - y0)^2
    z      <- sqrt(sum(res2, na.rm = TRUE)/length(y0))
    round(z, dgts)
}

#' @export
#' @rdname funRMSE
funMAE <- function (y_pred, y0, dgts = 4) {
    y_pred <- as.numeric(y_pred)
    y0     <- as.numeric(y0) 
    res    <- abs(y_pred - y0)
    z      <- sum(res, na.rm = TRUE)/length(y0)
    round(z, dgts)
}



