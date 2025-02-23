#' result UI Function
#'
#' This function creates the user interface for displaying results in a Shiny application. It includes text outputs for titles and subtitles, as well as a table output for displaying results in a reactive table.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @description A Shiny Module that generates the UI for displaying results, including titles, subtitles, and a results table.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_result_ui <- function(id) {
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
    
    # Table and chart
    mod_result_table_chart_ui(ns("table_chart"))
  )
}

#'  Result Server Function
#'
#' This function contains the server-side logic for a Shiny module that displays results based on user inputs. It dynamically updates text elements (titles, subtitles) and renders a results table. Additionally, it prepares and updates data for a chart.
#'
#' @param id A character string used to specify a namespace for the module.
#' @param data_table A reactive expression that returns the filtered data table to be displayed.
#' @param chart_data A reactive expression that returns the data to be used for charting.
#' @param parameters A list of reactive expressions representing user input selections (e.g., area, sector, size, legal form).
#'
#' @noRd
mod_result_server <- function(id, data_table, chart_data, parameters) {
  moduleServer(id, function(input, output, session) {
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

    
    # Reactive for checking data availability
    data_availability <- reactive({
      req(data_table())
      data <- data_table()
      if (nrow(data) > 0) {
        available <- 1
      } else {
        available <- 0
      }
      
      return(available)
    }) |> 
      bindEvent(data_table())
    
    
    # Observe and update the infotext and UI elements based on data availability
    observe({
      if (data_availability() > 0) {
        shinyjs::show(ns("table_chart"))  # Show the module container
        output$tableTitle <- renderText({
          "Die folgende Tabelle entspricht Ihren Suchkriterien"
        })
        
        # Initialize the nested module server function
        mod_result_table_chart_server("table_chart", data_table, chart_data)
        
      } else {
        shinyjs::hide(ns("table_chart"))  # Hide the module container
        output$tableTitle <- renderText({
          "Es gibt keine Daten mit den ausgewählten Suchkriterien."
        })
      }
    }) |> 
      bindEvent(data_availability())
    
  })
}

## To be copied in the UI
# mod_result_ui("result_1")

## To be copied in the server
# mod_result_server("result_1")
