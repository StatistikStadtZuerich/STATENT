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
    
    tags$div(
      id = ns("tableTitle_id"),
      class = "tableTitle_div",
      textOutput(ns("tableTitle"))
    ),
    
    reactableOutput(ns("results_table")),
    
    # div for d3 chart; namespace is dealt with in server/JS message handler
    div(id = ns("sszvis-chart"))
  )
}
    
#' result Server Functions
#'
#' @noRd 
mod_result_server <- function(id, data_table, chart_data, parameters){
  moduleServer( id, function(input, output, session){
    ns <- session$ns


     # Title
    output$title <- renderText({
      parameters$input_area()
    }) |> 
      bindEvent(parameters$input_area())
    
    # Subtitle
    output$subtitle <- renderText({
      paste0(parameters$input_sector())
    }) |>
      bindEvent(parameters$input_sector())

    # Sub-Subtitle
    output$subSubtitle <- renderText({
      paste0(parameters$input_size(), ", ", parameters$input_legal())
    }) |>
      bindEvent(parameters$input_size(), parameters$input_legal())

    # title for table
    output$tableTitle <- renderText({
      paste0("Die folgende Tabelle entspricht Ihren Suchkriterien")
    })

    output$results_table <- renderReactable(
      reactable_table(data_table())
    )
    
    
    # create and send data for bar chart
    observe({
      chart_data <- chart_data()
      id <- paste0("#", ns("sszvis-chart"))
      update_chart(list("data" = chart_data, "container_id" = id), "update_data", session)
    }) |>
      bindEvent(chart_data())
    
  })
}
    
## To be copied in the UI
# mod_result_ui("result_1")
    
## To be copied in the server
# mod_result_server("result_1")
