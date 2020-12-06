library(tidyverse)

raw_arabica <- read_csv("https://raw.githubusercontent.com/jldbc/coffee-quality-database/master/data/arabica_data_cleaned.csv") %>% 
  janitor::clean_names()

raw_robusta <- read_csv("https://raw.githubusercontent.com/jldbc/coffee-quality-database/master/data/robusta_data_cleaned.csv",
                        col_types = cols(
                          X1 = col_double(),
                          Species = col_character(),
                          Owner = col_character(),
                          Country.of.Origin = col_character(),
                          Farm.Name = col_character(),
                          Lot.Number = col_character(),
                          Mill = col_character(),
                          ICO.Number = col_character(),
                          Company = col_character(),
                          Altitude = col_character(),
                          Region = col_character(),
                          Producer = col_character(),
                          Number.of.Bags = col_double(),
                          Bag.Weight = col_character(),
                          In.Country.Partner = col_character(),
                          Harvest.Year = col_character(),
                          Grading.Date = col_character(),
                          Owner.1 = col_character(),
                          Variety = col_character(),
                          Processing.Method = col_character(),
                          Fragrance...Aroma = col_double(),
                          Flavor = col_double(),
                          Aftertaste = col_double(),
                          Salt...Acid = col_double(),
                          Balance = col_double(),
                          Uniform.Cup = col_double(),
                          Clean.Cup = col_double(),
                          Bitter...Sweet = col_double(),
                          Cupper.Points = col_double(),
                          Total.Cup.Points = col_double(),
                          Moisture = col_double(),
                          Category.One.Defects = col_double(),
                          Quakers = col_double(),
                          Color = col_character(),
                          Category.Two.Defects = col_double(),
                          Expiration = col_character(),
                          Certification.Body = col_character(),
                          Certification.Address = col_character(),
                          Certification.Contact = col_character(),
                          unit_of_measurement = col_character(),
                          altitude_low_meters = col_double(),
                          altitude_high_meters = col_double(),
                          altitude_mean_meters = col_double()
                        )) %>% 
  janitor::clean_names() %>% 
  rename(acidity = salt_acid, sweetness = bitter_sweet,
         aroma = fragrance_aroma, body = mouthfeel,uniformity = uniform_cup)


all_ratings <- bind_rows(raw_arabica, raw_robusta) %>% 
  select(-x1) %>% 
  select(total_cup_points, species, everything()) %>%
  # Cleans up Harvest Year
  mutate(
    harvest_year = harvest_year %>% gsub(pattern = ".*20", replacement = "20"),
    harvest_year = harvest_year %>% gsub(pattern = ".*/", replacement = "20"),
    harvest_year = harvest_year %>% substr(start = 1, stop = 4),
    harvest_year = harvest_year %>% as.integer()
  ) %>%
  #Fixes altitude readings
  mutate(
    altitude = ifelse(altitude == 190164, 
                      1901,
                      ifelse(altitude == 1901.64, 
                             1901, 
                             ifelse(altitude == "1100.00 mosl", 
                                    1100, 
                                    ifelse(altitude == "11000 metros", 
                                           1100, 
                                           altitude)))),
    altitude_mean_meters = ifelse(altitude_mean_meters >= 9000, altitude, altitude_mean_meters),
    altitude_mean_meters = as.double(altitude_mean_meters)
  ) %>% 
  #Fixes grading_date into date format
  mutate(
    grading_date = grading_date %>% gsub(pattern = "st,|nd,|rd,|th,", replacement = ""),
    grading_date = grading_date %>% as.Date(format = "%B %d %Y"),
  ) %>% 
  #Fixes expiration into date format
  mutate(
    expiration = expiration %>% gsub(pattern = "st,|nd,|rd,|th,", replacement = ""),
    expiration = expiration %>% as.Date(format = "%B %d %Y")
  )

all_ratings %>% 
  skimr::skim()



# all_ratings %>% 
#   write_csv("2020/2020-07-07/coffee_ratings.csv")