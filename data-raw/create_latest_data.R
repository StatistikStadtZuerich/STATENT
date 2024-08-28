# script to get the latest data from ogd and save it locally
# run locally, and will be run also in the deployment pipeline
#
# when running locally: load all as well
pkgload::load_all(helpers = FALSE, attach_testthat = FALSE)

# get and prepare data
data_vector <- lapply(get_params_data_load(), data_download)
statent_data <- prepare_data(data_vector[[1]], data_vector[[2]])
usethis::use_data(statent_data,
                  overwrite = TRUE,
                  internal = TRUE
)
