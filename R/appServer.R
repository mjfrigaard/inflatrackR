#' App Server
#'
#' @param input shiny parameter
#' @param output shiny parameter
#' @param session shiny parameter
#'
#' @returns app logic
#'
#' @export
#'
appServer <- function(input, output, session) {
    # Reactive values

  current_receipt <- reactiveVal(NULL)
    all_receipts <- reactiveVal(load_receipt_data())

    # Initialize modules
    mod_receipt_upload_server("upload", current_receipt)

    mod_data_table_server("current_receipt", current_receipt)

    mod_receipt_history_server("receipt_history", current_receipt, all_receipts)

    # Handle saving receipt to database
    observeEvent(input$save_receipt, {
      req(current_receipt())

      # Save to database
      if (save_receipt_data(current_receipt())) {
        showNotification("Receipt saved successfully!", type = "success")

        # Refresh the historical data
        all_receipts(load_receipt_data())
      } else {
        showNotification("Error saving receipt", type = "error")
      }
  })

}
