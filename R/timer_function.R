## timer_function




#' Create a timer object
#' 
#' @param verbose A parameter to control whether to print messages while using
#' methods. Default to \code{TRUE}.
#' @return a timer object.
#' @examples
#' ## Create, start and stop timing for event 1 (comment is optional)
#' ## Get all records in a data frame
#' timer1 <- createTimer()      # print is enabled
#' timer1 <- createTimer(FALSE) # print is disabled
#' timer1$start("event1")
#' timer1$stop("event1", RMSE = 1, comment = "event 1 stopped") 
#' getTimer(timer1)
#' @export
createTimer <- function(verbose = T){
    return(timeR$new(verbose = verbose))
}


#' Get the data frame in timer object
#'
#' timer object has a built-in data frame that contains all timings. run this
#' function to extract the data frame.
#'
#' @param object The name for timer object.
#' @return A data frame containing all records of a timer object.
#' @examples
#' timer1 <- createTimer()
#' timer1$start("event1")
#' Sys.sleep(1)
#' timer1$stop("event1")
#' getTimer(timer1)
#' @export
getTimer <- function(object){
    stopifnot(any(class(object) == "timeR"))
    return(object$getTimer())
}



