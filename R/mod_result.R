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
    h1(textOutput(ns("title"))),

    # Table Subsubtitle (Area)
    h3(textOutput(ns("subtitle"))),
    
    # Table Title
    h4(textOutput(ns("tableTitle"))),
    
    reactableOutput(ns("results_table")),

    # div for d3 chart; namespace is dealt with in server/JS message handler
    div(id = ns("sszvis-chart"))
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
      paste0(parameters$input_area(), ": ", parameters$input_sector())
    }) |>
      bindEvent(parameters$input_area(), parameters$input_sector())

    # Subtitle
    output$subtitle <- renderText({
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
