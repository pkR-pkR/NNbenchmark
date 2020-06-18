## add2csv 2019-08-04


#' @title Create or Append a data.frame to a csv File
#' @description
#' Create or append a data.frame to a csv file. Column names are added at creation and 
#' ignored at the append steps.
#' 
#' @param  x      a data.frame or a matrix.
#' @param  file   character. The filename.
#' @param  dir    character. The directory in which the file is written. 
#'                Default value \code{"."} is the current directory.
#' @return  
#' Nothing in the console. A csv file on the disk.
#' 
#' @examples 
#' results_csv <- tempfile("results", fileext = ".csv")
#' x <- data.frame(a = 1:3, b = 4:6) 
#' add2csv(x, file = results_csv) 
#' add2csv(x*10, file = results_csv) 
#' add2csv(x*100, file = results_csv) 
#' read.csv(file = results_csv) 
#' 
#' @export
#' @name add2csv
add2csv <- function(x, file = "results.csv", dir = ".") {
    dir2 <- gsub("\\", "/", path.expand(dir), fixed = TRUE)
    if (!dir.exists(dir2)) dir.create(dir2, recursive = TRUE)
	file2 <- if (dir2 == ".") file else file.path(dir2, file)
    TF    <- file.exists(file2)
    utils::write.table(x, 
            file   = file2, 
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



