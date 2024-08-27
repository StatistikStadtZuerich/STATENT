#' Export Data to Excel
#'
#' This utility function exports a data table to an Excel file with custom formatting and additional sheets. It creates a title sheet, inserts images, applies styles, and adjusts column widths, providing a well-formatted Excel document ready for distribution.
#'
#' @param data_table A reactive expression or data frame containing the data to be exported to Excel.
#' @param file A string specifying the file path where the Excel file will be saved.
#' @param parameters A list of user-selected parameters from the Shiny application, used to customize titles and other content in the Excel file.
#'
#' @return The function does not return a value but writes an Excel file to the specified path.
#'
#' @description A utility function that exports data to an Excel file with multiple sheets, custom formatting, and additional content such as images and titles.
#'
#' @noRd
export_excel <- function(data_table, file, parameters) {
  # Data Paths
  hauptPfad <- "inst/app/www/Titelblatt.xlsx"
  imagePfad <- "inst/app/www/logo_stzh_stat_sw_pos_1.png"


  # Manipulate Data for the two queries
  title_num <- "Anzahl Arbeitsstätten, Beschäftigte und Vollzeitäquivalente: "

  inputs_num <- paste0(parameters$input_area(), ", ", parameters$input_sector(), ", ", parameters$input_size())


  data <- read_excel(hauptPfad, sheet = 1) |>
    mutate(Date = ifelse(is.na(.data[["Date"]]),
      NA,
      format(Sys.Date(), "%d.%m.%Y")
    ))

  data <- data |>
    mutate(Titel = ifelse(is.na(.data[["Titel"]]),
      NA,
      paste0(title_num, inputs_num)
    ))

  selected <- list(
    c(
      "T_1",
      title_num,
      inputs_num,
      " ",
      "Quelle: Statistik Stadt Zürich, Statistik der Unternehmenssturktur (STATENT)"
    )
  ) |>
    as.data.frame()

  definitions <- read_excel(hauptPfad, sheet = 2)

  # Styling
  sty <- createStyle(fgFill = "#ffffff")
  styConcept <- createStyle(
    textDecoration = c("bold"),
    valign = "top",
    wrapText = TRUE
  )
  styDefinition <- createStyle(
    valign = "top",
    wrapText = TRUE
  )
  styTitle <- createStyle(
    fontName = "Arial Black"
  )
  styNumeric <- createStyle(
    halign = "right"
  )

  # Create Workbook
  wb <- createWorkbook()

  # Add Sheets
  addWorksheet(wb, sheetName = "Inhalt", gridLines = FALSE)
  addWorksheet(wb, sheetName = "Erläuterungen", gridLines = TRUE)
  addWorksheet(wb, sheetName = "T_1", gridLines = TRUE)

  # Write Table Sheet 1
  writeData(wb,
    sheet = 1, x = data,
    colNames = FALSE, rowNames = FALSE,
    startCol = 2,
    startRow = 7,
    withFilter = FALSE
  )

  # Write Table Sheet 2
  writeData(wb,
    sheet = 2, x = definitions,
    colNames = FALSE, rowNames = FALSE,
    startCol = 1,
    startRow = 1,
    withFilter = FALSE
  )

  # Write Table Sheet 3
  writeData(wb,
    sheet = 3, x = selected,
    colNames = FALSE, rowNames = FALSE,
    startCol = 1,
    startRow = 1,
    withFilter = FALSE
  )
  writeData(wb,
    sheet = 3, x = data_table(),
    colNames = TRUE, rowNames = FALSE,
    startCol = 1,
    startRow = 9,
    withFilter = FALSE
  )

  # Insert Plot on Sheet 1
  insertImage(wb, imagePfad, sheet = 1, startRow = 2, startCol = 2, width = 1.75, height = 0.35)

  # Add Styling
  addStyle(wb, 1, style = sty, row = 1:19, cols = 1:6, gridExpand = TRUE)
  addStyle(wb, 1, style = styTitle, row = 14, cols = 2, gridExpand = TRUE)
  addStyle(wb, 2, style = styConcept, row = 1:20, cols = 1, gridExpand = TRUE)
  addStyle(wb, 2, style = styDefinition, row = 1:20, cols = 2, gridExpand = TRUE)
  addStyle(wb, 3, style = styConcept, row = 9, cols = 1:50, gridExpand = TRUE)

  # Numeric values: different columns in the two queries
  addStyle(wb, 3, style = styNumeric, rows = 10:50, cols = 4:10, gridExpand = TRUE)


  modifyBaseFont(wb, fontSize = 8, fontName = "Arial")

  # Set Column Width
  setColWidths(wb, sheet = 1, cols = "A", widths = 1)
  setColWidths(wb, sheet = 1, cols = "B", widths = 4)
  setColWidths(wb, sheet = 1, cols = "D", widths = 40)
  setColWidths(wb, sheet = 1, cols = "5", widths = 8)
  setColWidths(wb, sheet = 2, cols = "A", widths = 40)
  setColWidths(wb, sheet = 2, cols = "B", widths = 65)
  setColWidths(wb, sheet = 3, cols = "B", widths = 15)
  setColWidths(wb, sheet = 3, cols = "C", widths = 15)
  setColWidths(wb, sheet = 3, cols = "D", widths = 15)
  setColWidths(wb, sheet = 3, cols = "E", widths = 15)
  setColWidths(wb, sheet = 3, cols = "F", widths = 15)
  setColWidths(wb, sheet = 3, cols = "G", widths = 15)
  setColWidths(wb, sheet = 3, cols = "H", widths = 15)


  # Save Excel
  saveWorkbook(wb, file, overwrite = TRUE) ## save to working directory
}
