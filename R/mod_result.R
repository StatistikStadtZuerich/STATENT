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
mod_result_server <- function(id, data_table, parameters){
  moduleServer( id, function(input, output, session){
    ns <- session$ns


     # Title
    output$title <- renderText({
      parameters$input_sector()
    }) |> 
      bindEvent(parameters$input_sector())
    
    # Subtitle
    output$subtitle <- renderText({
      paste0(parameters$input_size(), ", ", parameters$input_legal())
    }) |>
      bindEvent(parameters$input_size(), parameters$input_legal())

    # Sub-Subtitle
    output$subSubtitle <- renderText({
      paste0(parameters$input_area())
    }) |>
      bindEvent(parameters$input_area())


    output$results_table <- renderReactable(
      reactable_table(data_table())
    )
  })
}
    
## To be copied in the UI
# mod_result_ui("result_1")
    
## To be copied in the server
# mod_result_server("result_1")
