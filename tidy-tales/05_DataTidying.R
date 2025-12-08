# ==============================================================================
#                   R for Data Science (2e) - 5. Data tidying
# ==============================================================================
# Author: Érica
# Purpose: Studying Chapter 5 of R for Data Science (2nd edition)
# Reference: Wickham, H., C etinkaya-Rundel, M., & Grolemund, G. (2023).
# R for Data Science (2nd ed.).
# https://r4ds.hadley.nz/data-tidy.html
# Notes: Personal study notes and exercise solutions
# Date: 2025.11.11-18
# ==============================================================================

# ----------------------------- ENVIRONMENT SETUP ------------------------------

rm(list = ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

options(encoding = "UTF-8")
options(scipen = 999)
rstudioapi::writeRStudioPreference("data_viewer_max_columns", 1000L)

library(tidyverse)
library(nycflights13)
library(styler)

centralizado <- function(title, width = 78, border = "-", uppercase = FALSE) {
  if (uppercase) title <- toupper(title)
  label <- paste0(" ", title, " ")
  pad_total <- width - nchar(label, type = "width")
  pad_left <- floor(pad_total / 2)
  pad_right <- ceiling(pad_total / 2)
  line <- paste0("# ", strrep(border, pad_left), label, strrep(border, pad_right))
  cat(line, "\n")
}

# ---------------------------- 5.1.1 Prerequisites -----------------------------

library(tidyverse)

# ------------------------------- 5.2 TIDY DATA --------------------------------

# Finally learned what are those table1, table2 that appear in autocomplete when
# I'm working in a table.
table1 # tidy dataframe
table2 # messy dataframe
table3 # the messiest of all

# Computing rate per 10,000 people per year and country.
table1 |>
  mutate(rate = cases / population * 10000)

# Computing total cases per year
table1 |>
  group_by(year) |>
  summarise(total_cases = sum(cases))

# Plotting changes over time
ggplot(table1, aes(x = year, y = cases)) +
  geom_line(aes(group = country), color = "grey50") +
  geom_point(aes(color = country, shape = country)) +
  scale_x_continuous(breaks = c(1999, 2000)) # without it we'll have 1999.50 and so on.

# ------------------------------ 5.2.1 Exercises -------------------------------

# 1. ---------------------------------------------------------------------------
# For each of the sample tables, describe what each observation and each column
# represents.

# table1: each row shows a snapshot of a country in a given year, including its
# population and number of TB cases. Columns are: country, year, cases,
# population.

# table2: each row contains either the number of TB cases or the population for
# a country in a given year. Columns are: country, year, type, count.

# table3: each row gives the TB case rate per total population for a country in
# a specific year. Columns are: country, year, rate.

# 2. ---------------------------------------------------------------------------
# Sketch out the process you’d use to calculate the rate for table2 and table3.
# You will need to perform four operations:
# a. Extract the number of TB cases per country per year.
# b. Extract the matching population per country per year.
# c. Divide cases by population, and multiply by 10000.
# d. Store back in the appropriate place.
# You haven’t yet learned all the functions you’d need to actually perform these
# operations, but you should still be able to think through the transformations
# you’d need.

# Pretending I don't know about left_join or pivot functions, I think this task
# can still be done using only the functions introduced in the previous
# chapters. The tools we already have are enough to separate cases and
# population, summarize them by country and year, and then calculate the rate.

table2 |>
  mutate(
    cases = ifelse(type == "cases", count, NA), 
    pop = ifelse(type == "population", count, NA)
  ) |>
  summarize(
    pop = max(pop, na.rm = TRUE), 
    cases = max(cases, na.rm = TRUE), 
    .by = c(country, year)
  ) |>
  mutate(cases_ratio = cases / pop * 10000)

# ---------------------------- 5.3 LENGTHENING DATA ---------------------------- 

# ------------------------- 5.3.1 Data in column names ------------------------- 

billboard

# Reminiscing about the good old days of my beloved reshape2, where I'd use melt right
# here.

billboard |> 
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank"
  )

# cols() uses the same arguments as select()

# Getting rid of unnecessary NAs.
billboard |> 
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank",
    values_drop_na = TRUE
  ) 

# Converting values of week from character strings to numbers using
# parse_number()

billboard_longer <- billboard |> 
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank",
    values_drop_na = TRUE
  ) |> 
  mutate(
    week = parse_number(week)
  )

# Visualizing how songs rank vary over time.
billboard_longer |> 
  ggplot(aes(x = week, y = rank, group = track)) +
  geom_line(alpha = 0.25) +
  scale_y_reverse()

# ----------------------- 5.3.2 How does pivoting work? ------------------------ 

df <- tribble(
  ~id,  ~bp1, ~bp2,
  "A",  100,  120,
  "B",  140,  115,
  "C",  120,  125
)

# Melting the data frame — I still can’t forget reshape2; its function names
# were so intuitive.

df |>  
  pivot_longer(
    col = bp1:bp2,
    names_to = "measurement",
    values_to = "values"
  )

# -------------------- 5.3.3 Many variables in column names -------------------- 

who2

# Pulling as much information as possible out of the column names.

who2 |> 
  pivot_longer(
    cols = !(country:year),
    names_to = c("diagnosis", "gender", "age"),
    names_sep = "_",
    values_to = "count"
  )

# It honestly feels like a magic trick. Before learning this, I’d be wrestling
# with regex just to extract the same information from the column names.

# ------------ 5.3.4 Data and variable names in the column headers ------------- 

household

household |> 
  pivot_longer(
    cols = !family,
    names_to = c(".value", "child"),
    names_sep = "_",
    values_drop_na = TRUE
  )

# ----------------------------- 5.4 WIDENING DATA ------------------------------ 

cms_patient_experience
cms_patient_experience |>
  distinct(measure_cd, measure_title)

# It brings te same idea as the late cast() in reshape2.

cms_patient_experience |> 
  pivot_wider(
    names_from = measure_cd,
    values_from = prf_rate
  )

cms_patient_experience |> 
  pivot_wider(
    id_cols = starts_with("org"),
    names_from = measure_cd,
    values_from = prf_rate
  )

# --------------------- 5.4.1 How does pivot_wider() work? --------------------- 

df <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "B",        "bp1",    140,
  "B",        "bp2",    115, 
  "A",        "bp2",    120,
  "A",        "bp3",    105
)

df |> 
  pivot_wider(
    names_from = measurement,
    values_from = value
  )

df |> 
  select(!measurement & !value) |> 
  distinct()

df |> 
  select(!measurement & !value) |> 
  distinct() |> 
  mutate(x = NA, y = NA, z = NA)

df |>
  pivot_wider(
    names_from = measurement,
    values_from = value
  )

# ------------------------------------------------------------------------------
#                             TIL - Today I Learned 
# ------------------------------------------------------------------------------

# 2025-11-13 -------------------------------------------------------------------
# readr::parse_number() grabs the first number from a string, ignoring all text.
# Way easier than wrestling with regex.

# 2025-11-11 -------------------------------------------------------------------
# Turns out the cols argument in pivot_longer() understands the same helpers as
# select() — so you can use starts_with, ends_with, matches, and friends.

# ------------------------------------------------------------------------------
