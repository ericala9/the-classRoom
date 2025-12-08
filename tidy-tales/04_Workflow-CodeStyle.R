# ==============================================================================
#               R for Data Science (2e) - 4. Workflow: code style
# ==============================================================================
# Author: Érica
# Purpose: Studying Chapter 4 of R for Data Science (2nd edition)
# Reference: Wickham, H., Çetinkaya-Rundel, M., & Grolemund, G. (2023).
# R for Data Science (2nd ed.).
# https://r4ds.hadley.nz/workflow-style.html
# Notes: Personal study notes and exercise solutions
# Date: 2025.11.10
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

# To run styler: Ctrl + Shift + P → type "styler".
# Use a common prefix to make autocomplete more useful.

# --------------------------------- 4.1 NAMES ---------------------------------- 

short_flights <- flights |>
  filter(air_time < 60)

# --------------------------------- 4.2 SPACES ---------------------------------

# Preferred style:
z <- (a + b)^2 / d
mean(x, na.rm = TRUE)

# Avoid unnecessary spaces:
z<-( a + b ) ^ 2/d
mean( x ,na.rm=TRUE)

# Good example — using spacing for clear alignment inside mutate():
flights |> 
  mutate(
    speed      = distance / air_time,
    dep_hour   = dep_time %/% 100,
    dep_minute = dep_time %% 100,
    .before = year
  )

# --------------------------------- 4.3 PIPES ---------------------------------- 

# Good example:
flights |> 
  filter(!is.na(arr_delay), !is.na(tailnum)) |> 
  count(dest)

# Bad example:
flights|>filter(!is.na(arr_delay),!is.na(tailnum))|>count(dest)

# Both versions work perfectly, but the first one is much easier to read.

# Preferred style:
flights |> 
  group_by(tailnum) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

# Avoid:
flights |> 
  group_by(
    tailnum
  ) |> 
  summarize(delay = mean(arr_delay, na.rm=TRUE), n=n())

# For years, I used to write it like this:
flights |> 
  group_by(tailnum) |> 
  summarize(delay=mean(arr_delay, na.rm=TRUE), n=n())

# It's important to place each named argument on its own line, as in summarize()
# and mutate(), since these functions often expand as we refine our code.

# -------------------------------- 4.4 ggplot2 --------------------------------- 

# The transition from |> to + in ggplot2 is necessary because the package was
# created before the pipe operator existed. I remember using ggplot2 long before
# the tidyverse came along. For ggplot2 to use |>, it would probably have to
# become ggplot3.

flights |> 
  group_by(month) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE)
  ) |> 
  ggplot(aes(x = month, y = delay)) +
  geom_point() +
  geom_line()

flights |> 
  group_by(dest) |> 
  summarize(
    distance = mean(distance),
    speed = mean(distance / air_time, na.rm = TRUE)
  ) |> 
  ggplot(aes(x = distance, y = speed)) +
  geom_smooth(
    method = "loess",
    span = 0.5,
    se = FALSE,
    color = "white",
    linewidth = 4
  ) +
  geom_point()

# -------------------------- 4.5 SECTIONING COMMENTS --------------------------- 

# Shortcut: CTRL + SHIFT + R. I’m not a fan of how those section breaks look by
# default, so, with a little help from AI, I came up with a custom function
# instead. I love how sectioning comments make everything look cleaner (or
# tidier, since we’re in tidy-tales). Being able to navigate using the code
# navigation tool makes everything better.

center_title <- function(title, width = 78, border = "-", uppercase = FALSE) {
  if (uppercase) title <- toupper(title)
  label <- paste0(" ", title, " ")
  pad_total <- width - nchar(label)
  pad_left <- floor(pad_total / 2)
  pad_right <- ceiling(pad_total / 2)
  line <- paste0("# ", strrep(border, pad_left), label, strrep(border, pad_right))
  cat(line, "\n")
}

# Sectioning comments: a way to organize chaos — and navigate through it.

# ------------------------------- 4.6 EXERCISES -------------------------------- 

# 1. ---------------------------------------------------------------------------
# Restyle the following pipelines following the guidelines above.
# flights|>filter(dest=="IAH")|>group_by(year,month,day)|>summarize(n=n(),
#                                                                   delay=mean(arr_delay,na.rm=TRUE))|>filter(n>10)
# flights|>filter(carrier=="UA",dest%in%c("IAH","HOU"),sched_dep_time>
#                   0900,sched_arr_time<2000)|>group_by(flight)|>summarize(delay=mean(
#                     arr_delay,na.rm=TRUE),cancelled=sum(is.na(arr_delay)),n=n())|>filter(n>10)


flights |> 
  filter(dest == "IAH") |> 
  group_by(year, month, day) |> 
  summarize(
    n = n(),
    delay = mean(arr_delay, na.rm = TRUE)
  ) |> 
  filter(n > 10)

flights |> 
  filter(
    carrier == "UA", 
    dest %in% c("IAH", "HOU"), 
    sched_dep_time > 0900, 
    sched_arr_time < 2000
  ) |>
  group_by(flight) |>
  summarize(
    delay = mean(arr_delay, na.rm = TRUE),
    cancelled = sum(is.na(arr_delay)),
    n = n()
  ) |> 
  filter(n > 10)

# ------------------------------------------------------------------------------ 
#                             TIL - Today I Learned 
# ------------------------------------------------------------------------------ 

# 2025-11-10 -------------------------------------------------------------------
# Sectioning comments: a way to organize chaos — and navigate through it.

# ------------------------------------------------------------------------------ 
