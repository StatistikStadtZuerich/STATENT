#' input UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_input_ui <- function(id, choices_inputs){
  ns <- NS(id)
  tagList(
    
    sszSelectInput(ns("select_area"), "Geografischer Raum:", 
                   choices = choices_inputs[["choices_area"]], 
                   selected = "LAX"),
    
    sszSelectInput(ns("select_sector"), "Sektor:", 
                   choices = c("HOU", "LAX", "JFK", "SEA"), 
                   selected = "LAX"),
    
    sszRadioButtons(ns("select_size"),
                    "Betriebsgrösse:",
                    # choices = choicesapp[["choices_price"]]
                    choices = c("Preis pro m² Grundstücksfläche",
                                "Preis pro m² Grundstücksfläche, abzgl. Versicherungswert")),
    
    sszSelectInput(ns("select_legal"), "Rechtsform:", 
                   choices = c("HOU", "LAX", "JFK", "SEA"), 
                   selected = "LAX"),
    
    sszSliderInput(inputId = ns("select_year"), 
                   label = "Jahr:", 
                   value = 30, 
                   min = 0, 
                   max = 100),
    
    
    sszActionButton(ns("ActionButtonId"), "Abfrage starten")
 
  )
}
    
#' input Server Functions
#'
#' @noRd 
mod_input_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_input_ui("input_1")
    
## To be copied in the server
# mod_input_server("input_1")
