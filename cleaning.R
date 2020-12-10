library(tidyverse)
library(lubridate)
library(dplyr)

# https://github.com/zdelrosario/tidy-exercises/blob/master/2020/2020-03-27-covid-tracking/proc.Rmd


url_states_current <- "https://covidtracking.com/api/states.csv"
url_states_historical <- "http://covidtracking.com/api/states/daily.csv"
url_states_racial <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vS8SzaERcKJOD_EzrtCDK1dX1zkoMochlA9iHoHg_RSw3V8bkpfk1mpw4pfL5RdtSOyx_oScsUtyXyk/pub?gid=43720681&single=true&output=csv"
filename_states_current <- "./data/states_current.csv"
filename_states_historical <- "./data/states_historical.csv"
filename_states_racial <- "./data/states_racial.csv"
# I typed this up so we wouldn't have a giant vector in this file
filename_abbreviations <- "./data/states_with_abbrevs.csv"
# From C06
filename_population <- "./data/ACSDT5Y2018.B01003_data_with_overlays_2020-10-22T174815.csv"
filename_pop_racial <- "./data/ACSDT5Y2018.B02001_data_with_overlays_2020-12-08T035125.csv"
theme_common <- function() {
  theme_minimal() %+replace%
    theme(
      axis.text.x = element_text(size = 12),
      axis.text.y = element_text(size = 12),
      axis.title.x = element_text(margin = margin(4, 4, 4, 4), size = 16),
      axis.title.y = element_text(margin = margin(4, 4, 4, 4), size = 16, angle = 90),
      legend.title = element_text(size = 16),
      legend.text = element_text(size = 12),
      strip.text.x = element_text(size = 12),
      strip.text.y = element_text(size = 12),
      panel.grid.major = element_line(color = "grey90"),
      panel.grid.minor = element_line(color = "grey90"),
      aspect.ratio = 4 / 4,
      plot.margin = unit(c(t = +0, b = +0, r = +0, l = +0), "cm"),
      plot.title = element_text(size = 18),
      plot.title.position = "plot",
      plot.subtitle = element_text(size = 16),
      plot.caption = element_text(size = 12)
    )
}

# curl::curl_download(
#   url_states_current,
#   destfile = filename_states_current
# )
# curl::curl_download(
#   url_states_historical,
#   destfile = filename_states_historical
# )
# curl::curl_download(
#   url_states_racial,
#   destfile = filename_states_racial
# )


df_states_current <- read_csv(filename_states_current)
df_states_historical <- read_csv(filename_states_historical)
df_abbreviations <- read_csv(filename_abbreviations)
df_pop <- read_csv(filename_population, skip = 1) %>%
  # Selecting because we don't need the error estimate and FIPS code
  select(
    population = `Estimate!!Total`,
    state
  )
    
df_states_racial <- read_csv(filename_states_racial) %>%
  pivot_longer(
    names_to = c(".value","race"),
    names_sep = "_",
    cols = c(-"Date",-"State")
  )


df_pop_racial <- read_csv(filename_pop_racial, skip = 1,col_types = cols(.default = col_character())) %>%
  pivot_longer(
    names_to = c(".value","x1", "category","division"),
    names_sep = "!!",
    cols = c(-"id",-"Geographic Area Name")
    ) %>%
  select(-id, -x1) %>%
  rename(
    state = "Geographic Area Name",
    race_estimate = "Estimate",
    race_moe = "Margin of Error"
    ) %>%
  mutate(
    race_estimate = as.double(race_estimate),
    race_moe = as.double(race_moe)
    ) %>%
  filter(is.na(division)) %>%
  select(-division) %>%
  filter(!is.na(category)) %>%
  mutate(
    category = if_else(category == "White alone", "White", category),
    category = if_else(category == "Black or African American alone", "Black", category),
    category = if_else(category == "American Indian and Alaska Native alone", "AIAN", category),
    category = if_else(category == "Asian alone", "Asian", category),
    category = if_else(category == "Native Hawaiian and Other Pacific Islander alone", "NHPI", category),
    category = if_else(category == "Two or more races", "Multiracial", category),
    category = if_else(category == "Some other race alone", "Other", category),
  )



df_states_historical <- df_states_historical %>%
  # Change state to state_abbreviation, put it at the front, and don't keep the state value
  mutate( 
    state_abbreviation = state,
    .after = date,
    .keep = "unused"
  ) %>%
  # Join in the state names from df_abbreviations
  left_join(df_abbreviations) %>%
  # Organize columns- not necessary, but nice
  relocate(
    state,
    .after = state_abbreviation
  ) %>%
  # Add in population data
  right_join(df_pop, by = "state") %>%
  # Organize columns- not necessary, but nice
  relocate(
    state,
    population,
    .after = state_abbreviation
  ) %>%
  mutate(
    date = date %>% as.character() %>% as.Date(format="%Y%m%d")
  )

df_states_racial_comb <-
  df_states_racial %>%
  filter(race != "Total") %>%
  left_join(df_abbreviations, by = c("State" = "state_abbreviation")) %>%
  left_join(df_pop_racial) %>%
  filter(race == category) %>%
  select(-category) %>%
  select(Date, State, state, race, everything()) %>%
  rename(
    date = "Date",
    state_abrv = "State",
    cases = "Cases",
    deaths = "Deaths",
    hosp = "Hosp",
    tests = "Tests"
  ) %>%
  mutate(
    cases_per_100k = cases/race_estimate *100000,
    deaths_per_100k = deaths/race_estimate *100000,
    hosp_per_100k = hosp/race_estimate *100000,
    tests_per_100k = tests/race_estimate *100000
  ) %>%
  # Add statewide population to the state racial data
  right_join(df_pop, by = "state") %>%
  relocate(
    state,
    population,
    .after = state_abrv
  ) %>%
  #Cast the date integer to a date object
  mutate(
    date = date %>% as.character() %>% as.Date(format="%Y%m%d")
  )

df_usa <-
  df_states_historical %>%
  mutate(
    date = ymd(date)
  ) %>%
  group_by(date) %>%
  summarize_at(
    c("positive", "totalTestResults", "death", "positiveIncrease", "totalTestResultsIncrease", "deathIncrease"),
    ~sum(., na.rm = TRUE)
  ) %>%
  # Add in US total population
  mutate(
    population = df_pop %>%
      filter(state == "United States") %>%
      pull(population)
  )


# Get rid of working variables for cleanliness when this file is used as a source
remove(list = c(
  "df_abbreviations",
  "df_pop",
  "df_pop_racial", 
  "df_states_racial",
  "filename_abbreviations",
  "filename_pop_racial",
  "filename_population",
  "filename_states_current",
  "filename_states_historical",
  "filename_states_racial",
  "url_states_current",
  "url_states_historical",
  "url_states_racial"
  ))