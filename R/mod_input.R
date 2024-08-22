#' input UI Function
#'
#' @param id 
#' @param choices_inputs 
#'
#' @description A shiny Module.
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
                   value = c(2011, 2021), 
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
#' @param id 
#' @param data_table 
#'
#' @noRd 
mod_input_server <- function(id, data_table){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # update selection of sectors based on selected area
    observe( {
      new_choices <- unique(data_table[data_table$RaumLang == input$select_area, ]$BrancheLang)
      updateSelectInput(
        session = session,
        inputId = "select_sector",
        choices = new_choices,
        selected = new_choices[[1]]
      )
    }) |> 
      bindEvent(input$select_area)
    
    # update selection of size based on selected area and legal
    observe({
      new_choices <- unique(
        data_table[data_table$RaumLang == input$select_area &
                     data_table$RechtsformLang == input$select_legal, ]$BetriebsgrLang
        )
      updateRadioButtons(
        session = session,
        inputId = "select_size",
        choices = new_choices,
        selected = new_choices[[1]]
      )
    }) |>
      bindEvent(input$select_area, input$select_legal)
    
    # update selection of legal based on selected area and size
    observe({
      new_choices <- unique(
        data_table[data_table$RaumLang == input$select_area &
                     data_table$BetriebsgrLang == input$select_size, ]$RechtsformLang
    )
      updateSelectInput(
        session = session,
        inputId = "select_legal",
        choices = new_choices,
        selected = new_choices[[1]]
      )
    }) |>
      bindEvent(input$select_area, input$select_size)
    # 
    
    # Filter main data according to input
    filtered_data <- reactive({
      filter_table_data(data_table, input)
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
