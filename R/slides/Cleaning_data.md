<style>
.small-code pre code {
  font-size: 1em;
}
</style>

Cleaning Data with R
========================================================
author: Ben Bellman
date: August 29, 2018
autosize: true
incremental: false

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

Refresh from Yesterday
========================================================
- Introduction to R
    - Anatomy of a command
    - Data classes and functions
- Using ```dplyr```
    - ```tidyverse``` packages
    - ```select()```, ```filter()```, ```arrange()```, ```summarise()```, and ```mutate()```
    - The piping operator, ```%>%```
- Using ```ggplot2```
    - Initialize with ```ggplot()```
    - Customize with additional functions
- Modeling workflows
    
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

The tidyverse Philosophy
========================================================

- Tidy data is data where: 
    1. Each variable is in a column.
    2. Each observation is a row. 
    3. Each value is a cell.

- Code is written to be human legible, read like a recipe
    - Implemented with ```%>%```, the piping operator

- Tidy data objects can be analyzed with all tidyverse functions

tidyr and reshape2
========================================================

- Tools to shape data into tidy framework
- When do I need to worry about this?
    - Unstructured data sources: web scraping with ```rvest```, reading documents, combining data from multiple tables, etc.
    - Information in one column can be broken into multiple columns
    - Transforming multilevel data between long/wide formats
    
reshape2 functions
========================================================

- `reshape2` must be loaded separately from the `tidyverse`

```r
library(tidyverse)
library(reshape2)
library(here)
```
- Works like "reshape" in Stata, but in two parts
- `melt()` decomposes the data into a key-value format
- `dcast()` reconstructs the "melted" data at a new level

melt() function
========================================================
class: small-code
- Let's reshape the salaries data so it has one row for every person
    - Searches automatically for numeric columns
    - these columns are saved under column "variable"
    - numeric values are saved under column "values"

```r
salaries <- read_csv(here("data","white-house-salaries.csv")) %>% 
  mutate(year = factor(year))     # need year to not be numeric
melted <- melt(salaries) %>% as_tibble()

select(melted, variable, value)
```

```
# A tibble: 7,108 x 2
   variable  value
   <fct>     <dbl>
 1 salary    40000
 2 salary    65000
 3 salary    36000
 4 salary    92000
 5 salary    42800
 6 salary   130500
 7 salary    57000
 8 salary    54768
 9 salary    55000
10 salary    50000
# ... with 7,098 more rows
```

dcast() function
========================================================
class: small-code
- `dcast()` needs a formula to reconstruct the data
    - LHS is the new unit of observation
    - RHS is the combo of "variable" with the lower level of observation
    - Variables not in formula are dropped

```r
employees <- dcast(melted, employee_name ~ variable + year) %>% 
  as_tibble()

employees
```

```
# A tibble: 3,321 x 17
   employee_name        salary_2001 salary_2003 salary_2004 salary_2005
   <chr>                      <dbl>       <dbl>       <dbl>       <dbl>
 1 abbot, anita k             55500          NA          NA          NA
 2 abdullah, hasan a             NA          NA          NA          NA
 3 aberger, marie e              NA          NA          NA          NA
 4 abizaid, christine s          NA          NA          NA          NA
 5 abney, allen k                NA       45000       45000       55000
 6 abraham, sabey m              NA          NA          NA          NA
 7 abraham, yohannes a           NA          NA          NA          NA
 8 abrams, adam w                NA          NA          NA          NA
 9 abramson, jerry e             NA          NA          NA          NA
10 abrevaya, sandra              NA          NA          NA          NA
# ... with 3,311 more rows, and 12 more variables: salary_2006 <dbl>,
#   salary_2007 <dbl>, salary_2008 <dbl>, salary_2009 <dbl>,
#   salary_2010 <dbl>, salary_2011 <dbl>, salary_2012 <dbl>,
#   salary_2013 <dbl>, salary_2014 <dbl>, salary_2015 <dbl>,
#   salary_2016 <dbl>, salary_2017 <dbl>
```

tidyr functions
========================================================

- `tidyr` functions are better for tidying specific columns
    - `melt()` and `dcast()` are best for large-scale transformation of many columns

- ```gather()``` and ```spread()``` transform across ID levels 
    
- ```separate()``` and ```extract()``` both take information from one column, and split it into multiple columns

gather() function
========================================================

- Also uses concept of "key-value" pairs to separate variables

- Take a simple example with two heartrate measurements taken for three people
- Each measurement is associated with a drug, recorded in separate columns
- The ```gather()``` function reassigns the variable names (drugs) to a column, and gathers the heartrate measure into one column

gather() function
========================================================
class: small-code

```r
library(tidyverse)

messy <- tibble(
  name = c("Wilbur", "Petunia", "Gregory"),
  a = c(67, 80, 64),
  b = c(56, 90, 50)
)

messy
```

```
# A tibble: 3 x 3
  name        a     b
  <chr>   <dbl> <dbl>
1 Wilbur     67    56
2 Petunia    80    90
3 Gregory    64    50
```

gather() function
========================================================
class: small-code

```r
tidy <- messy %>%
  gather(drug, heartrate, a, b)

tidy
```

```
# A tibble: 6 x 3
  name    drug  heartrate
  <chr>   <chr>     <dbl>
1 Wilbur  a            67
2 Petunia a            80
3 Gregory a            64
4 Wilbur  b            56
5 Petunia b            90
6 Gregory b            50
```

spread() function
========================================================

- The ```spread()``` function does the opposite of ```gather()```
    - When two columns are a key-value pair, you can make they key variable into its own columns
    - Best example in population research is longitudinal data
    - Do we want one row for each person with different columns for time points?
    - Or do we want multiple rows for each person, with one column holding all measurements?
    
spread() function
========================================================
class: small-code

```r
tidy
```

```
# A tibble: 6 x 3
  name    drug  heartrate
  <chr>   <chr>     <dbl>
1 Wilbur  a            67
2 Petunia a            80
3 Gregory a            64
4 Wilbur  b            56
5 Petunia b            90
6 Gregory b            50
```

```r
tidy %>%
  spread(drug, heartrate)
```

```
# A tibble: 3 x 3
  name        a     b
  <chr>   <dbl> <dbl>
1 Gregory    64    50
2 Petunia    80    90
3 Wilbur     67    56
```

separate() function
========================================================

- ```separate()``` is used to split one column into two columns
    - Compare to "split" in Stata
    - Use a regular expression to identify "where" to split the data
- ```extract()``` essentially does the same thing, but uses regular expressions to extract data rather than simply split a string

separate() function
========================================================
class: small-code

```r
employees <- employees %>% 
  separate(employee_name, into = c("last_name", "first_mi"), sep = ", ", extra = "merge")

employees 
```

```
# A tibble: 3,321 x 18
   last_name first_mi    salary_2001 salary_2003 salary_2004 salary_2005
   <chr>     <chr>             <dbl>       <dbl>       <dbl>       <dbl>
 1 abbot     anita k           55500          NA          NA          NA
 2 abdullah  hasan a              NA          NA          NA          NA
 3 aberger   marie e              NA          NA          NA          NA
 4 abizaid   christine s          NA          NA          NA          NA
 5 abney     allen k              NA       45000       45000       55000
 6 abraham   sabey m              NA          NA          NA          NA
 7 abraham   yohannes a           NA          NA          NA          NA
 8 abrams    adam w               NA          NA          NA          NA
 9 abramson  jerry e              NA          NA          NA          NA
10 abrevaya  sandra               NA          NA          NA          NA
# ... with 3,311 more rows, and 12 more variables: salary_2006 <dbl>,
#   salary_2007 <dbl>, salary_2008 <dbl>, salary_2009 <dbl>,
#   salary_2010 <dbl>, salary_2011 <dbl>, salary_2012 <dbl>,
#   salary_2013 <dbl>, salary_2014 <dbl>, salary_2015 <dbl>,
#   salary_2016 <dbl>, salary_2017 <dbl>
```


extract() function
========================================================
- Extracts the patterns matched within the parenteses
class: small-code

```r
employees <- employees %>% 
  extract(first_mi, into = c("first_name", "mi"), regex = "^([a-z]*) ([a-z])$", remove = F)

employees 
```

```
# A tibble: 3,321 x 20
   last_name first_mi first_name mi    salary_2001 salary_2003 salary_2004
   <chr>     <chr>    <chr>      <chr>       <dbl>       <dbl>       <dbl>
 1 abbot     anita k  anita      k           55500          NA          NA
 2 abdullah  hasan a  hasan      a              NA          NA          NA
 3 aberger   marie e  marie      e              NA          NA          NA
 4 abizaid   christi… christine  s              NA          NA          NA
 5 abney     allen k  allen      k              NA       45000       45000
 6 abraham   sabey m  sabey      m              NA          NA          NA
 7 abraham   yohanne… yohannes   a              NA          NA          NA
 8 abrams    adam w   adam       w              NA          NA          NA
 9 abramson  jerry e  jerry      e              NA          NA          NA
10 abrevaya  sandra   <NA>       <NA>           NA          NA          NA
# ... with 3,311 more rows, and 13 more variables: salary_2005 <dbl>,
#   salary_2006 <dbl>, salary_2007 <dbl>, salary_2008 <dbl>,
#   salary_2009 <dbl>, salary_2010 <dbl>, salary_2011 <dbl>,
#   salary_2012 <dbl>, salary_2013 <dbl>, salary_2014 <dbl>,
#   salary_2015 <dbl>, salary_2016 <dbl>, salary_2017 <dbl>
```


stringr: Using Text Data
========================================================

- Often, "data cleaning" means text cleaning
    - Remove unwanted text, extract wanted text
    - Recognize patterns, etc.
- ```stringr``` package is best toolkit for these operations
    - Lots of functions, can't learn them all
    - Uses "regular expressions" for pattern recognition
    - Beyond the scope of workshop, but powerful and relatively easy to learn
    - [Here's the tidyverse website tutorial](https://stringr.tidyverse.org/articles/regular-expressions.html)
- Let's explore the salaries data

Basic stringr
========================================================
class: small-code
First, let's take a look at what kind of job titles there are

```r
unique(salaries$position)
```

```
   [1] "legislative assistant and assistant to the house liaison"                                                                                              
   [2] "western regional communications director"                                                                                                              
   [3] "executive assistant to the director of scheduling and advance"                                                                                         
   [4] "deputy director of intergovernmental affairs"                                                                                                          
   [5] "operator"                                                                                                                                              
   [6] "special assistant to the president for energy and environment"                                                                                         
   [7] "domestic director"                                                                                                                                     
   [8] "special assistant"                                                                                                                                     
   [9] "executive assistant to the chief of staff"                                                                                                             
  [10] "policy assistant"                                                                                                                                      
  [11] "counsel"                                                                                                                                               
  [12] "priority placement director"                                                                                                                           
  [13] "staff assistant to the social secretary"                                                                                                               
  [14] "policy director"                                                                                                                                       
  [15] "assistant shift leader"                                                                                                                                
  [16] "special advisor to the assistant to the president/deputy national security advisor"                                                                    
  [17] "assistant to the president and senior advisor"                                                                                                         
  [18] "director, response policy"                                                                                                                             
  [19] "staff assistant"                                                                                                                                       
  [20] "assistant to the president and director of the domestic policy council"                                                                                
  [21] "deputy associate counsel"                                                                                                                              
  [22] "associate director"                                                                                                                                    
  [23] "director of response"                                                                                                                                  
  [24] "tax counsel"                                                                                                                                           
  [25] "legislative assistant and assistant for events"                                                                                                        
  [26] "deputy assistant to the president and director of advance and operations"                                                                              
  [27] "associate director of urban affairs"                                                                                                                   
  [28] "director of special projects and special assistant to the office of the chief of staff"                                                                
  [29] "researcher"                                                                                                                                            
  [30] "deputy associate director of intergovernmental affairs"                                                                                                
  [31] "special counsel to the president"                                                                                                                      
  [32] "records management analyst"                                                                                                                            
  [33] "deputy director of public engagement"                                                                                                                  
  [34] "executive assistant to the chief of staff to the first lady"                                                                                           
  [35] "deputy associate director"                                                                                                                             
  [36] "executive assistant to the senior advisor"                                                                                                             
  [37] "policy analyst"                                                                                                                                        
  [38] "assistant to the president and deputy national security advisor for counterterrorism and homeland security"                                            
  [39] "executive assistant to the director of public engagement"                                                                                              
  [40] "supervisor of correspondence review"                                                                                                                   
  [41] "executive assistant"                                                                                                                                   
  [42] "assistant to the president and staff secretary"                                                                                                        
  [43] "director, cyber-security policy"                                                                                                                       
  [44] "assistant to the president for energy and climate change"                                                                                              
  [45] "midwest regional communications director"                                                                                                              
  [46] "special assistant and advance lead"                                                                                                                    
  [47] "special assistant and press lead"                                                                                                                      
  [48] "special assistant to the president and associate counsel to the president"                                                                             
  [49] "deputy director and deputy social secretary"                                                                                                           
  [50] "special assistant to the president and deputy press secretary"                                                                                         
  [51] "deputy assistant to the president and deputy counsel to the president"                                                                                 
  [52] "supervisor, document management and tracking unit"                                                                                                     
  [53] "associate director and trip coordinator"                                                                                                               
  [54] "executive assistant to the deputy chief of staff for policy"                                                                                           
  [55] "special assistant to the president for presidential personnel"                                                                                         
  [56] "deputy assistant to the president and director, office of urban affairs"                                                                               
  [57] "associate director of special projects"                                                                                                                
  [58] "correspondence analyst"                                                                                                                                
  [59] "director of confirmations"                                                                                                                             
  [60] "assistant press secretary"                                                                                                                             
  [61] "senior writer for proclamations"                                                                                                                       
  [62] "assistant staff secretary"                                                                                                                             
  [63] "senior policy advisor"                                                                                                                                 
  [64] "energy and environment director"                                                                                                                       
  [65] "shift leader"                                                                                                                                          
  [66] "associate director and scheduling researcher"                                                                                                          
  [67] "deputy director, technology"                                                                                                                           
  [68] "legal researcher"                                                                                                                                      
  [69] "special assistant to the president for mobility and opportunity policy"                                                                                
  [70] "director of administration"                                                                                                                            
  [71] "assistant to the president and counsel to the president"                                                                                               
  [72] "special assistant to the president for science, technology and innovation"                                                                             
  [73] "deputy executive secretary"                                                                                                                            
  [74] "deputy director for whitehouse.gov"                                                                                                                    
  [75] "director of the office of national aids policy"                                                                                                        
  [76] "deputy assistant to the president and director of appointments and scheduling"                                                                         
  [77] "special assistant to the president for justice and regulatory policy"                                                                                  
  [78] "deputy director, presidential correspondence"                                                                                                          
  [79] "special assistant to the president and deputy director of advance"                                                                                     
  [80] "associate director of scheduling"                                                                                                                      
  [81] "advisor to the president"                                                                                                                              
  [82] "special assistant to the president and deputy associate director of public engagement"                                                                 
  [83] "senior analyst"                                                                                                                                        
  [84] "deputy assistant to the president for management and administration"                                                                                   
  [85] "director of white house services"                                                                                                                      
  [86] "special assistant to the president for economic policy"                                                                                                
  [87] "presidential support specialist"                                                                                                                       
  [88] "intake staff assistant"                                                                                                                                
  [89] "counselor to the president and director of the white house office for health care reform"                                                              
  [90] "policy advisor"                                                                                                                                        
  [91] "special assistant to the president and deputy director of political affairs"                                                                           
  [92] "deputy director, video"                                                                                                                                
  [93] "director, preparedness policy"                                                                                                                         
  [94] "director, cyber policy"                                                                                                                                
  [95] "assistant to the president and deputy national security advisor"                                                                                       
  [96] "special assistant to the president for urban affairs"                                                                                                  
  [97] "director of records management"                                                                                                                        
  [98] "special assistant to the president and executive director of the white house office of faith-based and neighborhood partnerships"                      
  [99] "assistant to the president and director of communications"                                                                                             
 [100] "special assistant to the white house counsel"                                                                                                          
 [101] "greetings coordinator"                                                                                                                                 
 [102] "director of african american media"                                                                                                                    
 [103] "special assistant to the president and special counsel to the president"                                                                               
 [104] "legal director"                                                                                                                                        
 [105] "assistant to the president and chief of staff"                                                                                                         
 [106] "deputy assistant to the president for economic policy"                                                                                                 
 [107] "advance coordinator"                                                                                                                                   
 [108] "assistant to the president and director of speechwriting"                                                                                              
 [109] "special assistant to the president and senior advisor to the chief of staff"                                                                           
 [110] "special assistant to the president and director of oval office operations"                                                                             
 [111] "associate director of press advance and press pool wrangler"                                                                                           
 [112] "volunteer coordinator"                                                                                                                                 
 [113] "deputy director of advance and trip director for the first lady"                                                                                       
 [114] "director, surface transportation security"                                                                                                             
 [115] "economics staff assistant"                                                                                                                             
 [116] "director of veterans and wounded warrior policy"                                                                                                       
 [117] "senior presidential speechwriter"                                                                                                                      
 [118] "counselor for energy and climate change"                                                                                                               
 [119] "deputy director of cabinet affairs"                                                                                                                    
 [120] "deputy assistant to the president and director of policy and projects for the first lady"                                                              
 [121] "legislative assistant and assistant to the senate liaison"                                                                                             
 [122] "writer"                                                                                                                                                
 [123] "assistant to the president and director of political affairs"                                                                                          
 [124] "assistant to the president and press secretary"                                                                                                        
 [125] "assistant to the president and director of presidential personnel"                                                                                     
 [126] "deputy associate counsel for presidential personnel"                                                                                                   
 [127] "legislative assistant"                                                                                                                                 
 [128] "director of online resources and interdepartmental development"                                                                                        
 [129] "deputy director of scheduling and events coordinator for the first lady"                                                                               
 [130] "special assistant to the president for financial markets"                                                                                              
 [131] "deputy special counsel to the president"                                                                                                               
 [132] "deputy director of finance"                                                                                                                            
 [133] "director, immigration and visa security policy"                                                                                                        
 [134] "director of white house internship program"                                                                                                            
 [135] "special assistant to the president for legislative affairs"                                                                                            
 [136] "associate director and travel manager"                                                                                                                 
 [137] "deputy  assistant to the president and deputy director of the domestic policy council"                                                                 
 [138] "western political director"                                                                                                                            
 [139] "special assistant to the president and chief of staff for presidential personnel"                                                                      
 [140] "clearance advisor"                                                                                                                                     
 [141] "assistant director of correspondence for agency liaision"                                                                                              
 [142] "e-mail content/design lead and new media liaison"                                                                                                      
 [143] "associate director of speechwriting and senior presidential speechwriter"                                                                              
 [144] "agency coordinator"                                                                                                                                    
 [145] "director of speciality media"                                                                                                                          
 [146] "deputy associate director of correspondence for the first lady"                                                                                        
 [147] "production assistant"                                                                                                                                  
 [148] "senior advisor and assistant to the president for intergovernmental affairs and public engagement"                                                     
 [149] "special assistant for scheduling and traveling aide to the first lady"                                                                                 
 [150] "research director"                                                                                                                                     
 [151] "northeast political director"                                                                                                                          
 [152] "domestic staff assistant"                                                                                                                              
 [153] "personal secretary to the president"                                                                                                                   
 [154] "assistant director of correspondence for gifts"                                                                                                        
 [155] "special assistant to the president and director of communications for the first lady"                                                                  
 [156] "senior advisor  for social innovation and civic participation"                                                                                         
 [157] "assistant supervisor, document management and tracking unit"                                                                                           
 [158] "director of white house personnel"                                                                                                                     
 [159] "national security advisor"                                                                                                                             
 [160] "assistant director of correspondence for student correspondence"                                                                                       
 [161] "special assistant to the director"                                                                                                                     
 [162] "senior correspondence analyst"                                                                                                                         
 [163] "deputy executive clerk"                                                                                                                                
 [164] "special assistant to the president and director of white house operations"                                                                             
 [165] "special assistant to the director of intergovernmental affairs"                                                                                        
 [166] "special projects coordinator"                                                                                                                          
 [167] "associate staff secretary"                                                                                                                             
 [168] "presidential speechwriter"                                                                                                                             
 [169] "special assistant to the president and director of presidential correspondence"                                                                        
 [170] "vetter"                                                                                                                                                
 [171] "director of counsel operations"                                                                                                                        
 [172] "assistant to the president for management and administration"                                                                                          
 [173] "attorney"                                                                                                                                              
 [174] "special assistant to the president for healthcare"                                                                                                     
 [175] "scheduler for chief of staff"                                                                                                                          
 [176] "deputy director of advance and special events for the office of intergovernmental affairs and public engagement"                                       
 [177] "deputy assistant to the president for legislative affairs"                                                                                             
 [178] "deputy director and hotel program manager"                                                                                                             
 [179] "associate director of correspondence for the first lady"                                                                                               
 [180] "director of online programs"                                                                                                                           
 [181] "special assistant to the president and director of message events"                                                                                     
 [182] "deputy director of response"                                                                                                                           
 [183] "director and press secretary to the first lady"                                                                                                        
 [184] "associate director of press advance"                                                                                                                   
 [185] "southern political director"                                                                                                                           
 [186] "special assistant to the senior advisor"                                                                                                               
 [187] "special assistant to the president for economic policy and chief of staff of the national economic council"                                            
 [188] "press assistant"                                                                                                                                       
 [189] "special assistant and personal aide to the first lady"                                                                                                 
 [190] "deputy director of advance and director of press advance"                                                                                              
 [191] "deputy assistant to the president and chief of staff for national security operations"                                                                 
 [192] "special assistant to the president for international economic affairs"                                                                                 
 [193] "associate for law and policy"                                                                                                                          
 [194] "new media creative director"                                                                                                                           
 [195] "legislative assistant and associate director for legislative correspondence"                                                                           
 [196] "special assistant to the president and personal aide to the president"                                                                                 
 [197] "director of technology"                                                                                                                                
 [198] "assistant to the president and cabinet secretary"                                                                                                      
 [199] "special services operator"                                                                                                                             
 [200] "deputy director of special projects"                                                                                                                   
 [201] "deputy assistant to the president for legislative affairs and senate liaison"                                                                          
 [202] "director, public health policy"                                                                                                                        
 [203] "boards and commissions director"                                                                                                                       
 [204] "assistant to the president and director of scheduling and advance"                                                                                     
 [205] "printer and photograph coordinator"                                                                                                                    
 [206] "national security staff assistant"                                                                                                                     
 [207] "assistant executive clerk"                                                                                                                             
 [208] "deputy assistant to the president and national security spokesperson"                                                                                  
 [209] "advisor"                                                                                                                                               
 [210] "director of operations"                                                                                                                                
 [211] "assistant director of correspondence for volunteers and comment line"                                                                                  
 [212] "operations staff assistant"                                                                                                                            
 [213] "deputy chief of staff to the first lady"                                                                                                               
 [214] "deputy assistant to the president and principal deputy counsel to the president"                                                                       
 [215] "assistant to the president and deputy chief of staff for operations"                                                                                   
 [216] "aviation security director"                                                                                                                            
 [217] "special assistant to the cabinet secretary"                                                                                                            
 [218] "director of hispanic media"                                                                                                                            
 [219] "senior policy advisor for social innovation and civic participation"                                                                                   
 [220] "deputy associate director of public engagement"                                                                                                        
 [221] "deputy director of oval office operations"                                                                                                             
 [222] "deputy director of operations"                                                                                                                         
 [223] "deputy assistant to the president and director of intergovernmental affairs"                                                                           
 [224] "northeast regional communications director"                                                                                                            
 [225] "senior vetter"                                                                                                                                         
 [226] "associate director and deputy press secretary to the first lady"                                                                                       
 [227] "assistant to the executive clerk"                                                                                                                      
 [228] "gift analysis"                                                                                                                                         
 [229] "director of travel office"                                                                                                                             
 [230] "special assistant to the president and trip director"                                                                                                  
 [231] "assistant speechwriter"                                                                                                                                
 [232] "chief of staff, office of legislative affairs"                                                                                                         
 [233] "deputy director"                                                                                                                                       
 [234] "chief of staff of the domestic policy council"                                                                                                         
 [235] "legislative assistant and assistant to the director's office"                                                                                          
 [236] "west wing receptionist"                                                                                                                                
 [237] "assistant supervisor of classification"                                                                                                                
 [238] "director of policy for the office of intergovernmental affairs and public engagement"                                                                  
 [239] "deputy director and surrogate scheduler"                                                                                                               
 [240] "new media analyst"                                                                                                                                     
 [241] "deputy assistant to the president and deputy director of communications"                                                                               
 [242] "special assistant to the president and director of new media"                                                                                          
 [243] "research assistant"                                                                                                                                    
 [244] "deputy director of records management"                                                                                                                 
 [245] "special assistant to the president for homeland security and senior director for continuity policy"                                                    
 [246] "director, maritime security"                                                                                                                           
 [247] "special assistant to the president and director of media affairs"                                                                                      
 [248] "special assistant to the president and deputy director of speechwriting"                                                                               
 [249] "supervisor of classification"                                                                                                                          
 [250] "assistant director of correspondence for mail analysis"                                                                                                
 [251] "special assistant to the president for education policy"                                                                                               
 [252] "special assistant to the president and white house social secretary"                                                                                   
 [253] "national security director"                                                                                                                            
 [254] "deputy assistant to the president and deputy staff secretary"                                                                                          
 [255] "assistant director of technology"                                                                                                                      
 [256] "deputy director of policy and projects for the first lady"                                                                                             
 [257] "executive clerk"                                                                                                                                       
 [258] "director of visitors office"                                                                                                                           
 [259] "assistant to the president and director, office of legislative affairs"                                                                                
 [260] "deputy assistant to the president and director, office of social innovation and civic participation"                                                   
 [261] "executive assistant to the deputy chief of staff for operations"                                                                                       
 [262] "assistant to the president and chief of staff to the first lady"                                                                                       
 [263] "special assistant to the deputy assistant to the president"                                                                                            
 [264] "director and aide to the senior advisor"                                                                                                               
 [265] "supervisor of search and file"                                                                                                                         
 [266] "deputy assistant to the president and deputy cabinet secretary"                                                                                        
 [267] "analytics and reports coordinator/it liaison"                                                                                                          
 [268] "midwest political director"                                                                                                                            
 [269] "coordinator of student writing and materials"                                                                                                          
 [270] "director for white house citizen participation"                                                                                                        
 [271] "director of scheduling and advance for the first lady"                                                                                                 
 [272] "senior writer for messages"                                                                                                                            
 [273] "special assistant to the president and chief of staff of the office of intergovernmental affairs and public engagement"                                
 [274] "assistant to the president for economic policy and director of the national economic council"                                                          
 [275] "assistant to the president and deputy chief of staff for policy"                                                                                       
 [276] "special assistant to the president and director, office of the chief of staff"                                                                         
 [277] "assistant supervisor of search and file"                                                                                                               
 [278] "deputy assistant to the president and director of the office of public engagement"                                                                     
 [279] "research associate"                                                                                                                                    
 [280] "manager of mail and messenger operations"                                                                                                              
 [281] "southern regional communications director"                                                                                                             
 [282] "senior writer for policy"                                                                                                                              
 [283] "supervisor of computer administration"                                                                                                                 
 [284] "deputy assistant to the president for legislative affairs and house liaison"                                                                           
 [285] "director of surrogate booking"                                                                                                                         
 [286] "associate director of communications for economics"                                                                                                    
 [287] "senior advisor for economics division of presidential personnel"                                                                                       
 [288] "legal and boards staff assistant"                                                                                                                      
 [289] "executive assistant to the executive director"                                                                                                         
 [290] "executive assistant to the counsel to the president"                                                                                                   
 [291] "special assistant for scheduling correspondence"                                                                                                       
 [292] "policy assistant for urban affairs and mobility and opportunity policy"                                                                                
 [293] "energy and environment staff assistant"                                                                                                                
 [294] "deputy assistant to the president and deputy director of presidential personnel"                                                                       
 [295] "deputy director for radio"                                                                                                                             
 [296] "special assistant to the president and deputy chief of staff to the first lady"                                                                        
 [297] "special assistant to the chief of staff of the office of intergovernmental affairs and public engagement"                                              
 [298] "deputy director of scheduling for the president"                                                                                                       
 [299] "economics director"                                                                                                                                    
 [300] "special assistant to the director of public engagement"                                                                                                
 [301] "deputy assistant to the president for energy and climate change"                                                                                       
 [302] "senior program manager"                                                                                                                                
 [303] "special assistant to the chief of staff"                                                                                                               
 [304] "analyst"                                                                                                                                               
 [305] "communications director"                                                                                                                               
 [306] "media monitor"                                                                                                                                         
 [307] "deputy director for media affairs"                                                                                                                     
 [308] "director, online engagement"                                                                                                                           
 [309] "assistant to the president for homeland security and counterterrorism"                                                                                 
 [310] "special assistant to the deputy chief of staff"                                                                                                        
 [311] "ethics advisor"                                                                                                                                        
 [312] "deputy chief of staff for presidential personnel"                                                                                                      
 [313] "executive assistant to the political director"                                                                                                         
 [314] "special assistant to the president for mobilty and opportunity policy"                                                                                 
 [315] "director of the office of national aids policy and senior advisor on disability policy"                                                                
 [316] "assistant to the president for special projects"                                                                                                       
 [317] "senior legislative affairs analyst"                                                                                                                    
 [318] "policy assistant, urban policy and mobility and opportunity"                                                                                           
 [319] "associate director for scheduling correspondence"                                                                                                      
 [320] "special assistant to the president and director of events and protocol"                                                                                
 [321] "assistant director"                                                                                                                                    
 [322] "special assistant to the president and senior presidential speechwriter"                                                                               
 [323] "deputy assistant to the president  for economic policy"                                                                                                
 [324] "special assistant to the president and  associate counsel to the president"                                                                            
 [325] "boards and commissions staff assistant"                                                                                                                
 [326] "associate counsel to the president"                                                                                                                    
 [327] "deputy assistant to the president and deputy director of the domestic policy council"                                                                  
 [328] "deputy assistant to the president and director of presidential personnel"                                                                              
 [329] "special assistant to the press secretary"                                                                                                              
 [330] "special assistant to the president and director of research"                                                                                           
 [331] "personal aide to the president"                                                                                                                        
 [332] "director of white house administration"                                                                                                                
 [333] "special assistant to the president for healthcare and economic policy"                                                                                 
 [334] "assistant counsel for nominations"                                                                                                                     
 [335] "director of correspondence for the first lady"                                                                                                         
 [336] "coordinator"                                                                                                                                           
 [337] "midwestern regional communications director"                                                                                                           
 [338] "director of press advance"                                                                                                                             
 [339] "legislative counsel and policy advisor"                                                                                                                
 [340] "director of finance"                                                                                                                                   
 [341] "deputy assistant to the president for legislative affairs and senate liaision"                                                                         
 [342] "senior policy director"                                                                                                                                
 [343] "special assistant to the president and deputy director of presidential personnel"                                                                      
 [344] "deputy assistant to the president and national security council chief of staff"                                                                        
 [345] "senior policy advisor for education"                                                                                                                   
 [346] "deputy assistant to the president and senior advisor to the chief of staff"                                                                            
 [347] "chief tax counsel"                                                                                                                                     
 [348] "special assistant to the president and chief of staff of the domestic policy council"                                                                  
 [349] "director of special projects for communications"                                                                                                       
 [350] "director of communications for the office of health reform"                                                                                            
 [351] "priority placement staff assistant"                                                                                                                    
 [352] "senior writer"                                                                                                                                         
 [353] "speechwriter"                                                                                                                                          
 [354] "deputy director, online programs and email"                                                                                                            
 [355] "deputy regional political director"                                                                                                                    
 [356] "director"                                                                                                                                              
 [357] "deputy assistant to the president and director, office  of social innovation and civic participation"                                                  
 [358] "assistant to the president, chief of staff to the first lady and counsel"                                                                              
 [359] "director of special projects and special assistant to the senior advisor"                                                                              
 [360] "deputy assistant to the president and white house social secretary"                                                                                    
 [361] "associate director, new media operations"                                                                                                              
 [362] "senior policy advisor for native american affairs"                                                                                                     
 [363] "deputy director of message events"                                                                                                                     
 [364] "communications advisor, domestic policy council and office of national aids policy"                                                                    
 [365] "director of information services"                                                                                                                      
 [366] "white house business liaison"                                                                                                                          
 [367] "special assistant to the president and director of broadcast media"                                                                                    
 [368] "senior advisor for technology and innovation to the national economic council director"                                                                
 [369] "deputy director for broadcast media"                                                                                                                   
 [370] "regional communications director"                                                                                                                      
 [371] "associate communications director"                                                                                                                     
 [372] "senior legislative affairs advisor"                                                                                                                    
 [373] "deputy assistant to the president and national security staff chief of staff  and counselor"                                                           
 [374] "press secretary to the first lady"                                                                                                                     
 [375] "associate counsel"                                                                                                                                     
 [376] "deputy assistant to the president and director, office of the chief of staff"                                                                          
 [377] "deputy director of digital strategy"                                                                                                                   
 [378] "special assistant to the president and policy advisor to the office of the chief of staff"                                                             
 [379] "assistant director of intergovernmental affairs"                                                                                                       
 [380] "assistant to the president for manufacturing policy"                                                                                                   
 [381] "staff assistant to the deputy chief of staff"                                                                                                          
 [382] "senior advance lead"                                                                                                                                   
 [383] "deputy director of hispanic media"                                                                                                                     
 [384] "information services operator"                                                                                                                         
 [385] "associate director of online outreach and operations"                                                                                                  
 [386] "deputy assistant to the president and director of scheduling and advance"                                                                              
 [387] "senior scheduler"                                                                                                                                      
 [388] "assistant to the president and deputy senior advisor"                                                                                                  
 [389] "deputy assistant to the president and staff secretary"                                                                                                 
 [390] "special assistant to the president and deputy director, national economic council"                                                                     
 [391] "assistant to the president and national security advisor"                                                                                              
 [392] "special assistant to the president and principal deputy press secretary"                                                                               
 [393] "assistant counsel of ethics"                                                                                                                           
 [394] "special assistant to the president and senior  presidential speechwriter"                                                                              
 [395] "assistant to the president and principal deputy director of the national economic council"                                                             
 [396] "special assistant to the president and cabinet communications director"                                                                                
 [397] "associate counsel for ethics"                                                                                                                          
 [398] "director for finance"                                                                                                                                  
 [399] "legal assistant"                                                                                                                                       
 [400] "assistant counsel"                                                                                                                                     
 [401] "associate director for policy and events"                                                                                                              
 [402] "director of specialty media"                                                                                                                           
 [403] "director of special projects"                                                                                                                          
 [404] "white house services manager"                                                                                                                          
 [405] "associate director of scheduling and advance"                                                                                                          
 [406] "director of advance and special events for the office of intergovernmental affairs and public engagement"                                              
 [407] "deputy assistant director of broadcast media"                                                                                                          
 [408] "chief of staff of the national economic council"                                                                                                       
 [409] "deputy assistant to the president for health policy"                                                                                                   
 [410] "assistant to the president and counselor to the chief of staff"                                                                                        
 [411] "special assistant to the chief of staff of the office of intergovernmental affairs and publc engagement"                                               
 [412] "associate director and advance coordinator"                                                                                                            
 [413] "director of progressive media and online response"                                                                                                     
 [414] "director of african-american media"                                                                                                                    
 [415] "associate director of online engagement"                                                                                                               
 [416] "special assistant to the president for international  economic affairs"                                                                                
 [417] "senior vetting counsel for presidential personnel"                                                                                                     
 [418] "assistant director of cabinet affairs"                                                                                                                 
 [419] "special assistant to the president for manufacturing policy"                                                                                           
 [420] "special assistant to the counselor to the president"                                                                                                   
 [421] "deputy director of scheduling"                                                                                                                         
 [422] "legislative assistant and special assistant to the director"                                                                                           
 [423] "senior advisor for health, domestic policy council"                                                                                                    
 [424] "assistant director of public engagement"                                                                                                               
 [425] "special assistant to the president and director of message planning"                                                                                   
 [426] "senior advisor for housing, national economic council"                                                                                                 
 [427] "special assistant to the president and director of digital strategy"                                                                                   
 [428] "director of white house operations"                                                                                                                    
 [429] "deputy director for operations"                                                                                                                        
 [430] "special assistant to the president for financial and international markets"                                                                            
 [431] "associate director for finance"                                                                                                                        
 [432] "counselor to the president"                                                                                                                            
 [433] "director of systems development for presidential personnel"                                                                                            
 [434] "director of online engagement"                                                                                                                         
 [435] "records systems analyst"                                                                                                                               
 [436] "assistant to the president and special advisor"                                                                                                        
 [437] "deputy director of digital content"                                                                                                                    
 [438] "principal deputy director"                                                                                                                             
 [439] "deputy communications director"                                                                                                                        
 [440] "deputy assistant to the president and counselor to the senior  advisor for strategic engagement"                                                       
 [441] "special assistant to the president for public engagement"                                                                                              
 [442] "deputy director for energy and climate change"                                                                                                         
 [443] "senior director and national security staff spokesman"                                                                                                 
 [444] "deputy director of online platform"                                                                                                                    
 [445] "special assistant to the president and deputy chief of staff  and director of operations for the first lady"                                           
 [446] "deputy assistant to the president and director of scheduling"                                                                                          
 [447] "associate research director"                                                                                                                           
 [448] "associate director for travel planning"                                                                                                                
 [449] "associate director of public engagement"                                                                                                               
 [450] "chief calligrapher"                                                                                                                                    
 [451] "associate director of intergovernmental affairs"                                                                                                       
 [452] "special assistant to the chief of staff to the first lady"                                                                                             
 [453] "calligrapher"                                                                                                                                          
 [454] "special assistant to the senior advisor and deputy chief of staff"                                                                                     
 [455] "special assistant to the president and assistant communications director"                                                                              
 [456] "communications director of the domestic policy council and office of national aids policy"                                                             
 [457] "assistant to the president and deputy chief of staff for planning"                                                                                     
 [458] "chief of staff, office of the staff secretary"                                                                                                         
 [459] "executive director, joining forces"                                                                                                                    
 [460] "deputy to the counselor for strategic engagement"                                                                                                      
 [461] "special assistant to the president and senior counsel to the president"                                                                                
 [462] "director of digital content"                                                                                                                           
 [463] "deputy assistant to the president and deputy director, national economic council"                                                                      
 [464] "scheduling assistant and trip coordinator"                                                                                                             
 [465] "deputy director of advance and special events for the office of public engagement and intergovernmental affairs"                                       
 [466] "associate director for policy and events let's move! initiative"                                                                                       
 [467] "deputy director and hotel program director"                                                                                                            
 [468] "senior policy director for immigration"                                                                                                                
 [469] "special assistant and press manager"                                                                                                                   
 [470] "assistant director for information technology"                                                                                                         
 [471] "assistant to the president and deputy national security advisor for international economics"                                                           
 [472] "special assistant to the president and cabinet communicatons director"                                                                                 
 [473] "policy advisor to the office of the chief of staff"                                                                                                    
 [474] "special assistant to the president and director, office of social innovation and civic participation"                                                  
 [475] "associate director and trip manager"                                                                                                                   
 [476] "senior policy analyst"                                                                                                                                 
 [477] "special assistant to the president, senior advisor to the council on women and girls, and senior presidential speechwriter"                            
 [478] "special assistant to the president for intergovernmental affairs"                                                                                      
 [479] "deputy director of advance and traveling aide for the first lady"                                                                                      
 [480] "special assistant to the president and traveling aide"                                                                                                 
 [481] "assistant director for vetting"                                                                                                                        
 [482] "special assistant to the counselor to the senior advisor for strategic engagement"                                                                     
 [483] "deputy director of online engagement"                                                                                                                  
 [484] "assistant for arrangements"                                                                                                                            
 [485] "deputy policy director for immigration"                                                                                                                
 [486] "director of oval office operations"                                                                                                                    
 [487] "deputy director of scheduling and scheduling manager"                                                                                                  
 [488] "special assistant to the president, trip director and personal aide to the president"                                                                  
 [489] "special assistant to the president and director of special projects, office of the chief of staff"                                                     
 [490] "senior legal assistant"                                                                                                                                
 [491] "director of white house operations and advisor for management and administration"                                                                      
 [492] "deputy press secretary and executive secretary"                                                                                                        
 [493] "deputy director of operations and continuity"                                                                                                          
 [494] "deputy assistant to the president for urban affairs and economic mobility"                                                                             
 [495] "special assistant to the president and director of visitors office"                                                                                    
 [496] "deputy chief of staff of the national economic council"                                                                                                
 [497] "deputy executive director for the council on women and girls"                                                                                          
 [498] "associate director of digital content"                                                                                                                 
 [499] "systems administrator"                                                                                                                                 
 [500] "deputy assistant to the president and counselor to the senior advisor for strategic engagement"                                                        
 [501] "press lead"                                                                                                                                            
 [502] "senior press lead"                                                                                                                                     
 [503] "special assistant to the president, senior director and national security staff spokesman"                                                             
 [504] "technology project manager"                                                                                                                            
 [505] "special assistant to the president and deputy chief of staff and director of operations for the first lady"                                            
 [506] "special assistant to the president for labor and workforce policy"                                                                                     
 [507] "special assistant to the president and chief of staff for the office of public engagement and intergovernmental affairs"                               
 [508] "senior confirmations advisor"                                                                                                                          
 [509] "deputy assistant to the president and director of the white house military office"                                                                     
 [510] "outreach and recruitment director (community organizations)"                                                                                           
 [511] "ethics counsel"                                                                                                                                        
 [512] "energy/environment director for presidential personnel"                                                                                                
 [513] "travel planner"                                                                                                                                        
 [514] "special assistant to the president and advisor to the chief of staff"                                                                                  
 [515] "national security director for presidential personnel"                                                                                                 
 [516] "assistant director for cabinet affairs operations"                                                                                                     
 [517] "deputy director, let's move!"                                                                                                                          
 [518] "outreach and recruitment director"                                                                                                                     
 [519] "public engagement liaison"                                                                                                                             
 [520] "associate director of white house personnel"                                                                                                           
 [521] "policy advisor for health care"                                                                                                                        
 [522] "special assistant to the chief of staff for the office of public engagement and intergovernmental affairs"                                             
 [523] "chief of staff to the white house counsel"                                                                                                             
 [524] "special assistant to the senior advisor and the deputy chief of staff"                                                                                 
 [525] "executive assistant to the director of the presidential personnel office"                                                                              
 [526] "special assistant to the president, principal deputy press secretary and chief of staff"                                                               
 [527] "director of white house personnel and advisor for management and administration"                                                                       
 [528] "public engagement advisor"                                                                                                                             
 [529] "personal aide to the first lady and east wing operations coordinator"                                                                                  
 [530] "executive director of let's move! and senior policy advisor for nutrition policy"                                                                      
 [531] "outreach and recruitment staff assistant"                                                                                                              
 [532] "clearance counsel"                                                                                                                                     
 [533] "domestic director for presidential personnel"                                                                                                          
 [534] "special assistant to the director of the national economic council"                                                                                    
 [535] "special assistant to the deputy senior advisor for communications and strategy"                                                                        
 [536] "outreach and recruitment director for presidential personnel"                                                                                          
 [537] "special assistant to the president and director of private sector engagement"                                                                          
 [538] "senior communications advisor"                                                                                                                         
 [539] "deputy associate director of let's move!"                                                                                                              
 [540] "special assistant to the president and director of strategic planning"                                                                                 
 [541] "assistant to the president for homeland security and counterterrorism and deputy national security advisor"                                            
 [542] "associate director for policy"                                                                                                                         
 [543] "principal deputy director of scheduling and scheduling manager"                                                                                        
 [544] "director of research"                                                                                                                                  
 [545] "special assistant to the president and senior advisor to the deputy chief of staff"                                                                    
 [546] "associate director for policy, let's move!"                                                                                                            
 [547] "special assistant to the president and senior director of cabinet affairs"                                                                             
 [548] "special assistant to the president for management and administration"                                                                                  
 [549] "outreach and recruitment director (congressional)"                                                                                                     
 [550] "deputy assistant to the president, deputy national security advisor for strategic communications and speechwriting"                                    
 [551] "senior policy advisor and deputy chief of staff of the national economic council"                                                                      
 [552] "economics director for presidential personnel"                                                                                                         
 [553] "assistant to the president and deputy senior advisor for communications and strategy"                                                                  
 [554] "director of international affairs and senior policy advisor"                                                                                           
 [555] "senior director of cabinet affairs"                                                                                                                    
 [556] "special assistant to the president and principal deputy director of public engagement"                                                                 
 [557] "deputy assistant to the president and senior advisor to the first lady"                                                                                
 [558] "policy assistant for urban affairs and economic mobility"                                                                                              
 [559] "special assistant to the president and house legislative affairs liaison"                                                                              
 [560] "chief of staff and senior advisor to the director of the office of legislative affairs"                                                                
 [561] "deputy assistant to the president for the office of urban affairs, justice, and opportunity"                                                           
 [562] "digital creative director"                                                                                                                             
 [563] "assistant to the president and director of the white house military office"                                                                            
 [564] "trip coordinator"                                                                                                                                      
 [565] "deputy director, joining forces"                                                                                                                       
 [566] "director of the white house business council"                                                                                                          
 [567] "deputy assistant to the president and director of advance"                                                                                             
 [568] "technology manager for presidential personnel"                                                                                                         
 [569] "assistant to the president and deputy chief of staff for implementation"                                                                               
 [570] "deputy director of digital programs"                                                                                                                   
 [571] "advisor to the counselor to the president"                                                                                                             
 [572] "deputy director of white house personnel and director of the white house internship program"                                                           
 [573] "deputy director of stenography"                                                                                                                        
 [574] "boards and commissions director for presidential personnel"                                                                                            
 [575] "stenographer"                                                                                                                                          
 [576] "director of planning and events for the office of public engagement and intergovernmental affairs"                                                     
 [577] "special assistant to the president for immigration policy"                                                                                             
 [578] "assistant to the president and director of the office of legislative affairs"                                                                          
 [579] "senior advisor for strategic communications for the national economic council"                                                                         
 [580] "senior advisor and chief of staff of the national economic council"                                                                                    
 [581] "director of video for digital strategy"                                                                                                                
 [582] "associate director of public engagement and intergovernmental affairs"                                                                                 
 [583] "deputy director of presidential correspondence"                                                                                                        
 [584] "special assistant for presidential personnel"                                                                                                          
 [585] "vetting advisor for presidential personnel"                                                                                                            
 [586] "special assistant and senior advance lead"                                                                                                             
 [587] "special assistant to the president and senate legislative affairs liaison"                                                                             
 [588] "member relations advisor"                                                                                                                              
 [589] "associate director of content"                                                                                                                         
 [590] "special assistant to the office of cabinet affairs"                                                                                                    
 [591] "associate director for operations"                                                                                                                     
 [592] "outreach and recruitment staff assistant for presidential personnel"                                                                                   
 [593] "deputy senior advisor and director of external relations for the first lady"                                                                           
 [594] "research coordinator for presidential personnel"                                                                                                       
 [595] "director for correspondence systems innovation"                                                                                                        
 [596] "chief of staff for presidential personnel"                                                                                                             
 [597] "deputy director for finance"                                                                                                                           
 [598] "director of message planning"                                                                                                                          
 [599] "special assistant to the director of the presidential personnel office"                                                                                
 [600] "special assistant to the president and director of progressive media and online response"                                                              
 [601] "operations staff assistant for presidential personnel"                                                                                                 
 [602] "associate policy director"                                                                                                                             
 [603] "special assistant to the president and principal deputy director of scheduling"                                                                        
 [604] "special assistant to the president for international economics"                                                                                        
 [605] "special assistant to the director of the office of political strategy and outreach"                                                                    
 [606] "economics staff assistant for presidential personnel"                                                                                                  
 [607] "deputy assistant to the president for presidential personnel"                                                                                          
 [608] "deputy director of email and petitions"                                                                                                                
 [609] "outreach and recruitment director for presidential personnel (congressional)"                                                                          
 [610] "special assistant to the president and director of strategic planning for the first lady"                                                              
 [611] "special assistant to the president and senior advisor for the national economic council"                                                               
 [612] "associate director for technology"                                                                                                                     
 [613] "senior policy advisor for labor and workforce"                                                                                                         
 [614] "special assistant to the president and advisor for the office of political strategy and outreach"                                                      
 [615] "special assistant to the president and deputy director of intergovernmental affairs"                                                                   
 [616] "special assistant to the president and deputy director of the office of political strategy and outreach"                                               
 [617] "national security staff assistant for presidential personnel"                                                                                          
 [618] "operations director for presidential personnel"                                                                                                        
 [619] "assistant to the president and deputy national security advisor for strategic communications and speechwriting"                                        
 [620] "regional communicatons director"                                                                                                                       
 [621] "energy and environment director for presidential personnel"                                                                                            
 [622] "director of digital analytics"                                                                                                                         
 [623] "associate regional communications director"                                                                                                            
 [624] "deputy press secretary and executive secretary for the domestic policy council"                                                                        
 [625] "assistant to the president and director of the office of political strategy and outreach"                                                              
 [626] "director of stenography"                                                                                                                               
 [627] "deputy press secretary"                                                                                                                                
 [628] "special assistant to the president for energy and climate change"                                                                                      
 [629] "executive director and policy advisor, reach higher initiative"                                                                                        
 [630] "director of writers and production"                                                                                                                    
 [631] "senior policy advisor for health and the office of national aids policy"                                                                               
 [632] "deputy director for energy policy"                                                                                                                     
 [633] "special assistant to the president for message planning"                                                                                               
 [634] "senior advisor for the national economic council"                                                                                                      
 [635] "senior analyst and project manager"                                                                                                                    
 [636] "deputy director of research"                                                                                                                           
 [637] "senior public engagement advisor for labor and working families"                                                                                       
 [638] "special assistant to the director of scheduling and advance"                                                                                           
 [639] "advance lead"                                                                                                                                          
 [640] "associate director of content and operations"                                                                                                          
 [641] "assistant director of the council on women and girls"                                                                                                  
 [642] "director of greetings"                                                                                                                                 
 [643] "associate research director for vetting"                                                                                                               
 [644] "deputy director of message planning and senior writer"                                                                                                 
 [645] "senior assistant staff secretary"                                                                                                                      
 [646] "director of the white house switchboard"                                                                                                               
 [647] "counselor to the office of legislative affairs"                                                                                                        
 [648] "special assistant to the president and deputy director of scheduling"                                                                                  
 [649] "chief of staff for the office of digital strategy"                                                                                                     
 [650] "special assistant to the president for economic and technology policy"                                                                                 
 [651] "special assistant to the president for management and administration and director of white house personnel"                                            
 [652] "special assistant to the director of presidential personnel"                                                                                           
 [653] "senior management analyst"                                                                                                                             
 [654] "director of principal trip accommodations"                                                                                                             
 [655] "deputy assistant to the president and chief digital officer"                                                                                           
 [656] "special assistant to the director of the domestic policy council"                                                                                      
 [657] "special assistant to the president and deputy staff secretary"                                                                                         
 [658] "deputy director for information services"                                                                                                              
 [659] "senior designer for the office of digital strategy"                                                                                                    
 [660] "special assistant and advisor to the senior advisor"                                                                                                   
 [661] "special assistant to the president, senior strategic and policy advisor to the council on women and girls, and senior presidential speechwriter"       
 [662] "senior associate research director"                                                                                                                    
 [663] "special assistant and director of special projects for the first lady"                                                                                 
 [664] "director of the white house internship program"                                                                                                        
 [665] "advisor to the council on women and girls"                                                                                                             
 [666] "associate director for confirmations"                                                                                                                  
 [667] "deputy chief of staff for the national economic council"                                                                                               
 [668] "director of planning for the office of political strategy and outreach"                                                                                
 [669] "director of regional media"                                                                                                                            
 [670] "director of the comment line"                                                                                                                          
 [671] "chief of staff to the office of the white house counsel"                                                                                               
 [672] "scheduler"                                                                                                                                             
 [673] "travel manager"                                                                                                                                        
 [674] "senior advisor, tax and fiscal policy"                                                                                                                 
 [675] "advisor for technology"                                                                                                                                
 [676] "assistant to the executive clerk for legislation"                                                                                                      
 [677] "special assistant to the president and principal travel aide"                                                                                          
 [678] "principal deputy associate counsel"                                                                                                                    
 [679] "special assistant and advisor to the director of legislative affairs"                                                                                  
 [680] "director of broadcast media"                                                                                                                           
 [681] "deputy assistant to the president and advisor to the chief of staff"                                                                                   
 [682] "strategic communications advisor"                                                                                                                      
 [683] "deputy director and senior advisor for records management"                                                                                             
 [684] "special assistant and advisor to the press secretary"                                                                                                  
 [685] "special assistant to the president and director of white house information technology"                                                                 
 [686] "special assistant to the president and senior deputy director of public engagement"                                                                    
 [687] "deputy assistant to the president for education policy"                                                                                                
 [688] "senior associate director and trip manager"                                                                                                            
 [689] "press secretary and deputy communications director for the first lady"                                                                                 
 [690] "records management information systems specialist"                                                                                                     
 [691] "special assistant to the president for management and administration and director of the visitors office"                                              
 [692] "deputy executive director and director of outreach for the council on women and girls"                                                                 
 [693] "assistant director for constituent engagement for presidential correspondence"                                                                         
 [694] "director, office of presidential support"                                                                                                              
 [695] "special assistant to the president for legislative affairs and house legislative affairs liaison"                                                      
 [696] "special assistant to the president and senior director of cabinet affairs for the my brother\u0092s keeper initiative"                                 
 [697] "deputy director of scheduling and advance and travel aide for the first lady"                                                                          
 [698] "special assistant to the president for economic mobility"                                                                                              
 [699] "associate director for presidential correspondence"                                                                                                    
 [700] "assistant executive clerk for messages and executive actions"                                                                                          
 [701] "special assistant to the president and advisor to the office of the chief of staff"                                                                    
 [702] "deputy press secretary for the first lady"                                                                                                             
 [703] "special assistant and advisor to the chief of staff"                                                                                                   
 [704] "presidential writer"                                                                                                                                   
 [705] "director, office of social innovation and civic participation"                                                                                         
 [706] "associate director for the management and administration front office"                                                                                 
 [707] "advisor to the chief of staff"                                                                                                                         
 [708] "deputy assistant to the president for intergovernmental affairs and public engagement and senior advisor to the national economic council"             
 [709] "press assistant for regional and specialty media"                                                                                                      
 [710] "senior associate director of intergovernmental affairs"                                                                                                
 [711] "senior legislative assistant"                                                                                                                          
 [712] "senior press assistant"                                                                                                                                
 [713] "associate director for presidential personnel"                                                                                                         
 [714] "deputy director for white house personnel"                                                                                                             
 [715] "staff assistant and coordinator for presidential personnel office"                                                                                     
 [716] "special assistant and advisor for the press secretary"                                                                                                 
 [717] "deputy director of research and rapid response advisor"                                                                                                
 [718] "chief of staff for the deputy chief of staff for operations"                                                                                           
 [719] "director of scheduling correspondence"                                                                                                                 
 [720] "archivist"                                                                                                                                             
 [721] "assistant director for constituent engagement for the office of presidential correspondence"                                                           
 [722] "deputy chief of staff for the domestic policy council"                                                                                                 
 [723] "deputy executive director of the council on women and girls"                                                                                           
 [724] "senior policy advisor for economic policy and director of techhire"                                                                                    
 [725] "chief of staff for the office of communications"                                                                                                       
 [726] "senior director of hispanic media"                                                                                                                     
 [727] "special assistant and trip director to the first lady"                                                                                                 
 [728] "special assistant to the president for presidential personnel and lead for leadership development"                                                     
 [729] "senior writer and deputy director of messaging"                                                                                                        
 [730] "associate director of communications for the office of public engagement"                                                                              
 [731] "consultant"                                                                                                                                            
 [732] "chief of staff for the office of the staff secretary"                                                                                                  
 [733] "policy advisor to the council on women and girls"                                                                                                      
 [734] "special assistant and policy advisor for the office of urban affairs, justice, and opportunity"                                                        
 [735] "special assistant to the president for native american affairs"                                                                                        
 [736] "associate director for boards, commissions, and delegations"                                                                                           
 [737] "deputy chief of staff for the office of public engagement and intergovernmental affairs"                                                               
 [738] "director of the white house business council and policy advisor"                                                                                       
 [739] "assistant supervisor for classification"                                                                                                               
 [740] "associate director of public engagement and senior policy advisor"                                                                                     
 [741] "assistant director for cabinet affairs"                                                                                                                
 [742] "director of students correspondence and engagement for presidential correspondence"                                                                    
 [743] "outreach and recruitment director for presidential personnel and associate director of public engagement"                                              
 [744] "special assistant to the president, deputy press secretary and senior advisor to the press secretary"                                                  
 [745] "press assistant and press wrangler"                                                                                                                    
 [746] "special assistant and policy advisor for education"                                                                                                    
 [747] "director of video and special projects for the office of digital strategy"                                                                             
 [748] "associate director of digital outbound"                                                                                                                
 [749] "senior advance manager and director of principal trip accommodations"                                                                                  
 [750] "deputy chief of staff for presidential personnel and policy advisor to the council on women and girls"                                                 
 [751] "special assistant and policy advisor to the director of the domestic policy council"                                                                   
 [752] "presidential videographer"                                                                                                                             
 [753] "communications director and senior policy advisor for the domestic policy council"                                                                     
 [754] "assistant director of the white house business council"                                                                                                
 [755] "senior advisor for congressional engagement and legislative relations"                                                                                 
 [756] "assistant press secretary and white house spokesperson"                                                                                                
 [757] "white house leadership development fellow"                                                                                                             
 [758] "policy advisor to the senior advisor"                                                                                                                  
 [759] "special assistant to the director of the office of public engagement"                                                                                  
 [760] "associate counsel for presidential personnel"                                                                                                          
 [761] "west wing receptionist and coordinator for operations"                                                                                                 
 [762] "special assistant to the president and chief of staff of the national economic council"                                                                
 [763] "climate and domestic director for presidential personnel"                                                                                              
 [764] "senior policy advisor for economic policy"                                                                                                             
 [765] "director of the white house internship program and dc scholars program"                                                                                
 [766] "senior associate director of intergovernmental affairs and public engagement"                                                                          
 [767] "special assistant to the president, chief of staff, and advisor to the director of presidential personnel"                                             
 [768] "senior video producer"                                                                                                                                 
 [769] "special assistant to the president for presidential personnel and lead for national security and foreign policy"                                       
 [770] "special assistant to the president and director of rapid response"                                                                                     
 [771] "assistant director of online engagement"                                                                                                               
 [772] "senior technical program manager"                                                                                                                      
 [773] "senior policy advisor for economic development"                                                                                                        
 [774] "policy advisor to the deputy chief of staff for implementation"                                                                                        
 [775] "trip coordinator for the first lady"                                                                                                                   
 [776] "senior director of regional media"                                                                                                                     
 [777] "deputy director for digital outbound"                                                                                                                  
 [778] "associate director of confirmations and legislative correspondence"                                                                                    
 [779] "special assistant and policy advisor for the white house office of faith-based and neighborhood partnerships"                                          
 [780] "chief of staff and advisor to the white house counsel office"                                                                                          
 [781] "special assistant to the president for higher education policy"                                                                                        
 [782] "special assistant to the president and chief of staff of the office of legislative affairs"                                                            
 [783] "director of product management"                                                                                                                        
 [784] "senior records management analyst"                                                                                                                     
 [785] "special assistant to the president for presidential personnel and lead for boards, commissions, and presidential delegations"                          
 [786] "senior analyst and presidential writer"                                                                                                                
 [787] "associate director of the white house internship program"                                                                                              
 [788] "leadership development director for presidential personnel"                                                                                            
 [789] "senior advisor to the director and deputy chief of staff of the national economic council"                                                             
 [790] "strategic communications advisor and special projects manager"                                                                                         
 [791] "special assistant to the president for presidential personnel and lead for economics and justice"                                                      
 [792] "senior regional communications director"                                                                                                               
 [793] "principal associate director of scheduling"                                                                                                            
 [794] "senior advance coordinator"                                                                                                                            
 [795] "senior director of specialty media"                                                                                                                    
 [796] "special assistant to the president and deputy director of digital strategy"                                                                            
 [797] "special assistant to the president, principal deputy press secretary and senior advisor to the press secretary"                                        
 [798] "associate digital producer"                                                                                                                            
 [799] "principal deputy director of presidential correspondence"                                                                                              
 [800] "deputy director for digital initiatives"                                                                                                               
 [801] "research director for presidential personnel"                                                                                                          
 [802] "special assistant to the president and director of scheduling and advance for the first lady"                                                          
 [803] "special assistant to the president and senior director of cabinet affairs for the my brother's keeper initiative"                                      
 [804] "director of digital rapid response"                                                                                                                    
 [805] "special assistant and policy advisor to the director of intergovernmental affairs"                                                                     
 [806] "deputy director for technology"                                                                                                                        
 [807] "deputy director of the office of presidential correspondence"                                                                                          
 [808] "associate director for technology and operations for presidential personnel"                                                                           
 [809] "senior associate communications director"                                                                                                              
 [810] "senior research associate"                                                                                                                             
 [811] "special assistant to the deputy chief of staff for operations"                                                                                         
 [812] "senior technical advisor to the director of white house information technology"                                                                        
 [813] "supervisor for classification"                                                                                                                         
 [814] "senior press assistant and special assistant to the deputy director of communications"                                                                 
 [815] "senior director of cabinet affairs and senior advisor for the domestic policy council"                                                                 
 [816] "senior director of african-american media"                                                                                                             
 [817] "deputy director for white house operations and director for finance"                                                                                   
 [818] "deputy director for white house operations"                                                                                                            
 [819] "senior public engagement advisor"                                                                                                                      
 [820] "special assistant and policy advisor to the chief of staff of the office of public engagement and intergovernmental affairs"                           
 [821] "special assistant to the president and director of the office of the chief of staff"                                                                   
 [822] "deputy director of operations for the white house management office"                                                                                   
 [823] "director of digital engagement"                                                                                                                        
 [824] "special assistant to the president and senior associate counsel to the president"                                                                      
 [825] "assistant to the president and chief strategist and senior counselor"                                                                                  
 [826] "senior digital strategist"                                                                                                                             
 [827] "special assistant to the president for regulatory reform, legal and immigration policy"                                                                
 [828] "writer for correspondence"                                                                                                                             
 [829] "special assistant to the president and assistant to the senior advisor"                                                                                
 [830] "deputy social secretary"                                                                                                                               
 [831] "special assistant to the president and deputy director of white house management and administration"                                                   
 [832] "special assistant to the president and associate director of presidential personnel"                                                                   
 [833] "special assistant to the president for health policy"                                                                                                  
 [834] "supervisor for document management and tracking unit"                                                                                                  
 [835] "lead advance representative"                                                                                                                           
 [836] "operations manager"                                                                                                                                    
 [837] "special assistant to the president and director of special communications projects"                                                                    
 [838] "special assistant to the president for operations"                                                                                                     
 [839] "assistant to the president and director of the national economic council"                                                                              
 [840] "assistant to the president and senior counselor"                                                                                                       
 [841] "assistant to the president for intergovernmental and technology initiatives"                                                                           
 [842] "scheduler and trip coordinator"                                                                                                                        
 [843] "director of digital response for correspondence"                                                                                                       
 [844] "assistant to the president and deputy chief of staff for legislative, cabinet, intergovernmental affairs and implementation"                           
 [845] "director of the white house swrtchboard"                                                                                                               
 [846] "special assistant to the president and deputy counsel to the president"                                                                                
 [847] "deputy assistant to the president and director of policy and interagency coordination"                                                                 
 [848] "special assistant to the president and advisor for planning"                                                                                           
 [849] "deputy assistant to the president and special counsel to the president and chief of staff to the white house counsel"                                  
 [850] "director of congressional communications"                                                                                                              
 [851] "project manager"                                                                                                                                       
 [852] "lead press representative"                                                                                                                             
 [853] "deputy assistant to the president and deputy counsel to the president for national security affairs and legal advisor to the national security council"
 [854] "deputy assistant to the president and deputy director of the national economic council and international economic affairs"                             
 [855] "research analyst"                                                                                                                                      
 [856] "special assistant to the president and senior associate counsel to the president and deputy legal advisor to the national security council"            
 [857] "deputy director of advance for the first lady"                                                                                                         
 [858] "senior director for cabinet affairs"                                                                                                                   
 [859] "senior trip coordinator"                                                                                                                               
 [860] "director of video images"                                                                                                                              
 [861] "deputy assistant to the president and director of presidential advance"                                                                                
 [862] "education advisor"                                                                                                                                     
 [863] "deputy assistant to the president and strategist"                                                                                                      
 [864] "director of presidentialgifts"                                                                                                                         
 [865] "special assistant to the president and deputy director of trade and manufacturing policy"                                                              
 [866] "assistant to the president and special representative for international negotiations"                                                                  
 [867] "special assistant to the president and deputy strategist"                                                                                              
 [868] "director of whrte house travel office"                                                                                                                 
 [869] "special assistant to the president and advisor for strategy and speechwriting"                                                                         
 [870] "regional director"                                                                                                                                     
 [871] "director of agency liaison for correspondence"                                                                                                         
 [872] "assistant to the president and director of strategic communications"                                                                                   
 [873] "special projects manager"                                                                                                                              
 [874] "deputy assistant to the president and chief of staff to the senior counselor"                                                                          
 [875] "special assistant to the president and executive assistant to the chief of staff"                                                                      
 [876] "director of student and children's correspondence"                                                                                                     
 [877] "director of white house internship program and volunteers"                                                                                             
 [878] "special assistant to the president and advisor for development and speechwriting"                                                                      
 [879] "personal aide"                                                                                                                                         
 [880] "assistant supervisor for document management and tracking unit"                                                                                        
 [881] "special assistant to the president and deputy director of presidential advance"                                                                        
 [882] "director of digital operations"                                                                                                                        
 [883] "deputy assistant to the president and deputy director of the national economic council and economic policy"                                            
 [884] "executive director for white house council on native american affairs"                                                                                 
 [885] "assistant to the president and executive secretary and chief of staff for the national security council"                                               
 [886] "deputy assistant to the president and director of white house management and administration and director of the office of administration"              
 [887] "special assistant to the president and deputy director of the office of public liaison"                                                                
 [888] "director of special projects for cabinet affairs"                                                                                                      
 [889] "supervisor for search and file section"                                                                                                                
 [890] "communications coordinator"                                                                                                                            
 [891] "assistant to the president for strategic initiatives"                                                                                                  
 [892] "special assistant to the president for innovation policy and initiatives"                                                                              
 [893] "research assistant and executive assistant"                                                                                                            
 [894] "special assistant to the president and director of whue house events and presidential scheduling"                                                      
 [895] "director of radio media"                                                                                                                               
 [896] "assistant to the president and director of communications for the office of public liaison"                                                            
 [897] "special assistant to the president and chief of staff of the national economic council and economic policy"                                            
 [898] "special assistant to the president and director of organizational structure and human capital"                                                         
 [899] "deputy director of correspondence and director of writers"                                                                                             
 [900] "special assistant to the president and deputy cabinet secretary"                                                                                       
 [901] "special assistant to the president and associate staff secretary"                                                                                      
 [902] "director of mail analysis"                                                                                                                             
 [903] "deputy associate counsel to the president"                                                                                                             
 [904] "deputy assistant to the president and cabinet secretary"                                                                                               
 [905] "education, women and families, and workforce policy advisor"                                                                                           
 [906] "special assistant to the president and deputy director for press advance"                                                                              
 [907] "deputy assistant to the president for legislative affairs and house deputy director"                                                                   
 [908] "assistant to the president and senior advisor for policy"                                                                                              
 [909] "assistant supervisor for search and file"                                                                                                              
 [910] "research analyst and executive assistant"                                                                                                              
 [911] "assistant to the office of american innovation"                                                                                                        
 [912] "deputy director for buy american/hire american"                                                                                                        
 [913] "senior director of scheduling"                                                                                                                         
 [914] "advisor to the press secretary"                                                                                                                        
 [915] NA                                                                                                                                                      
 [916] "deputy assistant to the president and principal deputy director of the office of public liaison"                                                       
 [917] "deputy assistant to the president and director of trade and manufacturing policy"                                                                      
 [918] "special assistant to the president and social secretary"                                                                                               
 [919] "director of agency outreach for cabinet affairs"                                                                                                       
 [920] "senior writer for correspondence"                                                                                                                      
 [921] "assistant to the president and white house staff secretary"                                                                                            
 [922] "assistant to the president and deputy national security advisor for strategy"                                                                          
 [923] "special assistant to president and associate director of presidential personnel"                                                                       
 [924] "special assistant to the president and chief of staff for economic initiatives"                                                                        
 [925] "deputy assistant to the president and communications advisor"                                                                                          
 [926] "director of cabinet communications"                                                                                                                    
 [927] "interim chief digital officer"                                                                                                                         
 [928] "special assistant to the president and director of special projects and research"                                                                      
 [929] "special assistant to the president and speechwriter"                                                                                                   
 [930] "special assistant to the president and director of message strategy"                                                                                   
 [931] "senior lead press representative"                                                                                                                      
 [932] "deputy assistant to the president and principal deputy press secretary"                                                                                
 [933] "special assistant to the president and director of correspondence"                                                                                     
 [934] "assistant to the president and director of social media"                                                                                               
 [935] "deputy assistant to the president and director of oval office operations"                                                                              
 [936] "deputy assistant to the president and deputy director of communications and director of research"                                                      
 [937] "labor advisor"                                                                                                                                         
 [938] "communications assistant"                                                                                                                              
 [939] "assistant to the president and director of the office of public liaison"                                                                               
 [940] "urban affairs and revitalization policy advisor"                                                                                                       
 [941] "special assistant to the president and director of whrte house personnel"                                                                              
 [942] "deputy assistant to the president and director of political affairs"                                                                                   
 [943] "finance and logistics officer"                                                                                                                         
 [944] "assistant press secretary and senior writer"                                                                                                           
 [945] "deputy assistant to the president for legislative affairs and senate deputy director"                                                                  
 [946] "special assistant to the president for healthcare policy"                                                                                              
 [947] "deputy director of nominations"                                                                                                                        
 [948] "associate director of presidential personnel"                                                                                                          
 [949] "director of regional operations"                                                                                                                       
 [950] "special assistant to the president and deputy chief of staff of operations for the first lady"                                                         
 [951] "first daughter and advisor to the president"                                                                                                           
 [952] "supervisor of computer administration for records management"                                                                                          
 [953] "supervisor for records management classification"                                                                                                      
 [954] "immigration advisor"                                                                                                                                   
 [955] "special assistant to the president and deputy press secretary and advisor to the press secretary"                                                      
 [956] "deputy director of white house travel office"                                                                                                          
 [957] "special assistant to the president and executive assistant to the president"                                                                           
 [958] "director of personal correspondence"                                                                                                                   
 [959] "deputy assistant to the president and deputy director of the domestic policy council and director of budget policy"                                    
 [960] "special assistant to the president for justice and homeland security policy"                                                                           
 [961] "correspondence assistant/analyst"                                                                                                                      
 [962] "director, office of management and administration"                                                                                                     
 [963] "senior advance representative"                                                                                                                         
 [964] "deputy director, student correspondence"                                                                                                               
 [965] "special government employee"                                                                                                                           
 [966] "executive assistant to the counselor"                                                                                                                  
 [967] "special assistant to the president and associate director"                                                                                             
 [968] "director, white house greetings and comment line"                                                                                                      
 [969] "press advance representative"                                                                                                                          
 [970] "director, gift unit"                                                                                                                                   
 [971] "finance manager"                                                                                                                                       
 [972] "white house telephone operator"                                                                                                                        
 [973] "deputy assistant to the president and chief of staff to the first lady"                                                                                
 [974] "administrative assistant to the staff secretary"                                                                                                       
 [975] "deputy assistant to the president and director, intergovernmental affairs"                                                                             
 [976] "deputy assistant to the counselor, communications"                                                                                                     
 [977] "special assistant to the president and associate counsel"                                                                                              
 [978] "write house phone director"                                                                                                                            
 [979] "hovel program manager"                                                                                                                                 
 [980] "executive assistant to the deputy director"                                                                                                            
 [981] "chief of staff's scheduler"                                                                                                                            
 [982] "deputy director of scheduling-research"                                                                                                                
 [983] "senior press advance representative"                                                                                                                   
 [984] "senior correspondence analyst and agency mail coordinator"                                                                                             
 [985] "administrative assistant"                                                                                                                              
 [986] "special assistant to the president and deputy director of public liaison"                                                                              
 [987] "assistant to the president and deputy chief of staff"                                                                                                  
 [988] "assistant counsel to the president"                                                                                                                    
 [989] "deputy assistant to the president and director, domestic policy counsel"                                                                               
 [990] "associate director, presidential personnel"                                                                                                            
 [991] "assistant to the president for legislative affairs"                                                                                                    
 [992] "supervisor, data entry unit"                                                                                                                           
 [993] "associate director of law and policy"                                                                                                                  
 [994] "special assistant to the president and deputy director of strategic initiative"                                                                        
 [995] "special assistat to the president (house)"                                                                                                             
 [996] "special assistant to the assistant to the president for legislative affairs"                                                                           
 [997] "assistant director, presidential support"                                                                                                              
 [998] "director of agency liaison"                                                                                                                            
 [999] "honorary chair and awards coordinator"                                                                                                                 
[1000] "associate director of political affairs"                                                                                                               
[1001] "special assistant for management and administration"                                                                                                   
[1002] "press advance administrative assistant"                                                                                                                
[1003] "director, presidential messages and proclamations"                                                                                                     
[1004] "special assistant to the president and deputy director of media affairs"                                                                               
[1005] "deputy director, proclamations"                                                                                                                        
[1006] "assistant to the president and director, white house faith-based and community initiatives"                                                            
[1007] "correspondence manager"                                                                                                                                
[1008] "supervisor, correspondence review unit"                                                                                                                
[1009] "political coordinator"                                                                                                                                 
[1010] "deputy assistant to the president for faith-based and community initiatives"                                                                           
[1011] "deputy assistant to the president and deputy nsa for international economic affairs"                                                                   
[1012] "associate director/volunteer office"                                                                                                                   
[1013] "deputy assistant to the president and director of media affairs"                                                                                       
[1014] "president's personal secretary"                                                                                                                        
[1015] "assistant ot the executive clerk"                                                                                                                      
[1016] "speechwriter for the first lady"                                                                                                                       
[1017] "executive assistant to the director of scheduling and appointments"                                                                                    
[1018] "deputy assistant to the president and deputy counsel"                                                                                                  
[1019] "assistant to the president and white house press secretary"                                                                                            
[1020] "special assistant to the president for economic speech writing"                                                                                        
[1021] "deputy assistant to the president and director, oval office operations"                                                                                
[1022] "executive assistant to the deputy assistant to the president for presidential personnel"                                                               
[1023] "deputy assistant to the president and director of speechwriting"                                                                                       
[1024] "caseworker"                                                                                                                                            
[1025] "associate director of public liaison"                                                                                                                  
[1026] "assistant to the president and white house counsel"                                                                                                    
[1027] "director, office of records management"                                                                                                                
[1028] "communications staff assistant"                                                                                                                        
[1029] "executive assistant to the director"                                                                                                                   
[1030] "deputy director of scheduling-surrogate scheduling"                                                                                                    
[1031] "executive assistant/paralegal"                                                                                                                         
[1032] "director of radio services"                                                                                                                            
[1033] "associate director, white house comments line and greetings office"                                                                                    
[1034] "paralegal specialist"                                                                                                                                  
[1035] "editor/quality control"                                                                                                                                
[1036] "director, presidential personal correspondence"                                                                                                        
[1037] "press staff assistant"                                                                                                                                 
[1038] "associate director of presidential advance"                                                                                                            
[1039] "assistant to the president and secretary to the cabinet"                                                                                               
[1040] "white house travel specialist"                                                                                                                         
[1041] "director of projects"                                                                                                                                  
[1042] "deputy assistant to the president and deputy to the senior advisor"                                                                                    
[1043] "special assistant to the social secretary"                                                                                                             
[1044] "deputy assistant to the president for legislative affairs (house)"                                                                                     
[1045] "computer specialist"                                                                                                                                   
[1046] "deputy assistant to the president and deputy director for legislative affairs"                                                                         
[1047] "logistical specialist"                                                                                                                                 
[1048] "deputy assistant to the president and director of strategic initiatives"                                                                               
[1049] "scheduler to the first lady"                                                                                                                           
[1050] "special assistant to the president and deputy director of advance press"                                                                               
[1051] "principal assistant press secretary"                                                                                                                   
[1052] "assistant to the president for presidential personnel and deputy to the chief of staff"                                                                
[1053] "deputy director of the office of records management"                                                                                                   
[1054] "deputy director of correspondence"                                                                                                                     
[1055] "invitations assistant"                                                                                                                                 
[1056] "assistant agency coordinator/correspondence analyst"                                                                                                   
[1057] "special assistant to the chief of staff for policy"                                                                                                    
[1058] "special assistant to the president for legislative affairs (house)"                                                                                    
[1059] "records management technician"                                                                                                                         
[1060] "special assistant to the president for legislative affairs (senate)"                                                                                   
[1061] "administrative assistant to the director"                                                                                                              
[1062] "senior mail clerk"                                                                                                                                     
[1063] "assistant to the president for domestic policy"                                                                                                        
[1064] "special assistant to the president and director, office of administration"                                                                             
[1065] "manager, the president's young artists program"                                                                                                        
[1066] "assistant to the president and chief of staff to the vice president"                                                                                   
[1067] "assistant to the president and director, national economic council"                                                                                    
[1068] "spokesman"                                                                                                                                             
[1069] "executive assistant to the deputy chief of staff"                                                                                                      
[1070] "printer"                                                                                                                                               
[1071] "director, presidential letters and messages"                                                                                                           
[1072] "acting director of white house personnel"                                                                                                              
[1073] "white house telephone service chief operator"                                                                                                          
[1074] "executive assistant to the press secretary"                                                                                                            
[1075] "special assistant to the president and director of white house management"                                                                             
[1076] "procurement liaison"                                                                                                                                   
[1077] "deputy director of scheduling (invitation and correspondence)"                                                                                         
[1078] "special assistant to the first lady"                                                                                                                   
[1079] "director, white house telephone service"                                                                                                               
[1080] "supervisor, optical disk unit"                                                                                                                         
[1081] "deputy assistant to the president for legislative affairs (senate)"                                                                                    
[1082] "director of internet news service"                                                                                                                     
[1083] "executive assistant to the assistant to the president for presidential personnel"                                                                      
[1084] "director of legislative correspondence"                                                                                                                
[1085] "director, white house visitor's office"                                                                                                                
[1086] "attorney advisor"                                                                                                                                      
[1087] "special assistant to the director of communications"                                                                                                   
[1088] "special assistant to the president and deputy director of advance for event coordination"                                                              
[1089] "assistant to the president for national security affairs"                                                                                              
[1090] "assistant to the deputy counsel to the president"                                                                                                      
[1091] "executive assistant to the director of speechwriting"                                                                                                  
[1092] "data entry"                                                                                                                                            
[1093] "director, mail analysis"                                                                                                                               
[1094] "receptionist"                                                                                                                                          
[1095] "director of communications and press secretary to the first lady"                                                                                      
[1096] "deputy director, white house correspondence agency liaison"                                                                                            
[1097] "senior advisor to the president"                                                                                                                       
[1098] "special assistant to the deputy director for legislative affairs"                                                                                      
[1099] "associate director white house comments line and greetings office"                                                                                     
[1100] "office manager"                                                                                                                                        
[1101] "coordinator, white house intern program"                                                                                                               
[1102] "data entry/ quality control"                                                                                                                           
[1103] "special assistant to the president and director of political affairs"                                                                                  
[1104] "associate director for community outreach"                                                                                                             
[1105] "special assistant for management"                                                                                                                      
[1106] "special assistant to the president and senior speechwriter"                                                                                            
[1107] "administrative assistant to the director/photos"                                                                                                       
[1108] "gift analyst/writer"                                                                                                                                   
[1109] "special assistant to the president and deputy director of communications for production"                                                               
[1110] "night staff supervisor and director of special projects"                                                                                               
[1111] "assistant supervisor, classification section"                                                                                                          
[1112] "supervisor, search and file unit"                                                                                                                      
[1113] "legislative correspondent"                                                                                                                             
[1114] "special assistant to the deputy director of the office of public liaison"                                                                              
[1115] "senior telephone operator/training assistant"                                                                                                          
[1116] "senior correspondent analyst"                                                                                                                          
[1117] "deputy assistant to the president and deputy director of the national economic council"                                                                
[1118] "corrspondence analyst"                                                                                                                                 
[1119] "assistant supervisor, search and file unit"                                                                                                            
[1120] "acting director, operations"                                                                                                                           
[1121] "director, student correspondence"                                                                                                                      
[1122] "manager, data entry"                                                                                                                                   
[1123] "staff assistant for projects"                                                                                                                          
[1124] "senior financial manager"                                                                                                                              
[1125] "director, presidential support"                                                                                                                        
[1126] "senior operations manager"                                                                                                                             
[1127] "presidential aide"                                                                                                                                     
[1128] "deputy director for white house correspoindence"                                                                                                       
[1129] "special assistant to the president and deputy director, speechwriting"                                                                                 
[1130] "special assistant, visitors office"                                                                                                                    
[1131] "deputy assistant to the president and director of public liaison"                                                                                      
[1132] "special assistant to the president and deputy director of communications for planning"                                                                 
[1133] "special assistant to the president and director of law and policy"                                                                                     
[1134] "security advisor"                                                                                                                                      
[1135] "associate deputy director, boards and commissions"                                                                                                     
[1136] "supervisor, classification unit"                                                                                                                       
[1137] "director for programs and resources"                                                                                                                   
[1138] "telephone service assistant"                                                                                                                           
[1139] "deputy director of global communication"                                                                                                               
[1140] "deputy director of correspondence for the first lady"                                                                                                  
[1141] "director, comment line, greetings and volunteers"                                                                                                      
[1142] "deputy director of advance"                                                                                                                            
[1143] "deputy director, white house management"                                                                                                               
[1144] "director for administration"                                                                                                                           
[1145] "senior presidential support specialist"                                                                                                                
[1146] "deputy director scheduling and advance"                                                                                                                
[1147] "gift analyst"                                                                                                                                          
[1148] "assistant to the president for communications"                                                                                                         
[1149] "associate political director"                                                                                                                          
[1150] "correspondence analyst and volunteer coordinator"                                                                                                      
[1151] "hotel program manager"                                                                                                                                 
[1152] "director, office of the chief of staff"                                                                                                                
[1153] "special assistant to the president and senior director for biodefense"                                                                                 
[1154] "special assistant to the president and deputy director of communication for planning"                                                                  
[1155] "director, white house management office"                                                                                                               
[1156] "director for transportation and aviation security"                                                                                                     
[1157] "assistant to the president and director usa freedom corps"                                                                                             
[1158] "paralegal"                                                                                                                                             
[1159] "lead advance"                                                                                                                                          
[1160] "special assistant to the president for intergovernmental affairs - mayors"                                                                             
[1161] "director, critical infrastructure protection"                                                                                                          
[1162] "special assistant to the director of speechwriting"                                                                                                    
[1163] "supervisor data entry unit"                                                                                                                            
[1164] "media assistant"                                                                                                                                       
[1165] "special assistant to the president and deputy director, usa freedom corps"                                                                             
[1166] "special assistant for cabinet affair"                                                                                                                  
[1167] "lead presidential support specialist"                                                                                                                  
[1168] "deputy associate director of press advance"                                                                                                            
[1169] "deputy assistant to the president for communication"                                                                                                   
[1170] "associate director of communications for production"                                                                                                   
[1171] "director, presidential proclamations"                                                                                                                  
[1172] "director for response and planning"                                                                                                                    
[1173] "deputy director, office of records management"                                                                                                         
[1174] "civil participation liaison"                                                                                                                           
[1175] "deputy assistant to the president for international economic affairs and deputy national security advisor"                                             
[1176] "senior lead advance representative"                                                                                                                    
[1177] "deputy assistant to the president and director of global communication"                                                                                
[1178] "department of commerce liaison"                                                                                                                        
[1179] "deputy assistant to the president and deputy homeland security advisor"                                                                                
[1180] "deputy director of appointments and scheduling"                                                                                                        
[1181] "media coordinator"                                                                                                                                     
[1182] "assistant to the president for economic policy, and director, national economic council"                                                               
[1183] "special assistant to the executive secretary"                                                                                                          
[1184] "deputy assistant to the president for management, administration and oval office operations"                                                           
[1185] "special assistant to the president and deputy director of advance for press"                                                                           
[1186] "assistant to the president for speechwriting and policy advisor"                                                                                       
[1187] "special assistant to the president and deputy director office of public liaison"                                                                       
[1188] "assistant to the president for homeland security"                                                                                                      
[1189] "special assistant to the president for administrative reform"                                                                                          
[1190] "deputy director of scheduling - surrogate scheduling"                                                                                                  
[1191] "director of advance for the first lady"                                                                                                                
[1192] "spokesman and director of radio"                                                                                                                       
[1193] "intergovernmental liaison"                                                                                                                             
[1194] "director presidential personal correspondence"                                                                                                         
[1195] "associate director of communications"                                                                                                                  
[1196] "deputy assistant to the president and assistant to the senior advisor"                                                                                 
[1197] "director for domestic counterterrorism policy"                                                                                                         
[1198] "associate director of scheduling for invitations and correspondence"                                                                                   
[1199] "special assistant to the deputy assistant to the president for legislative affairs (house)"                                                            
[1200] "director, correspondence personnel"                                                                                                                    
[1201] "acting senior director of response and recovery"                                                                                                       
[1202] "executive assistant to the cabinet secretary and special projects coordinator"                                                                         
[1203] "invitation assistant"                                                                                                                                  
[1204] "special assistant to the assistant to the president"                                                                                                   
[1205] "director for incident management"                                                                                                                      
[1206] "deputy assistant director"                                                                                                                             
[1207] "assistant supervisor, data entry unit"                                                                                                                 
[1208] "special assistant to the president"                                                                                                                    
[1209] "special assistant to the president and director of public and political affairs, usa freedom corps"                                                    
[1210] "assistant to the director of research"                                                                                                                 
[1211] "special assistant to the president and deputy director, office of faith-based and community initiatives"                                               
[1212] "special assistant to the president and senior director, critical infrastructure protection"                                                            
[1213] "usaid liaison"                                                                                                                                         
[1214] "mail clerk/correspondence analyst"                                                                                                                     
[1215] "associate director for correspondence and records management"                                                                                          
[1216] "deputy assistant to the president for domestic policy"                                                                                                 
[1217] "deputy counsel to the president"                                                                                                                       
[1218] "associate director, mail analysis"                                                                                                                     
[1219] "deputy associate director of advance for personnel"                                                                                                    
[1220] "director for public liaison"                                                                                                                           
[1221] "special assistant to the president and deputy director of presidential correspondence"                                                                 
[1222] "director, presidential messages"                                                                                                                       
[1223] "deputy assistant to the president, deputy director of speechwriting and assistant to the vice president"                                               
[1224] "correspondence analyst and web mail administrator"                                                                                                     
[1225] "exec assistant to the director for strategic initiatives"                                                                                              
[1226] "senior associate counsel to the president and general counsel of the office of homeland security"                                                      
[1227] "associate director for security"                                                                                                                       
[1228] "assistant director of projects and policy advisor"                                                                                                     
[1229] "executive assistant to the deputy counsel to the president"                                                                                            
[1230] "special assistant to the president for economic speechwriting"                                                                                         
[1231] "director for cyberspace security"                                                                                                                      
[1232] "director of internet news services"                                                                                                                    
[1233] "director for plans and exercises"                                                                                                                      
[1234] "director, cyber infrastructure protection"                                                                                                             
[1235] "senior editor/writer"                                                                                                                                  
[1236] "attorney, ethics assistant"                                                                                                                            
[1237] "director for recovery"                                                                                                                                 
[1238] "assistant to the president for presidential personnel"                                                                                                 
[1239] "director, white house personnel"                                                                                                                       
[1240] "director of scheduling for the first lady"                                                                                                             
[1241] "executive assistant to the communication director"                                                                                                     
[1242] "director of strategy and performance measurement"                                                                                                      
[1243] "director for consular and international programs"                                                                                                      
[1244] "special assistant to the president and senior speechwriter for the president"                                                                          
[1245] "special assistant to the president and deputy director of communication for production"                                                                
[1246] "assistant supervisor, classification unit"                                                                                                             
[1247] "director, support"                                                                                                                                     
[1248] "senior gift analyst"                                                                                                                                   
[1249] "supervisor search and file unit"                                                                                                                       
[1250] "deputy associate director for outreach"                                                                                                                
[1251] "special assistant to the director of media affairs"                                                                                                    
[1252] "executive secretary"                                                                                                                                   
[1253] "deputy director, gift unit"                                                                                                                            
[1254] "director, homeland security council public liaison"                                                                                                    
[1255] "deputy assistant to the president and director, office of faith-based and community initiatives"                                                       
[1256] "assistant supervisor, optical disk unit"                                                                                                               
[1257] "personnel assistant"                                                                                                                                   
[1258] "deputy director of scheduling for research"                                                                                                            
[1259] "associate director of outreach"                                                                                                                        
[1260] "department of education liaison"                                                                                                                       
[1261] "internet and e-communications director"                                                                                                                
[1262] "deputy director of student correspondence"                                                                                                             
[1263] "associate director for invitations and correspondence"                                                                                                 
[1264] "director of the gift office"                                                                                                                           
[1265] "director of schedule c appointments"                                                                                                                   
[1266] "deputy assistant to the president for appointments and scheduling"                                                                                     
[1267] "associate director of scheduling - research"                                                                                                           
[1268] "director of radio"                                                                                                                                     
[1269] "supervisor of data entry"                                                                                                                              
[1270] "deputy associate director for press advance"                                                                                                           
[1271] "scheduling and advance assistant"                                                                                                                      
[1272] "director of fact-checking"                                                                                                                             
[1273] "special assistant to the president and associate director of communications for production"                                                            
[1274] "director of white house management"                                                                                                                    
[1275] "deputy assistant to the president and deputy press secretary"                                                                                          
[1276] "special assistant to the president , deputy director of advance for press"                                                                             
[1277] "assistant to the president for policy and strategic planning"                                                                                          
[1278] "deputy director of mail analysis"                                                                                                                      
[1279] "special assistant to the president and personal aide"                                                                                                  
[1280] "intern coordinator"                                                                                                                                    
[1281] "special assistant to the president and deputy director, office of public affairs"                                                                      
[1282] "deputy director of presidential writers"                                                                                                               
[1283] "director of presidential messages"                                                                                                                     
[1284] "special assistant to the president for policy"                                                                                                         
[1285] "director of student correspondence"                                                                                                                    
[1286] "special assistant to the staff secretary"                                                                                                              
[1287] "assistant to the president for economic policy and director, national economic council"                                                                
[1288] "executive assistant to the deputy chief of staff and senior advisor"                                                                                   
[1289] "associate director of scheduling - surrogate scheduling"                                                                                               
[1290] "director, immigration security policy"                                                                                                                 
[1291] "assistant supervisor of data entry"                                                                                                                    
[1292] "editor"                                                                                                                                                
[1293] "special assistant to the president and personal secretary"                                                                                             
[1294] "director of presidential support"                                                                                                                      
[1295] "director of television"                                                                                                                                
[1296] "deputy director of media affairs"                                                                                                                      
[1297] "special assistant to the president and clearance counsel"                                                                                              
[1298] "deputy assistant to the president and deputy director of communications for policy and planning"                                                       
[1299] "special assistant to the president for speechwriting"                                                                                                  
[1300] "associate director of communications for policy and planning"                                                                                          
[1301] "executive assistant to the director of strategic initiatives"                                                                                          
[1302] "assistant to the president for speechwriting"                                                                                                          
[1303] "special assistant to the president for domestic policy and director of projects for the first lady"                                                    
[1304] "counsel to the president"                                                                                                                              
[1305] "deputy director of projects for the first lady"                                                                                                        
[1306] "special assistant to the president and sr director for preparedness and response"                                                                      
[1307] "director of coalitions media"                                                                                                                          
[1308] "executive assistant to the deputy assistant to the president for homeland security"                                                                    
[1309] "director, physical ip policy"                                                                                                                          
[1310] "director or administration"                                                                                                                            
[1311] "deputy assistant to the president for homeland security and executive secretary"                                                                       
[1312] "executive assistant to the communications director"                                                                                                    
[1313] "assistant to the president, deputy chief of staff and senior advisor"                                                                                  
[1314] "deputy director for proclamations"                                                                                                                     
[1315] "deputy assistant to the president and director of usa freedom corps"                                                                                   
[1316] "deputy assistant to the president and deputy director of communications for production"                                                                
[1317] "director law enforcement policy"                                                                                                                       
[1318] "deputy assistant to the president for international economic affairs and deputy nsa"                                                                   
[1319] "director of the travel office"                                                                                                                         
[1320] "special assistant to the president for cabinet liaison"                                                                                                
[1321] "website coordinator"                                                                                                                                   
[1322] "associate director for outreach"                                                                                                                       
[1323] "deputy director of the gift office"                                                                                                                    
[1324] "aide to the assistant to the president for homeland security"                                                                                          
[1325] "director of comment line, greetings and visitors"                                                                                                      
[1326] "assistant to the president and director of the office of faith-based and community initiatives"                                                        
[1327] "deputy press secretary to the first lady"                                                                                                              
[1328] "director of presidential proclamations"                                                                                                                
[1329] "director for investigation and law enforcement"                                                                                                        
[1330] "special assistant to the president and deputy director"                                                                                                
[1331] "director, financial management and planning"                                                                                                           
[1332] "asst to the president for economic policy and director, nec"                                                                                           
[1333] "assistant to the president and dep chief of staff for policy"                                                                                          
[1334] "asst to the president, deputy chief of staff and senior advisor"                                                                                       
[1335] "assistant to the president for homeland security and cntrtrsm"                                                                                         
[1336] "dep assistant to the president for management and administration"                                                                                      
[1337] "dep assistant to the president and chief of staff to the first lady"                                                                                   
[1338] "deputy assistant to the president for homeland security and exec"                                                                                      
[1339] "deputy assistant to the president for inational economic affairs and deputy nsa"                                                                       
[1340] "acting director of cabinet liaison"                                                                                                                    
[1341] "deputy assistant to the president for appts and scheduling"                                                                                            
[1342] "dep assistant to the president and deputy staff secretary"                                                                                             
[1343] "dep asstistant to the president and deputy to the senior advisor"                                                                                      
[1344] "dep assistant to the president and deputy director of communications for policy and planning"                                                          
[1345] "dep assistant to the president and deputy press secretary"                                                                                             
[1346] "deputy assistant to the president and director of u.s.a. freedom corps"                                                                                
[1347] "dep assistant to the president and deputy director of communications for production"                                                                   
[1348] "dep assistant to the president and director of political affairs"                                                                                      
[1349] "executive director"                                                                                                                                    
[1350] "director, law enforcement policy"                                                                                                                      
[1351] "director of nuclear defense policy"                                                                                                                    
[1352] "special assistant to the president and director for border and trans"                                                                                  
[1353] "special assistant to the president and dep dir of public liaison"                                                                                      
[1354] "special asstistant to the president for legislative affairs"                                                                                           
[1355] "special assistant to the president for coop policy"                                                                                                    
[1356] "special assistant to the president and director of media affrs"                                                                                        
[1357] "special assistant to the president and dep dir of speechwriting"                                                                                       
[1358] "director for lessons learned"                                                                                                                          
[1359] "special assistant to the president and deputy director, ofbci"                                                                                         
[1360] "special assistant to the president and dep press secretary"                                                                                            
[1361] "special assistant to the president for prevention, preperations and response policy"                                                                   
[1362] "director, training and exercise policy"                                                                                                                
[1363] "special assistant to the president for intergovernmental affrs"                                                                                        
[1364] "special assistant to the president and associate dirrector of comm for production"                                                                     
[1365] "special assistant to the president, deputy director of advance for press"                                                                              
[1366] "special assistant to the president and deputy director, opa"                                                                                           
[1367] "special assistant to the president and deputy director for political affairs"                                                                          
[1368] "special assistant to the president for domestic policy and director of projects for first lady"                                                        
[1369] "special assistant to the president for communications"                                                                                                 
[1370] "assistant to the chief of staff"                                                                                                                       
[1371] "director, office of the  chief of staff"                                                                                                               
[1372] "director of transportation security policy"                                                                                                            
[1373] "director of visas and screening policy"                                                                                                                
[1374] "director of infrastructure protection policy"                                                                                                          
[1375] "director of the  travel office"                                                                                                                        
[1376] "director of preparedness policy"                                                                                                                       
[1377] "director of coop pollcy"                                                                                                                               
[1378] "director of response and recovery policy"                                                                                                              
[1379] "communications advisor"                                                                                                                                
[1380] "director of white house visitors office"                                                                                                               
[1381] "acting director of presidential correspondence"                                                                                                        
[1382] "executive assistant to the deputy assistant to the president for homeland"                                                                             
[1383] "director of comment line, greetings and volunteers"                                                                                                    
[1384] "director of immigration security policy"                                                                                                               
[1385] "deputy director of projects for the  first lady"                                                                                                       
[1386] "director of aviation security policy"                                                                                                                  
[1387] "director of correspondence for the  first lady"                                                                                                        
[1388] "special assistant to the assistant to the president for legis affairs"                                                                                 
[1389] "director of presidential writers"                                                                                                                      
[1390] "deputy director and intern coordinator"                                                                                                                
[1391] "director of fact checking"                                                                                                                             
[1392] "special assisant and personal aide to the first lady"                                                                                                  
[1393] "deputy director of presidential messages"                                                                                                              
[1394] "director of rapid response"                                                                                                                            
[1395] "deputy associate director for scheduling advance"                                                                                                      
[1396] "director, food agriculture and water security policy"                                                                                                  
[1397] "confidential assistant"                                                                                                                                
[1398] "deputy director of comment line and greetings"                                                                                                         
[1399] "deputy director of proclamations"                                                                                                                      
[1400] "advance representative"                                                                                                                                
[1401] "deputy director of agency liaison"                                                                                                                     
[1402] "deputy associate director for invitations and correspondence"                                                                                          
[1403] "deputy assistant staff secretary"                                                                                                                      
[1404] "senior editor"                                                                                                                                         
[1405] "chairman"                                                                                                                                              
[1406] "vice chairman"                                                                                                                                         
[1407] "board member"                                                                                                                                          
[1408] "assistant to the president & deputy chief of staff"                                                                                                    
[1409] "assistant to the president for economic policy & director, national economic council"                                                                  
[1410] "assistant to the president, deputy chief of staff & senior advisor"                                                                                    
[1411] "assistant to the president & press secretary"                                                                                                          
[1412] "assistant to the president for homeland security & counterterrorism"                                                                                   
[1413] "deputy assistant to the president for homeland security"                                                                                               
[1414] "deputy assistant to the president & deputy counsel to the president"                                                                                   
[1415] "deputy assistant to the president for management & administration"                                                                                     
[1416] "deputy assistant to the pres and deputy national security adviser for international economic afairs"                                                   
[1417] "deputy assistant to the president for appointments & scheduling"                                                                                       
[1418] "deputy assistant to the president & director of advance"                                                                                               
[1419] "deputy assistant to the president & director of public liaison"                                                                                        
[1420] "deputy assistant to the president & director of political affairs"                                                                                     
[1421] "deputy assistant to the president & deputy press secretary"                                                                                            
[1422] "deputy assistant to the president & director of intergovernmental affairs"                                                                             
[1423] "deputy assistant to the president and director of the office of faith-based and community initiatives"                                                 
[1424] "deputy assistant to the president & deputy to the senior advisor"                                                                                      
[1425] "deputy assistant to the president & director of media affairs"                                                                                         
[1426] "deputy assistant to the president & deputy director of communication for policy & planning"                                                            
[1427] "deputy assistant to the president & deputy staff secretary"                                                                                            
[1428] "deputy assistant to the president & principal deputy press secretary"                                                                                  
[1429] "deputy assistant to the president & deputy director of communications for production"                                                                  
[1430] "deputy assistant to the president & deputy director of speechwriting"                                                                                  
[1431] "deputy assistant to the president & director of strategic initiatives"                                                                                 
[1432] "special assistant to the president for homeland security and senior director for border and transportation security"                                   
[1433] "special assistant to the president for white house management"                                                                                         
[1434] "special assistant to the president & deputy director of public liaison"                                                                                
[1435] "special assistant to the president and executive secretary"                                                                                            
[1436] "director, international programs border security policy"                                                                                               
[1437] "special assistant to the president for domestic policy and director of policy and projects for the first lady"                                         
[1438] "special assistant to the president for homeland security &senior director for response policy"                                                         
[1439] "special assistant to the president & deputy director, office of faith-based and community initiatives"                                                 
[1440] "special assistant to the president & white house social secretary"                                                                                     
[1441] "director, response and recovery policy"                                                                                                                
[1442] "director, response recovery"                                                                                                                           
[1443] "special assistant to the president for homeland security & senior director for preparedness policy"                                                    
[1444] "special assistant to the president & associate director of communication for production"                                                               
[1445] "special assistant to the president & director of presidential correspondence"                                                                          
[1446] "special assistant to the president & deputy director for political affairs"                                                                            
[1447] "special assistant to the president & deputy director of advance"                                                                                       
[1448] "special assistant to the president & trip director"                                                                                                    
[1449] "deputy executive director & counsel"                                                                                                                   
[1450] "director, nuclear detection policy"                                                                                                                    
[1451] "director, office of the senior advisor"                                                                                                                
[1452] "director, strategy and resources"                                                                                                                      
[1453] "director, transportation security policy"                                                                                                              
[1454] "director, aviation security policy"                                                                                                                    
[1455] "director, immigration & visa security policy"                                                                                                          
[1456] "director, protection & information sharing policy"                                                                                                     
[1457] "director of outreach"                                                                                                                                  
[1458] "director, continuity policy"                                                                                                                           
[1459] "director of the white house visitors office"                                                                                                           
[1460] "executive assistant to the assistant to the president for homeland security &counterterrorism"                                                         
[1461] "director, communications systems & cyber security policy"                                                                                              
[1462] "deputy director of policy & projects for the first lady"                                                                                               
[1463] "director of advance for the.first lady"                                                                                                                
[1464] "executive assistant to the deputy chief of staff & senior advisor"                                                                                     
[1465] "deputy director of white house management"                                                                                                             
[1466] "director of presidential personal correspondence"                                                                                                      
[1467] "executive assistant to the deputy assistant to the president for homeland sec"                                                                         
[1468] "deputy director of scheduling for the first lady"                                                                                                      
[1469] "special assistant to the assistant to the president for leg affairs"                                                                                   
[1470] "policy and special projects coordinator"                                                                                                               
[1471] "deputy assistant press secretary"                                                                                                                      
[1472] "aide to the assistant to the president for homeland security &counterterrorism"                                                                        
[1473] "assistant press secretary to the first lady"                                                                                                           
[1474] "deputy associate director for invitations & correspondence"                                                                                            
[1475] "deputy director, gift office"                                                                                                                          
[1476] "website assistant"                                                                                                                                     
[1477] "assistant to the president for strategic initiatives and external affairs"                                                                             
[1478] "assistant to president for international economic affairs and deputy national security advisor for international economic affairs"                     
[1479] "director response policy"                                                                                                                              
[1480] "deputy assistant to the president and director intergovernmental affairs"                                                                              
[1481] "deputy assistant to the president for advance and operations"                                                                                          
[1482] "deputy assistant to the president for strategic initiatives and external affairs"                                                                      
[1483] "deputy assistant to the president for domestic policy and director of projects for the first lady"                                                     
[1484] "deputy assistant to the president and deputy director of speechwriting"                                                                                
[1485] "deputy assistant to the president and director of strategic initiative"                                                                                
[1486] "special assistant to the president for homeland security and senior director for bio defense policy"                                                   
[1487] "special assistant to the president and deputy associate director for outreach and personal aide"                                                       
[1488] "special assistant to the president for homeland sec and senior director for nuclear defense policy"                                                    
[1489] "director of response policy"                                                                                                                           
[1490] "director continuity policy"                                                                                                                            
[1491] "director preparedness policy"                                                                                                                          
[1492] "special assistant to the president for homeland security and senior director for response policy"                                                      
[1493] "special assistant to the president for homeland security and senior director for cyber-security and information sharing policy"                        
[1494] "special assistant to the president and deputy director of  usa freedom corps"                                                                          
[1495] "special assistant to the president and deputy director of appointments and scheduling"                                                                 
[1496] "special assistant to the president and director of communications and press secretary to the first lady"                                               
[1497] "special assistant to the president for white house mgmt"                                                                                               
[1498] "special assistant to the president for strategic initiatives and external affairs"                                                                     
[1499] "assistant press secretary and director of television"                                                                                                  
[1500] "director, international programs and border security policy"                                                                                           
[1501] "deputy director of media affairs and senior spokesman"                                                                                                 
[1502] "associate director information sharing policy"                                                                                                         
[1503] "deputy director presidential correspondence"                                                                                                           
[1504] "assistant supervisor document management and tracking unit"                                                                                            
[1505] "director, communications systems and cyber security policy"                                                                                            
[1506] "director of radio and spokesman"                                                                                                                       
[1507] "deputy director of strategic initiatives"                                                                                                              
[1508] "speech writer for the first lady"                                                                                                                      
[1509] "executive assistant and director, office of strategic initiatives and external affairs"                                                                
[1510] "associate director continuity policy"                                                                                                                  
[1511] "director, office of public liaison"                                                                                                                    
[1512] "deputy director finance"                                                                                                                               
[1513] "communications adviser"                                                                                                                                
[1514] "director of comment line greetings and volunteers"                                                                                                     
[1515] "deputy director of presidential support"                                                                                                               
[1516] "research assistant and junior speechwriter"                                                                                                            
[1517] "records analyst"                                                                                                                                       
```


Basic stringr
========================================================
class: small-code
- ```str_``` functions take vectors of text strings, return new vectors
- ```str_detect()``` simply returns a logical vector
    - Elements are true when the pattern was found, false when not

```r
unique(salaries$position) %>%
  str_detect("advisor") %>% 
  table()
```

```
.
FALSE  TRUE 
 1365   151 
```

Basic stringr
========================================================
class: small-code
- ```str_detect()``` is useful for subsetting data

```r
advisors <- salaries %>%
  filter(str_detect(position, "advisor")) %>%
  .$position %>%          # using $ returns a vector instead of a data frame
  unique()
advisors
```

```
  [1] "special advisor to the assistant to the president/deputy national security advisor"                                                                    
  [2] "assistant to the president and senior advisor"                                                                                                         
  [3] "executive assistant to the senior advisor"                                                                                                             
  [4] "assistant to the president and deputy national security advisor for counterterrorism and homeland security"                                            
  [5] "senior policy advisor"                                                                                                                                 
  [6] "advisor to the president"                                                                                                                              
  [7] "policy advisor"                                                                                                                                        
  [8] "assistant to the president and deputy national security advisor"                                                                                       
  [9] "special assistant to the president and senior advisor to the chief of staff"                                                                           
 [10] "clearance advisor"                                                                                                                                     
 [11] "senior advisor and assistant to the president for intergovernmental affairs and public engagement"                                                     
 [12] "senior advisor  for social innovation and civic participation"                                                                                         
 [13] "national security advisor"                                                                                                                             
 [14] "special assistant to the senior advisor"                                                                                                               
 [15] "advisor"                                                                                                                                               
 [16] "senior policy advisor for social innovation and civic participation"                                                                                   
 [17] "director and aide to the senior advisor"                                                                                                               
 [18] "senior advisor for economics division of presidential personnel"                                                                                       
 [19] "ethics advisor"                                                                                                                                        
 [20] "director of the office of national aids policy and senior advisor on disability policy"                                                                
 [21] "legislative counsel and policy advisor"                                                                                                                
 [22] "senior policy advisor for education"                                                                                                                   
 [23] "deputy assistant to the president and senior advisor to the chief of staff"                                                                            
 [24] "director of special projects and special assistant to the senior advisor"                                                                              
 [25] "senior policy advisor for native american affairs"                                                                                                     
 [26] "communications advisor, domestic policy council and office of national aids policy"                                                                    
 [27] "senior advisor for technology and innovation to the national economic council director"                                                                
 [28] "senior legislative affairs advisor"                                                                                                                    
 [29] "special assistant to the president and policy advisor to the office of the chief of staff"                                                             
 [30] "assistant to the president and deputy senior advisor"                                                                                                  
 [31] "assistant to the president and national security advisor"                                                                                              
 [32] "senior advisor for health, domestic policy council"                                                                                                    
 [33] "senior advisor for housing, national economic council"                                                                                                 
 [34] "assistant to the president and special advisor"                                                                                                        
 [35] "deputy assistant to the president and counselor to the senior  advisor for strategic engagement"                                                       
 [36] "special assistant to the senior advisor and deputy chief of staff"                                                                                     
 [37] "assistant to the president and deputy national security advisor for international economics"                                                           
 [38] "policy advisor to the office of the chief of staff"                                                                                                    
 [39] "special assistant to the president, senior advisor to the council on women and girls, and senior presidential speechwriter"                            
 [40] "special assistant to the counselor to the senior advisor for strategic engagement"                                                                     
 [41] "director of white house operations and advisor for management and administration"                                                                      
 [42] "deputy assistant to the president and counselor to the senior advisor for strategic engagement"                                                        
 [43] "senior confirmations advisor"                                                                                                                          
 [44] "special assistant to the president and advisor to the chief of staff"                                                                                  
 [45] "policy advisor for health care"                                                                                                                        
 [46] "special assistant to the senior advisor and the deputy chief of staff"                                                                                 
 [47] "director of white house personnel and advisor for management and administration"                                                                       
 [48] "public engagement advisor"                                                                                                                             
 [49] "executive director of let's move! and senior policy advisor for nutrition policy"                                                                      
 [50] "special assistant to the deputy senior advisor for communications and strategy"                                                                        
 [51] "senior communications advisor"                                                                                                                         
 [52] "assistant to the president for homeland security and counterterrorism and deputy national security advisor"                                            
 [53] "special assistant to the president and senior advisor to the deputy chief of staff"                                                                    
 [54] "deputy assistant to the president, deputy national security advisor for strategic communications and speechwriting"                                    
 [55] "senior policy advisor and deputy chief of staff of the national economic council"                                                                      
 [56] "assistant to the president and deputy senior advisor for communications and strategy"                                                                  
 [57] "director of international affairs and senior policy advisor"                                                                                           
 [58] "deputy assistant to the president and senior advisor to the first lady"                                                                                
 [59] "chief of staff and senior advisor to the director of the office of legislative affairs"                                                                
 [60] "advisor to the counselor to the president"                                                                                                             
 [61] "senior advisor for strategic communications for the national economic council"                                                                         
 [62] "senior advisor and chief of staff of the national economic council"                                                                                    
 [63] "vetting advisor for presidential personnel"                                                                                                            
 [64] "member relations advisor"                                                                                                                              
 [65] "deputy senior advisor and director of external relations for the first lady"                                                                           
 [66] "special assistant to the president and senior advisor for the national economic council"                                                               
 [67] "senior policy advisor for labor and workforce"                                                                                                         
 [68] "special assistant to the president and advisor for the office of political strategy and outreach"                                                      
 [69] "assistant to the president and deputy national security advisor for strategic communications and speechwriting"                                        
 [70] "executive director and policy advisor, reach higher initiative"                                                                                        
 [71] "senior policy advisor for health and the office of national aids policy"                                                                               
 [72] "senior advisor for the national economic council"                                                                                                      
 [73] "senior public engagement advisor for labor and working families"                                                                                       
 [74] "special assistant and advisor to the senior advisor"                                                                                                   
 [75] "special assistant to the president, senior strategic and policy advisor to the council on women and girls, and senior presidential speechwriter"       
 [76] "advisor to the council on women and girls"                                                                                                             
 [77] "senior advisor, tax and fiscal policy"                                                                                                                 
 [78] "advisor for technology"                                                                                                                                
 [79] "special assistant and advisor to the director of legislative affairs"                                                                                  
 [80] "deputy assistant to the president and advisor to the chief of staff"                                                                                   
 [81] "strategic communications advisor"                                                                                                                      
 [82] "deputy director and senior advisor for records management"                                                                                             
 [83] "special assistant and advisor to the press secretary"                                                                                                  
 [84] "special assistant to the president and advisor to the office of the chief of staff"                                                                    
 [85] "special assistant and advisor to the chief of staff"                                                                                                   
 [86] "advisor to the chief of staff"                                                                                                                         
 [87] "deputy assistant to the president for intergovernmental affairs and public engagement and senior advisor to the national economic council"             
 [88] "special assistant and advisor for the press secretary"                                                                                                 
 [89] "deputy director of research and rapid response advisor"                                                                                                
 [90] "senior policy advisor for economic policy and director of techhire"                                                                                    
 [91] "policy advisor to the council on women and girls"                                                                                                      
 [92] "special assistant and policy advisor for the office of urban affairs, justice, and opportunity"                                                        
 [93] "director of the white house business council and policy advisor"                                                                                       
 [94] "associate director of public engagement and senior policy advisor"                                                                                     
 [95] "special assistant to the president, deputy press secretary and senior advisor to the press secretary"                                                  
 [96] "special assistant and policy advisor for education"                                                                                                    
 [97] "deputy chief of staff for presidential personnel and policy advisor to the council on women and girls"                                                 
 [98] "special assistant and policy advisor to the director of the domestic policy council"                                                                   
 [99] "communications director and senior policy advisor for the domestic policy council"                                                                     
[100] "senior advisor for congressional engagement and legislative relations"                                                                                 
[101] "policy advisor to the senior advisor"                                                                                                                  
[102] "senior policy advisor for economic policy"                                                                                                             
[103] "special assistant to the president, chief of staff, and advisor to the director of presidential personnel"                                             
[104] "senior policy advisor for economic development"                                                                                                        
[105] "policy advisor to the deputy chief of staff for implementation"                                                                                        
[106] "special assistant and policy advisor for the white house office of faith-based and neighborhood partnerships"                                          
[107] "chief of staff and advisor to the white house counsel office"                                                                                          
[108] "senior advisor to the director and deputy chief of staff of the national economic council"                                                             
[109] "strategic communications advisor and special projects manager"                                                                                         
[110] "special assistant to the president, principal deputy press secretary and senior advisor to the press secretary"                                        
[111] "special assistant and policy advisor to the director of intergovernmental affairs"                                                                     
[112] "senior technical advisor to the director of white house information technology"                                                                        
[113] "senior director of cabinet affairs and senior advisor for the domestic policy council"                                                                 
[114] "senior public engagement advisor"                                                                                                                      
[115] "special assistant and policy advisor to the chief of staff of the office of public engagement and intergovernmental affairs"                           
[116] "special assistant to the president and assistant to the senior advisor"                                                                                
[117] "special assistant to the president and advisor for planning"                                                                                           
[118] "deputy assistant to the president and deputy counsel to the president for national security affairs and legal advisor to the national security council"
[119] "special assistant to the president and senior associate counsel to the president and deputy legal advisor to the national security council"            
[120] "education advisor"                                                                                                                                     
[121] "special assistant to the president and advisor for strategy and speechwriting"                                                                         
[122] "special assistant to the president and advisor for development and speechwriting"                                                                      
[123] "education, women and families, and workforce policy advisor"                                                                                           
[124] "assistant to the president and senior advisor for policy"                                                                                              
[125] "advisor to the press secretary"                                                                                                                        
[126] "assistant to the president and deputy national security advisor for strategy"                                                                          
[127] "deputy assistant to the president and communications advisor"                                                                                          
[128] "labor advisor"                                                                                                                                         
[129] "urban affairs and revitalization policy advisor"                                                                                                       
[130] "first daughter and advisor to the president"                                                                                                           
[131] "immigration advisor"                                                                                                                                   
[132] "special assistant to the president and deputy press secretary and advisor to the press secretary"                                                      
[133] "deputy assistant to the president and deputy to the senior advisor"                                                                                    
[134] "attorney advisor"                                                                                                                                      
[135] "senior advisor to the president"                                                                                                                       
[136] "security advisor"                                                                                                                                      
[137] "deputy assistant to the president for international economic affairs and deputy national security advisor"                                             
[138] "deputy assistant to the president and deputy homeland security advisor"                                                                                
[139] "assistant to the president for speechwriting and policy advisor"                                                                                       
[140] "deputy assistant to the president and assistant to the senior advisor"                                                                                 
[141] "assistant director of projects and policy advisor"                                                                                                     
[142] "executive assistant to the deputy chief of staff and senior advisor"                                                                                   
[143] "assistant to the president, deputy chief of staff and senior advisor"                                                                                  
[144] "asst to the president, deputy chief of staff and senior advisor"                                                                                       
[145] "dep asstistant to the president and deputy to the senior advisor"                                                                                      
[146] "communications advisor"                                                                                                                                
[147] "assistant to the president, deputy chief of staff & senior advisor"                                                                                    
[148] "deputy assistant to the president & deputy to the senior advisor"                                                                                      
[149] "director, office of the senior advisor"                                                                                                                
[150] "executive assistant to the deputy chief of staff & senior advisor"                                                                                     
[151] "assistant to president for international economic affairs and deputy national security advisor for international economic affairs"                     
```

Basic stringr
========================================================
class: small-code
- ```str_replace()``` is critical for text cleaning
- Looks for given pattern, and replaces with new string

```r
str_replace(advisors[1:3], "advisor", "party")
```

```
[1] "special party to the assistant to the president/deputy national security advisor"
[2] "assistant to the president and senior party"                                     
[3] "executive assistant to the senior party"                                         
```
- Or that text can be removed

```r
str_remove(advisors[1:3], "advisor")
```

```
[1] "special  to the assistant to the president/deputy national security advisor"
[2] "assistant to the president and senior "                                     
[3] "executive assistant to the senior "                                         
```

Basic stringr
========================================================
class: small-code
- ```str_replace_all()``` replaces all intances of pattern if it appears more than once in a string

```r
advisors[1:3] %>% str_replace(" ", "-")
```

```
[1] "special-advisor to the assistant to the president/deputy national security advisor"
[2] "assistant-to the president and senior advisor"                                     
[3] "executive-assistant to the senior advisor"                                         
```

```r
advisors[1:3] %>% str_replace_all(" ", "-")
```

```
[1] "special-advisor-to-the-assistant-to-the-president/deputy-national-security-advisor"
[2] "assistant-to-the-president-and-senior-advisor"                                     
[3] "executive-assistant-to-the-senior-advisor"                                         
```

Basic stringr
========================================================
class: small-code
- There are also useful functions for dealing with letter cases

```r
str_to_upper(advisors[1:3])
```

```
[1] "SPECIAL ADVISOR TO THE ASSISTANT TO THE PRESIDENT/DEPUTY NATIONAL SECURITY ADVISOR"
[2] "ASSISTANT TO THE PRESIDENT AND SENIOR ADVISOR"                                     
[3] "EXECUTIVE ASSISTANT TO THE SENIOR ADVISOR"                                         
```

```r
str_to_title(advisors[1:3])
```

```
[1] "Special Advisor To The Assistant To The President/Deputy National Security Advisor"
[2] "Assistant To The President And Senior Advisor"                                     
[3] "Executive Assistant To The Senior Advisor"                                         
```


Joins and Merges
========================================================
class: small-code
- Joining data tables is key for data management
- `dplyr` provides effective `_join()` family
- Let's create some test data

```r
a <- tibble(name = c("Jen", "Chuck", "Kaitlyn", "Jose"),
            age = c(31, 47, 23, 25))

b <- tibble(name = c("Jose", "Jen", "Chuck", "Gloria"),
            gender = c("M", "F", "M", "F"))
```

inner_join()
========================================================
class: small-code
- Functions automatically detect join columns
    - Can be specified with `by =`
- `inner_join()` returns all matching rows from a and b
class: small-code

```r
inner_join(a, b)
```

```
# A tibble: 3 x 3
  name    age gender
  <chr> <dbl> <chr> 
1 Jen      31 F     
2 Chuck    47 M     
3 Jose     25 M     
```

full_join()
========================================================
class: small-code
- `full_join()` returns all rows from both a and b

```r
full_join(a, b)
```

```
# A tibble: 5 x 3
  name      age gender
  <chr>   <dbl> <chr> 
1 Jen        31 F     
2 Chuck      47 M     
3 Kaitlyn    23 <NA>  
4 Jose       25 M     
5 Gloria     NA F     
```

left_join() and right_join()
========================================================
class: small-code
- `left_join()` returns all rows from a
- `right_join()` returns all rows from b

```r
left_join(a, b)
```

```
# A tibble: 4 x 3
  name      age gender
  <chr>   <dbl> <chr> 
1 Jen        31 F     
2 Chuck      47 M     
3 Kaitlyn    23 <NA>  
4 Jose       25 M     
```

```r
right_join(a, b)
```

```
# A tibble: 4 x 3
  name     age gender
  <chr>  <dbl> <chr> 
1 Jose      25 M     
2 Jen       31 F     
3 Chuck     47 M     
4 Gloria    NA F     
```

Handling missing data
========================================================
class: small-code
- `tidyr` also provides functions to handle missing values
- `drop_na()` simply removes rows with any missing value

```r
m <- full_join(a, b)
m
```

```
# A tibble: 5 x 3
  name      age gender
  <chr>   <dbl> <chr> 
1 Jen        31 F     
2 Chuck      47 M     
3 Kaitlyn    23 <NA>  
4 Jose       25 M     
5 Gloria     NA F     
```

```r
drop_na(m)
```

```
# A tibble: 3 x 3
  name    age gender
  <chr> <dbl> <chr> 
1 Jen      31 F     
2 Chuck    47 M     
3 Jose     25 M     
```

Handling missing data
========================================================
class: small-code
- `replace_na()` replaces `NA` with specific values by column
    - If input is a data frame, specify with a named list 
    - If input is a vector, specify with a single value

```r
subs <- list(age = 0, gender = "blank")
replace_na(m, replace = subs)
```

```
# A tibble: 5 x 3
  name      age gender
  <chr>   <dbl> <chr> 
1 Jen        31 F     
2 Chuck      47 M     
3 Kaitlyn    23 blank 
4 Jose       25 M     
5 Gloria      0 F     
```

Questions?
========================================================
