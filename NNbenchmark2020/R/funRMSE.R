## funRMSe, funMAE 2019-08-04, funWAE 2020-06-17, funMSE 2020-06-18


#' @title Calculate the RMSE, MSE, MAE, and WAE Rounded to 4 digits 
#' @description
#' Calculate the Root Mean Squared Error (RMSE), the Mean Squared Error (MSE), 
#' the Mean Absoluter Error (MAE), and the Worst Absolute Error (WAE). The
#' result is rounded to 4 digits by default. Apply \code{na.rm = TRUE}
#' 
#' @param   y_pred  numeric vector of the predicted values
#' @param   y0      numeric vector of the observed values 
#' @param   dgts    integer value for how many digits to round to
#' @return  
#' A numeric value, either the RMSE, MSE, MAE, or WAE.
#' 
#' @examples
#' y0 <- 1:19
#' y_pred <- y0 + rnorm(length(y0), sd = 0.3)
#' funRMSE(y_pred, y0)
#' funMSE( y_pred, y0)
#' funMAE( y_pred, y0)
#' funWAE( y_pred, y0)
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
funMSE <- function (y_pred, y0, dgts = 4) {
    y_pred <- as.numeric(y_pred)
    y0     <- as.numeric(y0) 
    res2   <- (y_pred - y0)^2
    z      <- sum(res2, na.rm = TRUE)/length(y0)
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

#' @export
#' @rdname funRMSE
funWAE <- function(y_pred, y0, dgts = 4)
{
    y_pred <- as.numeric(y_pred)
    y0     <- as.numeric(y0) 
    res    <- abs(y_pred - y0)
    z      <- max(res, na.rm = TRUE)
    round(z, dgts)
}



