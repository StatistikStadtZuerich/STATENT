#' download UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
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
#' @noRd 
mod_download_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_download_ui("download_1")
    
## To be copied in the server
# mod_download_server("download_1")
