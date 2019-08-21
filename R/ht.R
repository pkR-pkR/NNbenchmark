## ht 2019-08-04


#' @title Concatenates head() and tail() in vector, list, matrix, data.frame
#' @description
#' Concatenates \code{head(n)} and \code{tail(n)} rows and subset with m columns. 
#' Works also with list.
#' 
#' @param   x      vectors, matrix, data.frame or list.
#' @param   n      integer. Half-Length of vector or half-numer of lines (for matrix 
#'                 and data.frame) of the resulting object.
#' @param   m      integer. Half-number of columns (for matrix and data.frame) of the 
#'                 resulting object. \code{m = Inf} prevents any extraction. 
#' @param   l      integer. Half-length of the list of the resulting object. 
#' @return  
#' An object of the same class than x but much shorter. 
#' 
#' @examples
#' ### ht
#' vec <- 1:19
#' ht(vec)
#' 
#' dfr <- data.frame(A=1:19, B=21:39)
#' ht(dfr)
#' 
#' mat <- matrix(1:200, ncol = 20)
#' ht9(mat)
#' 
#' 
#' lst <- list(A = 11:13, B = 21:59, C = 31:69, 
#'             D = 41:43, E = 51:88, G = 61:99, 
#'             H = matrix(1:300, ncol = 15, dimnames = list(1:20, 1:15)))
#' ht(lst)
#' ht(lst, n = 2, m = 3, l = 2)
#' ht9(lst, l = 2)
#' 
#' @export
#' @name ht
ht <- function (x, n = 3, m = 4, l = 2) {
  if (is.null(dim(x))) {
      if (is.list(x)) {
            if ((length(x) / 2) > l) x <- c(utils::head(x, l), utils::tail(x, l))
            lapply(x, ht, n = n, m = m, l = l)
      } else {
            if ((length(x) / 2) > n) x <- c(utils::head(x, n), utils::tail(x, n)) 
            x      
      }
  } else {
      xrow <- if ((nrow(x) / 2) <= n) 1:nrow(x) else c(1:n, (nrow(x)-n+1):nrow(x))
      xcol <- if (is.finite(m)) {
                if (ncol(x) / 2 <= m) 1:ncol(x) else c(1:m, (ncol(x)-m+1):ncol(x))
              } else x
      rown <- rownames(x)[xrow]
      coln <- colnames(x)[xcol]
      x    <- x[xrow, xcol, drop = FALSE]
      rownames(x) <- rown
      colnames(x) <- coln
      x
  }
}

#' @export
#' @rdname ht
ht9 <- function (x, n = 3, m = 999, l = 2) {
  if (is.null(dim(x))) {
      if (is.list(x)) {
            if ((length(x) / 2) > l) x <- c(utils::head(x, l), utils::tail(x, l))
            lapply(x, ht, n = n, m = m, l = l)
      } else {
            if ((length(x) / 2) > n) x <- c(utils::head(x, n), utils::tail(x, n)) 
            x      
      }
  } else {
      xrow <- if ((nrow(x) / 2) <= n) 1:nrow(x) else c(1:n, (nrow(x)-n+1):nrow(x))
      xcol <- if (is.finite(m)) {
                if (ncol(x) / 2 <= m) 1:ncol(x) else c(1:m, (ncol(x)-m+1):ncol(x))
              } else x
      rown <- rownames(x)[xrow]
      coln <- colnames(x)[xcol]
      x    <- x[xrow, xcol, drop = FALSE]
      rownames(x) <- rown
      colnames(x) <- coln
      x
  }
}

