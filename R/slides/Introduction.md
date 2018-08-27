<style>
.small-code pre code {
  font-size: 1em;
}
</style>

Introduction to R
========================================================
author: Ben Bellman
date: August 28, 2018
autosize: true
incremental: false

What is R?
========================================================

"R is an integrated suite of software facilities for data manipulation, calculation and graphical display." (R Project website)

- Provides eight base packages for computing and data analysis

- True strength of R is development commpunity, wealth of packages

- Huge range of tools, R is becoming a flagship for academic software

- Open source, ethos of reproducability and sharing


- I think of R as an ecosystem
- All kinds of packages
    - Foundational, popular, niche, big, small, etc.
    
My goals for workshop
========================================================

- Introduce syntax and key functions
- Showcase cool packages and functionality
- Give you tools to start working with
- But, these two days aren't enough!
    - Find projects, work on short term goals
    - Trial, error, pain, and Google!
    - Working group, collaboration and sharing
    - Resources at end of these slides
    
Using RStudio
========================================================

- Lots of tools
- Intuitive and informative layout
- Provides GUI for R environment with four panels:
    - R console and system terminal
    - Code and data viewer
    - Plot viewer (and other stuff)
    - Objects in environment (and other stuff)
- Let's take a look!

Plan for Workshop
========================================================

- **Tues. Morning:** 
    - Introduction to R, Data Manipulation (```tidyverse``` and ```dplyr```)
- **Tues. Afternoon:** 
    - Data Visualization (```ggplot2```), Stats and Modeling
- **Wed. Morning:** 
    - Cleaning Data, Advanced Topics
- **Wed. Afternoon:** 
    - Twitter + Census APIs, network analysis, spatial data, web scraping

Basics: Anatomy of a command
========================================================

```r
obj <- funct(arg1 = data,
             arg2 = T,
             arg3 = "setting",
             ...)
```

- ```obj``` = output is stored in object
- ```<-``` = the assignment operator for storing results
    - Results are printed to console if no assignment
- ```funct``` = name of function being called
- ```arg1``` = first argument is usually object/data being operated on
- ```arg2, arg3``` = additional arguments that change how ```funct``` works
    - Can refer to true/false value, different methods, etc.
    - Have default values, so not always necessary to use them
    - Functions also assume argument order, naming arguments not required

Basics: Objects and Data
========================================================

- There are a few basic types of objects/data
    - Single values
    - Vectors (integer/numeric, character, factor)
    - Matrices
    - Data frames
    - Lists
    
- Other types of data are introduced through packages
  - Built on these basic data structures

Basics: Objects and Data
========================================================
class: small-code
- We'll start by using the console as a calculator

- Results of commands are returned there


```r
2 + 3
```

```
[1] 5
```

Basics: Objects and Data
========================================================
class: small-code
- Results can be stored as objects (AKA variables)

```r
a <- 2 + 3
a
```

```
[1] 5
```
- Character strings can also be stored as data

```r
string <- "Hello world"
string
```

```
[1] "Hello world"
```

Data: Vectors
========================================================
class: small-code
- Vectors hold multiple elements of the same type, can be used for element-wise operations

```r
x <- c(2, 18, 12, 23, 73)
x - 3
```

```
[1] -1 15  9 20 70
```

```r
str(x)
```

```
 num [1:5] 2 18 12 23 73
```

Data: Vectors
========================================================
class: small-code
- The ```c``` function "c"oerces elements into a vector
- The ```str``` function lets us see the "str"ucture of the data
- Vectors can also contain character strings and logical values

```r
c("Learning", "R", "is", "fun!")
```

```
[1] "Learning" "R"        "is"       "fun!"    
```

```r
c(T, F, F, F, T, F)
```

```
[1]  TRUE FALSE FALSE FALSE  TRUE FALSE
```

Data: Vectors
========================================================
class: small-code
- Values in vectors (and other data types) can be missing
- ```NA``` is the most important missing value
    - Used for both numeric and text data

```r
b <- c(1, 2, 3, NA, 5)
is.na(b)
```

```
[1] FALSE FALSE FALSE  TRUE FALSE
```
- Math functions also return ```Inf```, ```-Inf```, and ```NaN```

Data: Vectors
========================================================
class: small-code
- You can reference cells of vectors using ```[n]``` function/notation
    - ```n``` is a number or vector of numbers/logical values

```r
x <- c("Learning", "R", "is", "fun!")
x[1]
```

```
[1] "Learning"
```

Data: Vectors
========================================================
class: small-code


```r
x[c(1, 4)]
```

```
[1] "Learning" "fun!"    
```

```r
x[c(T, F, F, T)]
```

```
[1] "Learning" "fun!"    
```

Data: Vectors
========================================================
class: small-code
- Element-wise operations on vectors work for all kinds of data

```r
v <- c("abcd", "efgh", "ijkl")
v
```

```
[1] "abcd" "efgh" "ijkl"
```

```r
substr(v, 1, 2)
```

```
[1] "ab" "ef" "ij"
```

Data: Factors
========================================================
class: small-code
- However, R can't give meaning to character strings on its own

```r
f <- c("Red", "Blue", "Red", "Blue")
summary(f)
```

```
   Length     Class      Mode 
        4 character character 
```
- We can create a factor, which creates values according to category

```r
f <- factor(f)
summary(f)
```

```
Blue  Red 
   2    2 
```

Data: Factors
========================================================
class: small-code
- Factors are similar to using labels for categories in Stata
- R can also order the levels in factors

```r
temperatures <- c("High", "Low", "High","Low", "Medium")
temp_factor <- factor(temperatures, 
                      order = TRUE, 
                      levels = c("Low", "Medium", "High"))
temp_factor
```

```
[1] High   Low    High   Low    Medium
Levels: Low < Medium < High
```

Data: Matrices
========================================================
class: small-code
- Matrices are like two-dimensional vectors
    - Can only hold one type of data

```r
matrix(1:9, byrow = TRUE, nrow = 3)
```

```
     [,1] [,2] [,3]
[1,]    1    2    3
[2,]    4    5    6
[3,]    7    8    9
```
- Note that ```1:9``` generates a vector of all integers from 1 through 9

Data: Matrices
========================================================
class: small-code
- You can create matrices from vectors

```r
col1 <- c(1, 2, 3)
col2 <- c(4, 5, 6)
col3 <- c(7, 8, 9)
matrix(c(col1, col2, col3), ncol = 3)
```

```
     [,1] [,2] [,3]
[1,]    1    4    7
[2,]    2    5    8
[3,]    3    6    9
```

Data: Matrices
========================================================
class: small-code
- Refer to cells using ```[ ]``` and two dimensions
    - First term for rows, second term for columns
    

```r
m <- matrix(c(col1, col2, col3), ncol = 3)
m
```

```
     [,1] [,2] [,3]
[1,]    1    4    7
[2,]    2    5    8
[3,]    3    6    9
```

```r
m[2, 2]
```

```
[1] 5
```

Data: Lists
========================================================
class: small-code
- Similar to a vector, but can contain multiple data types in on object, even other lists
- Not critical for beginners, but new object types from packages are often built on lists


```r
l <- list(a, v, matrix(1:9, byrow = TRUE, nrow = 3))
str(l)
```

```
List of 3
 $ : num 5
 $ : chr [1:3] "abcd" "efgh" "ijkl"
 $ : int [1:3, 1:3] 1 4 7 2 5 8 3 6 9
```

Data: Lists
========================================================
class: small-code
- Reference list elements with double brackets ```[[ ]]```

```r
l[[2]]
```

```
[1] "abcd" "efgh" "ijkl"
```
- Add ```[ ]``` to reference cells of object in list

```r
l[[3]][2, 2]
```

```
[1] 5
```


Data: Data frames
========================================================
class: small-code
- In my view, matrices are best used for math calculations
- Restrictive in usage, hard to create and manipulate
- You will most likely be using data frames in R

```r
data.frame(col1, col2, col3)
```

```
  col1 col2 col3
1    1    4    7
2    2    5    8
3    3    6    9
```

Data: Data frames
========================================================
class: small-code
- Data frames store a variety of data types in columns of the same table
    - Like a standard dataset in Stata
    - However, you can load as many data frames as you want!!!

```r
col2 <- c("lmao", "brb", "smh")            #character
col3 <- factor(c("Good", "Good", "Bad"))   #factor
col4 <- c(T, F, T)                         #logical
df <- data.frame(col1, col2, col3, col4, stringsAsFactors = F)
```

Data: Data frames
========================================================
class: small-code

```r
df
```

```
  col1 col2 col3  col4
1    1 lmao Good  TRUE
2    2  brb Good FALSE
3    3  smh  Bad  TRUE
```

```r
summary(df)
```

```
      col1         col2             col3      col4        
 Min.   :1.0   Length:3           Bad :1   Mode :logical  
 1st Qu.:1.5   Class :character   Good:2   FALSE:1        
 Median :2.0   Mode  :character            TRUE :2        
 Mean   :2.0                                              
 3rd Qu.:2.5                                              
 Max.   :3.0                                              
```

Data: Data frames
========================================================
class: small-code
- You can reference data frames like matrices with ```[ ]```
- Reference and add columns by name with ```$```


```r
df$new <- 0
df$new
```

```
[1] 0 0 0
```

```r
df
```

```
  col1 col2 col3  col4 new
1    1 lmao Good  TRUE   0
2    2  brb Good FALSE   0
3    3  smh  Bad  TRUE   0
```

Data: Data frames
========================================================
class: small-code
- You can load data from a range of file types with built-in functions
- We'll look at packages that cover even more


```r
#change to own file path
library(here)
salaries <- read.csv(here("data","white-house-salaries.csv"))
summary(salaries)
```

```
             employee_name      salary      
 brooke, mary j     :  16   Min.   :     0  
 campbell, frances l:  16   1st Qu.: 45000  
 droege, philip c   :  16   Median : 61952  
 jones, crystal b   :  16   Mean   : 76412  
 kalbaugh, david e  :  16   3rd Qu.:102000  
 mattson, philip c  :  16   Max.   :225000  
 (Other)            :7012                   
                       position         year     
 staff assistant           : 429   Min.   :2001  
 associate director        : 221   1st Qu.:2006  
 records management analyst: 206   Median :2010  
 deputy associate director : 176   Mean   :2010  
 executive assistant       : 154   3rd Qu.:2014  
 (Other)                   :5920   Max.   :2017  
 NA's                      :   2                 
                  status            party      president        term     
 detailee            : 328   democrat  :3740   bush :2991   first :3982  
 employee            :6778   republican:3368   obama:3740   second:3126  
 employee (part-time):   2                     trump: 377                
                                                                         
                                                                         
                                                                         
                                                                         
    gender    
 female:3521  
 male  :3587  
              
              
              
              
              
```

Basics: Classes
========================================================

- These are the main data types, but there are others

- Other packages introduce their own classes
- Checking object classes is a good debugging tool

```r
class(df)
```

```
[1] "data.frame"
```

```r
class(df$col4)
```

```
[1] "logical"
```

Basics: Functions
========================================================

- When coding, think of objects as nouns and functions as verbs

- Easy to create custom functions to simplify code
    - Allows for easy distribution
    - Packages are suites of functions that work together

- Must pay attention to required arguments of functions

- Can always view CRAN documentation of a function with ```?funct_name```
    - See description and all possible arguments 



Some resources
========================================================

- Important resources distributed through CRAN infrastructure
    - Documentation and vignettes by package authors
- Past questions on StackExchange and sibling forums
- Lots of resources at https://rdrr.io/
- Dedicated websites for packages like ```ggplot2```
- Articles at sites like https://www.r-bloggers.com/
- Style guide for readable R code by Hadley Wickham:
    - http://adv-r.had.co.nz/Style.html
- Plenty of books (digital and print, free and paid)
    - Twitter recipes: https://rud.is/books/21-recipes/

Great #rstats Twitter Follows
========================================================

- Mara Averick (@dataandme)

- Sharon Machlis (@sharon000)
- Jenny Bryan (@JennyBryan)
- Angela Li (@CivicAngela)
- Kyle Walker (@kyle_e_walker)
- Thomas Mock (@thomas_mock)

