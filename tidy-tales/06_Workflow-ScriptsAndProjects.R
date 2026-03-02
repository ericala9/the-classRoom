# ==============================================================================
#          R for Data Science (2e) - 6. Workflow: scripts and projects
# ==============================================================================
# Author: Érica
# Purpose: Studying Chapter 6 of R for Data Science (2nd edition)
# Reference: Wickham, H., Çetinkaya-Rundel, M., & Grolemund, G. (2023).
# R for Data Science (2nd ed.).
# https://r4ds.hadley.nz/workflow-scripts.html
# Notes: Personal study notes and exercise solutions
# Date: 2025.11.25
# ==============================================================================

# ----------------------------- ENVIRONMENT SETUP ------------------------------

rm(list = ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

options(encoding = "UTF-8")
options(scipen = 999)
rstudioapi::writeRStudioPreference("data_viewer_max_columns", 1000L)

library(tidyverse)

# ------------------------------------------------------------------------------
#                             TIL - Today I Learned 
# ------------------------------------------------------------------------------

# 2025-11-25 -------------------------------------------------------------------
# CTRL + SHIFT + F10 restarts R.
# CTRL + SHIFT + S re-runs the current script.

# ------------------------------------------------------------------------------
