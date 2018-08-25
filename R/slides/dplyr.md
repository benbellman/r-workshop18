<style>
.small-code pre code {
  font-size: 1em;
}
</style>

dplyr - Data Manipulation
========================================================
author: Ben Bellman
date: August 29, 2017
autosize: true
incremental: true

Frameworks for Extending R
========================================================

- So far, material has been from base packages
- Packages offer special tools for loading and manipulating data
    - ```data.table``` package for big data
    - ```sp``` package for spatial data and GIS
- We will focus on the ```tidyverse```
    - Suite of six integrated packages for data analysis
    - Other packages use same framework
    - Some of the most popular R extensions
    
Loading packages
========================================================
class: small-code
- We can manage packages through commands


```r
#Install from "cloud", automatically selects CRAN mirror
install.packages("tidyverse", repos = 0)
```

- Only install once, but must load into library each session


```r
library(tidyverse)
```

The tidyverse Suite
========================================================

- ```tibble``` : A "modern" version of a data frame

- ```purrr``` : Tools for programming functions
- ```readr``` : Tools for importing text data files
- ```tidyr``` : Tools for cleaning and transforming data
- ```dplyr``` : Tools for data manipulation and analysis
- ```ggplot2``` : Tools for data visualization

The tidyverse Philosophy
========================================================

- ```tidyverse``` is a cohorent suite based on guiding principles
        - Lead by Hadley Wickham, Head Scientist and RStudio

- Tidy data is data where: 
    1. Each variable is in a column.
    2. Each observation is a row. 
    3. Each value is a cell.

- Code is written to be legible, read sequentially
    - Implemented with ```%>%```, the piping operator

- However, can conflict with other packages
    

The Tibble
========================================================
class: small-code
- ```tibble``` introduces a data frame variant ```"tbl"```
    - Essentially the same, but there are some technical differences

```r
tbl <- tibble(
  x = 1:4, 
  y = 1, 
  z = x ^ 2 + y
)
tbl
```

```
# A tibble: 4 x 3
      x     y     z
  <int> <dbl> <dbl>
1     1     1     2
2     2     1     5
3     3     1    10
4     4     1    17
```

The Tibble
========================================================
class: small-code
- Referencing tibbles by column:

```r
tbl$x
```

```
[1] 1 2 3 4
```

```r
tbl[["x"]]
```

```
[1] 1 2 3 4
```

```r
tbl[[1]]
```

```
[1] 1 2 3 4
```

Using readr
========================================================

- Introduces new family of ```read_``` functions
    - ```read_csv()```: comma separated (CSV) files
    - ```read_tsv()```: tab separated files
    - ```read_delim()```: general delimited files
    - ```read_fwf()```: fixed width files
    - ```read_table()```: tabular files where colums are separated by white-space.
    - ```read_log()```: web log files
- Functions from ```readr``` return data as tibbles

Using readr
========================================================
class: small-code
- Automatically prints class of columns

```r
salaries <- read_csv("~/Google Drive/Computer Backup/R Workshop/Data/white-house-salaries.csv")
salaries
```

```
# A tibble: 7,108 x 9
          employee_name salary
                  <chr>  <dbl>
 1  abraham, yohannes a  40000
 2       abrams, adam w  65000
 3         adams, ian h  36000
 4       agnew, david p  92000
 5    ahrens, rebecca a  42800
 6   aldy, jr, joseph e 130500
 7 alvarado, lissette a  57000
 8  amorsingh, lucius l  54768
 9   anderson, amanda d  55000
10  anderson, charles d  50000
# ... with 7,098 more rows, and 7 more variables: position <chr>,
#   year <int>, status <chr>, party <chr>, president <chr>, term <chr>,
#   gender <chr>
```

readr + haven + readxl
========================================================
class: small-code
- The ```haven``` package extends the ```read_``` family to data from other stats packages
    - ```read_dta()```
    - ```read_sas()```
    - ```read_spss()```
- The ```readxl``` package loads Excel spreadsheets into R
- Must be loaded separately from ```tidyverse```

```r
install.packages("haven", repos = 0)
install.packages("readxl", repos = 0)
library(haven)
library(readxl)
```

Starting with dplyr
========================================================

- ```dplyr``` is how we can manipulate the data and run calculations
    - Similar to working in STATA
- Based on five main functions or "verbs"
     - ```select()``` picks variables based on their names.
     - ```filter()``` picks cases based on their values.
     - ```arrange()``` changes the ordering of the rows.
     - ```summarise()``` reduces multiple values down to a single summary.
     - ```mutate()``` adds new variables that are functions of existing variables
- Other functions and variants included

Practice Data
========================================================

- We will use the White House Salaries dataset to learn these functions.
- Nine variables
    - Employee name, inferred gender
    - Salary
    - Position, full/part time status, year
    - President, party, term
- [Link to data.world page](https://data.world/chipoglesby/whitehousesalaries/workspace/file?filename=white-house-salaries.csv) for downloading and more info

select() function
========================================================
class: small-code
- ```select()``` creates a new tibble, keeping only the desired columns


```r
names(salaries)
```

```
[1] "employee_name" "salary"        "position"      "year"         
[5] "status"        "party"         "president"     "term"         
[9] "gender"       
```

```r
select(salaries, president, party, year)
```

```
# A tibble: 7,108 x 3
   president    party  year
       <chr>    <chr> <int>
 1     obama democrat  2009
 2     obama democrat  2009
 3     obama democrat  2009
 4     obama democrat  2009
 5     obama democrat  2009
 6     obama democrat  2009
 7     obama democrat  2009
 8     obama democrat  2009
 9     obama democrat  2009
10     obama democrat  2009
# ... with 7,098 more rows
```

select() function
========================================================
class: small-code
- There are other functions that work inside of ```select()```
- See: ```starts_with()``` or ```contains()``` or ```matches()```


```r
select(salaries, starts_with("s"))
```

```
# A tibble: 7,108 x 2
   salary   status
    <dbl>    <chr>
 1  40000 employee
 2  65000 employee
 3  36000 employee
 4  92000 employee
 5  42800 employee
 6 130500 employee
 7  57000 employee
 8  54768 employee
 9  55000 employee
10  50000 employee
# ... with 7,098 more rows
```

rename() function
========================================================
class: small-code
- ```rename()``` works like ```select```, but changes variable names
    - keeps variables that aren't specified
    - new column name goes on left hand side


```r
rename(salaries, name = employee_name)
```

```
# A tibble: 7,108 x 9
                   name salary
                  <chr>  <dbl>
 1  abraham, yohannes a  40000
 2       abrams, adam w  65000
 3         adams, ian h  36000
 4       agnew, david p  92000
 5    ahrens, rebecca a  42800
 6   aldy, jr, joseph e 130500
 7 alvarado, lissette a  57000
 8  amorsingh, lucius l  54768
 9   anderson, amanda d  55000
10  anderson, charles d  50000
# ... with 7,098 more rows, and 7 more variables: position <chr>,
#   year <int>, status <chr>, party <chr>, president <chr>, term <chr>,
#   gender <chr>
```


filter() function
========================================================
class: small-code
- Uses logical statements to subset rows, like if statements in STATA
    - Returns tibble of data where statement is true

```r
yr_2013 <- filter(salaries, year == 2013)
unique(yr_2013$year)
```

```
[1] 2013
```

```r
unique(yr_2013$president)
```

```
[1] "obama"
```

Logical operators
========================================================

Description | Symbol
------------- | -------------
less than | ```<```
less than or equal to | ```<=```
greater than | ```>```
greater than or equal to | ```>=```
exactly equal to | ```==```
not equal to | ```!=```
Not x | ```!x```
x OR y | ```x \\| y```
x AND y | ```x & y```
x within the set of y | ```x %in% y```

slice() function
========================================================
class: small-code
- ```slice()``` lets you subset rows by order in the table
    - Similar to using ```[, ]``` notation

```r
slice(salaries, 100:105)
```

```
# A tibble: 6 x 9
         employee_name salary
                 <chr>  <dbl>
1      davies, susan m 130500
2 davis, christopher e  75000
3  de sio, jr, henry f 153300
4        de vos, erica  60000
5       deese, brian c 130500
6    deguzman, brian k  41900
# ... with 7 more variables: position <chr>, year <int>, status <chr>,
#   party <chr>, president <chr>, term <chr>, gender <chr>
```


arrange() function
========================================================
class: small-code
- Lets you reorder data rows according to variables
     - Returns tibble, where ```base::order()``` returns row numbers
     - use ```select()``` to reorder columns

```r
arrange(salaries, employee_name, year)
```

```
# A tibble: 7,108 x 9
          employee_name salary
                  <chr>  <dbl>
 1       abbot, anita k  55500
 2    abdullah, hasan a 105960
 3     aberger, marie e  42000
 4     aberger, marie e  42000
 5 abizaid, christine s 156552
 6       abney, allen k  45000
 7       abney, allen k  45000
 8       abney, allen k  55000
 9     abraham, sabey m  55000
10  abraham, yohannes a  40000
# ... with 7,098 more rows, and 7 more variables: position <chr>,
#   year <int>, status <chr>, party <chr>, president <chr>, term <chr>,
#   gender <chr>
```

arrange() function
========================================================
class: small-code

```r
arrange(salaries, -salary)
```

```
# A tibble: 7,108 x 9
         employee_name salary
                 <chr>  <dbl>
 1     wheeler, seth f 225000
 2   marcozzi, david e 192934
 3       house, mark s 187100
 4     hash, michael m 179700
 5     love, timothy p 179700
 6   bannon, stephen k 179700
 7   bossert, thomas p 179700
 8  bremberg, andrew p 179700
 9 conway, kellyanne e 179700
10   dearborn, ricky a 179700
# ... with 7,098 more rows, and 7 more variables: position <chr>,
#   year <int>, status <chr>, party <chr>, president <chr>, term <chr>,
#   gender <chr>
```


mutate() function
========================================================
class: small-code
- Creates new variables based on other

```r
new <- mutate(salaries, in_1000s = salary / 1000)
names(new)
```

```
 [1] "employee_name" "salary"        "position"      "year"         
 [5] "status"        "party"         "president"     "term"         
 [9] "gender"        "in_1000s"     
```

```r
summary(new$in_1000s)
```

```
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
   0.00   45.00   61.95   76.41  102.00  225.00 
```


transmute() function
========================================================
class: small-code
- ```transmute()``` works the same way, but only returns new columns

```r
transmute(salaries, in_1000s = salary / 1000)
```

```
# A tibble: 7,108 x 1
   in_1000s
      <dbl>
 1   40.000
 2   65.000
 3   36.000
 4   92.000
 5   42.800
 6  130.500
 7   57.000
 8   54.768
 9   55.000
10   50.000
# ... with 7,098 more rows
```

if_else() function
========================================================
class: small-code
- Useful for creating dummy variables, applying functions based on a conditional statement

```r
new <- transmute(salaries, democrat = if_else(party == "democrat", 1, 0))
summary(new)
```

```
    democrat     
 Min.   :0.0000  
 1st Qu.:0.0000  
 Median :1.0000  
 Mean   :0.5262  
 3rd Qu.:1.0000  
 Max.   :1.0000  
```

summarise() function
========================================================
class: small-code
- ```summarise()``` returns a new tibble with results of aggregate functions
    - Best used with ```group_by()``` function
    - Creates a "grouped" table, object can also be ungrouped
    - ```summarise()``` output will have grouping variable as a column

```r
salaries %>%
  group_by(gender) %>%
  summarise(mean_salary = mean(salary))
```

```
# A tibble: 2 x 2
  gender mean_salary
   <chr>       <dbl>
1 female    70412.61
2   male    82301.18
```

Using the "pipe" operator
========================================================
- The ```%>%``` operator is the glue of ```tidyverse``` style
    - Originally from ```magrittr``` package
- Readable way to nest functions
- Automatically inserts previous object/output into the first argument of the next function
    - Creates "recipe" like style, each process appears in sequence
    - The result being "piped" can also be referenced elsewhere with the ```.``` placeholder


Using the dplyr workflow
========================================================
class: small-code
- Let's practice using these functions together
- Now we can introduce some functions for graphs and statistics from the base packages

```r
by_year <- salaries %>%
  group_by(year) %>%
  summarise(mean_salary = mean(salary))
by_year
```

```
# A tibble: 16 x 2
    year mean_salary
   <int>       <dbl>
 1  2001    58042.17
 2  2003    65793.63
 3  2004    65793.63
 4  2005    64580.45
 5  2006    65928.33
 6  2007    69893.72
 7  2008    74257.32
 8  2009    80384.44
 9  2010    82721.34
10  2011    81765.34
11  2012    80843.14
12  2013    82303.87
13  2014    82844.13
14  2015    84864.12
15  2016    84223.62
16  2017    94872.00
```

========================================================
class: small-code

```r
#generate bar chart
barplot(height = by_year$mean_salary,
        names.arg = by_year$year,
        main = "Mean Salary by Year")
```

![plot of chunk barplot](dplyr-figure/barplot-1.png)


========================================================
class: small-code
- Let's create a new column with the length of tenure in years

```r
salaries <- salaries %>%
  rename(name = employee_name) %>%
  arrange(name) %>%
  group_by(name) %>%
  mutate(tenure = rank(year))

select(salaries, name, tenure, salary)
```

```
# A tibble: 7,108 x 3
# Groups:   name [3,321]
                   name tenure salary
                  <chr>  <dbl>  <dbl>
 1       abbot, anita k      1  55500
 2    abdullah, hasan a      1 105960
 3     aberger, marie e      1  42000
 4     aberger, marie e      2  42000
 5 abizaid, christine s      1 156552
 6       abney, allen k      1  45000
 7       abney, allen k      2  45000
 8       abney, allen k      3  55000
 9     abraham, sabey m      1  55000
10  abraham, yohannes a      1  40000
# ... with 7,098 more rows
```

========================================================
class: small-code
- Salary distribution by years in White House

```r
boxplot(salaries$salary ~ salaries$tenure)
```

![plot of chunk unnamed-chunk-20](dplyr-figure/unnamed-chunk-20-1.png)

========================================================
class: small-code
- Analyze employees by total tenure in White House

```r
by_tenure <- salaries %>% 
  group_by(name) %>%      # limit by employee
  arrange(name, tenure) %>%
  summarise(tenure = last(tenure)) %>%
  group_by(tenure) %>%    #analyze by tenure length
  summarise(count = n()) %>%
  mutate(pct = count / sum(count) * 100)
```

========================================================
class: small-code

```r
by_tenure
```

```
# A tibble: 16 x 3
   tenure count         pct
    <dbl> <int>       <dbl>
 1      1  1593 47.96747967
 2      2   832 25.05269497
 3      3   459 13.82113821
 4      4   185  5.57061126
 5      5   100  3.01114122
 6      6    63  1.89701897
 7      7    27  0.81300813
 8      8    24  0.72267389
 9      9     9  0.27100271
10     10     4  0.12044565
11     11     5  0.15055706
12     12     1  0.03011141
13     13     3  0.09033424
14     14     3  0.09033424
15     15     2  0.06022282
16     16    11  0.33122553
```

========================================================
class: small-code

```r
pie(by_tenure$pct, labels = by_tenure$tenure)
```

![plot of chunk unnamed-chunk-23](dplyr-figure/unnamed-chunk-23-1.png)

Any Questions?
========================================================
Try to think of questions for data we can answer together

- Resources
    - https://www.tidyverse.org/
    - Online book: *R for Data Science* (http://r4ds.had.co.nz/)
    - RStudio cheatsheets
        - Help menu -> Cheatsheets

