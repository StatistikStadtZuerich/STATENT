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
    
    # Table Title (Sector)
    tags$div(
      id = ns("title_id"),
      class = "title_div",
      textOutput(ns("title"))
    ),
    
    # Table Subtitle (Legal & Size)
    tags$div(
      id = ns("subtitle_id"),
      class = "subtitle_div",
      textOutput(ns("subtitle"))
    ),

    # Table Subsubtitle (Area)
    tags$div(
      id = ns("subSubtitle_id"),
      class = "subSubtitle_div",
      textOutput(ns("subSubtitle"))
    ),
    
    reactableOutput(ns("results_table"))
  )
}
    
#' result Server Functions
#'
#' @noRd 
mod_result_server <- function(id, data_table, input_area, input_sector, input_size, input_legal){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    
     # Title
    output$title <- renderText({
      input_sector()
    }) |> 
      bindEvent(input_sector())
    
    # Subtitle
    output$subtitle <- renderText({
      paste0(input_size(), ", ", input_legal())
    }) |>
      bindEvent(input_size(), input_legal())

    # Sub-Subtitle
    output$subSubtitle <- renderText({
      paste0(input_area())
    }) |>
      bindEvent(input_area())

    
    output$results_table <- renderReactable(
      reactable_table(data_table())
    )
  })
}
    
## To be copied in the UI
# mod_result_ui("result_1")
    
## To be copied in the server
# mod_result_server("result_1")
