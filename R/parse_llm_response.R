#' Parse LLM Response
#'
#' @param response Raw response from LLM
#'
#' @return Data frame with structured receipt data
#'
#' @keywords internal
parse_llm_response <- function(response) {
  # In reality, you'd need to parse JSON from the API
  # For this example, we'll assume the response is CSV text

  df <- read.csv(text = response, header = FALSE,
                 col.names = c("date_purchased", "item", "quantity", "price"))
  return(df)
}
