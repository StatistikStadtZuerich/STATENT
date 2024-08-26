#' Input UI Function
#'
#' This function creates a UI module for a Shiny application. The UI includes several inputs such as select inputs, radio buttons, and a slider. The inputs allow the user to filter and select different criteria like geographic area, sector, company size, legal form, and year.
#'
#' @param id A character string used to specify a namespace for the module.
#' @param choices_inputs A list containing the choices for the select inputs and slider. The list should include the following named elements:
#'   - `choices_area`: A vector of choices for the geographic area.
#'   - `choices_sector`: A vector of choices for the sector.
#'   - `choices_size`: A vector of choices for the company size.
#'   - `choices_legal`: A vector of choices for the legal form.
#'   - `choices_year`: A vector of numeric values representing the years available for selection.
#'
#' @description A Shiny Module that generates a user interface with various input elements for filtering data based on area, sector, company size, legal form, and year.
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
    
#' Input Server Function
#'
#' This function is the server-side logic for a Shiny module that handles the dynamic filtering of a data table based on user inputs from the UI. It updates input options and prepares filtered data for further use in charts, downloads, and other outputs.
#'
#' @param id A character string used to specify a namespace for the module.
#' @param data_table A data frame that contains the data to be filtered based on user inputs.
#'
#' @return A list containing:
#'   - `filtered_data`: A reactive expression returning the filtered data table.
#'   - `filtered_data_download`: A reactive expression returning the filtered data prepared for download.
#'   - `filtered_chart_data`: A reactive expression returning the filtered data prepared for charting.
#'   - `parameters`: A list of reactive expressions for each user input (area, sector, size, and legal form).
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
        choices = new_choices
        # selected = new_choices[[1]]
      )
    }) |> 
      bindEvent(input$select_area)
    
    # update selection of size based on selected area and legal
    # observeEvent(list(input$select_area, input$select_legal), {
    #   new_choices <- unique(
    #     data_table[data_table$RaumLang == input$select_area &
    #                  data_table$RechtsformLang == input$select_legal, ]$BetriebsgrLang
    #     )
    #   updateRadioButtons(
    #     session = session,
    #     inputId = "select_size",
    #     choices = new_choices,
    #     selected = new_choices[[1]]
    #   )
    # }) 
    
    # update selection of legal based on selected area and size
    # observeEvent(list(input$select_area, input$select_size), {
    #   new_choices <- unique(
    #     data_table[data_table$RaumLang == input$select_area &
    #                  data_table$BetriebsgrLang == input$select_size, ]$RechtsformLang
    # )
    #   updateSelectInput(
    #     session = session,
    #     inputId = "select_legal",
    #     choices = new_choices,
    #     selected = new_choices[[1]]
    #   )
    # }) 
    
    
    # Filter main data according to input
    filtered_data <- reactive({
      filter_table_data(data_table, input)
    })
    
    # Prepare data for chart
    filtered_chart_data <- reactive({
      filter_chart_data(data_table, input)
    })
    
    # Prepare data for downloads
    filtered_data_download <- reactive({
      filter_download_data(data_table, input)
    })

    
    return(list(
      "filtered_data" = filtered_data,
      "filtered_data_download" = filtered_data_download,
      "filtered_chart_data" = filtered_chart_data,
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
