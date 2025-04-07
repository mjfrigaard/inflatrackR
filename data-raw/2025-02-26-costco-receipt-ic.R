## code to prepare `2025-02-26-costco-receipt-ic` dataset goes here

library(tibble)

costco_receipt_ic_2025_02_26 <- tibble::tibble(
  date_purchased = as.Date("2025-02-26"),
  product = c(
    "Clorox Disinfecting Wipes, Variety Pack, 85-count, 5-pack",
    "Ruprecht's Irish Beef Stew",
    "Celsius Sparkling Energy Drink, Variety Pack, 12 fl oz, 18-count",
    "KS ORG A2 PR",
    "Kirkland Signature Daily Makeup Remover Towelettes, 180-count",
    "Kirkland Signature Rotisserie Chicken",
    "Kirkland Signature Sparkling Water, Variety Pack, 12 fl oz, 35-count"
  ),
  quantity = c(1, 1, 1, 1, 1, 1, 1),
  price = c(19.45, 23.07, 26.12, 14.97, 15.29, 5.46, 12.56)
)

usethis::use_data(costco_receipt_ic_2025_02_26, overwrite = TRUE)
