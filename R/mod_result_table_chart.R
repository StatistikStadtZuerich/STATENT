#' result_table_chart UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_result_table_chart_ui <- function(id){
  ns <- NS(id)
  tagList(
 
    reactableOutput(ns("results_table")),
    
    # div for d3 chart; namespace is dealt with in server/JS message handler
    div(id = ns("sszvis-chart"))
  )
}
    
#' result_table_chart Server Functions
#'
#' @noRd 
mod_result_table_chart_server <- function(id, data_table, chart_data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
    observe({
      req(data_table())
      
      output$results_table <- renderReactable(
        reactable_table(data_table)
      )
    })
    
    # create and send data for bar chart
    observe({
      
      req(chart_data())
      chart_data <- chart_data()
      id <- paste0("#", ns("sszvis-chart"))
      update_chart(list("data" = chart_data, "container_id" = id), "update_data", session)
    })

    
  })
}
    
## To be copied in the UI
# mod_result_table_chart_ui("result_table_chart_1")
    
## To be copied in the server
# mod_result_table_chart_server("result_table_chart_1")
