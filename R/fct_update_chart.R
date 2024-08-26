#' Update Chart
#'
#' Sends data as JSON in a custom message, which can be received by JavaScript and used to update an sszvis chart. This function requires an appropriate message handler in the JavaScript code specific to each chart type.
#'
#' @param data A tibble containing the data to be sent to the chart.
#' @param type A string specifying which message handler or chart will receive the data.
#' @param session The Shiny session object used to send the custom message.
#'
#' @return na
update_chart <- function(data, type, session) {
  # print(glue::glue("sending message {data}"))
  session$sendCustomMessage(
    type = type,
    message = jsonlite::toJSON(data)
  )
}