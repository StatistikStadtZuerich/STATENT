test_that("check filter function", {
  
  my_inputs <- list(
    "select_area" = "Ganze Stadt",
    "select_sector" = "Alle Sektoren",
    "select_size" = "Alle Betriebsgrössen",
    "select_legal" = "Alle Rechtsformen",
    "select_year" = c(2011, 2021)
  )
  
  filtered_data <- filter_table_data(statent_data, my_inputs)
  
  # check columns: 8
  expect_equal(
    ncol(filtered_data),
    8
  )
  # check rows: only 11 (since 11 years)
  expect_equal(
    nrow(filtered_data),
    11
  )
  
  #test specific row
  row_to_be_selected <- 5
  year_to_be_selected <- filtered_data |>
    slice(row_to_be_selected) |>
    pull(Jahr)
  
  expect_equal(
    year_to_be_selected,
    2015
  )
  
  # check data type
  expect_s3_class(
    filter_table_data(statent_data, my_inputs),
    "data.frame"
  )
  
})
