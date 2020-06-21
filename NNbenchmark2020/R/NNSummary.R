## 2020-06-18


#' @title Summarize Calculations of RMSE, MSE, MAE, and WAE
#' @description
#' Summarize measures of fit and time for a single training. Measures of fit 
#' include the Root Mean Squared Error (RMSE), the Mean Squared Error (MSE), 
#' the Mean Absolute Error (MAE), and the Worst Absolute Error (WAE) rounded
#' by default to 4 digits and set to \code{na.rm = TRUE}. See more at \code{\link{funRMSE}}. 
#' The summary can also include the results of time from \code{\link{getTimer}} in
#' NNbenchmark or results of time from other functions/packages
#' 
#' @param   y_pred  numeric vector of the predicted values
#' @param   y0      numeric vector of the observed values 
#' @param   dgts    integer value for how many digits to round to
#' @param   time    numeric value of time
#' @return  
#' A vector of RMSE, MSE, MAE, WAE, and time values for a single training.
#' 
#' @examples
#' options("digits.secs" = 4)
#' timeTT <- createTimer()
#' 
#' timeTT$start("event")
#' y0 <- 1:19
#' y_pred <- y0 + rnorm(length(y0), sd = 0.3)
#' timeTT$stop("event") 
#' 
#' time <- getTimer(timeTT)
#' 
#' NNSummary(y_pred, y0, 4, time[,4])
#' 
#' @export
#' @name NNSummary
NNSummary <- function(y_pred, y0, dgts = 4, time) {
  c(RMSE = funRMSE(y_pred, y0, dgts), 
    MSE  = funMSE( y_pred, y0, dgts), 
    MAE  = funMAE( y_pred, y0, dgts), 
    WAE  = funWAE( y_pred, y0, dgts), 
    time = time)
}



