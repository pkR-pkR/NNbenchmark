## add2csv


#' @title Create or Append a data.frame To a csv File
#' @description
#' Create or append a data.frame to a csv file. Column names are added at creation and 
#' ignored at the append steps.
#' 
#' @param  x      a data.frame or a matrix.
#' @param  file   character. The filename.
#' 
#' @examples 
#' x <- data.frame(a = 1:4, b = 5:8)  
#' add2csv(x) 
#' add2csv(x) 
#' add2csv(x)
#' read.csv("results.csv")
#' 
#' @export
#' @name add2csv
add2csv <- function(x, file = "results.csv") {
    TF <- file.exists(file)
    utils::write.table(x, 
            file   = file, 
            append = if (TF) TRUE else FALSE, 
            quote  = FALSE, 
            sep    = ",", 
            eol    = "\n", 
            na     = "NA",
            dec    = ".", 
            row.names    = FALSE, 
            col.names    = if (TF) FALSE else TRUE, 
            qmethod      = "escape",
            fileEncoding = "UTF-8"
    )
}



