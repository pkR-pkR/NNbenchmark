## NNdataSummary


#' @title A Summary (in data.frame format) of NNdatasets
#' @description
#' \code{NNdataSummary} summarizes the information of the 12 datasets
#' listed in \code{NNdatasets}: name, n_rows, n_inputs, n_neurons, 
#' n_parameters. 
#' 
#' @param   NNdatasets   the NNdatasets list.
#' @examples 
#' NNdataSummary(NNdatasets)
#' 
#' @export
#' @name NNdataSummary
NNdataSummary <- function(NNdatasets) {
    data.frame(
        Dataset   = names(NNdatasets),
        n_rows    = sapply(NNdatasets, function(lst) nrow(lst[["Z"]])),
        n_inputs  = sapply(NNdatasets, function(lst) ncol(lst[["Z"]])-1),
        n_neurons = sapply(NNdatasets, function(lst) lst[["neur"]]),
        n_parameters = sapply(NNdatasets, function(lst) lst[["nparNN"]]),
        row.names = NULL
    )
}



