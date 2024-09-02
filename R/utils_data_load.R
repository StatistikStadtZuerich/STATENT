#' get_params_data_load
#'
#' @description A utils function: the place where hardcoded things like links are set.
#' No other function should need modification with the addition of another year if the structure remains the same.
#'
#' @return a list with a vector of years, a vector of links to the candidate datasets, and a vector of links to the result datasets
#'
#' @noRd
get_params_data_load <- function() {
  # URLs for all the candidates
  urls_data <- c(
    "https://data.stadt-zuerich.ch/dataset/bfs_wir_statent_ast_beschaeftigte_vza_sektor_jahr_od2551/download/WIR255OD2551.csv",
    "https://data.stadt-zuerich.ch/dataset/bfs_wir_statent_ast_beschaeftigte_vza_rechtsform_betrgr_jahr_od2552/download/WIR255OD2552.csv"
  )


  return(urls_data)
}

#' data_download
#' @description Function to download the data from Open Data Zürich
#'
#' @param link URL to the csv
#'
#' @return tibble, downloaded from link
#' @noRd
data_download <- function(link) {
  data.table::fread(link, encoding = "UTF-8")
}

#' Prepare Data
#'
#' This utility function prepares and merges two datasets (`data_sector` and `data_size_legal`) by adding and modifying specific columns, ensuring consistency across the datasets. It then combines them into a single dataset and handles potential duplicates by retaining only the first occurrence of each unique combination of grouping variables.
#'
#' @param data_sector A data frame or tibble representing data segmented by sector.
#' @param data_size_legal A data frame or tibble representing data segmented by size and legal form.
#'
#' @return A merged and cleaned data frame (tibble) combining the sector and size/legal form datasets.
#'
#' @description A utility function that processes and merges two datasets, ensuring consistent column structure and handling duplicates.
#'
#' @noRd
prepare_data <- function(data_sector, data_size_legal) {
  data_sector_mutate <- data_sector |>
    mutate(
      RechtsformSort = 0,
      RechtsformLang = "Alle Rechtsformen",
      BetriebsgrSort = 0,
      BetriebsgrLang = "Alle Betriebsgrössen"
    ) |>
    select(
      all_of(c(
        "Jahr",
        "RaumSort",
        "RaumLang",
        "BrancheSort",
        "BrancheCd",
        "BrancheLang",
        "RechtsformSort",
        "RechtsformLang",
        "BetriebsgrSort",
        "BetriebsgrLang"
      )),
      everything()
    ) |> 
    filter(BrancheSort != 0)

  data_size_legal_mutate <- data_size_legal |>
    mutate(
      BrancheSort = 0,
      BrancheCd = "0",
      BrancheLang = "Alle Sektoren"
    ) |>
    select(
      all_of(c(
        "Jahr",
        "RaumSort",
        "RaumLang",
        "BrancheSort",
        "BrancheCd",
        "BrancheLang",
        "RechtsformSort",
        "RechtsformLang",
        "BetriebsgrSort",
        "BetriebsgrLang"
      )),
      everything()
    )
  
  data_merge <- bind_rows(data_sector_mutate, data_size_legal_mutate) |>
    mutate(across(
      all_of(c("AnzVZA", "AnzVZAW", "AnzVZAM")),
      as.numeric
    )) 
}
# test <- prepare_data(data_vector[[1]], data_vector[[2]])
