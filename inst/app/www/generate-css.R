library(sass)
sass(
  sass_file("inst/app/www/statent_list.sass"),
  "inst/app/www/statent-custom.css",
  options = sass_options(
    source_map_embed = TRUE
  )
)
