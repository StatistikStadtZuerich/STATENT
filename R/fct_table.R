#' Create a Reactable Table
#'
#' This function creates a styled reactable table for displaying tabular data in a Shiny application. The table includes custom column names, grouped columns, pagination, and language settings tailored for a German-speaking audience.
#'
#' @param target_data A data frame or tibble that contains the data to be displayed in the table.
#'
#' @return A reactable table object that can be rendered in a Shiny UI.
#'
#' @description A helper function to generate a reactable table with specific formatting and customization, such as grouped columns and language settings.
#'
#' @noRd
reactable_table <- function(target_data) {
  reactable(
    target_data |>
      mutate(Jahr = as.character(Jahr)),
    paginationType = "simple",
    language = reactableLang(
      noData = "Keine Einträge gefunden",
      pageNumbers = "{page} von {pages}",
      pageInfo = "{rowStart} bis {rowEnd} von {rows} Einträgen",
      pagePrevious = "\u276e",
      pageNext = "\u276f",
      pagePreviousLabel = "Vorherige Seite",
      pageNextLabel = "Nächste Seite"
    ),
    theme = reactableTheme(
      borderColor = "#DEDEDE"
    ),
    columns = list(
      Jahr = colDef(name = "Jahr", align = "left"),
      Arbeitsstaetten = colDef(name = "Arbeits-\nstätten"),
      AnzBesch = colDef(name = "Total"),
      AnzBeschW = colDef(name = "Frauen"),
      AnzBeschM = colDef(name = "Männer"),
      AnzVZA = colDef(name = "Total"),
      AnzVZAW = colDef(name = "Frauen"),
      AnzVZAM = colDef(name = "Männer")
    ),
    columnGroups = list(
      colGroup(
        name = "Beschäftigte",
        columns = c("AnzBesch", "AnzBeschW", "AnzBeschM"),
        align = "left",
        headerVAlign = "bottom"
      ),
      colGroup(
        name = "Vollzeitäquivalente",
        columns = c("AnzVZA", "AnzVZAW", "AnzVZAM"),
        align = "left",
        headerVAlign = "bottom"
      )
    ),
    defaultColDef = colDef(
      align = "left",
      headerVAlign = "bottom",
      minWidth = 50,
      cell = function(value) {
        # Format only numeric columns with thousands separators
        if (!is.numeric(value)) {
          return(value)
        } else if (!is.na(value)) {
          format(value, big.mark = "\ua0")
        } else {
          "( )"
        }
      }
    ),
    outlined = TRUE,
    highlight = TRUE,
    defaultPageSize = 10,
    rowClass = JS("function(rowInfo) {return rowInfo.selected ? 'selected' : ''}"),
    rowStyle = JS("function(rowInfo) {if (rowInfo.selected) { return { backgroundColor: '#F2F2F2'}}}")
  )
}
