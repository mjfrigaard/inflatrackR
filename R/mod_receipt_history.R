#' Receipt History Module UI
#'
#' @param id The module identifier
#' @return A shiny UI component
#' @export
mod_receipt_history_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h3("Price History"),
    selectInput(ns("item_select"), "Select Item", choices = NULL),
    plotOutput(ns("price_history_plot")),
    h4("Total Spending by Month"),
    plotOutput(ns("monthly_spending_plot"))
  )
}

#' Receipt History Module Server
#'
#' @param id The module identifier
#' @param receipt_data Reactive containing receipt data
#' @param historical_data Reactive containing all historical receipt data
#' @return A module server function
#' @export
mod_receipt_history_server <- function(id, receipt_data, historical_data) {
  moduleServer(id, function(input, output, session) {

    # Update item selection dropdown when data changes
    observe({
      req(historical_data())
      items <- unique(historical_data()$item)
      updateSelectInput(session, "item_select", choices = items)
    })

    # Price history plot for the selected item
    output$price_history_plot <- renderPlot({
      req(historical_data(), input$item_select)

      # Filter data for the selected item
      item_data <- historical_data()[historical_data()$item == input$item_select, ]

      # Plot price over time
      ggplot(item_data, aes(x = date_purchased, y = price/quantity)) +
        geom_line() +
        geom_point() +
        labs(title = paste("Price History for", input$item_select),
             x = "Date",
             y = "Price per Unit ($)") +
        theme_minimal()
    })

    # Monthly spending plot
    output$monthly_spending_plot <- renderPlot({
      req(historical_data())

      # Create month column
      plot_data <- historical_data()
      plot_data$month <- format(plot_data$date_purchased, "%Y-%m")

      # Calculate total spending by month
      monthly_totals <- aggregate(
        price ~ month,
        data = plot_data,
        FUN = sum
      )

      # Sort by date
      monthly_totals <- monthly_totals[order(monthly_totals$month), ]

      # Plot
      ggplot(monthly_totals, aes(x = month, y = price)) +
        geom_col(fill = "steelblue") +
        labs(title = "Total Monthly Spending",
             x = "Month",
             y = "Total Amount ($)") +
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    })
  })
}
