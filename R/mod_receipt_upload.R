# R/mod_receipt_upload.R

#' Receipt Upload Module UI
#'
#' @param id The module identifier
#'
#' @return A shiny UI component
#'
#' @export
mod_receipt_upload_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h3("Upload Receipt"),
    fileInput(ns("receipt_image"), "Select receipt image",
              accept = c("image/png", "image/jpeg", "image/jpg")),
    actionButton(ns("process_btn"), "Process Receipt",
                 icon = icon("cogs"),
                 class = "btn-primary"),
    uiOutput(ns("upload_status"))
  )
}

#' Receipt Upload Module Server
#'
#' @param id The module identifier
#' @param receipt_data Reactive to store processed receipt data
#'
#' @return A module server function
#'
#' @export
mod_receipt_upload_server <- function(id, receipt_data) {
  moduleServer(id, function(input, output, session) {

    # Status message output
    output$upload_status <- renderUI({
      NULL
    })

    # Process receipt when button is clicked
    observeEvent(input$process_btn, {
      req(input$receipt_image)

      output$upload_status <- renderUI({
        div(class = "alert alert-info",
            icon("spinner"), "Processing receipt...", role = "alert")
      })

      # Get file path
      file_path <- input$receipt_image$datapath

      # Process the receipt with LLM
      tryCatch({
        result <- process_receipt_image(file_path)

        # Update the reactive receipt data
        receipt_data(result)

        output$upload_status <- renderUI({
          div(class = "alert alert-success",
              icon("check"), "Receipt processed successfully!", role = "alert")
        })
      }, error = function(e) {
        output$upload_status <- renderUI({
          div(class = "alert alert-danger",
              icon("exclamation-triangle"), "Error processing receipt: ", e$message, role = "alert")
        })
      })
    })
  })
}
