#' Filter Data Table
#'
#' This utility function filters a data table based on user input values. The function applies a series of filtering conditions to the data, including geographic area, sector, company size, legal form, and a range of years.
#'
#' @param data_table A data frame or tibble containing the data to be filtered.
#' @param input_values A list of input values typically from a Shiny application. This list should include elements such as `select_area`, `select_sector`, `select_size`, `select_legal`, and `select_year`.
#'
#' @return A filtered data table (tibble) with unnecessary columns removed and duplicate rows eliminated.
#'
#' @description A utility function that filters a data table based on specified criteria, such as area, sector, size, legal form, and year range.
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

#' Filter Data for Download
#'
#' This utility function filters and formats a data table for downloading. It applies the same filtering criteria as `filter_table_data` and then formats specific columns, handling missing values and renaming columns for clarity in the downloaded file.
#'
#' @param data_table A data frame or tibble containing the data to be filtered and formatted for download.
#' @param input_values A list of input values typically from a Shiny application. This list should include elements such as `select_area`, `select_sector`, `select_size`, `select_legal`, and `select_year`.
#'
#' @return A filtered and formatted data table (tibble) ready for download.
#'
#' @description A utility function that filters and prepares data for download, including formatting numeric columns with missing values and renaming columns for better readability.
#'
#' @noRd
filter_download_data <- function(data_table, input_values) {

  filter_table_data(data_table, input_values) |>
    mutate(AnzVZA = case_when(
      is.na(.data[["AnzVZA"]]) ~ "( )",
      TRUE ~ as.character(.data[["AnzVZA"]])
    )) |> 
    mutate(AnzVZAW = case_when(
      is.na(.data[["AnzVZAW"]]) ~ "( )",
      TRUE ~ as.character(.data[["AnzVZAW"]])
    )) |> 
    mutate(AnzVZAM = case_when(
      is.na(.data[["AnzVZAM"]]) ~ "( )",
      TRUE ~ as.character(.data[["AnzVZAM"]])
    )) |> 
    rename("Arbeitsstätten" = "Arbeitsstaetten",
           "Anzahl Beschäftigte" = "AnzBesch",
           "Anzahl Beschäftigte (weiblich)" = "AnzBeschW",
           "Anzahl Beschäftigte (männlich)" = "AnzBeschM",
           "Anzahl Vollzeitäqui- valente" = "AnzVZA",
           "Anzahl Vollzeitäqui- valente (weiblich)" = "AnzVZAW",
           "Anzahl Vollzeitäqui- valente (männlich)" = "AnzVZAM"
             ) 
}

#' Filter Data for Charting
#'
#' This utility function filters and formats a data table for use in charting. It prepares the data by gathering relevant columns and categorizing them, making it suitable for visualizations such as bar charts or line charts.
#'
#' @param data_table A data frame or tibble containing the data to be filtered and formatted for charting.
#' @param input_values A list of input values typically from a Shiny application. This list should include elements such as `select_area`, `select_sector`, `select_size`, `select_legal`, and `select_year`.
#'
#' @return A formatted data table (tibble) ready to be used for creating charts, with columns gathered and categorized appropriately.
#'
#' @description A utility function that filters and processes data for charting purposes. It gathers data columns and categorizes them to prepare for visualization.
#'
#' @noRd
filter_chart_data <- function(data_table, input_values) {
  
  data <- filter_table_data(data_table, input_values)

  data |>
    tidyr::gather(Button, Anzahl, -Jahr) |> 
    mutate(Kategorie = case_when(
      .data[["Button"]] == "Arbeitsstaetten" ~ "Total",
      .data[["Button"]] == "AnzBesch" ~ "Total",
      .data[["Button"]] == "AnzVZA" ~ "Total",
      .data[["Button"]] == "AnzBeschW" ~ "weiblich",
      .data[["Button"]] == "AnzVZAW" ~ "weiblich",
      .data[["Button"]] == "AnzBeschM" ~ "männlich",
      .data[["Button"]] == "AnzVZAM" ~ "männlich"
    )) |> 
    mutate(Button = case_when(
      .data[["Button"]] == "Arbeitsstaetten" ~ "Arbeitsstätten",
      .data[["Button"]] == "AnzBesch" ~ "Anzahl Beschäftigte",
      .data[["Button"]] == "AnzVZA" ~ "Anzahl Vollzeitäquivalente",
      .data[["Button"]] == "AnzBeschW" ~ "Anzahl Beschäftigte",
      .data[["Button"]] == "AnzVZAW" ~ "Anzahl Vollzeitäquivalente",
      .data[["Button"]] == "AnzBeschM" ~ "Anzahl Beschäftigte",
      .data[["Button"]] == "AnzVZAM" ~ "Anzahl Vollzeitäquivalente"
    ))
}