#' result UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_result_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' result Server Functions
#'
#' @noRd 
mod_result_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_result_ui("result_1")
    
## To be copied in the server
# mod_result_server("result_1")
