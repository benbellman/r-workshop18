<style>
.small-code pre code {
  font-size: 1em;
}
</style>

Advanced R Topics
========================================================
author: Ben Bellman
date: August 29, 2018
autosize: true
incremental: false

Preface
========================================================
- These are important topics, but...
- Beginning users won't need them right away
    - You have enough to learn in two days as is!
- Important for advanced programming beyond simple analysis
- These are foundational, you will need them eventually
    

"If" and "Else" statements
========================================================
class: small-code
- We can use the ```if ()```statement to run code only if a condition is met

```r
x <- 5
if (x < 10) {x + 1}
```

```
[1] 6
```

```r
x <- 15
if (x < 10) {x + 1}
```

"If" and "Else" statements
========================================================
class: small-code
- If statements can be combined with more if statements, or they can be concluded with the ```else``` function

```r
x <- 15
if(x < 10){
  x + 1
} else {
  print("Statement was false")
}
```

```
[1] "Statement was false"
```

"While" loops
========================================================
class: small-code
- Conditional statements can be used to control loops
- If the statement is still true at the end of code block, the computer runs the code again
- When the statement is evaluated as false, the loop stops

```r
x <- 1
while (x < 8){
  x <- x + 1
  print(x)
}
```

```
[1] 2
[1] 3
[1] 4
[1] 5
[1] 6
[1] 7
[1] 8
```

"For" loops
========================================================
class: small-code
- You can also loop through elements in a vector using the ```for()``` function

```r
library(tidyverse)

for(year in 2010:2015){
  paste("The year is", year, sep = " ") %>% 
    print()
}
```

```
[1] "The year is 2010"
[1] "The year is 2011"
[1] "The year is 2012"
[1] "The year is 2013"
[1] "The year is 2014"
[1] "The year is 2015"
```


"For" loops
========================================================
class: small-code
- When beginners learn "for" loops, there's a danger they will use them inefficiently
    - My early mistake was looping over rows of data


```r
library(here)
salaries <- read_csv(here("data","white-house-salaries.csv"))

t1 <- Sys.time()
for(a in 1:nrow(salaries)){
  salaries$salary[a] / 1000
}
t2 <- Sys.time()
loop <- t2 - t1
loop
```

```
Time difference of 0.01889801 secs
```

Iteration and Vectorization
========================================================
- Loops work through iteration
    - It literally solves one problem at a time as it loops
- By contrast, vectorized code uses the computer to process things simultaneously
- `dplyr` functions are vectorized processes
- `map()` from the `purrr` package in `tidyverse` vectorizes functions over lists and vectors
- Only use a loop when you must!

Loop vs. Vectorization
========================================================
class: small-code

```r
t3 <- Sys.time()
invisible(salaries$salary / 1000)   # suppress output
t4 <- Sys.time()
vect <- t4 - t3

loop
```

```
Time difference of 0.01889801 secs
```

```r
vect
```

```
Time difference of 0.001572847 secs
```

```r
0.01929402 / 0.003953934  # How many times longer was loop?
```

```
[1] 4.879702
```

Writing functions
========================================================
- Writing functions has a learning curve, but is rewarding
    - Save time and space
    - Make code easy to share and run
    - Easier to maintain and improve
- Define with the ```function()``` function
- Arguments define the objects refernced in function code
- Good idea to keep functions short and nest them

RMarkdown and RStudio
========================================================
- I made all these materials inside RStudio!
- Lots of ways to generate documents with RMarkdown, which is integrated into RStudio development tools
    - Reports, slides, etc. with embedded code and results
- You can also create websites, like "book sites", blog posts, and personal sites for professional exposure
    - This is on my to-do list!
    - (working group plug)

Questions?
========================================================
