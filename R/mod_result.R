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
    h4(uiOutput(ns("tableTitle"))),
    
    
    # Conditional UI output for the module
    # uiOutput(ns("conditional_module_ui"))
    conditionalPanel(
      condition = "output.infotext !== null",  # Correct condition to hide/show
      ns = ns,
      mod_result_table_chart_ui(ns("table_chart"))
    ),
    textOutput(ns("infotext"))
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
    
    
    # Reactive for checking data availability
    data_availability <- reactive({
      req(data_table())
      test <- data_table()
      nrow(test) > 0
    }) |> 
      bindEvent(data_table())
    
    # Title for table
    output$tableTitle <- renderText({
      paste0("Die folgende Tabelle entspricht Ihren Suchkriterien")
    })
    
    # Infotext to show messages
    output$infotext <- renderText({
      if (data_availability()) {
        ""  # Clear message when data is available
      } else {
        "Es gibt keine Daten mit den ausgewählten Suchkriterien."
      }
    })
    
    # Ensure 'infotext' is marked as dynamic for conditionalPanel
    outputOptions(output, "infotext", suspendWhenHidden = FALSE)
    
    # Observe and update the UI elements based on data availability
    observe({
      if (data_availability()) {  # Data is available
        mod_result_table_chart_server(ns("table_chart"), data_table(), chart_data())
      } else {
        # Explicitly clear or reset the table/chart output when no data is available
        output$infotext <- renderText({
          "Es gibt keine Daten mit den ausgewählten Suchkriterien."
        })
      }
    })
    
  })
}

## To be copied in the UI
# mod_result_ui("result_1")

## To be copied in the server
# mod_result_server("result_1")
