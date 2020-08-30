## timestart timediff 2020-06-20


#' @title Collect the difftime between two events
#' 
#' @description
#' \code{timestart} starts the timer and saved the value in an object named 
#' \code{time0} stored in \code{.GlobalEnv}.
#' 
#' \code{timediff} stops the timer, remove the \code{time0} objet from \code{.GlobalEnv}
#' and prints the duration in seconds between the two events.
#' 
#' \code{timestart} and \code{timediff} are fully independant from  the R6 class
#' \code{timeR} and the objects \code{createTimer} or \code{getTimer}. They use
#' \code{\link{proc.time}} instead.
#' 
#' @return   
#' A single numeric value that represents a duration in seconds. 
#' 
#' @examples 
#' timestart()
#' Sys.sleep(2)
#' timediff()
#' 
#' @export
#' @name timestart
timestart <- function() {
   gc(FALSE)
   time0  <- proc.time()["elapsed"]
   time0 <<- time0
}

#' @export
#' @rdname timestart
timediff <- function() {
   t1 <- proc.time()["elapsed"]
   t0 <- get("time0", envir = .GlobalEnv)
   # remove("time0", envir = .GlobalEnv)
   time0 <<- NA
   unname(t1 - t0)
}



