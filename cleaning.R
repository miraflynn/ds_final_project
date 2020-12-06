library(tidyverse)
library(lubridate)
library(dplyr)
url_states_current <- "https://covidtracking.com/api/states.csv"
url_states_historical <- "http://covidtracking.com/api/states/daily.csv"
filename_states_current <- "./data/states_current.csv"
filename_states_historical <- "./data/states_historical.csv"
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

curl::curl_download(
  url_states_current,
  destfile = filename_states_current
)
curl::curl_download(
  url_states_historical,
  destfile = filename_states_historical
)

df_states_current <- read_csv(filename_states_current)
df_states_historical <- read_csv(filename_states_historical)

filename_abbreviations <- "./data/states_with_abbrevs.csv"
df_abbreviations <- read_csv(filename_abbreviations)

df_states_historical <- df_states_historical %>%
  mutate(
    state_abbreviation = state,
    .after = date,
    .keep = "unused"
  ) %>%
  left_join(df_abbreviations) %>%
  mutate(
    state = state,
    .after = state_abbreviation
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
  ) 

# https://github.com/zdelrosario/tidy-exercises/blob/master/2020/2020-03-27-covid-tracking/proc.Rmd


filename_population <- "./data/ACSDT5Y2018.B01003_data_with_overlays_2020-10-22T174815.csv"

df_pop <- read_csv(filename_population, skip = 1) %>%
  select(
    population = `Estimate!!Total`,
    state
  )
df_states_historical <- df_states_historical %>%
  right_join(df_pop, by = "state") %>%
  relocate(
    state,
    population,
    .after = state_abbreviation
  )

remove(list = c(
  "df_abbreviations", 
  "df_pop", 
  "filename_abbreviations", 
  "filename_population",
  "filename_states_current",
  "filename_states_historical",
  "url_states_current",
  "url_states_historical"
  ))