#' Launch Receipt Tracker App
#'
#' @param ... Additional parameters passed to shinyApp
#'
#' @return A Shiny app object
#'
#' @import shiny
#'
#' @export
launch_app <- function() {
  shinyApp(
    ui = appUI(),
    server = appServer
  )
}
