library(tibble)

costco_receipt_2025_04_04 <- receipt_df_store_apr4 <- tibble::tibble(
  date_purchased = as.Date("2025-04-04"),
  product = c(
    "**KS TOWEL**",
    "HUGG PU 4T5T",
    "HUGGIES SIZE 4",
    "**KS BATH**",
    "KS ORG EGGS",
    "SCOOP AWAY",
    "KS STIR FRY",
    "KS ORG A2 PR",
    "CHK FLORENT",
    "BURRITO BOWL",
    "CASCADE GEL",
    "PALMOLIVE",
    "VITALPROTEIN"
  ),
  quantity = c(
    1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1, 1
  ),
  price = c(
    19.89,
    41.99,
    49.99,
    20.99,
    8.79,
    16.49,
    9.69,
    12.39,
    13.99,
    11.99,
    10.99,
    8.99,
    29.99
  )
)


usethis::use_data(costco_receipt_2025_04_04, overwrite = TRUE)
