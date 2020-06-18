## ht 2019-08-04. Rewritten in 2020-11-01


#' @title Concatenates head() and tail() in vector, list, matrix, data.frame, array
#' @description
#' Concatenates \code{head(n)} and \code{tail(n)} rows and subset with m columns. 
#' Works also with array, list and matrix in data.frame.
#' 
#' @param   x      vector, matrix, data.frame, array or list.
#' @param   n      integer. Cut in the first dimension.
#' @param   m      integer. Cut in the second dimension. 
#' @param   p      integer. Cut in the third and the next dimensions. 
#' @param   l      integer. Cut for a list and for data.frame with matrix inside. 
#' @param   names  logical. Provide names and numbers for undefined dimnames.
#' @param   LTT    character. The letter used in each dimension (vector, list, array).
#' @return  
#' An object of the same class than x but much shorter. 
#' 
#' @examples
#' 
#' ### Vector, data.frame, array
#' ht(1:100, names = FALSE)
#' ht(1:100, LTT = "z")
#' 
#' ht9(mtcars); dim(mtcars)
#' 
#' arr4 <- array(1:1680, c(8,7,6,5))
#' ht(arr4, n=1, p=1, names = FALSE)
#' ht(arr4, n=1, p=1, names = TRUE, LTT = c("x","L","X","Y","Z","T"))
#' 
#' ### List of matrices
#' lstmat <- rep(list(matrix(1:100, 10)), 8)
#' for (i in seq_along(lstmat)) lstmat[[i]] <- lstmat[[i]] *i
#' lstmat
#' ht(lstmat, n = 2, m = 2, l = 2, names = FALSE)
#' ht(lstmat, n = 2, m = 3, l = 1, names = TRUE)
#' ht(lstmat, n = 2, m = 3, l = 1, LTT = c("x","L","X","Y","Z"))
#' 
#' ### Data.frame with matrices inside.
#' ### See For instance data("gasoline", package = "pls")
#' 
#' ## Colnames on matrix B but not on matrix C. Protected data.frame.
#' B <- matrix(101:160, 10); colnames(B) <- paste0(1:6, "b"); B
#' C <- matrix(101:160, 10); C
#' dfrmat <- data.frame(A = 1:10, B = I(B), C = I(C), D = 11:20); dfrmat
#' colnames(dfrmat)
#' 
#' ## Matrix columns are controlled by m.
#' ## Unnamed C matrix columns have old values but new names. Be aware!
#' ht(dfrmat, n = 2, m = 1, l = 2, names = FALSE) # Original C.6 is now C.2
#' ht(dfrmat, n = 2, m = 1, l = 2, names = TRUE)  # Names keep original ranks
#' 
#' ## Data.frame columns are controlled by l.
#' ht(dfrmat, n = 3, m = 2, l = 1, names = TRUE)
#' 
#' @export
#' @name ht
ht <- function (x, n = 3, m = 4, p = 2, l = 2, names = TRUE,
                LTT = c("x","L","N","M","P","Q","R","S","T")) {
	fun_ij <- function(i, j) {
		if (j < i/2) c(seq_len(j), seq.int(to=i, length.out=j)) else seq_len(i)
	}
    if (is.null(dim(x))) {
		if (is.list(x)) {
        ## LIST
			if (is.null(names(x)) & names) {
				names(x) <- paste0(LTT[2], seq_along(x))
			}
			xl <- fun_ij(length(x), l)
			x  <- x[xl]
            lapply(x, ht, n = n, m = m, p = p, l = l, names = names, LTT = LTT)
        } else {
		## VECTOR
			if (is.null(names(x)) & names) {
				names(x) <- paste0(LTT[1], seq_along(x))
			}
			xn <- fun_ij(length(x), n)
			x[xn]
        }
    } else {
        if (is.data.frame(x) & ((length(apply(x, 2, length)) != NCOL(x)))) {
		## DATA.FRAME WITH MATRIX INSIDE
			rn  <- rownames(x)
			rnn <- rn[fun_ij(length(rn), n)]
			message(cat("Matrix in data.frame with colnames", colnames(x)))
			data.frame(ht(as.list(x), n=n, m=m, p=p, l=l, names=names, LTT=LTT),
			           row.names = rnn)
        } else {
		## MATRIX, ARRAY AND STANDARD DATA.FRAME
			dd  <- dim(x)
			LT3 <- LTT[-c(1,2)]
			stopifnot(length(dd) <= length(LT3))
			if (names) x <- provideDimnames(x, base = mapply(paste0, 
								as.list(LT3[seq_along(dd)]), 
								lapply(dd, seq_len), 
								SIMPLIFY = FALSE))
			nmp    <- c(n, m, rep(p, length(dd)-2))
			lstdc2 <- mapply(fun_ij, dd, nmp, SIMPLIFY = FALSE)
			listx  <- c(list(x), lstdc2, drop = FALSE)
			do.call(`[`, listx)
		}
    }
}

#' @export
#' @rdname ht
ht9 <- function (x, n = 3, m = 9999, p = 2, l = 2, names = TRUE,
                 LTT = c("x","L","N","M","P","Q","R","S","T")) {
	ht(x, n = n, m = m, p = p, l = l, names = names, LTT = LTT)
}



