#' Add Dependencies
#'
#' This utility function attaches the necessary JavaScript and CSS dependencies for D3 and sszvis to a Shiny tag object. This is useful for ensuring that the required libraries are available for custom visualizations in a Shiny application.
#'
#' @param tag A Shiny tag object (e.g., a UI element) to which the dependencies should be added.
#'
#' @return The Shiny tag object with the D3 and sszvis dependencies attached.
#'
#' @description A utility function that adds D3 and sszvis dependencies to a Shiny tag object.
#'
#' @noRd
add_dependencies <- function(tag) {
  d3 <- htmltools::htmlDependency(
    name = "d3",
    version = "5.16.0",
    src = c(href = "https://unpkg.com/d3@5/dist/"),
    script = "d3.min.js"
  )

  sszvis <- htmltools::htmlDependency(
    name = "sszvis",
    version = "2.1.1",
    src = c(href = "https://unpkg.com/sszvis@2/build/"),
    script = "sszvis.min.js",
    stylesheet = "sszvis.css"
  )

  tagList(d3, sszvis, tag)
}
