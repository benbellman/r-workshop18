<style>
.small-code pre code {
  font-size: 1em;
}
</style>

Introduction to R
========================================================
author: Ben Bellman
date: August 29, 2017
autosize: true
incremental: true

What is R?
========================================================

"R is an integrated suite of software facilities for data manipulation, calculation and graphical display."

"Many users think of R as a statistics system. We prefer to think of it of an environment within which statistical techniques are implemented. R can be extended (easily) via packages. There are about eight packages supplied with the R distribution and many more are available through the CRAN family of Internet sites covering a very wide range of modern statistics."

Via [Project R website](https://www.r-project.org/about.html).
- GNU License, open source

What is R?
========================================================

- Very flexible

- Tons of free resources, add-ons
- Easy to write and distribute programs
- Effective for scientific transparency

How does R work?
========================================================

- Creates environment using memory on machine

- Can load different datasets as separate objects
- Install, manage, and use packages (suites of new functions and data types)
- Create and store data, results, visualizations within environment
- Export results as files, publish reports and distribute code online

How do I use R?
========================================================

- R is a world all of its own
    - Too many functions and quirks to cover in two days, or even a lifetime!
- My goal is to give you understanding of system
    - You will find own workflows/expertise with practice
- The only way to really master R is to use it independently
    - That means a lot of struggling, trial, error, and Google!
    - Documentation, guides, and user questions are everywhere
    - Some specific resources at end of these slides
    
How do I use R?
========================================================

- Can be run locally, on server, or via cloud services

- Easiest with RStudio
- Provides GUI for environment with four panels:
    1. Main I/O Console
    2. Scripts and markdown docs + data viewer
    3. Summary of environment + command history
    4. Computer files, plot viewer, package manager, help files, HTML viewer
- Let's take a look!

Plan for Workshop
========================================================

- **Tues. Morning:** 
    - Introduction to R, Data Manipulation (```tidyverse``` and ```dplyr```)
- **Tues. Afternoon:** 
    - Data Visualization (```ggplot2```), Practice
- **Wed. Morning:** 
    - Cleaning Data, Advanced Topics
- **Wed. Afternoon:** 
    - Practice

Basics: Anatomy of a command
========================================================
```obj <- funct(arg1, arg2 = True, arg3 = "setting", ...)```
- ```obj``` = object where output of ```function``` is stored
    - ```<-``` is the assignment operator for storing results
- ```funct``` = name of function being called
- ```arg1``` = first argument is usually object/data being operated on
- ```arg2, arg3``` = additional arguments that change how ```funct``` works
    - Can refer to true/false value, different methods, etc.
    - Have default values, so not always necessary to use them

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
- Vectors can also contain character strings and logical values (important for indexing)

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
- You can reference cells of vectors using ```[n]``` function/notation
    - ```n``` is number or vector of numbers


```r
x <- c("Learning", "R", "is", "fun!")
x[1]
```

```
[1] "Learning"
```

```r
x[c(1, 4)]
```

```
[1] "Learning" "fun!"    
```

Data: Vectors
========================================================
class: small-code
- The index can also be a vector of logical values
    - Later, we'll use conditional statements


```r
index <- c(T, F, F, T)
x[index]
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
summary(c("Red", "Blue", "Red", "Blue"))
```

```
   Length     Class      Mode 
        4 character character 
```
- We can create a factor, which creates values according to category

```r
summary(factor(c("Red", "Blue", "Red", "Blue")))
```

```
Blue  Red 
   2    2 
```

Data: Factors
========================================================
class: small-code
- Creating a factor is similar to using labels for categories in STATA
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
col1 <- c(11, 22, 33)
col2 <- c(44, 55, 66)
col3 <- c(77, 88, 99)
matrix(c(col1, col2, col3), ncol = 3)
```

```
     [,1] [,2] [,3]
[1,]   11   44   77
[2,]   22   55   88
[3,]   33   66   99
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
[1,]   11   44   77
[2,]   22   55   88
[3,]   33   66   99
```

```r
m[2, 2]
```

```
[1] 55
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
1   11   44   77
2   22   55   88
3   33   66   99
```

Data: Data frames
========================================================
class: small-code
- Data frames store a variety of data types in columns of the same table
    - Like a standard dataset in STATA
    - However, you can load as many data frames as you want!!!

```r
col2 <- c("lmao", "brb", "smh")            #character
col3 <- factor(c("Good", "Good", "Bad"))   #factor
col4 <- c(T, F, T)                         #logical
df <- data.frame(col1, col2, col3, col4, 
                 stringsAsFactors = F)
```
- Note: R changes character data to factors by default when creating data frames

Data: Data frames
========================================================
class: small-code

```r
df
```

```
  col1 col2 col3  col4
1   11 lmao Good  TRUE
2   22  brb Good FALSE
3   33  smh  Bad  TRUE
```

```r
summary(df)
```

```
      col1          col2             col3      col4        
 Min.   :11.0   Length:3           Bad :1   Mode :logical  
 1st Qu.:16.5   Class :character   Good:2   FALSE:1        
 Median :22.0   Mode  :character            TRUE :2        
 Mean   :22.0                                              
 3rd Qu.:27.5                                              
 Max.   :33.0                                              
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
1   11 lmao Good  TRUE   0
2   22  brb Good FALSE   0
3   33  smh  Bad  TRUE   0
```

Data: Data frames
========================================================
class: small-code
- You can load data from a range of file types with built-in functions
- We'll look at packages that cover even more


```r
#change to own file path
salaries <- read.csv("~/Google Drive/Computer Backup/R Workshop/Data/white-house-salaries.csv")
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

Data: Lists
========================================================
class: small-code
- Similar to a vector, but can contain multiple data types in on object, even other lists
- Not critical for beginners, but new object types from packages are often built on lists


```r
l <- list(a, v, matrix(1:9, byrow = TRUE, nrow = 3), salaries)
summary(l)
```

```
     Length Class      Mode     
[1,] 1      -none-     numeric  
[2,] 3      -none-     character
[3,] 9      -none-     numeric  
[4,] 9      data.frame list     
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

Basics: Functions
========================================================

- When coding, think of objects as nouns and functions as verbs

- R is a "functional language"
    - Can be directy referenced as objects and inputs without storing in memory
    - Packages are suites of functions
    - Can write own functions (we'll discuss later!)

- Must pay attention to required arguments of functions

- Can always view CRAN documentation of function with ```?function```

Functions: Math operations
========================================================

- Some numeric operations:

Operation | Syntax
------------- | -------------
Addition | ```a + b```
Subtraction | ```a - b```
Negative | ```-a```
Multiplication | ```a * b```
Division | ```a / b```
Exponents | ```a ^ b```
Square root | ```sqrt(a)```
Natrual and common logs | ```log(a)```, ```log10(a)```

Functions: Math operations
========================================================

- Some vector/matrix operations:

Operation | Syntax
------------- | -------------
Sum | ```sum(a)```
Matrix multiplication | ```a %*% b```
Mean | ```mean(a)```
Standard deviation | ```sd(a)```
Quantiles | ```quantile(a)```
Min or Max | ```min(a)```, ```max(a)```
Rescale or Recenter | ```scale(a)```

Functions: Strings
========================================================

- Some character string functions:

Operation | Syntax
------------- | -------------
Extract substring | ```substr(a, start = 1, stop = n)```
Splitting | ```strsplit(a, split = "")```
Combining text | ```paste(a, ..., sep = "")```
Convert all cases | ```toupper(a)```, ```tolower(a)```

Functions: And beyond
========================================================

- There's a huge range of built-in functions and utilities

- We will discuss more after break
- However, I can't possibly cover them all
    - (Not to mention all the packages out there)
- So if you're wondering: "Is there a function for..."
    - The answer is probably yes!

Some resources
========================================================

- Important resources distributed through CRAN infrastructure
    - Documentation and vignettes by package authors
- Past questions on StackExchange and sub-forums
- Lots of resources at https://rdrr.io/
- Dedicated websites for packages like ```ggplot2```
- Articles at sites like https://www.r-bloggers.com/
- Style guide for readable R code by Hadley Wickham:
    - http://adv-r.had.co.nz/Style.html
- Plenty of books (digital and print, free and paid)
- And much, much, much more!


