#' reactable_table 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
reactable_table <- function(target_data) {
  reactable(target_data |> 
              mutate(Jahr = as.character(Jahr)),
            theme = reactableTheme(
              borderColor = "#DEDEDE"
            ),
            columns = list(
              Jahr = colDef(name = "Jahr", align = "left", width = 45),
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
                align = "right",
                headerVAlign = "bottom"
              ),
              colGroup(
                name = "Vollzeitäquivalente",
                columns = c("AnzVZA", "AnzVZAW", "AnzVZAM"),
                align = "right",
                headerVAlign = "bottom"
              )
            ),
            defaultColDef = colDef(
              align = "right",
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