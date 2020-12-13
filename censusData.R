library(tidyverse)
library(tidycensus)

race <- c(White = "B03002_003", Black = "B03002_004", 
          AIAN = "B03002_005", Asian = "B03002_006", 
          NHPI = "B03002_007", Other = "B03002_008",
          Multiracial = "B03002_009", LatinX = "B03002_012")

race_pop <- get_acs(
  geography = "state",
  variables = race,
  year = 2018,
  survey = "acs5",
  geometry = FALSE, 
  cache_table = TRUE
  ) %>%
  select(-GEOID, -moe)

saveRDS(race_pop, file = "data/racial_pop_with_hispanic.Rds")
