#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  choices_inputs <- list(
    choices_area = unique(statent_data$RaumLang),
    choices_sector = unique(statent_data$BrancheLang),
    choices_size = unique(statent_data$BetriebsgrLang),
    choices_legal = unique(statent_data$RechtsformLang),
    choices_year = unique(statent_data$Jahr)
  )

  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    add_dependencies(fluidPage(
      sidebarPanel(
        mod_input_ui(
          id = "input_widgets",
          choices_inputs = choices_inputs
        ),
        conditionalPanel(
          condition = "input.query_start == 0",
          sszActionButton("query_start", "Abfrage starten")
        ),
        conditionalPanel(
          condition = "input.query_start",
          mod_download_ui("download")
        )
      ),
      mainPanel(
        conditionalPanel(
          condition = "input.query_start",
          mod_result_ui(id = "results")
        )
      )
    ))
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "statenttool"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
