test_that("check filter function", {
  
  my_inputs <- list(
    "select_area" = "Ganze Stadt",
    "select_sector" = "Alle Sektoren",
    "select_size" = "Alle Betriebsgrössen",
    "select_legal" = "Alle Rechtsformen",
    "select_year" = c(2011, 2021)
  )

  
  # check columns: 8
  expect_equal(
    ncol(filter_table_data(statent_data, my_inputs)),
    8
  )
  
  # check column names
  expect_named(filter_table_data(statent_data, my_inputs), 
               c("Jahr",
                 "Arbeitsstaetten", 
                 "AnzBesch","AnzBeschW",
                 "AnzBeschM", 
                 "AnzVZA" , 
                 "AnzVZAW",
                 "AnzVZAM"))
  
  #test specific row
  row_to_be_selected <- 5
  year_to_be_selected <- filter_table_data(statent_data, my_inputs) |>
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
  
  # expect different df if input is changed
  different_inputs <- list(
    "select_area" = "Rathaus",
    "select_sector" = "Alle Sektoren",
    "select_size" = "Alle Betriebsgrössen",
    "select_legal" = "Alle Rechtsformen",
    "select_year" = c(2011, 2021)
  )
  
  expect_failure(expect_equal(
    filter_table_data(statent_data, my_inputs), 
    filter_table_data(statent_data, different_inputs)))
 
  
})
