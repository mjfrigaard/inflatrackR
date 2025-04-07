## code to prepare `2025-01-10-costco-receipt-ic` dataset goes here
library(tibble)

costco_receipt_ic_2025_01_10 <- tibble::tibble(
  date_purchased = as.Date("2025-01-10"),
  product = c(
    "Clorox Disinfecting Wipes, Variety Pack, 85-count, 5-pack",
    "HUGG PU 4T5T",
    "Mission Carb Balance Flour Tortillas, 8-count, 2-pack",
    "HUGGIES SIZE 4",
    "Cholula, Hot Sauce Original, 12 fl oz, 2-Count",
    "Ajinomoto Yakitori Chicken Fried Rice, 9 oz, 6-count",
    "Cascade Advanced Power Liquid Dishwasher Detergent, Fresh Scent, 125 fl oz",
    "Skippy Peanut Butter, Creamy, 48 oz, 2-count",
    "Kirkland Signature Whey Protein, Creamy Chocolate, 5.4 lbs",
    "Foster Farms Take Out Crispy Chicken Wings, Classic Buffalo, 4 lbs"
  ),
  quantity = c(2, 1, 1, 1, 1, 1, 1, 1, 1, 1),
  price = c(38.90, 45.90, 6.55, 45.90, 10.92, 17.15, 12.01, 8.41, 54.65, 20.76)
)
usethis::use_data(costco_receipt_ic_2025_01_10, overwrite = TRUE)
