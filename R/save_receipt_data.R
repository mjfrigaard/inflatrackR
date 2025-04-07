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
