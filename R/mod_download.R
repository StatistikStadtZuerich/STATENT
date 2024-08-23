#' download UI Function
#'
#' @param id 
#'
#' @description A shiny Module.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_download_ui <- function(id){
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
        href = "https://data.stadt-zuerich.ch/dataset?tags=lima",
        image = img(ssz_icons$link)
      )
  )
)
}
    
#' download Server Functions
#'
#' @param id 
#' @param data_table 
#' @param parameters 
#'
#' @noRd 
mod_download_server <- function(id, data_table, data_table_excel, parameters){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
    filename <- reactive({
      area <- parameters$input_area()
      sector <- substr(parameters$input_sector(), 1, 20)
      size <- parameters$input_size()
      legal <- parameters$input_legal()
      paste0("Arbeitsstätten_Beschäftigte_Vollzeitäquivalente_", area, "_", 
             sector, "_", size, "_", legal)
    }) |>
      bindEvent(parameters$input_area(), parameters$input_sector(), 
                parameters$input_size(), parameters$input_legal())
    
    
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
                  file, row.names = FALSE, na = " ", fileEncoding = "UTF-8")
      }
    )
    
    # Excel
    output$excelDownload <- downloadHandler(
      filename = function() {
        name <- filename()
        paste0(name, ".xlsx")
      },
      content = function(file) {
        
        rlang::inject(export_excel(data_table_excel, file, parameters ))
      }
    )
    
  })
}
    
## To be copied in the UI
# mod_download_ui("download_1")
    
## To be copied in the server
# mod_download_server("download_1")
