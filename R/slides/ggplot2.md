<style>
.small-code pre code {
  font-size: 1em;
}
</style>

ggplot2 - Data Visualization
========================================================
author: Ben Bellman
date: August 28, 2018
autosize: true
incremental: false

Base R Graphics
========================================================

- Base functions for graphics are ugly and outdated

- However, they can be useful in a pinch, especially `plot()`
    - Good example of methods in R
    - Different functionality for different classes
    - `plot.histogram()` vs. `plot.xy()`
    - Packages can add new methods
    - When in doubt, give `plot()` a try!

Advantages of ggplot2
========================================================

- Standard function and syntax for any plot, regardless of style

- Uses logic similar to dplyr and piping
- Full suite of functions for customizing graphs
- Clean and professional visual styles
- Lots of accessory packages, like `ggmap` and `gganimate`

Logic of ggplot2
========================================================

- Initialize with ```ggplot()```function
- Define data and ```aes()``` arguments:
    - Columns for x and y axes
    - Data groupings, etc.
- Define plot type (geometry), color schemes, labels, etc. with additional functions
    - These can have their own ```aes()``` settings
- Connect functions using ```+``` operator, like ```%>%``` in ```dplyr```

Some aes() arguments
========================================================

Argument  | Property
------------- | -------------
x  |  x values
y  |  y values
col  |  color of line/point
fill  |  color of area
alpha  |  transparency
size  |  size of point/line
shape  |  point symbol

Setting up
========================================================
class: small-code
We'll start with the White House salaries data from the ```dplyr``` slides

```r
library(tidyverse)
library(here)

salaries <- read_csv(here("data","white-house-salaries.csv"))

# create the tenure variable
salaries <- salaries %>%
  rename(name = employee_name) %>%
  arrange(name) %>%
  group_by(name) %>%
  mutate(tenure = rank(year))
```

Starting
========================================================
class: small-code
Once we've initialized with ```ggplot()```, we add a geometry feature to generate a basic graph

```r
ggplot(salaries, aes(x = year, y = salary)) +
  geom_point()
```

Starting a plot
========================================================
class: small-code
![plot of chunk plot1_1](ggplot2-figure/plot1_1-1.png)

Starting a plot
========================================================

- When using new plot types, I like to look up its page on the package website

- Lets take a look at the `geom_point()` documentation and see some ways it can be used:
- https://ggplot2.tidyverse.org/reference/geom_point.html

Building geometries
========================================================
class: small-code

```r
ggplot(salaries, aes(x = year, y = salary)) +
  geom_point(alpha = .1) + 
  geom_smooth(aes(col = gender, fill = gender), method = "loess")
```


Building geometries
========================================================
class: small-code
![plot of chunk plot2_1](ggplot2-figure/plot2_1-1.png)


Labels
========================================================
class: small-code
There are functions for changing plot text, axis formats, and specifying colors and legends

```r
ggplot(salaries, aes(x = year, y = salary)) +
  geom_point(alpha = .05) +                              # alpha sets transparency
  geom_smooth(aes(col = gender), method = "loess") +     # color by gender
  labs(x = "Year",                                       # change labels
       y = "Employee Salary for Year ($)",
       title = "White House Salaries Since 2001") +
  scale_color_manual(name = "Gender",                    # set legend attributes
                       values = c("green", "blue"),
                       breaks = c("female", "male"),
                       labels = c("Women", "Men"))
```


Labels
========================================================
class: small-code
![plot of chunk plot3_1](ggplot2-figure/plot3_1-1.png)

Themes
========================================================
class: small-code
Other functions change the overall look if the grid

```r
ggplot(salaries, aes(x = year, y = salary)) +
  geom_point(alpha = .05) + 
  geom_smooth(aes(col = gender), method = "loess") +
  theme_minimal()
```
- Also possible to create custom themes

Themes
========================================================
class: small-code
![plot of chunk plot4_1](ggplot2-figure/plot4_1-1.png)


Scales, colors, and more
========================================================
- Functions for defining scales
    - ```scale_x_continuous()```, ```scale_y_discrete()```, ```scale_x_log10()```, ```scale_y_reverse()```, etc.
- Set scale limits
    - ```xlim()``` and ```ylim()```
- Functions for custom color/symbol schemes
    - Customize with ```scale_color_discrete()``` and ```scale_color_manual()```
    - Reliable schemes with ```scale_color_brewer()```
    - ```scale_size_manual()```, ```scale_shape_manual()```, ```scale_alpha_manual()```, etc.

Scales, colors, and more
========================================================
- Add extra lines
    - ```geom_abline()```, ```geom_vline()```, ```geom_hline()```
- Define colorbar and legend
    - ```guide_colorbar()``` and ```guide_legend()```
- Faceting multiple plots into one window
    - ```facet_grid()``` and ```facet_wrap()```
- Lots of `theme()` options

Navigating ggplot2 functions
========================================================
- There is a huge number of functions in ggplot2
    - Can't memorize them all
    - Important to use documentation and experiment
    - http://ggplot2.tidyverse.org/reference/
- If you can dream it, you can built it!
- Let's look at more examples

Histogram
========================================================
class: small-code
Create a histogram of salaries

```r
salaries %>%
ggplot(aes(x = salary)) +
  geom_histogram()
```

Histogram
========================================================
class: small-code
![plot of chunk plot5_1](ggplot2-figure/plot5_1-1.png)

Histogram
========================================================
class: small-code
- Let's stack the area according to president and change the bin width

```r
salaries %>%
ggplot(aes(x = salary, fill = president)) +
  geom_histogram(binwidth = 5000)
```

Histogram
========================================================
class: small-code
![plot of chunk plot7_1](ggplot2-figure/plot7_1-1.png)

Box plots
========================================================
class: small-code
Look at salaries for 1-5 years of tenure

```r
salaries %>%
  filter(tenure >= 1 & tenure <= 5) %>%
  ggplot(aes(tenure, salary, group = tenure)) +
    geom_boxplot(aes(fill = as.factor(tenure))) +
    scale_fill_brewer(palette = "Accent")
```


Box plots
========================================================
![plot of chunk plot6_1](ggplot2-figure/plot6_1-1.png)


Violin plots
========================================================
class: small-code
Look at salaries for 1-5 years of tenure

```r
salaries %>% 
  ggplot(aes(tenure, salary, group = as.factor(tenure))) +
    geom_violin(aes(col = as.factor(tenure),
                    fill = as.factor(tenure))) +
    theme(legend.position="none") +
    coord_flip()
```


Violin plots
========================================================
![plot of chunk plot8_1](ggplot2-figure/plot8_1-1.png)


Density and facet plots
========================================================
class: small-code
Look at salaries for 1-5 years of tenure

```r
salaries %>%
  ggplot(aes(salary, col = gender, fill = gender)) +
    geom_density(alpha = 0.4) +
    facet_grid(president ~ .)
```


Density and facet plots
========================================================
![plot of chunk plot9_1](ggplot2-figure/plot9_1-1.png)

Saving plots
========================================================
class: small-code
- It's easy to save plots with `ggsave()`
- It determines output from the extension in the file path 
- `here()` is creating a new folder in the project

```r
salaries %>%
  ggplot(aes(salary, col = gender, fill = gender)) +
    geom_density(alpha = 0.4) +
    facet_grid(president ~ .) +
    ggsave(here("results", "test_plot.pdf"), width = 5, height = 4)
```

Saving plots
========================================================
![plot of chunk unnamed-chunk-3](ggplot2-figure/unnamed-chunk-3-1.png)


Questions and Ideas?
========================================================
- That's all the material for today
- Let's spend rest of time working independently or in groups
    - On this data or own data
    - I can answer any questions you run into
- Or work through questions and ideas together?

