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
