# User 

Convert this UI to use the bslib package for the layout functions: 

```r
#' App UI
#'
#' @returns app front-end.
#'
#' @export
#'
appUI <- function() {
  tagList(fluidPage(
    theme = bslib::bs_theme(version = 5, bootswatch = "flatly"),
    # Header
    titlePanel("Receipt Tracker"),
    # Main layout
    sidebarLayout(
      sidebarPanel(
        mod_receipt_upload_ui("upload")),
      mainPanel(tabsetPanel(
        tabPanel(
          "Current Receipt",
          mod_data_table_ui("current_receipt"),
          br(),
          actionButton(
            "save_receipt",
            "Save to Database",
            icon = icon("save"),
            class = "btn-success"
          )
        ),
        tabPanel("History",
          mod_receipt_history_ui("receipt_history"))
      ))
    )
  ))
}
```

## Assistant 

Here's the UI converted to use bslib's modern layout functions instead of the classic Shiny layout system:

```r
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
```

## Key Changes

1. **Page Container**: Replaced `fluidPage()` with `bslib::page()` which is the modern equivalent and handles theming more elegantly.

2. **Layout Structure**: 
   - Replaced `sidebarLayout()` with `bslib::layout_sidebar()`
   - Replaced `sidebarPanel()` with `bslib::sidebar()`
   - Added a width parameter and title to the sidebar

3. **Navigation & Cards**:
   - Replaced `tabsetPanel()` with `bslib::navset_card_tab()`
   - Replaced `tabPanel()` with `bslib::nav_panel()`
   - Wrapped content in `bslib::card()` for consistent styling
   - Used `card_footer()` for the action button area

4. **Enhanced Features**:
   - Added a tooltip to the save button
   - Added the `full_screen` option to the card tabs
   - Set a proper title for the card navigation container

This approach gives you a more modern, responsive interface with better spacing and styling. The bslib package provides these enhanced components that work well on different screen sizes and follow modern UI design principles.
