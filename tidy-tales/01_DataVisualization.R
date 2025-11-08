# ==============================================================================
#                R for Data Science (2e) - 1. Data visualization
# ==============================================================================
# Title: R for Data Science (2e) - 1. Data visualization
# Author: Érica
# Purpose: Studying Chapter 1 of R for Data Science (2nd edition)
# Reference: Wickham, H., Çetinkaya-Rundel, M., & Grolemund, G. (2023). 
# R for Data Science (2nd ed.).
# https://r4ds.hadley.nz/data-visualize.html
# Notes: Personal study notes and exercise solutions
# Date: 2025.10.29-31
# ==============================================================================

# ------------------------------------------------------------------------------ 
#                               Environment Setup 
# ------------------------------------------------------------------------------ 

rm(list = ls()) 
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

options(encoding = "UTF-8")
options(scipen = 999)
rstudioapi::writeRStudioPreference("data_viewer_max_columns", 1000L)

library(tidyverse)
library(palmerpenguins)
library(ggthemes) # colorblind-safe palettes

# ------------------------------------------------------------------------------ 
#                                1.2 FIRST STEPS 
# ------------------------------------------------------------------------------ 

# ------------------------------------------------------------------------------
#                           1.2.1 The penguins data frame
# ------------------------------------------------------------------------------

penguins
glimpse(penguins)
View(penguins)
?penguins

# ------------------------------------------------------------------------------ 
#                            1.2.3 Creating a ggplot 
# ------------------------------------------------------------------------------

# Starting with a blank canvas
ggplot(data = penguins)

# Mapping variables to the axes
ggplot(data = penguins,
       mapping = aes(x = flipper_length_mm, y = body_mass_g))

# Plotting the penguins on the canvas
ggplot(data = penguins,
       mapping = aes(x = flipper_length_mm, y = body_mass_g)) + geom_point()

# ------------------------------------------------------------------------------ 
#                       1.2.4 Adding aesthetics and layers 
# ------------------------------------------------------------------------------

# Coloring the points by penguin species
ggplot(data=penguins,
       mapping=aes(x=flipper_length_mm, y=body_mass_g, color=species)) +
  geom_point()

# Adding a smooth line to help make the trend easier to see
ggplot(data=penguins,
       mapping=aes(x=flipper_length_mm, y=body_mass_g, color=species)) +
  geom_point() +
  geom_smooth(method="lm")

# Changing the global mapping so we get just one smooth line instead of one per
# species
ggplot(data=penguins,
       mapping=aes(x=flipper_length_mm, y=body_mass_g)) +
  geom_point(mapping = aes(color=species)) +
  geom_smooth(method="lm")

# Mapping both color and shape to species so each one stands out more
ggplot(data=penguins,
       mapping=aes(x=flipper_length_mm, y=body_mass_g)) +
  geom_point(mapping = aes(color=species, shape=species)) +
  geom_smooth(method="lm")

# Adding title, subtitle, axis labels, legend labels, and a colorblind-friendly
# palette
ggplot(data=penguins,
       mapping=aes(x=flipper_length_mm, y=body_mass_g)) +
  geom_point(mapping = aes(color=species, shape=species)) +
  geom_smooth(method="lm") +
  labs(title="Body mass and flipper length",
       subtitle="Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
       x = "Flipper length (mm)", y = "Body mass (g)", 
       color="Species", shape="Species") +
  scale_color_colorblind()

# ------------------------------------------------------------------------------ 
#                                1.2.5 Exercises 
# ------------------------------------------------------------------------------ 

# 1. How many rows are in penguins? How many columns?

# The penguins dataset contains 344 rows and 8 columns.
dim(penguins)

# ------------------------------------------------------------------------------
# 2. What does the bill_depth_mm variable in the penguins data frame describe?
# Read the help for ?penguins to find out.

# This variable represents the depth of the penguin's bill (beak), measured in
# millimeters.

?penguins

# ------------------------------------------------------------------------------
# 3. Make a scatterplot of bill_depth_mm vs. bill_length_mm. That is, make a
# scatterplot with bill_depth_mm on the y-axis and bill_length_mm on the x-axis.
# Describe the relationship between these two variables.

# When we look at bill depth and bill length, we notice a relationship:
# as one increases, the other tends to increase as well. However, the pattern
# isn't perfectly linear. By adding species as a color aesthetic, we can see
# that bill length varies distinctly across species, with each species showing
# a different concentration of values.

ggplot(data=penguins,
       mapping=aes(x=bill_length_mm, y=bill_depth_mm)) +
  geom_point(mapping=aes(color=species))

# ------------------------------------------------------------------------------
# 4. What happens if you make a scatterplot of species vs. bill_depth_mm? What
# might be a better choice of geom?

# A scatterplot is best suited for two quantitative variables. Since species is
# categorical, a better choice of geom would be a boxplot, which can show the
# distribution of bill depth across species more effectively.

ggplot(data=penguins,
       mapping=aes(x=species, y=bill_depth_mm)) +
  geom_point()

ggplot(data=penguins,
       mapping=aes(x=species, y=bill_depth_mm)) +
  geom_boxplot()

# ------------------------------------------------------------------------------
# 5. Why does the following give an error and how would you fix it?
# ggplot(data = penguins) + 
#   geom_point()

# This code returns an error because it doesn't specify which variables to plot.
# The geom_point() function requires a mapping of aesthetics, such as x and y
# axes. To fix it, you need to add an aes() mapping that defines which variables
# go on each axis.

ggplot(data = penguins,
       aes(x=bill_length_mm, y=bill_depth_mm)) +
  geom_point()

# ------------------------------------------------------------------------------
# 6. What does the na.rm argument do in geom_point()? What is the default value
# of the argument? Create a scatterplot where you successfully use this argument
# set to TRUE.

# The na.rm argument in geom_point() controls how missing values (NAs) are
# handled. By default, it is set to FALSE, which means missing values are
# removed but a warning is shown. Setting na.rm = TRUE removes the missing
# values silently, without displaying a warning.

ggplot(data = penguins,
       aes(x=bill_length_mm, y=bill_depth_mm)) +
  geom_point(mapping=aes(color=species), na.rm=TRUE)

# ------------------------------------------------------------------------------
# 7. Add the following caption to the plot you made in the previous exercise:
# “Data come from the palmerpenguins package.” Hint: Take a look at the
# documentation for labs().

ggplot(data = penguins,
       aes(x=bill_length_mm, y=bill_depth_mm)) +
  geom_point(mapping=aes(color=species), na.rm=TRUE) +
  labs(caption=("Data come from the palmerpenguins package."))

# ------------------------------------------------------------------------------
# 8. Recreate the following visualization. What aesthetic should bill_depth_mm
# be mapped to? And should it be mapped at the global level or at the geom
# level?

# bill_depth_mm should be mapped for the color at the geom level.

ggplot(data=penguins,
       aes(x=flipper_length_mm, y=body_mass_g)) +
  geom_point(mapping = aes(color=bill_depth_mm)) +
  geom_smooth(method="gam")

# ------------------------------------------------------------------------------
# 9. Run this code in your head and predict what the output will look like.
# Then, run the code in R and check your predictions.
# ggplot(
#   data = penguins,
#   mapping = aes(x = flipper_length_mm, y = body_mass_g, color = island)
# ) +
#   geom_point() +
#   geom_smooth(se = FALSE)

# Since the color aesthetic is mapped to the variable 'island' at the global
# level, it will apply to both the scatter plot and the smooth line. As a
# result, ggplot will generate separate smooth lines for each island, each in a
# different color. If we want only one smooth line for all data points, the
# color mapping should be applied locally to geom_point(), not globally.

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = island)) +
  geom_smooth(se = FALSE)

# ------------------------------------------------------------------------------
# 10. Will these two graphs look different? Why/why not?
# ggplot(
#   data = penguins,
#   mapping = aes(x = flipper_length_mm, y = body_mass_g)
# ) +
#   geom_point() +
#   geom_smooth()
# 
# ggplot() +
#   geom_point(
#     data = penguins,
#     mapping = aes(x = flipper_length_mm, y = body_mass_g)
#   ) +
#   geom_smooth(
#     data = penguins,
#     mapping = aes(x = flipper_length_mm, y = body_mass_g)
#   )

# The two graphs will look the same. In the first version, the aesthetic mapping
# is defined globally in ggplot(), so it applies to all layers by default. In
# the second version, the same mapping is defined locally within each geom.
# Since both approaches use the same variables for the x and y axes, and no
# additional aesthetics differ between layers, the visual output will be
# identical.

# ------------------------------------------------------------------------------ 
#                         1.4 VISUALIZING DISTRIBUTIONS 
# ------------------------------------------------------------------------------ 

# ------------------------------------------------------------------------------ 
#                          1.4.1 A categorical variable 
# ------------------------------------------------------------------------------ 

# Making a bar plot
ggplot(penguins, aes(x=species)) +
  geom_bar()

# Reordering the bars by frequency, from most to least common
ggplot(penguins,
       aes(x=fct_infreq(species))) +
  geom_bar()

# ------------------------------------------------------------------------------ 
#                           1.4.2 A numerical variable 
# ------------------------------------------------------------------------------ 

# Making a histogram
ggplot(penguins,
       aes(x=body_mass_g)) +
  geom_histogram(binwidth = 200)

# Trying out different binwidth values
ggplot(penguins,
       aes(x=body_mass_g)) +
  geom_histogram(binwidth = 20)

ggplot(penguins,
       aes(x=body_mass_g)) +
  geom_histogram(binwidth = 2000)

ggplot(penguins,
       aes(x=body_mass_g)) +
  geom_histogram(binwidth = 500)

# Creating a density plot.
ggplot(penguins,
       aes(x=body_mass_g)) +
  geom_density()

# ------------------------------------------------------------------------------ 
#                                1.4.3 Exercises 
# ------------------------------------------------------------------------------ 

# 1. Make a bar plot of species of penguins, where you assign species to the y
# aesthetic. How is this plot different?

# This plot differs from the one where species is mapped to the x-axis because
# the bars are displayed horizontally instead of vertically. The orientation
# changes, but the counts and overall structure remain the same.

ggplot(penguins,
       aes(y=species)) +
  geom_bar()

# ------------------------------------------------------------------------------
# 2. How are the following two plots different? Which aesthetic, color or fill,
# is more useful for changing the color of bars?
# ggplot(penguins, aes(x = species)) +
#   geom_bar(color = "red")
# 
# ggplot(penguins, aes(x = species)) +
#   geom_bar(fill = "red")

# These two plots differ in how they apply color to the bars. In the first plot,
# the bars have a red border but retain the default gray fill. In the second
# plot, the bars are filled with red, making the color much more visually
# prominent. Typically, the fill aesthetic is more useful for changing the color
# of bars, as it affects the interior of the bar and is more noticeable than
# just the border.

# ------------------------------------------------------------------------------
# 3. What does the bins argument in geom_histogram() do?

# The bins argument in geom_histogram() controls how many intervals (bins) the
# data is divided into along the x-axis. It determines the number of bars shown
# in the histogram.

# ------------------------------------------------------------------------------
# 4. Make a histogram of the carat variable in the diamonds dataset that is
# available when you load the tidyverse package. Experiment with different
# binwidths. What binwidth reveals the most interesting patterns?

# After experimenting with binwidth values such as 1, 0.5, 0.25, and 0.01, I
# found that 0.01 reveals the most interesting patterns. With this binwidth, we
# can clearly see that diamonds are distributed across a wide range of carat
# values, but there is a noticeable concentration at rounded values ending in .0
# or .5 — such as 0.5, 1.0, 1.5, and 2.0. There's also a spike around 0.9 and
# 0.99 carats, which may suggest that some diamonds are marketed as 1.0 carat or
# that there are legal or economic incentives — such as export regulations or
# pricing thresholds — influencing this clustering.

ggplot(diamonds,
       aes(x=carat)) +
  geom_histogram(binwidth = 0.01)

# ------------------------------------------------------------------------------ 
#                         1.5 VISUALIZING RELATIONSHIPS 
# ------------------------------------------------------------------------------ 

# ------------------------------------------------------------------------------ 
#                  1.5.1 A numerical and a categorical variable 
# ------------------------------------------------------------------------------ 

# Making a boxplot 
ggplot(penguins,
       aes(x=species, y=body_mass_g)) +
  geom_boxplot()

# Plotting density curves
ggplot(penguins,
       aes(x=body_mass_g, color=species)) +
  geom_density(linewidth=0.75)

# Filling the density curves with transparent color for each species
ggplot(penguins,
       aes(x=body_mass_g, color=species, fill=species)) +
  geom_density(alpha=0.5)

# ------------------------------------------------------------------------------ 
#                        1.5.2 Two categorical variables 
# ------------------------------------------------------------------------------ 

# Bar plot showing the number of each species on each island
ggplot(penguins,
       aes(x=island, fill=species)) +
  geom_bar()

# Frequency plot showing the proportion of each species on each island
ggplot(penguins,
       aes(x=island, fill=species)) +
  geom_bar(position = "fill")

# ------------------------------------------------------------------------------ 
#                         1.5.3 Two numerical variables 
# ------------------------------------------------------------------------------

# Making a scatterplot
ggplot(penguins,
       aes(x=flipper_length_mm, y=body_mass_g)) +
  geom_point()

# ------------------------------------------------------------------------------ 
#                         1.5.4 Three or more variables 
# ------------------------------------------------------------------------------ 

# Making a scatterplot with multiple aesthetic mappings
ggplot(penguins,
       aes(x=flipper_length_mm, y=body_mass_g)) +
  geom_point(aes(color=species, shape=island))

# Creating a plot with subplots for each island
ggplot(penguins,
       aes(x=flipper_length_mm, y=body_mass_g)) +
  facet_wrap(~island)

# Adding scatterplots inside each subplot
ggplot(penguins,
       aes(x=flipper_length_mm, y=body_mass_g)) +
  geom_point() +
  facet_wrap(~island)

# Changing colors and shapes of the points in the scatterplots
ggplot(penguins,
       aes(x=flipper_length_mm, y=body_mass_g)) +
  geom_point(aes(color=species, shape=species)) +
  facet_wrap(~island)

# ------------------------------------------------------------------------------ 
#                                1.5.5 Exercises 
# ------------------------------------------------------------------------------ 

# 1. The mpg data frame that is bundled with the ggplot2 package contains 234
# observations collected by the US Environmental Protection Agency on 38 car
# models. Which variables in mpg are categorical? Which variables are numerical?
# (Hint: Type ?mpg to read the documentation for the dataset.) How can you see
# this information when you run mpg?

# Categorical variables: manufacturer, model, trans, drv, fl, class 
# Numerical variables: displ, year, cyl, cty, hwy 
# We can see this information by using functions like str(mpg) or glimpse(mpg),
# or by reading the dataset documentation with ?mpg. Checking the documentation
# is important because sometimes values look numeric but are actually codes for
# categories (for example, 1 = yes, 0 = no).

?mpg
str(mpg)

# ------------------------------------------------------------------------------
# 2. Make a scatterplot of hwy vs. displ using the mpg data frame. Next, map a
# third, numerical variable to color, then size, then both color and size, then
# shape. How do these aesthetics behave differently for categorical vs.
# numerical variables?

# Color and size can be mapped to numerical variables, but shape cannot — shape
# only works with categorical variables.

ggplot(mpg,
       aes(x=hwy, y=displ)) +
  geom_point(aes(color=cyl, size=cyl, shape=fl))

ggplot(mpg,
       aes(x=hwy, y=displ)) +
  geom_point(aes(color=cyl, size=cyl))

ggplot(mpg,
       aes(x=hwy, y=displ)) +
  geom_point(aes(size=cyl))

ggplot(mpg,
       aes(x=hwy, y=displ)) +
  geom_point(aes(color=cyl))

ggplot(mpg,
       aes(x=hwy, y=displ)) +
  geom_point()

# ------------------------------------------------------------------------------
# 3. In the scatterplot of hwy vs. displ, what happens if you map a third
# variable to linewidth?

# Mapping a variable to linewidth in a scatterplot has no visible effect,
# because linewidth applies to line geoms, not points. Since points do not have
# a line width, the aesthetic is ignored.

ggplot(mpg,
       aes(x=hwy, y=displ, linewidth=year)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy, linewidth = cyl)) +
  geom_line()

# ------------------------------------------------------------------------------
# 4. What happens if you map the same variable to multiple aesthetics?

# It usually works as expected, ggplot2 will map the variable to each
# aesthetic. This can highlight patterns, but using too many aesthetics may
# clutter the plot.

# ------------------------------------------------------------------------------
# 5.Make a scatterplot of bill_depth_mm vs. bill_length_mm and color the points
# by species. What does adding coloring by species reveal about the relationship
# between these two variables? What about faceting by species?

# Coloring the points by species shows that the relationship between bill depth
# and bill length varies across species, as the points form distinct clusters.
# Each species occupies a different area in the plot, indicating different
# typical bill shapes and sizes. Faceting by species makes this pattern even
# clearer by separating each species into its own panel. This removes overlap
# between groups, so we can more easily compare the shape and strength of the
# relationship within each species.

ggplot(penguins,
       aes(x=bill_depth_mm, y=bill_length_mm))+
  geom_point(aes(color=species)) +
  facet_wrap(~species)

ggplot(penguins,
       aes(x=bill_depth_mm, y=bill_length_mm)) +
  geom_point(aes(color=species))

# ------------------------------------------------------------------------------
# 6. Why does the following yield two separate legends? How would you fix it to
# combine the two legends?
# ggplot(
#   data = penguins,
#   mapping = aes(
#     x = bill_length_mm, y = bill_depth_mm,
#     color = species, shape = species
#   )
# ) +
#   geom_point() +
#   labs(color = "Species")

# The plot shows two separate legends because only the color aesthetic has a
# label set in labs(), while shape does not. We can fix this by providing labels
# for both color and shape, which combines them into a single, unified legend.

ggplot(penguins,
       aes(x=bill_length_mm, y=bill_depth_mm,
           color=species, shape=species)) +
  geom_point() +
  labs(color="Species", shape="Species")

# ------------------------------------------------------------------------------
# 7. Create the two following stacked bar plots. Which question can you answer
# with the first one? Which question can you answer with the second one?
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill")
ggplot(penguins, aes(x = species, fill = island)) +
  geom_bar(position = "fill")

# The first plot shows species proportions within islands. The second plot shows
# island proportions within each species.

# ------------------------------------------------------------------------------ 
#                             1.6 SAVING YOUR PLOTS 
# ------------------------------------------------------------------------------ 

getwd()
ggplot(penguins,
       aes(x=flipper_length_mm, y=body_mass_g)) +
  geom_point()
ggsave(filename = "penguin-plot.png")

# ------------------------------------------------------------------------------ 
#                                1.6.1 Exercises 
# ------------------------------------------------------------------------------ 

# 1. Run the following lines of code. Which of the two plots is saved as
# mpg-plot.png? Why?
# ggplot(mpg, aes(x = class)) +
#   geom_bar()
# ggplot(mpg, aes(x = cty, y = hwy)) +
#   geom_point()
# ggsave("mpg-plot.png")

# The scatterplot of cty vs hwy is saved as mpg-plot.png because ggsave() saves
# the most recently created plot.

# ------------------------------------------------------------------------------
# 2. What do you need to change in the code above to save the plot as a PDF
# instead of a PNG? How could you find out what types of image files would work
# in ggsave()?

# Change the filename extension to .pdf to save as a PDF. The output type is
# inferred from the extension, or can be set explicitly with the device
# argument. See ?ggsave for supported formats.

?ggsave
ggsave("mpg-plot.pdf")

# ------------------------------------------------------------------------------ 
#                             TIL - Today I Learned 
# ------------------------------------------------------------------------------ 

# 2025-10-29 -------------------------------------------------------------------
# When I saw the book started with ggplot2, I almost gave up. Since I first
# heard about it back in 2011, I could never grasp its logic. Good thing I
# didn’t — this time, it finally clicked. 📊

# 2025-10-30 -------------------------------------------------------------------
# Discovered that the shortcut for <- is just Ctrl + -. 🤯 Two keys instead of
# five! As a loyal <- user who refuses to type =, this feels like a huge win —
# and a reminder that even dinosaurs can learn new tricks. 🦖

# 2025-10-31 -------------------------------------------------------------------
# The Esc key literally means escape. It suddenly makes perfect sense — it gets
# us out of almost every computer-related danger.

# Another revelation: ggsave()! I used to save plots with pdf() or jpeg(). No
# wonder ggplot2 felt so awkward back then — I was mixing it with ancient ways.
# 🤯

# ------------------------------------------------------------------------------ 
