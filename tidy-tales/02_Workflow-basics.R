# ============================================================================== 
#                 R for Data Science (2e) - 2. Workflow: basics 
# ============================================================================== 
# Title: R for Data Science (2e) - 2. Workflow: basics
# Author: Érica
# Purpose: Studying Chapter 2 of R for Data Science (2nd edition)
# Reference: Wickham, H., Çetinkaya-Rundel, M., & Grolemund, G. (2023). 
# R for Data Science (2nd ed.).
# https://r4ds.hadley.nz/workflow-basics.html
# Notes: Personal study notes and exercise solutions
# Date: 2025.10.31
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
#                               2.1 CODING BASICS 
# ------------------------------------------------------------------------------ 

1/200*30
(59+73+2)/3
sin(pi/2)
x <- 3 * 4
x
primes <- c(2, 3, 5, 7, 11, 13)
primes * 2
primes - 1

# ------------------------------------------------------------------------------ 
#                                  2.2 COMMENTS 
# ------------------------------------------------------------------------------ 

# Creating vector of primes
primes <- c(2, 3, 5, 7, 11, 13)

# Multiplying primes by 2
primes * 2

# Use the comments for explaning the why of what is being done. The what and how
# can be figured out. Understanding why something was done may be very hard, or
# impossible at times.

# ------------------------------------------------------------------------------ 
#                             2.3 WHAT’S IN A NAME? 
# ------------------------------------------------------------------------------ 

x
this_is_a_really_long_name <- 2.5
r_rocks <- 2^3
r_rock
R_rocks

# Shortcut Ctrl+uparrow to list all the comands starting with the letters just
# typed. Do this in the console.

# ------------------------------------------------------------------------------ 
#                             2.4 CALLING FUNCTIONS 
# ------------------------------------------------------------------------------ 

seq(from = 1, to = 10)
seq(1, 10)

x <- "hello world"
# x <- "hello

# ------------------------------------------------------------------------------ 
#                                 2.5 EXERCISES 
# ------------------------------------------------------------------------------ 

# 1. Why does this code not work?
# my_variable <- 10
# my_varıable
# #> Error: object 'my_varıable' not found
# Look carefully! (This may seem like an exercise in pointlessness, but training
# your brain to notice even the tiniest difference will pay off when
# programming.)

# "my_varıable" uses the dotless i instead of the regular “i”, so R thinks it's
# a different object name and cannot find it.

# ------------------------------------------------------------------------------ 
# 2. Tweak each of the following R commands so that they run correctly:
# libary(todyverse)
# 
# ggplot(dTA = mpg) + 
#   geom_point(maping = aes(x = displ y = hwy)) +
#   geom_smooth(method = "lm)

library(tidyverse)

ggplot(data = mpg,
       mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth(method = "lm")

# ------------------------------------------------------------------------------
# 3. Press Option + Shift + K / Alt + Shift + K. What happens? How can you get
# to the same place using the menus?

# When we press Alt + Shift + K, RStudio opens the Keyboard Shortcuts help
# panel. You can access the same panel using the menu: Tools > Keyboard
# Shortcuts Help.

# ------------------------------------------------------------------------------
# 4. Let’s revisit an exercise from the Section 1.6. Run the following lines of
# code. Which of the two plots is saved as mpg-plot.png? Why?
# my_bar_plot <- ggplot(mpg, aes(x = class)) +
#   geom_bar()
# my_scatter_plot <- ggplot(mpg, aes(x = cty, y = hwy)) +
#   geom_point()
# ggsave(filename = "mpg-plot.png", plot = my_bar_plot)

# The bar plot is saved as mpg-plot.png. Even though both plots were created,
# the ggsave() call explicitly names my_bar_plot in the plot argument, so that's
# the one written to the file. Because the plot is specified directly, it
# doesn’t depend on the most recently printed plot in the console.

# ------------------------------------------------------------------------------ 
#                             TIL - Today I Learned 
# ------------------------------------------------------------------------------ 

# 2025-10-31 ------------------------------------------------------------------- 
# Ctrl + ↑ shows all commands starting with what you just typed in the console.

# Alt + Ctrl + K opens a cheatsheet of RStudio shortcuts. Little things, big
# difference. 🚀

# ------------------------------------------------------------------------------ 
