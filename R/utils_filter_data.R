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
    select(-contains(c("Cd", "Sort", "Lang"))) |> 
    distinct()
}
# filter_table_data(x,
#                   input_values = list(
#                     select_area = reactive("Ganze Stadt"),
#                     select_sector = reactive("Alle Sektoren"),
#                     select_size = reactive("Alle Betriebsgrössen"),
#                     select_legal = reactive("Alle Rechtsformen")
#                     # select_year = reactive(input$select_year)
#                   ))


#' filter_download_data 
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
filter_download_data <- function(data_table, input_values) {

  filter_table_data(data_table, input_values) |>
    rename("Arbeitsstätten" = "Arbeitsstaetten",
           "Anzahl Beschäftigte" = "AnzBesch",
           "Anzahl Beschäftigte (weiblich)" = "AnzBeschW",
           "Anzahl Beschäftigte (männlich)" = "AnzBeschM",
           "Anzahl Vollzeitäqui- valente" = "AnzVZA",
           "Anzahl Vollzeitäqui- valente (weiblich)" = "AnzVZAW",
           "Anzahl Vollzeitäqui- valente (männlich)" = "AnzVZAM"
             )
}

#' filter_chart_data 
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
filter_chart_data <- function(data_table, input_values) {
  
  data <- filter_table_data(data_table, input_values)
  
  # data <- test |> 
  #   filter(RaumSort == 1) |> 
  #   filter(BrancheLang == "Herstellung von Möbeln" & BrancheCd == "31") |> 
  #   select(Jahr, starts_with("A"))
  
  data |>
    tidyr::gather(Button, Anzahl, -Jahr) |> 
    mutate(Kategorie = case_when(
      Button == "Arbeitsstaetten" ~ "Total",
      Button == "AnzBesch" ~ "Total",
      Button == "AnzVZA" ~ "Total",
      Button == "AnzBeschW" ~ "weiblich",
      Button == "AnzVZAW" ~ "weiblich",
      Button == "AnzBeschM" ~ "männlich",
      Button == "AnzVZAM" ~ "männlich"
    )) |> 
    mutate(Button = case_when(
      Button == "Arbeitsstaetten" ~ "Arbeitsstätten",
      Button == "AnzBesch" ~ "Anzahl Beschäftigte",
      Button == "AnzVZA" ~ "Anzahl Vollzeitäquivalente",
      Button == "AnzBeschW" ~ "Anzahl Beschäftigte",
      Button == "AnzVZAW" ~ "Anzahl Vollzeitäquivalente",
      Button == "AnzBeschM" ~ "Anzahl Beschäftigte",
      Button == "AnzVZAM" ~ "Anzahl Vollzeitäquivalente"
    ))
    
  
  
}