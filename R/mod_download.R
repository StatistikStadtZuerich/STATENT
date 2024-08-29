#' Download UI Function
#'
#' This function creates the user interface for downloading data in a Shiny application. It provides buttons for downloading data in CSV and Excel formats, as well as a link to an Open Government Data (OGD) portal.
#'
#' @param id A character string used to specify a namespace for the module.
#'
#' @description A Shiny Module that generates the UI for downloading data, including CSV, Excel, and a link to OGD.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_download_ui <- function(id) {
  ns <- NS(id)
  ### Set up directory for icons
  ssz_icons <- icon_set("inst/app/www/icons/")

  tagList(
    h3("Daten herunterladen"),
    tags$div(
      id = "downloadWrapperId",
      class = "downloadWrapperDiv",
      sszDownloadButton(ns("csvDownload"),
        label = "csv",
        image = img(ssz_icons$download)
      ),
      sszDownloadButton(ns("excelDownload"),
        label = "xlsx",
        image = img(ssz_icons$download)
      ),
      sszOgdDownload(
        outputId = ns("ogdDown"),
        label = "OGD",
        href = "https://data.stadt-zuerich.ch/dataset?q=statent",
        image = img(ssz_icons$link)
      )
    )
  )
}

#' Download Server Function
#'
#' This function contains the server-side logic for handling data downloads in a Shiny module. It provides reactive download handlers for exporting data in CSV and Excel formats based on user-selected parameters.
#'
#' @param id A character string used to specify a namespace for the module.
#' @param data_table A reactive expression that returns the data table to be downloaded as a CSV file.
#' @param data_table_excel A reactive expression or data frame that returns the data to be downloaded as an Excel file.
#' @param parameters A list of reactive expressions representing user input selections (e.g., area, sector, size, legal form) used to generate the filenames.
#'
#' @noRd
mod_download_server <- function(id, data_table, data_table_excel, parameters) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    filename <- reactive({
      area <- parameters$input_area()
      sector <- substr(parameters$input_sector(), 1, 20)
      size <- parameters$input_size()
      legal <- parameters$input_legal()
      paste0(
        "Arbeitsstätten_Beschäftigte_Vollzeitäquivalente_", area, "_",
        sector, "_", size, "_", legal
      )
    }) |>
      bindEvent(
        parameters$input_area(), parameters$input_sector(),
        parameters$input_size(), parameters$input_legal()
      )


    ### Write Download Table
    ## App 1
    # CSV
    output$csvDownload <- downloadHandler(
      filename = function() {
        name <- filename()
        paste0(name, ".csv")
      },
      content = function(file) {
        write.csv(data_table(),
          file,
          row.names = FALSE, na = " ", fileEncoding = "UTF-8"
        )
      }
    )

    # Excel
    output$excelDownload <- downloadHandler(
      filename = function() {
        name <- filename()
        paste0(name, ".xlsx")
      },
      content = function(file) {
        export_excel(data_table_excel, file, parameters)
      }
    )
  })
}

## To be copied in the UI
# mod_download_ui("download_1")

## To be copied in the server
# mod_download_server("download_1")
