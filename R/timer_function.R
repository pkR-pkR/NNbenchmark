## timer_function 2019-08-04



#' @title Create a timer object. Get the data frame of a timer object
#' @description
#' This is a modified version of the \code{timeR} package for an internal use. 
#' Full credit is to Yifu Yan, the author of the \code{timeR} package.
#' 
#' \code{createTimer} creates a timer object.
#' 
#' \code{getTimer} returns a data frame with all records saved by the timer 
#' object. Columns in the data.frame are: event, start, end, duration, RMSE, 
#' MAE, stars, params, comment.
#' 
#' @param  verbose  A parameter to control whether to print messages while using
#'                  methods. Default to \code{TRUE}.
#' @param  object   The name for timer object.
#' @return
#' An (invisible) object of R6 class for \code{createTimer}. A data.frame for 
#' \code{getTimer}.
#' 
#' @examples
#' ## Create a timer object. Record events. Get all records.
#' timeTT <- createTimer(FALSE) # print is disabled
#' timeTT <- createTimer()      # print is enabled
#' timeTT$start("event1")
#' Sys.sleep(1)
#' timeTT$stop("event1", RMSE = 1, MAE = 1.3, stars = "*", 
#'             params = "maxiter=100, lr=0.01", comment = "OK for 1",  
#'             printmsg = TRUE)
#' timeTT$start("event2")
#' Sys.sleep(2)
#' timeTT$stop("event2", RMSE = 2, MAE = 2.6, stars = "**",  
#'             params = "maxiter=1000, lr=0.001", comment = "OK for 2",  
#'             printmsg = FALSE)
#' getTimer(timeTT)
#' 
#' @export
#' @name createTimer
createTimer <- function(verbose = TRUE){
    return(timeR$new(verbose = verbose))
}

#' @export
#' @rdname createTimer
getTimer <- function(object){
    stopifnot(any(class(object) == "timeR"))
    return(object$getTimer())
}



