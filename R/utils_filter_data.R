#' filter_data 
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd

filter_table_data <- function(data_table, input_values) {
  
  data_table |> 
    filter(.data[["RaumLang"]] == input_values$select_area,
           .data[["BrancheLang"]] == input_values$select_sector,
           .data[["BetriebsgrLang"]] == input_values$select_size,
           .data[["RechtsformLang"]] == input_values$select_legal,
           .data[["Jahr"]] >= input_values$select_year[1],
           .data[["Jahr"]] <= input_values$select_year[2]
           ) |> 
    select(-contains(c("Cd", "Sort")))
}
# filter_table_data(x, 
#                   input_values = list(
#                     select_area = reactive("Ganze Stadt"),
#                     select_sector = reactive("Alle Sektoren"),
#                     select_size = reactive("Alle Betriebsgrössen"),
#                     select_legal = reactive("Alle Rechtsformen")
#                     # select_year = reactive(input$select_year)
#                   ))
