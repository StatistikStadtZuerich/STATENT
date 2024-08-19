#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  test <- prepare_data(data_vector[["OD2551"]], data_vector[["OD2552"]])
  reactive_data <- mod_input_server("input_widgets", test)
  print(reactive_data)
  
  mod_result_server("results", 
                    reactive_data$filtered_data
  )
  mod_download_server("download")
}

