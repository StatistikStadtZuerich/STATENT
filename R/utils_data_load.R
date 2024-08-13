#' data_load 
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
read_data <- function() {
  data1 <- read_csv("./temp_data/data1.csv")
  data2 <- read_csv("./temp_data/data2.csv")
  
  list(data1 = data1, data2 = data2)
}

#' prepare_data 
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
prepare_data <- function(data_sector, data_size_legal) {
  # data_sector <- data_vector[["data1"]]
  # data_size_legal <- data_vector[["data2"]]
}