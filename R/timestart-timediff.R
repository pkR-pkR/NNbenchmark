## timestart-timediff 2020-06-20


#' @title Collect the difftime between 2 intervals
#' @description
#' \code{timestart} starts the timer and saved the value in an object named 
#' \code{time0} stored in \{.GlobalEnv}.
#' 
#' \code{timediff} stops the timer, remove the \code{time0} objet from \{.GlobalEnv}
#' and prints the duration in seconds between the two events.
#' 
#' \code{timestart} and \code{timediff} are fully independant from  the R6 class
#' \code{timeR} and the objects \code{createTimer} or \code{getTimer}.
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
   t0 <- proc.time()["elapsed"]         
   assign("time0", t0, envir = .GlobalEnv)
}

#' @export
#' @rdname timestart
timediff <- function() {
   t1 <- proc.time()["elapsed"]
   t0 <- get("time0", envir = .GlobalEnv)
   remove("time0", envir = .GlobalEnv)
   unname(t1 - t0)
}



