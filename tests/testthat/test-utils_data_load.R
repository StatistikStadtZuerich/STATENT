test_that("test prepare data", {
  
  data_vector <- lapply(get_params_data_load(), data_download)
  
  # there should be no NAs in data_vector
  expect_true(sum(is.na(data_vector[[1]]$AnzVZA)) == 0)
  expect_true(sum(is.na(data_vector[[2]]$AnzVZA)) == 0)
  
  expect_snapshot_value(prepare_data(data_vector[[1]], data_vector[[2]]), style = "json2")
  
  prepared_data <- prepare_data(data_vector[[1]], data_vector[[2]])
  
  # check columns: 17
  expect_equal(
    ncol(prepared_data),
    17
  )
  
  # check data type
  expect_s3_class(
    prepared_data,
    "data.frame"
  )
  
})
