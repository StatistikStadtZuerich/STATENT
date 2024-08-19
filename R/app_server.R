#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  reactive_data <- mod_input_server("input_widgets", prepare_data(data_vector[["OD2551"]], data_vector[["OD2552"]]))
  
  
  mod_result_server("results", 
                    reactive_data[["filtered_data"]],
                    reactive_data[["input_area"]],
                    reactive_data[["input_sector"]],
                    reactive_data[["input_size"]],
                    reactive_data[["input_legal"]]
                    
  )
  mod_download_server("download",
                      reactive_data[["filtered_data"]],
                      reactive_data[["input_area"]],
                      reactive_data[["input_sector"]],
                      reactive_data[["input_size"]],
                      reactive_data[["input_legal"]])
}

