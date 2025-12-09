# 📓 TIL - Today I Learned - R4DS Edition
I first learned R back in 2009 — before RStudio, before tidyverse, before pipes. It was all Base R, the `apply()` - `sapply()` - `mapply()` gang, manual plots, and a lot of *“subscript out of bounds”* character building.

I’ve been using tidyverse for years now, but I’ve realized there’s a lot of powerful functionality I never truly learned — or picked up only halfway. So I’m revisiting the basics with r4ds - **[R for Data Science (2e)](https://r4ds.hadley.nz)** to fill those gaps, build cleaner habits, and take advantage of what modern R can really do.

This repository, **tidy-tales**, is where I keep small stories from this journey. Notes, scripts, and little discoveries that don’t pretend to teach anything grand, but quietly record what I learned each day.

We grow, the language grows, and there’s *always* more to learn.

---

## 🗂️ Table of Contents

1. **Data Visualization**
   - [TIL](#chapter-1--data-visualization--book--notes) | [Notes](01_DataVisualization.R) | Oct 2025
2. **Workflow: basics**
   - [TIL](#chapter-2--workflow-basics--book--notes) | [Notes](02_Workflow-basics.R) | Oct 2025

---
### Chapter 1 — Data Visualization | [book](https://r4ds.hadley.nz/data-visualize.html) | [notes](01_DataVisualization.R)
#### 2025-10-29 
- When I saw the book started with **ggplot2**, I almost gave up. Since I first heard about it back in 2011, I could never grasp its logic. Good thing I didn’t — this time, it finally clicked. :bar_chart:
#### 2025-10-30
- Discovered that the shortcut for `<-` is just **Ctrl** + **-**. :exploding_head: Two keys instead of five! As a loyal `<-` user who refuses to type `=`, this feels like a huge win — and a reminder that even dinosaurs can learn new tricks. :t-rex:
#### 2025-10-31
- The *Esc* key literally means <ins>escape</ins>. It suddenly makes perfect sense — it gets us out of almost every computer-related danger.
- Another revelation: `ggsave()`! I used to save plots with `pdf()` or `jpeg()`. No wonder **ggplot2** felt so awkward back then — I was mixing it with ancient ways. :exploding_head:

### Chapter 2 — Workflow: basics | [book](https://r4ds.hadley.nz/workflow-basics.html) | [notes](02_Workflow-basics.R)
#### 2025-10-31
- **Ctrl** + ↑ shows all commands starting with what you just typed in the console.
- **Alt** + **Ctrl** + **K** opens a cheatsheet of RStudio shortcuts.

Little things, big difference. 🚀

### Chapter 3 — Data transformation | [book](https://r4ds.hadley.nz/data-transform.html) | [notes](03_DataTransformation.R)
#### 2025-11-01
- Use `.keep_all = TRUE` in `distinct()` to keep all columns when filtering for unique rows.

#### 2025-11-03
- In `mutate()`, `.before` and `.after` let you place new variables before or after a specific column.
- The `.keep` helper in `mutate()` lets you keep only selected variables when creating new ones.
- Useful `select()` helpers: `starts_with()`, `ends_with()`, `contains()`, `matches()`. They work like `grep()` for column names. Only `matches()` uses regular expressions.
- Honestly, I don’t know how I survived this long without these helpers.
- By default, `contains()` and other helpers ignore case. Makes life much easier.

#### 2025-11-05
- `slice_` functions :heart_eyes: : Where have they been all this time? They make analyzing patterns within groups so much easier.
- Summarizing with multiple group variables drops the last group by default. Use `.groups` in `summarize()` if you want to keep groups or control how they’re dropped.
- `.by`: One-time, in-verb grouping — fast and handy for quick summaries; just don’t expect it to stick around or sort your groups for you.
  
#### 2025-11-07
- `count()`: a simpler, dplyr alternative to `table()`. Much easier than doing `group_by()` + `summarize()`.

### Chapter 4 — Workflow: code style | [book](https://r4ds.hadley.nz/workflow-style.html) | [notes](04_Workflow-CodeStyle.R)
#### 2025-11-10
- Sectioning comments: a way to organize chaos — and navigate through it.

### Chapter 5 - Data tidying | [book](https://r4ds.hadley.nz/data-tidy.html) | [notes](05_DataTidying.R)

#### 2025-11-11
- Turns out the `cols` argument in `pivot_longer()` understands the same helpers as `select()` — so you can use `starts_with`, `ends_with`, `matches`, and friends.
#### 2025-11-13
- `readr::parse_number()` grabs the first number from a string, ignoring all text. Way easier than wrestling with regex.
