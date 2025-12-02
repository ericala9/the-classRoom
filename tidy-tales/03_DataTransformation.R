# ==============================================================================
#                R for Data Science (2e) - 3. Data transformation
# ==============================================================================
# Title: R for Data Science (2e) - 1. Data visualization
# Author: Érica
# Purpose: Studying Chapter 2 of R for Data Science (2nd edition)
# Reference: Wickham, H., Çetinkaya-Rundel, M., & Grolemund, G. (2023). 
# R for Data Science (2nd ed.).
# https://r4ds.hadley.nz/data-transform.html
# Notes: Personal study notes and exercise solutions
# Date: 2025.11.01-07
# ==============================================================================

# ------------------------------------------------------------------------------ 
#                               Environment Setup 
# ------------------------------------------------------------------------------ 

rm(list = ls()) 
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

options(encoding = "UTF-8")
options(scipen = 999)
rstudioapi::writeRStudioPreference("data_viewer_max_columns", 1000L)

# ------------------------------------------------------------------------------ 
#                                3.1 INTRODUCTION 
# ------------------------------------------------------------------------------ 

# ------------------------------------------------------------------------------ 
#                              3.1.1 Prerequisites 
# ------------------------------------------------------------------------------ 

# install.packages("nycflights13")
library(nycflights13)
library(tidyverse)

# ------------------------------------------------------------------------------ 
#                               3.1.2 nycflights13 
# ------------------------------------------------------------------------------ 

View(flights)
print(flights, width = Inf)
glimpse(flights)

# ------------------------------------------------------------------------------ 
#                               3.1.3 dplyr basics 
# ------------------------------------------------------------------------------ 

flights |> 
  filter(dest == "IAH") |> 
  group_by(year, month, day) |> 
  summarize(arr_delay = mean(arr_delay, na.rm=TRUE))

# ------------------------------------------------------------------------------ 
#                                    3.2 ROWS 
# ------------------------------------------------------------------------------ 

# ------------------------------------------------------------------------------ 
#                                 3.2.1 filter() 
# ------------------------------------------------------------------------------ 

# Keeps rows based on conditions applied to columns.

# Flights that departed more than 2 hours late.
flights |> 
  filter(dep_delay > 120)

# Flights that departed on January 1
flights |>
  filter(month == 1 & day == 1)

# Flights that departed in January or February
# Textbook example
flights |> 
  filter(month == 1 | month == 2)

# A more practical alternative — what I'd normally use
flights |> 
  filter(month %in% c(1, 2))

jan1 <- flights |> 
  filter(month == 1 & day == 1)

# ------------------------------------------------------------------------------ 
#                                3.2.3 arrange()  
# ------------------------------------------------------------------------------ 

# Changes the row order based on column values.

flights |> 
  arrange(year, month, day, dep_time)

flights |> 
  arrange(desc(dep_delay))

# ------------------------------------------------------------------------------ 
#                                3.2.4 distinct() 
# ------------------------------------------------------------------------------ 

# Finds unique rows in a dataset.

flights |> 
  distinct()

flights |> 
  distinct(origin, dest)

# To keep all other columns when filtering for unique rows, add .keep_all=TRUE
flights |> 
  distinct(origin, dest, .keep_all = TRUE)

# Counting the number of occurrences.
flights |> 
  count(origin, dest, sort=TRUE)

# ------------------------------------------------------------------------------ 
#                                3.2.5 Exercises 
# ------------------------------------------------------------------------------ 

# 1. In a single pipeline for each condition, find all flights that meet the
# condition:
# Had an arrival delay of two or more hours
# Flew to Houston (IAH or HOU)
# Were operated by United, American, or Delta
# Departed in summer (July, August, and September)
# Arrived more than two hours late but didn’t leave late
# Were delayed by at least an hour, but made up over 30 minutes in flight

# Had an arrival delay of two or more hours
flights |> 
  filter(arr_delay >= 120) 

# Flew to Houston (IAH or HOU)
flights |> 
  filter(dest %in% c("IAH", "HOU"))

# Were operated by United, American, or Delta
flights |> 
  filter(carrier %in% c("UA", "AA", "DL"))

# Departed in summer (July, August, and September)
flights |> 
  filter(month %in% c(7:9))

# Arrived more than two hours late but didn’t leave late
flights |> 
  filter(arr_delay > 120 & dep_delay == 0)

# Were delayed by at least an hour, but made up over 30 minutes in flight
flights |> 
  filter(dep_delay > 60 & dep_delay - arr_delay > 30)

# ------------------------------------------------------------------------------
# 2. Sort flights to find the flights with the longest departure delays. Find
# the flights that left earliest in the morning.

flights |> 
  arrange(desc(dep_delay), dep_time)

# ------------------------------------------------------------------------------
# 3. Sort flights to find the fastest flights. (Hint: Try including a math
# calculation inside of your function.)

flights |> 
  arrange(desc(distance / (air_time /60)))

# ------------------------------------------------------------------------------
# 4. Was there a flight on every day of 2013?

# Yes, there were flights everyday in 2013.

flights |> 
  distinct(year, month, day) |> 
  count()

# ------------------------------------------------------------------------------
# 5. Which flights traveled the farthest distance? Which traveled the least
# distance?

# The five longest routes were JFK - HNL, EWR - HNL, ERW - ANC, JFK - SFO, and
# JFK - OAK.
# The five shortest routes were EWR - LGA, EWR - PHL, JFK - PHL, LGA - PHL and
# EWR - BDL.

flights |> 
  arrange(desc(distance)) |> 
  distinct(origin, dest, distance) |> 
  head(5)

flights |> 
  arrange(distance) |> 
  distinct(origin, dest, distance) |> 
  head(5)

# ------------------------------------------------------------------------------
# 6. Does it matter what order you used filter() and arrange() if you’re using
# both? Why/why not? Think about the results and how much work the functions
# would have to do.

# Yes, it does. If you arrange() first, R will sort all the rows before
# filtering, which can be a lot of unnecessary work. If you filter() first, you
# reduce the data to only the rows you need, and then sort that smaller set —
# which is faster and often more meaningful.

# ------------------------------------------------------------------------------ 
#                                  3.3 COLUMNS 
# ------------------------------------------------------------------------------ 

# ------------------------------------------------------------------------------ 
#                                 3.3.1 mutate() 
# ------------------------------------------------------------------------------

# Calculate how much time a delayed flight made up in the air, and compute its
# average speed (mph).
flights |> 
  mutate(gain = dep_delay - arr_delay,
         speed = distance / air_time *60)

# By using `.before` inside mutate(), we can place the new variables at the
# beginning of the dataset.
flights |> 
  mutate(gain = dep_delay - arr_delay,
         speed = distance / air_time * 60,
         .before = 1)

# We can also insert the new variables directly after a specific variable,
# instead of a fixed position.
flights |> 
  mutate(gain = dep_delay - arr_delay,
         speed = distance /air_time * 60,
         .before = day)

# `.keep = "used"` keeps only the variables involved in mutate().
# Other options are available depending on what we want to keep.
flights |> 
  mutate(gain = dep_delay - arr_delay,
         hours = air_time / 60,
         gain_per_hour = gain / hours,
         .keep = "used")

# ------------------------------------------------------------------------------ 
#                                 3.3.2 select() 
# ------------------------------------------------------------------------------ 

# Select specific variables
flights |> 
  select(year, month, day)

# Select all variables except those in this range
flights |> 
  select(!year:day)

# Select all variables that are character type
flights |> 
  select(where(is.character))

# select() helper functions:
# Some useful helpers include starts_with(), ends_with(), contains(), and
# matches().
# These work similarly to how I often use grep() to filter column names.
# Only matches() uses regular expressions.

# ------------------------------------------------------------------------------ 
#                                 3.3.3 rename() 
# ------------------------------------------------------------------------------ 

# To rename variables, we can use rename()
flights |> 
  rename(tail_num = tailnum)

# ------------------------------------------------------------------------------ 
#                                3.3.4 relocate() 
# ------------------------------------------------------------------------------ 

# Used to move variables around. 

flights |> 
  relocate(time_hour, air_time)

# Similar to the arguments `.before` and `.after` in mutate(), and has the same
# usage, with the same arguments.

flights |> 
  relocate(year:dep_time, .after = time_hour) 

flights |> 
  relocate(starts_with(("arr")), .before = "dep_time")

# ------------------------------------------------------------------------------ 
#                                3.3.5 Exercises 
# ------------------------------------------------------------------------------ 

# 1. Compare dep_time, sched_dep_time, and dep_delay. How would you expect those
# three numbers to be related?

# dep_delay represents the difference between the actual departure time
# (dep_time) and the scheduled departure time (sched_dep_time). So: dep_delay =
# dep_time - sched_dep_time If a flight leaves later than scheduled, dep_delay
# will be positive; if it leaves earlier, it will be negative.

flights |> 
  select(contains("dep"))

# ------------------------------------------------------------------------------
# 2. Brainstorm as many ways as possible to select dep_time, dep_delay,
# arr_time, and arr_delay from flights.

flights |> 
  select(dep_time, dep_delay, arr_time, arr_delay)

flights |> 
  select(contains("dep_"), 
         contains("arr_")) |> 
  select(!contains("sched_"))

flights |> 
  select(matches("^(dep|arr)_"))

flights |> 
  select(starts_with("dep_"), 
         starts_with("arr_"))

names(flights)
flights |> 
  select(c(4, 6, 7, 9))

# ------------------------------------------------------------------------------
# 3. What happens if you specify the name of the same variable multiple times in
# a select() call?

# Even if you list the same variable more than once, it is returned only once.

# ------------------------------------------------------------------------------
# 4. What does the any_of() function do? Why might it be helpful in conjunction
# with this vector?
# variables <- c("year", "month", "day", "dep_delay", "arr_delay")

# any_of() is a selection helper that selects variables listed in a vector, but
# safely ignores any that are not present in the data. This prevents errors. We
# can use it in conjuction with this vector to select the variables we want,
# since we can't use a vector as an argument to select.

?any_of()
variables <- c("year", "month", "day", "dep_delay", "arr_delay")
flights |> 
  select(any_of(variables))
rm(variables)

# ------------------------------------------------------------------------------
# 5. Does the result of running the following code surprise you? How do the
# select helpers deal with upper and lower case by default? How can you change
# that default?
# flights |> select(contains("TIME"))

# At first it is surprising, because R is usually case-sensitive. However,
# select helpers like contains() ignore case by default, so "TIME" matches
# variables that contain "time" in any case. We can change this behavior by
# setting ignore.case = FALSE.

?contains()
flights |> select(contains("TIME", ignore.case = FALSE))

# ------------------------------------------------------------------------------
# 6. Rename air_time to air_time_min to indicate units of measurement and move
# it to the beginning of the data frame.

flights |> 
  rename(air_time_min = air_time) |> 
  relocate(air_time_min)

# ------------------------------------------------------------------------------
# 7. Why doesn’t the following work, and what does the error mean?
# flights |> 
#   select(tailnum) |> 
#   arrange(arr_delay)
# #> Error in `arrange()`:
# #> ℹ In argument: `..1 = arr_delay`.
# #> Caused by error:
# #> ! object 'arr_delay' not found

# The code fails because after select(tailnum), the data frame only contains the
# column `tailnum`. Then, arrange(arr_delay) tries to sort by `arr_delay`, which
# no longer exists in the data. The error message indicates that `arr_delay` was
# not found when arrange() tried to use it.

# ------------------------------------------------------------------------------ 
#                                  3.4 THE PIPE 
# ------------------------------------------------------------------------------ 

flights |> 
  filter(dest == "IAH") |> 
  mutate(speed = distance / air_time * 60) |> 
  select(year:day, dep_time, carrier, flight, speed) |> 
  arrange(desc(speed))

# Usinr R base:
flights2 <- subset(flights, dest == "IAH")
flights2$speed <-  flights2$distance / flights2$air_time * 60
flights2 <- flights2[c("year", "month", "day", "dep_time", "carrier", "flight", "speed")]
head(flights2[order(flights2$speed, decreasing = TRUE),])

# ------------------------------------------------------------------------------ 
#                                   3.5 GROUPS 
# ------------------------------------------------------------------------------ 

# ------------------------------------------------------------------------------ 
#                                3.5.1 group_by() 
# ------------------------------------------------------------------------------

# The group_by() function changes how subsequent dplyr verbs behave by applying
# them within each group rather than to the entire dataset.

flights |> 
  group_by(month)

# ------------------------------------------------------------------------------ 
#                               3.5.2 summarize() 
# ------------------------------------------------------------------------------ 

# summarize() (or summarise()) collapses a data frame to one row per group by
# computing summary statistics for each group.

flights |> 
  group_by(month) |> 
  summarize(avg_delay = mean(dep_delay, na.rm = TRUE))

# You can compute multiple summary statistics in a single summarize() call

flights |> 
  group_by(month) |> 
  summarize(avg_delay = mean(dep_delay, na.rm = TRUE),
            n = n())

# ------------------------------------------------------------------------------ 
#                           3.5.3 The slice_ functions 
# ------------------------------------------------------------------------------

# The slice family allows us to select rows by position within each group.

# slice_tail() returns the last n rows in each group.
# slice_min() returns the n rows with the smallest values in a selected column.
# slice_max() returns the n rows with the largest values in a selected column.
# slice_sample() randomly selects n rows.
# slice_head() returns the first n rows from each group.

flights |> 
  group_by(dest) |> 
  slice_max(arr_delay, n = 1) |> 
  relocate(dest)

# By default, slice_min() and slice_max() keep tied values. 
# If we want to remove ties and return only one row, we can set with_ties =
# FALSE.

# While summarize() returns summary statistics, slice_min() and slice_max()
# return the full rows where those minimum or maximum values occur. This allows
# us to keep all relevant information associated with those observations.

# ------------------------------------------------------------------------------ 
#                      3.5.4 Grouping by multiple variables 
# ------------------------------------------------------------------------------ 

# Data can be grouped by more than one variable.

daily <- flights |> 
  group_by(year, month, day)
daily

# When summarizing with multiple group vars, dplyr drops the last group by
# default. Use `.groups` in summarize() if you want to keep groups or control
# drop behavior.

daily_flights <- daily |> 
  summarize(n = n(),
            .groups = "keep")
daily_flights

# ------------------------------------------------------------------------------ 
#                                3.5.5 Ungrouping 
# ------------------------------------------------------------------------------ 

# If we want to remove grouping from a dataframe without using .groups in
# summarize, we can use ungroup().

daily |> 
  ungroup() |> 
  summarize(avg_delay = mean(dep_delay, na.rm = TRUE),
            flights = n())

# ------------------------------------------------------------------------------ 
#                                   3.5.6 .by 
# ------------------------------------------------------------------------------ 

# `.by` lets us group inside a single dplyr verb (no separate group_by()).

flights |> 
  summarize(delay = mean(dep_delay, na.rm = TRUE),
            n = n(),
            .by = month) |> 
  arrange(as.numeric(month))

# Can group by multiple variables too.

flights |> 
  summarize(delay = mean(dep_delay, na.rm = TRUE),
            n = n(),
            .by = c(origin, dest))

# Notes:
# - `.by` only applies to the verb it's used in (not persistent like group_by()).
# - It doesn't sort the grouping variable in summaries.
# Source: https://dplyr.tidyverse.org/reference/dplyr_by.html#supported-verbs

# ------------------------------------------------------------------------------ 
#                                3.5.7 Exercises 
# ------------------------------------------------------------------------------ 

# 1. Which carrier has the worst average delays? Challenge: can you disentangle
# the effects of bad airports vs. bad carriers? Why/why not? (Hint: think about
# flights |> group_by(carrier, dest) |> summarize(n()))

# Grouping by carrier shows who's usually late. Grouping by both carrier and
# destination shows where they're late. The catch is, these effects overlap —
# some carriers mostly fly to airports that are already delay-prone. We'd need a
# model to separate airport and carrier effects properly.

flights |> 
  summarise(avg_arr_delay = mean(arr_delay, na.rm=TRUE), 
            .by = carrier) |> 
  arrange(desc(avg_arr_delay))

flights |> 
  summarise(avg_arr_delay = mean(arr_delay, na.rm=TRUE), 
            .by = c(carrier, dest)) |> 
  arrange(desc(avg_arr_delay))

# ------------------------------------------------------------------------------
# 2. Find the flights that are most delayed upon departure from each
# destination.

# slice_max() grabs the most delayed departures per destination. Quick and
# direct, no need to summarize first.

flights |> 
  slice_max(dep_delay, by = dest) |> 
  relocate(origin, dest, dep_delay)

# ------------------------------------------------------------------------------
# 3. How do delays vary over the course of the day? Illustrate your answer with
# a plot.

# Delays seem to get worse in the afternoon, probably because earlier delays
# start to snowball as the day goes on. Between 22:00 and 05:00, delays avegare
# improve — likely just fewer flights at those hours.

flights |> ggplot(aes(x = sched_dep_time, y = dep_delay)) +
  geom_point()

flights |>
  mutate(hour = sched_dep_time %/% 100) |> 
  summarize(mean_delay = mean(dep_delay, na.rm = TRUE), .by = hour) |>
  ggplot(aes(x = hour, y = mean_delay)) +
  geom_line() +
  geom_point()

# ------------------------------------------------------------------------------
# 4. What happens if you supply a negative n to slice_min() and friends?

# For slice_min() and slice_max(), a negative n means "drop" the n smallest or
# largest rows instead of "keep" them. For slice_head() and slice_tail(), a
# negative n drops rows from the start or end. slice_sample() returns all rows
# except a random n sample. slice() with a negative index works like normal R
# indexing: it removes rows.

flights |> slice_min(month, n = -10)
flights |> slice_max(month, n = -10)
flights |> slice_head(n = -10)
flights |> slice_tail(n = -10)
flights |> slice_sample(n = -10)
flights |> slice(-(10000:20000))  

# ------------------------------------------------------------------------------
# 5. Explain what count() does in terms of the dplyr verbs you just learned.
# What does the sort argument to count() do?

# When you just need to know "how many of each", count() is your go-to shortcut.
# It's shorthand for group_by() + summarize(n = n()), grouping the data and
# counting rows in each group. The argument sort = TRUE arranges results by
# descending n.

flights |> 
  group_by(carrier) |> 
  summarize(n = n())

flights |> count(carrier)

flights |> 
  group_by(carrier) |> 
  summarize(n = n()) |> 
  arrange(desc(n))

flights |> count(carrier, sort = TRUE)

# ------------------------------------------------------------------------------
# 6. Suppose we have the following tiny data frame:
# df <- tibble(
#   x = 1:5,
#   y = c("a", "b", "a", "a", "b"),
#   z = c("K", "K", "L", "L", "K")
# )

# ----
# a. Write down what you think the output will look like, then check if you were
# correct, and describe what group_by() does.
# df |>
#   group_by(y)

# It groups the tibble by the values in y — so there’ll be two groups: a and b.
# It doesn’t change the data itself, but later functions will operate within
# each group.

# ----
# b. Write down what you think the output will look like, then check if you were
# correct, and describe what arrange() does. Also, comment on how it’s different
# from the group_by() in part (a).
# df |>
#   arrange(y)

# The tibble will be sorted in ascending order of y. It only changes the row
# order — the data itself stays the same. Unlike group_by(), it doesn’t affect
# how later functions behave.

# ----
# c. Write down what you think the output will look like, then check if you were
# correct, and describe what the pipeline does.
# df |>
#   group_by(y) |>
#   summarize(mean_x = mean(x))

# The data is grouped by y, and then the mean of x is calculated for each group.
# The result shows one row per value of y, usually listed in ascending order.
# group_by() sets the grouping; summarize() collapses each group into a single
# value.

# ----
# d. Write down what you think the output will look like, then check if you were
# correct, and describe what the pipeline does. Then, comment on what the
# message says.
# df |>
#   group_by(y, z) |>
#   summarize(mean_x = mean(x))

# Data is grouped by both y and z, creating one group for each unique
# combination of those values — three groups in total. summarize() then
# calculates the mean of x within each group. After summarizing, dplyr drops
# the last level of grouping (z), leaving the data still grouped by y. That’s
# what the message “Groups: y [2]” means — there are two remaining groups based
# on y, because grouping by z was dropped when summarize() was applied.

# ----
# e. Write down what you think the output will look like, then check if you were
# correct, and describe what the pipeline does. How is the output different from
# the one in part (d)?
# df |>
#   group_by(y, z) |>
#   summarize(mean_x = mean(x), .groups = "drop")

# Data is grouped by both y and z, creating one group for each unique
# combination of those values — three groups in total. summarize() then
# calculates the mean of x within each group. Because the argument .groups =
# "drop" is used, all grouping is removed after summarizing. The result is an
# ungrouped tibble, so no “Groups:” message appears.

# ----
# f. Write down what you think the outputs will look like, then check if you
# were correct, and describe what each pipeline does. How are the outputs of the
# two pipelines different?
# df |>
#   group_by(y, z) |>
#   summarize(mean_x = mean(x))
# df |>
#   group_by(y, z) |>
#   mutate(mean_x = mean(x))

# The first pipeline groups data by both y and z, creating one group for each
# unique combination of those values — three groups in total. summarize()
# calculates the mean of x within each group, returning one row per group. After
# summarizing, dplyr drops the last level of grouping (z), so the data remains
# grouped by y. 
#
# The second pipeline also groups by y and z, but uses mutate() instead of
# summarize(). This keeps all original rows and adds a new column, mean_x, that
# stores the group mean for each row. 
#
# In short: summarize() condenses data (one row per group), while mutate()
# enriches data (adds group-level info to every row).

# ------------------------------------------------------------------------------ 
#                   3.6 CASE STUDY: AGGREGATES AND SAMPLE SIZE 
# ------------------------------------------------------------------------------ 

library(Lahman)

batters <- Lahman::Batting |> 
  group_by(playerID) |> 
  summarize(
    performance = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    n = sum(AB, na.rm = TRUE))
batters

# Each point is a player. The plot shows that players with few at-bats have more
# variable performance. As the number of at-bats increases, performance
# estimates become more stable.

batters |> 
  filter(n > 100) |> 
  ggplot(aes(x = n, y = performance)) +
  geom_point(alpha = 1 / 10) + 
  geom_smooth(se = FALSE)

# Players with fewer at-bats show higher apparent performance — not because
# they’re better, but due to small-sample variability. Think “beginner’s luck.”

# ------------------------------------------------------------------------------ 
#                             TIL - Today I Learned 
# ------------------------------------------------------------------------------ 

# 2025-11-01 ------------------------------------------------------------------- 
# Use .keep_all = TRUE in distinct() to keep all columns when filtering for
# unique rows.

# 2025-11-03 -------------------------------------------------------------------  
# In mutate(), .before and .after let you place new variables before or after a
# specific column.

# The .keep helper in mutate() lets you keep only selected variables when
# creating new ones.

# Useful select() helpers: starts_with(), ends_with(), contains(), matches().
# They work like grep() for column names. Only matches() uses regular
# expressions.

# Honestly, I don’t know how I survived this long without these helpers.

# By default, contains() and other helpers ignore case. Makes life much easier.

# 2025-11-05 -------------------------------------------------------------------
# slice_ functions :heart_eyes:: Where have they been all this time? They make
# analyzing patterns within groups so much easier.

# Summarizing with multiple group variables drops the last group by default. Use
# .groups in summarize() if you want to keep groups or control how they’re
# dropped.

# .by: One-time, in-verb grouping — fast and handy for quick summaries; just
# don’t expect it to stick around or sort your groups for you.

# 2025-11-07 -------------------------------------------------------------------
# count(): a simpler, dplyr alternative to table(). Much easier than doing
# group_by() + summarize().

# ------------------------------------------------------------------------------ 
