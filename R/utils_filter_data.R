#' filter_data 
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd

filter_table_data <- function(data_table, reactive_parameters) {
  # req(
  #   reactive_parameters$select_area, 
  #   reactive_parameters$select_sector,
  #   reactive_parameters$select_size,
  #   reactive_parameters$select_legal,
  #   reactive_parameters$select_year_min,
  #   reactive_parameters$select_year_max
  # )
  
  data_table |> 
    filter(.data[["RaumLang"]] == reactive_parameters[["select_area"]](),
           .data[["BrancheLang"]] == reactive_parameters[["select_sector"]](),
           .data[["BetriebsgrLang"]] == reactive_parameters[["select_size"]](),
           .data[["RechtsformLang"]] == reactive_parameters[["select_legal"]](),
           .data[["Jahr"]] >= reactive_parameters[["select_year_min"]]()
           # .data[["Jahr"]] <= reactive_parameters[["select_year_max"]]()
           ) |> 
    select(contains(c("Cd", "Sort")))
}