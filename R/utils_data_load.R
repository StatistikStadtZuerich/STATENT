#' data_load 
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
read_data <- function() {
  OD2551 <- read_csv("./temp_data/WIR255OD2551.csv")
  OD2552 <- read_csv("./temp_data/WIR255OD2552.csv")
  
  list(OD2551 = OD2551, OD2552 = OD2552)
}

#' prepare_data 
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
prepare_data <- function(data_sector, data_size_legal) {
  data_sector_mutate <- data_sector |> 
    mutate(RechtsformSort = 0,
           RechtsformLang = "Alle Rechtsformen",
           BetriebsgrSort = 0,
           BetriebsgrLang = "Alle Betriebsgrössen") |> 
    select(all_of(c("Jahr",
                    "RaumSort",
                    "RaumLang",
                    "BrancheSort",
                    "BrancheCd",
                    "BrancheLang",
                    "RechtsformSort",
                    "RechtsformLang",
                    "BetriebsgrSort",
                    "BetriebsgrLang")),
                  everything()) 
  
  data_size_legal_mutate <- data_size_legal |> 
    mutate(BrancheSort = 0,
           BrancheCd = "0",
           BrancheLang = "Alle Sektoren") |> 
    select(all_of(c("Jahr",
                    "RaumSort",
                    "RaumLang",
                    "BrancheSort",
                    "BrancheCd",
                    "BrancheLang",
                    "RechtsformSort",
                    "RechtsformLang",
                    "BetriebsgrSort",
                    "BetriebsgrLang")),
           everything()) 
  
  data_merge <- bind_rows(data_sector_mutate, data_size_legal_mutate) |> 
    mutate(across(
      all_of(c("AnzVZA", "AnzVZAW", "AnzVZAM")),
      as.numeric
    )) |> 
    # certain values appear double since they are in both OGD datasets
    # cannot use distinct since value may differ slightly due to rounding
    group_by(across(c("Jahr",
                      "RaumSort",
                      "RaumLang",
                      "BrancheSort",
                      "BrancheCd",
                      "BrancheLang",
                      "RechtsformSort",
                      "RechtsformLang",
                      "BetriebsgrSort",
                      "BetriebsgrLang"))) |> 
    slice_head(n = 1) |> 
    ungroup()
}
# test <- prepare_data(data_vector[[1]], data_vector[[2]])

