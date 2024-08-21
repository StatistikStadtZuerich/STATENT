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
                   selected = "Ganze Stadt"),
    
    conditionalPanel(
      condition = 'input.select_size == "Alle Betriebsgrössen" && input.select_legal == "Alle Rechtsformen"',
      ns = ns,
      sszSelectInput(ns("select_sector"), "Sektor:", 
                     choices = choices_inputs[["choices_sector"]], 
                     selected = "Total"
                     )
    ),
                    
    conditionalPanel(
      condition = 'input.select_sector == "Alle Sektoren"',
      ns = ns,
      sszRadioButtons(ns("select_size"), "Betriebsgrösse:",
                    choices = choices_inputs[["choices_size"]], 
                    selected = min(choices = choices_inputs[["choices_size"]])),
   
      sszSelectInput(ns("select_legal"), "Rechtsform:",
                   choices = choices_inputs[["choices_legal"]],
                   selected = "Alle Rechtsformen")
      ),
  
    sszSliderInput(inputId = ns("select_year"),
                   label = "Jahr:", 
                   value = c(2011, 2013), 
                   step = 1,
                   ticks = TRUE,
                   min = min(choices = choices_inputs[["choices_year"]]), 
                   max = max(choices = choices_inputs[["choices_year"]]),
                   sep = ""
                   )
 
  )
}
    
#' input Server Functions
#'
#' @noRd 
mod_input_server <- function(id, data_table2){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # Filter main data according to input
    filtered_data <- reactive({
      filter_table_data(data_table2, input)
    })

    
    return(list(
      "filtered_data" = filtered_data,
      "parameters" = list(
        input_area = reactive({ input$select_area }),
        input_sector = reactive({ input$select_sector }),
        input_size = reactive({ input$select_size }),
        input_legal = reactive({ input$select_legal })
      )
      ))
    
  })
}
    
## To be copied in the UI
# mod_input_ui("input_1")
    
## To be copied in the server
# mod_input_server("input_1")
