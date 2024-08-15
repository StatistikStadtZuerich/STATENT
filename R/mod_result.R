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
    h1(
      "Die Resultate entsprechen Ihren Eingabekriterien"
    ),
    
    reactableOutput(ns("results_table"))
  )
}
    
#' result Server Functions
#'
#' @noRd 
mod_result_server <- function(id, data_table){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$results_table <- renderReactable(
      reactable(data_table)
    )
  })
}
    
## To be copied in the UI
# mod_result_ui("result_1")
    
## To be copied in the server
# mod_result_server("result_1")
