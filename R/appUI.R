#' App UI
#'
#' @returns app front-end.
#'
#' @export
#'
appUI <- function() {
  bslib::page(
    title = "Receipt Tracker",
    theme = bslib::bs_theme(version = 5, bootswatch = "flatly"),

    # Layout with sidebar
    bslib::layout_sidebar(
      # Sidebar content
      sidebar = bslib::sidebar(
        width = 300,
        title = "Upload",
        mod_receipt_upload_ui("upload")
      ),

      # Main content with cards
      bslib::navset_card_tab(
        title = "Receipt Data",
        full_screen = TRUE,

        # Tab 1: Current Receipt
        bslib::nav_panel(
          title = "Current Receipt",
          bslib::card(
            mod_data_table_ui("current_receipt"),
            bslib::card_footer(
              bslib::tooltip(
                actionButton(
                  "save_receipt",
                  "Save to Database",
                  icon = icon("save"),
                  class = "btn-success"
                ),
                "Save this receipt to your database for historical tracking"
              )
            )
          )
        ),

        # Tab 2: History
        bslib::nav_panel(
          title = "History",
          bslib::card(
            mod_receipt_history_ui("receipt_history")
          )
        )
      )
    )
  )
}
