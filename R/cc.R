## cc 2019-08-04


#' @title Concatenates List and Vectors into a List
#' @description
#' An intermediate function between \code{c()} and \code{list()}. 
#' Combine all terms in one single list. The result can be used by \code{do.call()}.
#' 
#' @param   char      a vector of named objects, except a list.
#' @param   ...       basic R objects: character, vectors, list, data.frame.
#' @return  
#' A list with the objects concatenated.
#' 
#' @examples
#' lst <- list(yaxt = "s", side = 2, col = 1:3) ; lst
#' dfr <- data.frame(x = 5:9, y = 10:14) ; dfr
#' 
#' ## With c(), the list is returned at its given position
#' c(lst, at = 7, labels = c("0", "0.5", "1"), dfr = dfr)
#' c(at = 7, labels = c("0", "0.5", "1"), lst, dfr = dfr)
#' 
#' ## With cc(), the unnamed list is always returned in first position
#' cc(lst, at = 7, labels = c("0", "0.5", "1"), dfr = dfr)
#' cc(at = 7, dfr = dfr, labels = c("0", "0.5", "1"), lst)
#' 
#' ## Some similarities and differences between c() and cc()
#' c( 1:5, y = 2:6, col = 2, lwd = 2)
#' cc(1:5, y = 2:6, col = 2, lwd = 2)
#' 
#' c( x = 1:5, y = 2:6, col = 2, lwd = 2)
#' cc(x = 1:5, y = 2:6, col = 2, lwd = 2)
#' 
#' ## Regular function and do.call()
#' plot(x = 1:5, y = 2:6, col = 2, lwd = 2)
#' do.call( plot , cc(x = 1:5, y = 2:6, col = 3, lwd = 3, cex = 3))
#' do.call("plot", cc(x = 1:5, y = 2:6, col = 4, lwd = 4, cex = 4))
#' 
#' @export
#' @name cc
cc <- function (char, ...) {
  if (missing(char)) {
    list(...)
  } else {
    if (is.list(char)) {
      c(char, list(...))
    } else {
      c(char, ..., recursive = FALSE)
    }
  }
}



