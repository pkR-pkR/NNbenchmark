## datasets (univariate + multivariate) 2019-08-04



#' @title All Datasets in One List
#' @description
#' \code{NNdatasets} is a list with the 12 datasets presented in this package and the 
#' recommanded number of hidden neurons for each neural network model. 
#' 
#' \itemize{
#'   \item{mDette:    5 neurons.}
#'   \item{mFriedman: 5 neurons.}
#'   \item{mIshigami: 10 neurons.}
#'   \item{mRef153:   3 neurons.}
#'   \item{uDmod1:    6 neurons.}
#'   \item{uDmod2:    5 neurons.}
#'   \item{uDreyfus1: 3 neurons.}
#'   \item{uDreyfus2: 3 neurons.}
#'   \item{uGauss1:   5 neurons.}
#'   \item{uGauss2:   4 neurons.}
#'   \item{uGauss3:   4 neurons.}
#'   \item{uNeuroOne: 3 neurons.}
#' }
#' 
#' Each item of the list is itself a list with 4 components:
#' \itemize{
#' \item{ds: character. The name of the dataset.}
#' \item{neur: integer. The recommanded number of hidden neurons in the NN model and in 
#' \code{fmlaNN}.}
#' \item{nparNN: integer. The number of parameters in \code{fmlaNN}.}
#' \item{fmlaNN: the formula of the corresponding neural network, with tanh() as the
#' activation function in the hidden layer.}
#' \item{Z: matrix or data.frame. The dataset itself.}
#' }
#' Using \code{attach()} and \code{detach()} gives a direct access to these items. 
#' 
#' @examples 
#' ht(NNdatasets, n = 2, l = 6)
#' 
#' for (i in names(NNdatasets)) {
#'     DS <- NNdatasets[[i]]
#'     attach(DS)
#'     print(ds)
#'     print(neur)
#'     print(nparNN)
#'     print(nparNN)
#'     print(ht(Z, n = 2))
#'     cat("\n")
#'     ## Type here the code to test the 69 neural network packages.
#'     detach(DS)
#' }
#' 
#' @keywords datasets
#' @docType data
#' @name NNdatasets
NULL



#' @title Dataset mDette
#' @description
#' A multivariate dataset (x1, x2, x3, y) of class matrix and dim 500 x 4 to be fitted by 
#' a neural network with 5 hidden neurons.
#' @examples
#' ht(mDette)
#' pairs(mDette)
#' @references
#' Dette, H., & Pepelyshev, A. (2010). Generalized Latin hypercube design for computer 
#' experiments. Technometrics, 52(4). 
#' 
#' See also \url{http://www.sfu.ca/~ssurjano/detpep10curv.html}
#' @keywords datasets
#' @docType data
#' @name mDette
NULL



#' @title Dataset mFriedman
#' @description
#' A multivariate dataset (x1, x2, x3, x4, x5, y) of class matrix and dim 500 x 6 to be  
#' fitted by a neural network with 4 or 5 hidden neurons.
#' @examples
#' ht(mFriedman)
#' pairs(mFriedman)
#' @references
#' Friedman, J. H., Grosse, E., & Stuetzle, W. (1983). Multidimensional additive spline 
#' approximation. SIAM Journal on Scientific and Statistical Computing, 4(2), 291-301. 
#' 
#' See also \url{http://www.sfu.ca/~ssurjano/fried.html}
#' @keywords datasets
#' @docType data
#' @name mFriedman
NULL



#' @title Dataset mIshigami
#' @description
#' A multivariate dataset (x1, x2, x3, y) of class matrix and dim 500 x 4 to be fitted 
#' by a neural network with 10 hidden neurons.
#' @examples
#' ht(mIshigami)
#' pairs(mIshigami)
#' @references
#' Ishigami, T., & Homma, T. (1990, December). An importance quantification technique in 
#' uncertainty analysis for computer models. In Uncertainty Modeling and Analysis, 1990. 
#' Proceedings., First International Symposium on (pp. 398-403). IEEE. 
#' 
#' See also \url{http://www.sfu.ca/~ssurjano/ishigami.html}
#' @keywords datasets
#' @docType data
#' @name mIshigami
NULL



#' @title Dataset mRef153
#' @description
#' A multivariate dataset (x1, x2, x3, x4, x5, y) of class matrix and dim 153 x 6 to be 
#' fitted by a neural network with 3 or 4 hidden neurons.
#' This dataset was used to teach neural networks at ESPCI from 2003 to 2013 and is 
#' available in the software Neuro One. 
#' @references
#' Neuro One \url{http://www.inmodelia.com/software.html}
#' @examples
#' ht(mRef153)
#' pairs(mRef153)
#' @keywords datasets
#' @docType data
#' @name mRef153
NULL



#' @title Dataset uDmod1
#' @description
#' An univariate dataset (x, y) of class data.frame and dim 51 x 2 to be fitted by a 
#' neural network with 5 or 6 hidden neurons.
#' The parameters are highly correlated and singular Jacobian matrices often appear. 
#' A difficult dataset. 
#' @examples
#' ht(uDmod1)
#' plot(uDmod1)
#' @keywords datasets
#' @docType data
#' @name uDmod1
NULL



#' @title Dataset uDmod2
#' @description
#' An univariate dataset (x, y) of class data.frame and dim 51 x 2 to be fitted by a 
#' neural network with 5 hidden neurons.
#' @examples
#' ht(uDmod2)
#' plot(uDmod2)
#' @keywords datasets
#' @docType data
#' @name uDmod2
NULL



#' @title Dataset uDreyfus1
#' @description
#' An univariate dataset (x, y) of class data.frame and dim 51 x 2 to be fitted by a 
#' neural network with 3 hidden neurons.
#' This dataset was used to teach neural networks at ESPCI from 1991 to 2013. It usually
#' appeared in the very first slides. 
#' This is a combination of 3 pure tanh() functions without noise. The Jacobian matrix 
#' is singular at the target parameter values and many algorithms could fail. 
#' @references
#' Dreyfus, G., ESPCI \url{https://www.neurones.espci.fr}
#' @examples
#' ht(uDreyfus1)
#' plot(uDreyfus1)
#' @keywords datasets
#' @docType data
#' @name uDreyfus1
NULL



#' @title Dataset uDreyfus2
#' @description
#' An univariate dataset (x, y) of class data.frame and dim 51 x 2 to be fitted by a 
#' neural network with 3 hidden neurons.
#' This dataset was used to teach neural networks at ESPCI from 1991 to 2013. It usually
#' appeared in the very first slides. 
#' This is a combination of 3 pure tanh() functions with a small noise. Due to the noise, 
#' the Jacobian matrix is not singular at the target parameter values. All algorithms 
#' should find the target parameter values. 
#' @references
#' Dreyfus, G., ESPCI \url{https://www.neurones.espci.fr}
#' @examples
#' ht(uDreyfus2)
#' plot(uDreyfus2)
#' @keywords datasets
#' @docType data
#' @name uDreyfus2
NULL



#' @title Dataset uGauss1
#' @description
#' An univariate dataset (x, y) of class data.frame and dim 250 x 2 to be fitted by a 
#' neural network with 5 hidden neurons.
#' @references
#' Rust, B., NIST (1996) \url{https://itl.nist.gov/div898/strd/nls/data/gauss1.shtml}
#' @examples
#' ht(uGauss1)
#' plot(uGauss1)
#' @keywords datasets
#' @docType data
#' @name uGauss1
NULL



#' @title Dataset uGauss2
#' @description
#' An univariate dataset (x, y) of class data.frame and dim 250 x 2 to be fitted by a 
#' neural network with 4 hidden neurons.
#' @references
#' Rust, B., NIST (1996) \url{https://itl.nist.gov/div898/strd/nls/data/gauss2.shtml}
#' @examples
#' ht(uGauss2)
#' plot(uGauss2)
#' @keywords datasets
#' @docType data
#' @name uGauss2
NULL



#' @title Dataset uGauss3
#' @description
#' An univariate dataset (x, y) of class data.frame and dim 250 x 2 to be fitted by a 
#' neural network with 4 hidden neurons.
#' @references
#' Rust, B., NIST (1996) \url{https://itl.nist.gov/div898/strd/nls/data/gauss3.shtml}
#' @examples
#' ht(uGauss3)
#' plot(uGauss3)
#' @keywords datasets
#' @docType data
#' @name uGauss3
NULL



#' @title Dataset uNeuroOne
#' @description
#' An univariate dataset (x, y) of class data.frame and dim 51 x 2 to be fitted by a 
#' neural network with 3 hidden neurons.
#' This dataset was used to teach neural networks at ESPCI from 1991 to 2013 and is 
#' available in the software Neuro One. 
#' @references
#' Dreyfus, G., ESPCI \url{https://www.neurones.espci.fr}
#' 
#' Neuro One \url{http://www.inmodelia.com/software.html}
#' @examples
#' ht(uNeuroOne)
#' plot(uNeuroOne)
#' @keywords datasets
#' @docType data
#' @name uNeuroOne
NULL



