#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  mod_input_server("input_widgets")
  mod_result_server("results", prepare_data(data_vector[["data1"]], data_vector[["data2"]]))
  mod_download_server("download")
}
