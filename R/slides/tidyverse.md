<style>
.small-code pre code {
  font-size: 1em;
}
</style>

Data Manipulation - tidyverse and dplyr
========================================================
author: Ben Bellman
date: August 28, 2018
autosize: true
incremental: false

tidyverse vs. base R
========================================================

- So far, material has been from base packages

- Some base functions are still useful, but it's dated

- Instead, I want you to learn the ```tidyverse```:
    - A foundational suite of packages for data analysis
    - A philosphy about programming style and best practices
    - People are increasingly making R "tidy"
    - ```sf```, ```tidytext```, ```tidygraph```, ```tidybayes```, etc.
    - Spearheaded by RStudio development team
    
Loading packages
========================================================
class: small-code
- We can manage packages through commands

- Install them once, but library at the start of every session


```r
install.packages("tidyverse")
library(tidyverse)
```



The tidyverse Suite
========================================================

- These slides cover:
    - ```tibble``` : A "modern" version of a data frame
    - ```readr``` : Tools for importing text data files
    - ```dplyr``` : Tools for data manipulation and analysis
    - some other tidy extras I find useful!

- Includes five other core packages, like ```ggplot2``` and ```stringr```


The tidyverse Philosophy
========================================================

- Tidy data is data where: 
    1. Each variable is in a column.
    2. Each observation is a row. 
    3. Each value is a cell.

- Code is written to be human legible, read sequentially
    - Implemented with ```%>%```, the piping operator

- Can conflict with other packages
    - Partly motivates the new tidy dev push
    

The Tibble
========================================================
class: small-code
- ```tibble``` package introduces a data frame variant: ```"tbl"```
- Some useful technical differences
    - Good console printing
    - No row names
    - Does not convert character columns to factors

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
library(here)
salaries <- read_csv(here("data","white-house-salaries.csv"))

# useful tibble function to preview data
glimpse(salaries)
```

```
Observations: 7,108
Variables: 9
$ employee_name <chr> "abraham, yohannes a", "abrams, adam w", "adams,...
$ salary        <dbl> 40000, 65000, 36000, 92000, 42800, 130500, 57000...
$ position      <chr> "legislative assistant and assistant to the hous...
$ year          <int> 2009, 2009, 2009, 2009, 2009, 2009, 2009, 2009, ...
$ status        <chr> "employee", "employee", "employee", "employee", ...
$ party         <chr> "democrat", "democrat", "democrat", "democrat", ...
$ president     <chr> "obama", "obama", "obama", "obama", "obama", "ob...
$ term          <chr> "first", "first", "first", "first", "first", "fi...
$ gender        <chr> "male", "male", "male", "male", "female", "male"...
```

readr + haven + readxl
========================================================
class: small-code
- The ```haven``` package extends the ```read_``` family to data from other statistics software formats
    - ```read_dta()```
    - ```read_sas()```
    - ```read_spss()```
- The ```readxl``` package loads Excel spreadsheets into R
    - ```read_xlsx()```
- Must be installed and loaded separately

Starting with dplyr
========================================================

- ```dplyr``` is how we can manipulate the data and run calculations
- Five main functions or "verbs" that operate on data frames
     - ```select()``` picks variables based on their names.
     - ```filter()``` picks cases based on their values.
     - ```arrange()``` changes the ordering of the rows.
     - ```mutate()``` adds new variables that are functions of existing variables
     - ```summarise()``` calculates single values from many rows.
- Other important functions and variants included
    - e.g. ```group_by()``` and ```ungroup()```
    
Starting with dplyr
========================================================

- Functions in ```dplyr``` always take a data frame as the first argment

- Subsequent arguments will refer to variables, or define new variables

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
names(salaries)    # base R, read/change vector of column names
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
   president party     year
   <chr>     <chr>    <int>
 1 obama     democrat  2009
 2 obama     democrat  2009
 3 obama     democrat  2009
 4 obama     democrat  2009
 5 obama     democrat  2009
 6 obama     democrat  2009
 7 obama     democrat  2009
 8 obama     democrat  2009
 9 obama     democrat  2009
10 obama     democrat  2009
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
   salary status  
    <dbl> <chr>   
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
- ```rename()``` returns the full data, but changes variable names


```r
rename(salaries, name = employee_name)
```

```
# A tibble: 7,108 x 9
   name    salary position        year status party president term  gender
   <chr>    <dbl> <chr>          <int> <chr>  <chr> <chr>     <chr> <chr> 
 1 abraha…  40000 legislative a…  2009 emplo… demo… obama     first male  
 2 abrams…  65000 western regio…  2009 emplo… demo… obama     first male  
 3 adams,…  36000 executive ass…  2009 emplo… demo… obama     first male  
 4 agnew,…  92000 deputy direct…  2009 emplo… demo… obama     first male  
 5 ahrens…  42800 operator        2009 emplo… demo… obama     first female
 6 aldy, … 130500 special assis…  2009 emplo… demo… obama     first male  
 7 alvara…  57000 domestic dire…  2009 emplo… demo… obama     first female
 8 amorsi…  54768 special assis…  2009 emplo… demo… obama     first male  
 9 anders…  55000 executive ass…  2009 emplo… demo… obama     first female
10 anders…  50000 policy assist…  2009 emplo… demo… obama     first male  
# ... with 7,098 more rows
```

filter() function
========================================================
class: small-code
- Uses logical statements to subset rows, like if-statements in Stata
    - Returns rows where statement is true

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
x OR y | <code>x &#124; y</code>
x AND y | ```x & y```
x within the set of y | ```x %in% y```
x is missing | `is.na(x)`

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
  employee_name  salary position  year status party president term  gender
  <chr>           <dbl> <chr>    <int> <chr>  <chr> <chr>     <chr> <chr> 
1 davies, susan… 130500 special…  2009 emplo… demo… obama     first female
2 davis, christ…  75000 senior …  2009 emplo… demo… obama     first male  
3 de sio, jr, h… 153300 deputy …  2009 emplo… demo… obama     first male  
4 de vos, erica   60000 directo…  2009 emplo… demo… obama     first male  
5 deese, brian c 130500 special…  2009 emplo… demo… obama     first male  
6 deguzman, bri…  41900 operator  2009 emplo… demo… obama     first male  
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
   employee_name salary position  year status party president term  gender
   <chr>          <dbl> <chr>    <int> <chr>  <chr> <chr>     <chr> <chr> 
 1 abbot, anita…  55500 ethics …  2001 emplo… repu… bush      first female
 2 abdullah, ha… 105960 policy …  2015 detai… demo… obama     seco… male  
 3 aberger, mar…  42000 press a…  2012 emplo… demo… obama     first female
 4 aberger, mar…  42000 press a…  2013 emplo… demo… obama     first female
 5 abizaid, chr… 156552 advisor…  2016 detai… demo… obama     seco… female
 6 abney, allen…  45000 spokesm…  2003 emplo… repu… bush      first male  
 7 abney, allen…  45000 spokesm…  2004 emplo… repu… bush      first male  
 8 abney, allen…  55000 spokesm…  2005 emplo… repu… bush      seco… male  
 9 abraham, sab…  55000 energy …  2015 emplo… demo… obama     seco… male  
10 abraham, yoh…  40000 legisla…  2009 emplo… demo… obama     first male  
# ... with 7,098 more rows
```

arrange() function
========================================================
class: small-code
- The `desc()` function sorts in descending order

```r
arrange(salaries, desc(salary))
```

```
# A tibble: 7,108 x 9
   employee_name salary position  year status party president term  gender
   <chr>          <dbl> <chr>    <int> <chr>  <chr> <chr>     <chr> <chr> 
 1 wheeler, set… 225000 senior …  2013 detai… demo… obama     first male  
 2 marcozzi, da… 192934 directo…  2009 detai… demo… obama     first male  
 3 house, mark s 187100 senior …  2017 detai… repu… trump     first male  
 4 hash, michae… 179700 deputy …  2010 detai… demo… obama     first male  
 5 love, timoth… 179700 policy …  2010 detai… demo… obama     first male  
 6 bannon, step… 179700 assista…  2017 emplo… repu… trump     first male  
 7 bossert, tho… 179700 assista…  2017 emplo… repu… trump     first male  
 8 bremberg, an… 179700 assista…  2017 emplo… repu… trump     first male  
 9 conway, kell… 179700 assista…  2017 emplo… repu… trump     first female
10 dearborn, ri… 179700 assista…  2017 emplo… repu… trump     first male  
# ... with 7,098 more rows
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
- Useful if you only need the result

```r
transmute(salaries, in_1000s = salary / 1000)
```

```
# A tibble: 7,108 x 1
   in_1000s
      <dbl>
 1     40  
 2     65  
 3     36  
 4     92  
 5     42.8
 6    130. 
 7     57  
 8     54.8
 9     55  
10     50  
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
    - Adds group metadata to data object, which is removed with `ungroup()`
    - Grouping affects behavior of functions
    - ```summarise()``` output will have grouping variable as a column

```r
salaries %>%
  group_by(gender) %>%
  summarise(mean_salary = mean(salary))
```

```
# A tibble: 2 x 2
  gender mean_salary
  <chr>        <dbl>
1 female      70413.
2 male        82301.
```

Using the "pipe" operator
========================================================
- The ```%>%``` operator is the glue of ```tidyverse``` style
    - Originally from ```magrittr``` package
- Readable way to nest functions
- Automatically inserts previous object/result into the first argument of the next function
    - Creates recipe-like style, each process appears in sequence
    - The result being "piped" can also be referenced with the `.` placeholder


Using the dplyr workflow
========================================================
class: small-code
- Let's practice using these functions together

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
 1  2001      58042.
 2  2003      65794.
 3  2004      65794.
 4  2005      64580.
 5  2006      65928.
 6  2007      69894.
 7  2008      74257.
 8  2009      80384.
 9  2010      82721.
10  2011      81765.
11  2012      80843.
12  2013      82304.
13  2014      82844.
14  2015      84864.
15  2016      84224.
16  2017      94872 
```


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
   name                 tenure salary
   <chr>                 <dbl>  <dbl>
 1 abbot, anita k            1  55500
 2 abdullah, hasan a         1 105960
 3 aberger, marie e          1  42000
 4 aberger, marie e          2  42000
 5 abizaid, christine s      1 156552
 6 abney, allen k            1  45000
 7 abney, allen k            2  45000
 8 abney, allen k            3  55000
 9 abraham, sabey m          1  55000
10 abraham, yohannes a       1  40000
# ... with 7,098 more rows
```

========================================================
class: small-code
- Analyze employees by total tenure in White House

```r
by_tenure <- salaries %>% 
  group_by(name) %>%                      # look by employee
  summarise(tenure = max(tenure)) %>%     # get full tenure length
  group_by(tenure) %>%                    # new grouping by tenure
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
   tenure count     pct
    <dbl> <int>   <dbl>
 1      1  1593 48.0   
 2      2   832 25.1   
 3      3   459 13.8   
 4      4   185  5.57  
 5      5   100  3.01  
 6      6    63  1.90  
 7      7    27  0.813 
 8      8    24  0.723 
 9      9     9  0.271 
10     10     4  0.120 
11     11     5  0.151 
12     12     1  0.0301
13     13     3  0.0903
14     14     3  0.0903
15     15     2  0.0602
16     16    11  0.331 
```


Questions?
========================================================

- Resources
    - https://www.tidyverse.org/
    - Online book: *R for Data Science* (http://r4ds.had.co.nz/)
    - [base R vs. `tidyverse` code](https://www.significantdigits.org/2017/10/switching-from-base-r-to-tidyverse/)
    - RStudio cheatsheets
        - Help menu -> Cheatsheets

