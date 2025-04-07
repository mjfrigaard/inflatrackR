#' Data Table Module UI
#'
#' @param id The module identifier
#'
#' @return A shiny UI component
#'
#' @export
mod_data_table_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h3("Receipt Items"),
    DT::DTOutput(ns("receipt_table")),
    downloadButton(ns("download_csv"), "Download as CSV")
  )
}

#' Data Table Module Server
#'
#' @param id The module identifier
#' @param receipt_data Reactive containing receipt data
#' @return A module server function
#' @export
mod_data_table_server <- function(id, receipt_data) {
  moduleServer(id, function(input, output, session) {

    # Render the data table
    output$receipt_table <- DT::renderDT({
      req(receipt_data())
      DT::datatable(
        receipt_data(),
        options = list(pageLength = 10),
        editable = TRUE,
        rownames = FALSE
      ) %>%
        DT::formatCurrency(columns = "price", currency = "$") %>%
        DT::formatDate(columns = "date_purchased", method = "toLocaleDateString")
    })

    # Download handler for CSV export
    output$download_csv <- downloadHandler(
      filename = function() {
        paste("receipt-data-", Sys.Date(), ".csv", sep = "")
      },
      content = function(file) {
        write.csv(receipt_data(), file, row.names = FALSE)
      }
    )
  })
}
