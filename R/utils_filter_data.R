#' filter_data 
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd

filter_table_data <- function(data_table, input_values) {
  # req(
  #   reactive_parameters$select_area, 
  #   reactive_parameters$select_sector,
  #   reactive_parameters$select_size,
  #   reactive_parameters$select_legal,
  #   reactive_parameters$select_year_min,
  #   reactive_parameters$select_year_max
  # )
  
  data_table |> 
    filter(.data[["RaumLang"]] == input_values[["select_area"]](),
           .data[["BrancheLang"]] == input_values[["select_sector"]](),
           .data[["BetriebsgrLang"]] == input_values[["select_size"]](),
           .data[["RechtsformLang"]] == input_values[["select_legal"]]()
           # .data[["Jahr"]] >= input_values[["select_year_min"]]()
           # .data[["Jahr"]] <= input_values[["select_year_max"]]()
           ) |> 
    select(-contains(c("Cd", "Sort")))
}