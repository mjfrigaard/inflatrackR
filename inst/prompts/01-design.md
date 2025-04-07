## System prommpt 

You are an expert Shiny developer who loves explaining complex topics to non-technical audiences.

## User

I'd like to design an app package that allows users to track the cost of items they've purchased over time. They should be able to upload an image of a receipt and the application uses an LLM to convert the image into a data frame with the following columns: `date_purchased`, `item`, `quantity`, and `price`. 

I want this application to be part of an R package, so the functionality should be split into modules, with a separate UI and server function. I also want a standalone app function. 

## Response

# Creating a Receipt Tracker Package in R with Shiny

I'd be happy to design this receipt tracking app package! Let's break down how to structure this package to make it maintainable and user-friendly.

## Package Structure Overview

```
receiptracker/
├── R/
│   ├── app.R                 # Main app function
│   ├── mod_receipt_upload.R  # Receipt upload module
│   ├── mod_receipt_history.R # Receipt history/visualization module
│   ├── mod_data_table.R      # Data table display module
│   ├── process_receipt.R     # LLM processing logic
│   ├── data_management.R     # Functions for storing/retrieving data
│   └── utils.R               # Helper functions
├── inst/
│   └── extdata/              # Example receipts for testing
├── DESCRIPTION
├── NAMESPACE
└── README.md
```

## Key Components

Let's start by building the core functionality of your app:

### 1. The Receipt Upload Module

```r
# R/mod_receipt_upload.R

#' Receipt Upload Module UI
#'
#' @param id The module identifier
#' @return A shiny UI component
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
#' @return A module server function
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
```

### 2. Receipt Processing Function

```r
# R/process_receipt.R

#' Process Receipt Image with LLM
#'
#' Takes an image file path, uses OCR and an LLM to extract structured data
#'
#' @param file_path Path to the receipt image
#' @return A data frame with date_purchased, item, quantity, and price
#' @export
process_receipt_image <- function(file_path) {
  # This is where you would integrate with your LLM service
  # For example, using an API to a model like GPT-4 with vision capabilities
  
  # 1. Read the image
  img_data <- readBin(file_path, "raw", file.info(file_path)$size)
  
  # 2. Convert to base64 for API transmission
  img_b64 <- base64enc::base64encode(img_data)
  
  # 3. Call the LLM API (pseudo-code)
  response <- call_llm_api(
    image = img_b64,
    prompt = "Extract from this receipt the following information in a structured format: 
              date of purchase, item names, quantities, and prices. 
              Return the data as a CSV with columns: date_purchased, item, quantity, price."
  )
  
  # 4. Parse the response into a data frame
  result_df <- parse_llm_response(response)
  
  # 5. Clean and standardize the data
  result_df$date_purchased <- as.Date(result_df$date_purchased)
  result_df$quantity <- as.numeric(result_df$quantity)
  result_df$price <- as.numeric(result_df$price)
  
  return(result_df)
}

#' Call LLM API (Placeholder)
#'
#' @param image Base64-encoded image
#' @param prompt Instructions for the LLM
#' @return Raw API response
call_llm_api <- function(image, prompt) {
  # In a real implementation, this would connect to OpenAI, Anthropic, etc.
  # For example with httr2:
  
  # req <- request("https://api.openai.com/v1/chat/completions") %>%
  #   req_headers(
  #     "Content-Type" = "application/json",
  #     "Authorization" = paste("Bearer", Sys.getenv("OPENAI_API_KEY"))
  #   ) %>%
  #   req_body_json(list(
  #     model = "gpt-4-vision-preview",
  #     messages = list(
  #       list(
  #         role = "user",
  #         content = list(
  #           list(type = "text", text = prompt),
  #           list(type = "image_url", 
  #                image_url = list(
  #                  url = paste0("data:image/jpeg;base64,", image)
  #                ))
  #         )
  #       )
  #     ),
  #     max_tokens = 500
  #   )) %>%
  #   req_perform()
  # 
  # return(resp_body_json(req))
  
  # For demonstration purposes, return mock data
  return("2023-11-15,Milk,1,3.99\n2023-11-15,Bread,2,2.50\n2023-11-15,Eggs,12,4.99")
}

#' Parse LLM Response
#'
#' @param response Raw response from LLM
#' @return Data frame with structured receipt data
parse_llm_response <- function(response) {
  # In reality, you'd need to parse JSON from the API
  # For this example, we'll assume the response is CSV text
  
  df <- read.csv(text = response, header = FALSE, 
                 col.names = c("date_purchased", "item", "quantity", "price"))
  return(df)
}
```

### 3. Data Table Module

```r
# R/mod_data_table.R

#' Data Table Module UI
#'
#' @param id The module identifier
#' @return A shiny UI component
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
```

### 4. Receipt History/Visualization Module

```r
# R/mod_receipt_history.R

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
```

### 5. Data Management Functions

```r
# R/data_management.R

#' Save Receipt Data to Database
#'
#' @param data Data frame with receipt data
#' @param db_path Path to SQLite database file
#' @return Logical indicating success
#' @export
save_receipt_data <- function(data, db_path = get_default_db_path()) {
  con <- DBI::dbConnect(RSQLite::SQLite(), db_path)
  on.exit(DBI::dbDisconnect(con))
  
  # Create table if it doesn't exist
  if (!DBI::dbExistsTable(con, "receipts")) {
    DBI::dbCreateTable(con, "receipts", data)
  }
  
  # Write data to the database
  DBI::dbWriteTable(con, "receipts", data, append = TRUE)
  
  return(TRUE)
}

#' Load All Receipt Data
#'
#' @param db_path Path to SQLite database file
#' @return Data frame with all stored receipt data
#' @export
load_receipt_data <- function(db_path = get_default_db_path()) {
  if (!file.exists(db_path)) {
    return(data.frame(
      date_purchased = as.Date(character()),
      item = character(),
      quantity = numeric(),
      price = numeric()
    ))
  }
  
  con <- DBI::dbConnect(RSQLite::SQLite(), db_path)
  on.exit(DBI::dbDisconnect(con))
  
  if (DBI::dbExistsTable(con, "receipts")) {
    data <- DBI::dbReadTable(con, "receipts")
    data$date_purchased <- as.Date(data$date_purchased)
    return(data)
  } else {
    return(data.frame(
      date_purchased = as.Date(character()),
      item = character(),
      quantity = numeric(),
      price = numeric()
    ))
  }
}

#' Get Default Database Path
#'
#' @return Path to the default SQLite database
get_default_db_path <- function() {
  db_dir <- rappdirs::user_data_dir("receiptracker")
  if (!dir.exists(db_dir)) {
    dir.create(db_dir, recursive = TRUE)
  }
  return(file.path(db_dir, "receipts.sqlite"))
}
```

### 6. Main App Function

```r
# R/app.R

#' Launch Receipt Tracker App
#'
#' @param ... Additional parameters passed to shinyApp
#' @return A Shiny app object
#' @export
run_receipt_tracker <- function(...) {
  ui <- fluidPage(
    theme = bslib::bs_theme(version = 5, bootswatch = "flatly"),
    
    # Header
    titlePanel("Receipt Tracker"),
    
    # Main layout
    sidebarLayout(
      sidebarPanel(
        mod_receipt_upload_ui("upload")
      ),
      
      mainPanel(
        tabsetPanel(
          tabPanel("Current Receipt", 
                   mod_data_table_ui("current_receipt"),
                   br(),
                   actionButton("save_receipt", "Save to Database", 
                               icon = icon("save"), class = "btn-success")),
          tabPanel("History", 
                   mod_receipt_history_ui("receipt_history"))
        )
      )
    )
  )
  
  server <- function(input, output, session) {
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
  
  shinyApp(ui, server, ...)
}
```

## Package Dependencies

For the `DESCRIPTION` file, you'll need these dependencies:

```
Package: receiptracker
Title: Receipt Tracking and Price Monitoring
Version: 0.1.0
Authors@R: person("Your", "Name", email = "your.email@example.com", role = c("aut", "cre"))
Description: Track and analyze prices from receipts over time using image processing and LLM technology.
License: MIT + file LICENSE
Encoding: UTF-8
Roxygen: list(markdown = TRUE)
RoxygenNote: 7.2.3
Imports:
    shiny,
    bslib,
    DT,
    ggplot2,
    RSQLite,
    DBI,
    base64enc,
    httr2,
    rappdirs
Suggests:
    testthat,
    knitr,
    rmarkdown
```

## How This Design Works

1. **User Experience**: 
   - Users upload a receipt image
   - The LLM processes it into structured data
   - Data is displayed in a table (editable in case of errors)
   - Users can save the data to a local database
   - Historical price tracking charts show price trends

2. **Modularity**:
   - Each component is a separate module with clear inputs/outputs
   - Makes the code easier to maintain and test
   - Separates UI from server logic

3. **Data Flow**:
   - Receipt image → LLM processing → structured data frame
   - User can review/edit → save to database
   - Historical data loaded for visualization and analysis

4. **Persistence**:
   - SQLite database stores all receipt data
   - Uses user's app data directory for storage

This design is extensible - you could add additional modules for:

- Receipt search functionality

- Price alerts when items exceed historical averages

- Budget tracking and reporting

- Export to financial software

Would you like me to explain any specific part of this design in more detail?

