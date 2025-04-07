## code to prepare `costco_receipt_ic_2025_03_26` dataset goes here
library(tibble)

costco_receipt_ic_2025_03_26 <- tibble::tibble(
  date_purchased = as.Date("2025-03-26"),
  product = c(
    "Clorox Disinfecting Wipes, Variety Pack, 85-count, 5-pack",
    "Celsius Sparkling Energy Drink, Variety Pack, 12 fl oz, 18-count",
    "HUGG PU 4T5T",
    "Mission Carb Balance Flour Tortillas, 8-count, 2-pack",
    "That's it Mini Fruit Bars, 24-count",
    "Yummy Dino Buddies Dinosaur Chicken Breast Nuggets, 5 lbs",
    "KS ORG A2 PR",
    "BURRITO BOWL",
    "Kirkland Signature, Chicken Breast, 12.5 oz, 6-Count",
    "Skippy Peanut Butter, Creamy, 48 oz, 2-count",
    "Kirkland Signature Sparkling Water, Variety Pack, 12 fl oz, 35-count",
    "Kirkland Signature Chicken Tortilla Soup, 32 oz, 2-count"
  ),
  quantity = c(2, rep(1, 11)),
  price = c(30.58, 26.12, 41.99, 7.64, 15.29, 16.06, 12.39, 11.99, 13.11, 12.01, 12.56, 10.37)
)

usethis::use_data(costco_receipt_ic_2025_03_26, overwrite = TRUE)
