<style>
.small-code pre code {
  font-size: 1em;
}
</style>

Cleaning Data with R
========================================================
author: Ben Bellman
date: August 30, 2017
autosize: true
incremental: false

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

Refresh from Yesterday
========================================================
- Introduction to R
    - Anatomy of a command
    - Data types and functions
- Using ```dplyr```
    - ```tidyverse``` packages
    - ```select()```, ```filter()```, ```arrange()```, ```summarise()```, and ```mutate()```
    - The piping operator, ```%>%```
- Using ```ggplot2```
    - Initialize with ```ggplot()``` or ```ggmap()```
    - Customize with additional functions
    
Anatomy of a command
========================================================

```obj <- funct(arg1, arg2 = True, arg3 = "setting", ...)```

- ```obj``` = object where output of ```function``` is stored
    - ```<-``` is the assignment operator for storing results
- ```funct``` = name of function being called
- ```arg1``` = first argument is usually object/data being operated on
- ```arg2, arg3``` = additional arguments that change how ```funct``` works
    - Can refer to true/false value, different methods, etc.
    - Have default values, so not always necessary to use them

Objects and Data
========================================================

- There are a few basic types of objects/data
    - Single values
    - Vectors (integer/numeric, character, factor)
    - Matrices
    - Data frames
    - Lists
    
- Other types of data are introduced through packages
  - Built on these basic data structures

Functions
========================================================

- When coding, think of objects as nouns and functions as verbs

- R is a "functional language"
    - Can be directy referenced as objects and inputs without storing in memory
    - Packages are suites of functions
    - Can write own functions (we'll discuss later!)

- Must pay attention to required arguments of functions

- Can always view CRAN documentation of function with ```?function```

The tidyverse Suite
========================================================

- ```tibble``` : A "modern" version of a data frame

- ```purrr``` : Tools for programming functions
- ```readr``` : Tools for importing text data files
- ```tidyr``` : Tools for cleaning and transforming data
- ```dplyr``` : Tools for data manipulation and analysis
- ```ggplot2``` : Tools for data visualization

Tidy data
========================================================

- Tidy data is data where: 
    1. Each variable is in a column.
    2. Each observation is a row. 
    3. Each value is a cell.
    
- Guiding philosophy for Wickham packages, implemented through ```tidyr``` package

- See full paper in [Journal of Statistical Software](https://www.jstatsoft.org/article/view/v059i10)
    - Shorter version is a ```tidyr``` vignette


Using tidyr
========================================================

- Tools to bring any data into these standard definitions
- When do I need to worry about this?
    - "Raw" data sources: web scraping with ```rvest```, social media data, combining data from multiple tables, etc.
    - Data presented as a table, with one variable covering many columns
    - Transforming data across multiple levels of observation
    
tidyr functions
========================================================

- ```gather()``` and ```spread()``` are functions for reorganizing data by observations
    - Same as reshaping data in STATA
- ```separate()``` and ```extract()``` are similar functions with the purpose of taking information on two variables in one column, and creating two columns

gather() function
========================================================

- Uses the concept of "key-value" pairs to separate variables

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
     name     a     b
    <chr> <dbl> <dbl>
1  Wilbur    67    56
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
     name  drug heartrate
    <chr> <chr>     <dbl>
1  Wilbur     a        67
2 Petunia     a        80
3 Gregory     a        64
4  Wilbur     b        56
5 Petunia     b        90
6 Gregory     b        50
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
     name  drug heartrate
    <chr> <chr>     <dbl>
1  Wilbur     a        67
2 Petunia     a        80
3 Gregory     a        64
4  Wilbur     b        56
5 Petunia     b        90
6 Gregory     b        50
```

```r
tidy %>%
  spread(drug, heartrate)
```

```
# A tibble: 3 x 3
     name     a     b
*   <chr> <dbl> <dbl>
1 Gregory    64    50
2 Petunia    80    90
3  Wilbur    67    56
```

separate() function
========================================================

- ```separate()``` is used to split one column into two columns
    - Compare to "split" in STATA
    - Use a regular expression to identify "where" to split the data
- ```extract()``` essentially does the same thing, but uses regular expressions to extract data rather than simply split a string

separate() function
========================================================
class: small-code

```r
old <- tibble(
  day_of_week = c("Mon", "Tues", "Wed", "Thurs", "Fri"),
  date = c("08-28-2017", "08-29-2017", "08-30-2017", 
           "08-31-2017", "09-01-2017")
)

old
```

```
# A tibble: 5 x 2
  day_of_week       date
        <chr>      <chr>
1         Mon 08-28-2017
2        Tues 08-29-2017
3         Wed 08-30-2017
4       Thurs 08-31-2017
5         Fri 09-01-2017
```

separate() function
========================================================
class: small-code

```r
old %>%
  separate(date, into = c("day", "month", "year"), sep = "\\-")
```

```
# A tibble: 5 x 4
  day_of_week   day month  year
*       <chr> <chr> <chr> <chr>
1         Mon    08    28  2017
2        Tues    08    29  2017
3         Wed    08    30  2017
4       Thurs    08    31  2017
5         Fri    09    01  2017
```


stringr: Using Text Data
========================================================

- Very often, "data cleaning" means text cleaning
    - Remove unwanted text, extract wanted text
    - Recognize patterns, etc.
- ```stringr``` package is best toolkit for these operations
    - Lots of functions, can't learn them all
    - Uses "regular expressions" for pattern recognition
    - Beyond the scope of today, but relatively easy and worth learning
- Let's explore the salaries data


Basic stringr
========================================================
class: small-code

```r
install.packages("stringr", repos = 0)
library(stringr)

# load the salaries data
salaries <- read_csv("~/Google Drive/Computer Backup/R Workshop/Data/white-house-salaries.csv")

# create the tenure variable
salaries <- salaries %>%
  rename(name = employee_name) %>%
  arrange(name) %>%
  group_by(name) %>%
  mutate(tenure = rank(year))
```

Basic stringr
========================================================
class: small-code
First, let's take a look at what kind of job titles there are

```r
unique(salaries$position)
```

```
   [1] "ethics advisor"                                                                                                                                        
   [2] "policy advisor"                                                                                                                                        
   [3] "press assistant"                                                                                                                                       
   [4] "advisor to the chief of staff"                                                                                                                         
   [5] "spokesman"                                                                                                                                             
   [6] "energy and environment director for presidential personnel"                                                                                            
   [7] "legislative assistant and assistant to the house liaison"                                                                                              
   [8] "special assistant to the president and chief of staff for the office of public engagement and intergovernmental affairs"                               
   [9] "deputy assistant to the president for intergovernmental affairs and public engagement and senior advisor to the national economic council"             
  [10] "western regional communications director"                                                                                                              
  [11] "regional communications director"                                                                                                                      
  [12] "deputy assistant to the president and director of intergovernmental affairs"                                                                           
  [13] "associate communications director"                                                                                                                     
  [14] "staff assistant"                                                                                                                                       
  [15] "press assistant for regional and specialty media"                                                                                                      
  [16] "deputy press secretary"                                                                                                                                
  [17] "executive assistant to the director of scheduling and advance"                                                                                         
  [18] "director, response and recovery policy"                                                                                                                
  [19] "correspondence assistant/analyst"                                                                                                                      
  [20] "associate counsel to the president"                                                                                                                    
  [21] "deputy press secretary to the first lady"                                                                                                              
  [22] "correspondence analyst"                                                                                                                                
  [23] "deputy communications director"                                                                                                                        
  [24] "special assistant to the president and director of communications for the first lady"                                                                  
  [25] "deputy director of intergovernmental affairs"                                                                                                          
  [26] "senior confirmations advisor"                                                                                                                          
  [27] "executive assistant to the director of public engagement"                                                                                              
  [28] "operator"                                                                                                                                              
  [29] "director for programs and resources"                                                                                                                   
  [30] "research assistant"                                                                                                                                    
  [31] "senior policy advisor"                                                                                                                                 
  [32] "associate director of public engagement"                                                                                                               
  [33] "senior program manager"                                                                                                                                
  [34] "special assistant to the president for legislative affairs"                                                                                            
  [35] "associate director of intergovernmental affairs"                                                                                                       
  [36] "senior associate director of intergovernmental affairs"                                                                                                
  [37] "special assistant to the president for energy and environment"                                                                                         
  [38] "director of presidential support"                                                                                                                      
  [39] "executive assistant"                                                                                                                                   
  [40] "senior legislative assistant"                                                                                                                          
  [41] "director, office of management and administration"                                                                                                     
  [42] "special assistant to the director of the office of political strategy and outreach"                                                                    
  [43] "assistant to the president for domestic policy"                                                                                                        
  [44] "special assistant to the president for message planning"                                                                                               
  [45] "deputy assistant to the president and deputy director of communications"                                                                               
  [46] "senior press assistant"                                                                                                                                
  [47] "associate director"                                                                                                                                    
  [48] "deputy director of public engagement"                                                                                                                  
  [49] "director of the white house visitors office"                                                                                                           
  [50] "internet and e-communications director"                                                                                                                
  [51] "senior advance representative"                                                                                                                         
  [52] "domestic director"                                                                                                                                     
  [53] "special assistant to the president and director of the office of the chief of staff"                                                                   
  [54] "analyst"                                                                                                                                               
  [55] "deputy director of presidential correspondence"                                                                                                        
  [56] "special assistant to the president and associate counsel to the president"                                                                             
  [57] "deputy director, student correspondence"                                                                                                               
  [58] "special assistant"                                                                                                                                     
  [59] "deputy director of student correspondence"                                                                                                             
  [60] "director of student correspondence"                                                                                                                    
  [61] "associate counsel"                                                                                                                                     
  [62] "deputy director of operations for the white house management office"                                                                                   
  [63] "director of digital engagement"                                                                                                                        
  [64] "executive assistant to the chief of staff"                                                                                                             
  [65] "special assistant to the chief of staff"                                                                                                               
  [66] "senior legislative affairs advisor"                                                                                                                    
  [67] "special assistant to the president and house legislative affairs liaison"                                                                              
  [68] "scheduler"                                                                                                                                             
  [69] "deputy assistant to the president and national security staff chief of staff  and counselor"                                                           
  [70] "policy assistant"                                                                                                                                      
  [71] "senior advisor for the national economic council"                                                                                                      
  [72] "special assistant to the president for economic policy"                                                                                                
  [73] "agency coordinator"                                                                                                                                    
  [74] "telephone service assistant"                                                                                                                           
  [75] "special services operator"                                                                                                                             
  [76] "assistant shift leader"                                                                                                                                
  [77] "shift leader"                                                                                                                                          
  [78] "deputy director of agency liaison"                                                                                                                     
  [79] "special government employee"                                                                                                                           
  [80] "deputy director of global communication"                                                                                                               
  [81] "counsel"                                                                                                                                               
  [82] "assistant counsel"                                                                                                                                     
  [83] "executive assistant to the deputy counsel to the president"                                                                                            
  [84] "executive assistant to the counselor"                                                                                                                  
  [85] "priority placement director"                                                                                                                           
  [86] "deputy assistant to the president and director of the office of public engagement"                                                                     
  [87] "staff assistant to the social secretary"                                                                                                               
  [88] "national security director for presidential personnel"                                                                                                 
  [89] "deputy director of correspondence for the first lady"                                                                                                  
  [90] "director"                                                                                                                                              
  [91] "director of white house visitors office"                                                                                                               
  [92] "special assistant to the president and deputy chief of staff to the first lady"                                                                        
  [93] "special assistant for management and administration"                                                                                                   
  [94] "policy director"                                                                                                                                       
  [95] "special assistant to the president and associate director"                                                                                             
  [96] "writer"                                                                                                                                                
  [97] "senior analyst"                                                                                                                                        
  [98] "legislative assistant and associate director for legislative correspondence"                                                                           
  [99] "special assistant to the director"                                                                                                                     
 [100] "special assistant to the deputy chief of staff"                                                                                                        
 [101] "chief of staff and senior advisor to the director of the office of legislative affairs"                                                                
 [102] "associate director for presidential personnel"                                                                                                         
 [103] "special assistant to the president for international economic affairs"                                                                                 
 [104] "director, white house greetings and comment line"                                                                                                      
 [105] "director, comment line, greetings and volunteers"                                                                                                      
 [106] "press advance representative"                                                                                                                          
 [107] "deputy director of advance"                                                                                                                            
 [108] "special assistant to the president for operations"                                                                                                     
 [109] "associate director for invitations and correspondence"                                                                                                 
 [110] "press secretary to the first lady"                                                                                                                     
 [111] "deputy assistant to the president and deputy director, national economic council"                                                                      
 [112] "special assistant to the president and senior associate counsel to the president"                                                                      
 [113] "deputy associate director"                                                                                                                             
 [114] "deputy assistant to the president for the office of urban affairs, justice, and opportunity"                                                           
 [115] "special advisor to the assistant to the president/deputy national security advisor"                                                                    
 [116] "assistant to the president and senior advisor"                                                                                                         
 [117] "digital creative director"                                                                                                                             
 [118] "senior writer"                                                                                                                                         
 [119] "assistant to the chief of staff"                                                                                                                       
 [120] "director, office of the chief of staff"                                                                                                                
 [121] "special assistant to the president and director, office of the chief of staff"                                                                         
 [122] "deputy associate counsel"                                                                                                                              
 [123] "deputy director, white house management"                                                                                                               
 [124] "deputy director for white house personnel"                                                                                                             
 [125] "press lead"                                                                                                                                            
 [126] "director, response policy"                                                                                                                             
 [127] "director for administration"                                                                                                                           
 [128] "deputy assistant to the president for legislative affairs"                                                                                             
 [129] "senior analyst and project manager"                                                                                                                    
 [130] "senior presidential support specialist"                                                                                                                
 [131] "special assistant to the director of intergovernmental affairs"                                                                                        
 [132] "deputy assistant to the president for homeland security"                                                                                               
 [133] "staff assistant and coordinator for presidential personnel office"                                                                                     
 [134] "director, gift unit"                                                                                                                                   
 [135] "director of the gift office"                                                                                                                           
 [136] "finance manager"                                                                                                                                       
 [137] "white house telephone operator"                                                                                                                        
 [138] "special assistant to the president and director for border and trans"                                                                                  
 [139] "special assistant to the president for homeland security and senior director for border and transportation security"                                   
 [140] "deputy associate counsel for presidential personnel"                                                                                                   
 [141] "director for lessons learned"                                                                                                                          
 [142] "executive assistant to the counsel to the president"                                                                                                   
 [143] "communications director"                                                                                                                               
 [144] "speechwriter"                                                                                                                                          
 [145] "executive assistant to the director"                                                                                                                   
 [146] "deputy assistant to the president and chief of staff to the first lady"                                                                                
 [147] "director of scheduling for the first lady"                                                                                                             
 [148] "volunteer coordinator"                                                                                                                                 
 [149] "assistant to the president and chief strategist and senior counselor"                                                                                  
 [150] "deputy assistant to the president and deputy cabinet secretary"                                                                                        
 [151] "administrative assistant to the staff secretary"                                                                                                       
 [152] "deputy director scheduling and advance"                                                                                                                
 [153] "senior digital strategist"                                                                                                                             
 [154] "gift analyst"                                                                                                                                          
 [155] "special assistant and advisor for the press secretary"                                                                                                 
 [156] "assistant to the president and director of the domestic policy council"                                                                                
 [157] "deputy assistant to the president and director, intergovernmental affairs"                                                                             
 [158] "director, strategy and resources"                                                                                                                      
 [159] "deputy assistant to the counselor, communications"                                                                                                     
 [160] "assistant to the president for communications"                                                                                                         
 [161] "counselor to the president"                                                                                                                            
 [162] "special assistant to the president and associate counsel"                                                                                              
 [163] "researcher"                                                                                                                                            
 [164] "associate research director"                                                                                                                           
 [165] "deputy director of research"                                                                                                                           
 [166] "deputy director of research and rapid response advisor"                                                                                                
 [167] "trip coordinator"                                                                                                                                      
 [168] "special assistant to the president for regulatory reform, legal and immigration policy"                                                                
 [169] "associate director and travel manager"                                                                                                                 
 [170] "associate director for travel planning"                                                                                                                
 [171] "media monitor"                                                                                                                                         
 [172] "assistant to the president and counsel to the president"                                                                                               
 [173] "senior press advance representative"                                                                                                                   
 [174] "write house phone director"                                                                                                                            
 [175] "associate political director"                                                                                                                          
 [176] "director of schedule c appointments"                                                                                                                   
 [177] "special assistant to the president for presidential personnel"                                                                                         
 [178] "correspondence analyst and volunteer coordinator"                                                                                                      
 [179] "hovel program manager"                                                                                                                                 
 [180] "hotel program manager"                                                                                                                                 
 [181] "special assistant and advance lead"                                                                                                                    
 [182] "director of response"                                                                                                                                  
 [183] "deputy director for media affairs"                                                                                                                     
 [184] "vetter"                                                                                                                                                
 [185] "special assistant to the president for intergovernmental affairs"                                                                                      
 [186] "special assistant to the president and deputy director of intergovernmental affairs"                                                                   
 [187] "tax counsel"                                                                                                                                           
 [188] "writer for correspondence"                                                                                                                             
 [189] "legislative assistant and assistant for events"                                                                                                        
 [190] "deputy assistant to the president and director of advance and operations"                                                                              
 [191] "deputy assistant to the president and director, office of the chief of staff"                                                                          
 [192] "deputy assistant to the president and director of the white house military office"                                                                     
 [193] "assistant to the president and director of the white house military office"                                                                            
 [194] "deputy assistant to the president and deputy director of presidential personnel"                                                                       
 [195] "deputy assistant to the president and deputy director of communications for production"                                                                
 [196] "deputy executive secretary"                                                                                                                            
 [197] "assistant press secretary"                                                                                                                             
 [198] "executive assistant to the deputy director"                                                                                                            
 [199] "chief of staff's scheduler"                                                                                                                            
 [200] "deputy assistant to the president for appointments and scheduling"                                                                                     
 [201] "deputy assistant to the president for appts and scheduling"                                                                                            
 [202] "deputy assistant to the president for appointments & scheduling"                                                                                       
 [203] "advance coordinator"                                                                                                                                   
 [204] "records management analyst"                                                                                                                            
 [205] "travel planner"                                                                                                                                        
 [206] "stenographer"                                                                                                                                          
 [207] "special assistant to the president for communications"                                                                                                 
 [208] "special assistant to the president and assistant to the senior advisor"                                                                                
 [209] "associate director of scheduling - research"                                                                                                           
 [210] "special assistant to the president and white house social secretary"                                                                                   
 [211] "special assistant to the president and senior director for biodefense"                                                                                 
 [212] "director, online engagement"                                                                                                                           
 [213] "deputy director of digital strategy"                                                                                                                   
 [214] "associate director for finance"                                                                                                                        
 [215] "outreach and recruitment director (community organizations)"                                                                                           
 [216] "ethics counsel"                                                                                                                                        
 [217] "special assistant to the president and deputy director of communication for planning"                                                                  
 [218] "deputy director of scheduling-research"                                                                                                                
 [219] "associate director of urban affairs"                                                                                                                   
 [220] "special assistant to the president and deputy director of advance"                                                                                     
 [221] "deputy assistant to the president and director of advance"                                                                                             
 [222] "deputy assistant to the president & director of advance"                                                                                               
 [223] "director of special projects and special assistant to the office of the chief of staff"                                                                
 [224] "special assistant to the president and policy advisor to the office of the chief of staff"                                                             
 [225] "deputy social secretary"                                                                                                                               
 [226] "special assistant to the president and senate legislative affairs liaison"                                                                             
 [227] "paralegal"                                                                                                                                             
 [228] "senior correspondence analyst and agency mail coordinator"                                                                                             
 [229] "administrative assistant"                                                                                                                              
 [230] "legislative assistant"                                                                                                                                 
 [231] "chief calligrapher"                                                                                                                                    
 [232] "deputy associate director of intergovernmental affairs"                                                                                                
 [233] "deputy assistant to the president and director of scheduling"                                                                                          
 [234] "deputy assistant to the president and director of appointments and scheduling"                                                                         
 [235] "assistant director for cabinet affairs operations"                                                                                                     
 [236] "chief of staff for the deputy chief of staff for operations"                                                                                           
 [237] "special assistant to the counselor to the president"                                                                                                   
 [238] "special assistant to the president and deputy director of public liaison"                                                                              
 [239] "special counsel to the president"                                                                                                                      
 [240] "associate director for scheduling correspondence"                                                                                                      
 [241] "director of scheduling correspondence"                                                                                                                 
 [242] "assistant to the president and deputy national security advisor"                                                                                       
 [243] "assistant press secretary to the first lady"                                                                                                           
 [244] "assistant director of intergovernmental affairs"                                                                                                       
 [245] "special assistant to the president and deputy director of white house management and administration"                                                   
 [246] "senior public engagement advisor for labor and working families"                                                                                       
 [247] "assistant to the president for manufacturing policy"                                                                                                   
 [248] "director of special projects"                                                                                                                          
 [249] "records analyst"                                                                                                                                       
 [250] "special assistant to the president and associate director of presidential personnel"                                                                   
 [251] "director of radio"                                                                                                                                     
 [252] "director of radio and spokesman"                                                                                                                       
 [253] "director, white house management office"                                                                                                               
 [254] "associate director of scheduling"                                                                                                                      
 [255] "assistant to the president and deputy chief of staff"                                                                                                  
 [256] "assistant to the president and chief of staff"                                                                                                         
 [257] "executive assistant to the chief of staff to the first lady"                                                                                           
 [258] "archivist"                                                                                                                                             
 [259] "assistant to the president for homeland security and counterterrorism"                                                                                 
 [260] "director of infrastructure protection policy"                                                                                                          
 [261] "special assistant to the president for homeland security & senior director for preparedness policy"                                                    
 [262] "deputy assistant to the president and deputy counsel to the president"                                                                                 
 [263] "assistant director for constituent engagement for the office of presidential correspondence"                                                           
 [264] "assistant staff secretary"                                                                                                                             
 [265] "director of correspondence for the first lady"                                                                                                         
 [266] "travel manager"                                                                                                                                        
 [267] "special assistant to the director of scheduling and advance"                                                                                           
 [268] "research associate"                                                                                                                                    
 [269] "executive assistant to the senior advisor"                                                                                                             
 [270] "special assistant to the senior advisor"                                                                                                               
 [271] "director of special projects and special assistant to the senior advisor"                                                                              
 [272] "assistant counsel to the president"                                                                                                                    
 [273] "special assistant to the director of the national economic council"                                                                                    
 [274] "deputy chief of staff for the domestic policy council"                                                                                                 
 [275] "policy analyst"                                                                                                                                        
 [276] "energy/environment director for presidential personnel"                                                                                                
 [277] "advance lead"                                                                                                                                          
 [278] "editor"                                                                                                                                                
 [279] "associate director of content and operations"                                                                                                          
 [280] "director for transportation and aviation security"                                                                                                     
 [281] "personal aide to the president"                                                                                                                        
 [282] "special assistant to the president and personal aide to the president"                                                                                 
 [283] "assistant to the president and deputy chief of staff for operations"                                                                                   
 [284] "special assistant and senior advance lead"                                                                                                             
 [285] "assistant to the president and deputy national security advisor for counterterrorism and homeland security"                                            
 [286] "clearance advisor"                                                                                                                                     
 [287] "deputy assistant to the president and director, domestic policy counsel"                                                                               
 [288] "assistant to the president and director usa freedom corps"                                                                                             
 [289] "clearance counsel"                                                                                                                                     
 [290] "supervisor of correspondence review"                                                                                                                   
 [291] "supervisor, correspondence review unit"                                                                                                                
 [292] "director of the office of national aids policy"                                                                                                        
 [293] "special assistant to the chief of staff to the first lady"                                                                                             
 [294] "assistant director of the council on women and girls"                                                                                                  
 [295] "deputy executive director of the council on women and girls"                                                                                           
 [296] "deputy director, joining forces"                                                                                                                       
 [297] "senior director of cabinet affairs"                                                                                                                    
 [298] "calligrapher"                                                                                                                                          
 [299] "assistant to the president and staff secretary"                                                                                                        
 [300] "director, cyber-security policy"                                                                                                                       
 [301] "director of the white house business council"                                                                                                          
 [302] "scheduling assistant and trip coordinator"                                                                                                             
 [303] "associate director of scheduling and advance"                                                                                                          
 [304] "assistant to the president for energy and climate change"                                                                                              
 [305] "midwest regional communications director"                                                                                                              
 [306] "special assistant to the president and deputy press secretary"                                                                                         
 [307] "staff assistant to the deputy chief of staff"                                                                                                          
 [308] "special assistant to the senior advisor and deputy chief of staff"                                                                                     
 [309] "senior advance lead"                                                                                                                                   
 [310] "senior trip coordinator"                                                                                                                               
 [311] "special assistant and press lead"                                                                                                                      
 [312] "deputy director of cabinet affairs"                                                                                                                    
 [313] "associate director, presidential personnel"                                                                                                            
 [314] "associate director for policy, let's move!"                                                                                                            
 [315] "lead advance"                                                                                                                                          
 [316] "deputy assistant to the president and deputy staff secretary"                                                                                          
 [317] "dep assistant to the president and deputy staff secretary"                                                                                             
 [318] "technology manager for presidential personnel"                                                                                                         
 [319] "director of greetings"                                                                                                                                 
 [320] "special assistant to the president for legislative affairs (senate)"                                                                                   
 [321] "associate director of white house personnel"                                                                                                           
 [322] "special assistant to the president for intergovernmental affairs - mayors"                                                                             
 [323] "special assistant to the president for intergovernmental affrs"                                                                                        
 [324] "special assistant to the president and associate staff secretary"                                                                                      
 [325] "special assistant to the president and assistant communications director"                                                                              
 [326] "senior policy advisor for economic policy and director of techhire"                                                                                    
 [327] "special assistant to the president for white house management"                                                                                         
 [328] "acting director of cabinet liaison"                                                                                                                    
 [329] "deputy director and deputy social secretary"                                                                                                           
 [330] "director, critical infrastructure protection"                                                                                                          
 [331] "executive assistant to the assistant to the president for presidential personnel"                                                                      
 [332] "outreach and recruitment director for presidential personnel"                                                                                          
 [333] "deputy assistant to the president and senior advisor to the chief of staff"                                                                            
 [334] "assistant to the president for legislative affairs"                                                                                                    
 [335] "special assistant to the president and executive secretary"                                                                                            
 [336] "special assistant to the president for health policy"                                                                                                  
 [337] "special assistant to the director of speechwriting"                                                                                                    
 [338] "supervisor, document management and tracking unit"                                                                                                     
 [339] "supervisor for document management and tracking unit"                                                                                                  
 [340] "supervisor, data entry unit"                                                                                                                           
 [341] "supervisor data entry unit"                                                                                                                            
 [342] "supervisor of data entry"                                                                                                                              
 [343] "associate director and trip coordinator"                                                                                                               
 [344] "coordinator"                                                                                                                                           
 [345] "deputy director"                                                                                                                                       
 [346] "director for correspondence systems innovation"                                                                                                        
 [347] "executive assistant to the deputy chief of staff for policy"                                                                                           
 [348] "deputy director of hispanic media"                                                                                                                     
 [349] "special assistant to the president and special counsel to the president"                                                                               
 [350] "special assistant to the president and advisor to the chief of staff"                                                                                  
 [351] "assistant to the president and deputy chief of staff for implementation"                                                                               
 [352] "information services operator"                                                                                                                         
 [353] "lead advance representative"                                                                                                                           
 [354] "deputy associate director for invitations and correspondence"                                                                                          
 [355] "deputy associate director for invitations & correspondence"                                                                                            
 [356] "associate director information sharing policy"                                                                                                         
 [357] "associate director of law and policy"                                                                                                                  
 [358] "director of legislative correspondence"                                                                                                                
 [359] "assistant to the president and press secretary"                                                                                                        
 [360] "deputy assistant to the president and director, office of urban affairs"                                                                               
 [361] "communications director of the domestic policy council and office of national aids policy"                                                             
 [362] "deputy assistant press secretary"                                                                                                                      
 [363] "special assistant to the president and senior counsel to the president"                                                                                
 [364] "chief of staff for the office of communications"                                                                                                       
 [365] "director of fact checking"                                                                                                                             
 [366] "special assistant to the white house counsel"                                                                                                          
 [367] "assistant director"                                                                                                                                    
 [368] "national security director"                                                                                                                            
 [369] "media assistant"                                                                                                                                       
 [370] "associate director of special projects"                                                                                                                
 [371] "operations manager"                                                                                                                                    
 [372] "presidential speechwriter"                                                                                                                             
 [373] "director of outreach"                                                                                                                                  
 [374] "communications advisor"                                                                                                                                
 [375] "director of confirmations"                                                                                                                             
 [376] "deputy assistant to the president and principal deputy counsel to the president"                                                                       
 [377] "media coordinator"                                                                                                                                     
 [378] "special assistant to the president and director of special communications projects"                                                                    
 [379] "senior writer for proclamations"                                                                                                                       
 [380] "deputy associate director for press advance"                                                                                                           
 [381] "assistant to the president and deputy chief of staff for planning"                                                                                     
 [382] "chief of staff, office of the staff secretary"                                                                                                         
 [383] "senior director of hispanic media"                                                                                                                     
 [384] "special assistant to the president and deputy director, usa freedom corps"                                                                             
 [385] "energy and environment director"                                                                                                                       
 [386] "deputy chief of staff for presidential personnel"                                                                                                      
 [387] "special assistant to the president and deputy director of strategic initiative"                                                                        
 [388] "special assistant and trip director to the first lady"                                                                                                 
 [389] "deputy director of scheduling and events coordinator for the first lady"                                                                               
 [390] "special assistant to the president for speechwriting"                                                                                                  
 [391] "associate research director for vetting"                                                                                                               
 [392] "senior associate research director"                                                                                                                    
 [393] "chief of staff, office of legislative affairs"                                                                                                         
 [394] "associate director of online outreach and operations"                                                                                                  
 [395] "deputy director of digital programs"                                                                                                                   
 [396] "associate director and scheduling researcher"                                                                                                          
 [397] "deputy director, let's move!"                                                                                                                          
 [398] "legislative assistant and assistant to the senate liaison"                                                                                             
 [399] "assistant to the president and director of the national economic council"                                                                              
 [400] "deputy director, technology"                                                                                                                           
 [401] "scheduling and advance assistant"                                                                                                                      
 [402] "outreach and recruitment director"                                                                                                                     
 [403] "special assistant to the president for presidential personnel and lead for leadership development"                                                     
 [404] "deputy director of digital content"                                                                                                                    
 [405] "special assistat to the president (house)"                                                                                                             
 [406] "assistant to the president and senior counselor"                                                                                                       
 [407] "special assistant to the assistant to the president for legislative affairs"                                                                           
 [408] "executive director, joining forces"                                                                                                                    
 [409] "assistant to the president for intergovernmental and technology initiatives"                                                                           
 [410] "legal researcher"                                                                                                                                      
 [411] "executive assistant to the political director"                                                                                                         
 [412] "senior press lead"                                                                                                                                     
 [413] "advisor to the counselor to the president"                                                                                                             
 [414] "special assistant to the press secretary"                                                                                                              
 [415] "special assistant for cabinet affair"                                                                                                                  
 [416] "special assistant to the president for mobility and opportunity policy"                                                                                
 [417] "special assistant to the president for mobilty and opportunity policy"                                                                                 
 [418] "deputy to the counselor for strategic engagement"                                                                                                      
 [419] "public engagement liaison"                                                                                                                             
 [420] "special assistant to the president for legislative affairs (house)"                                                                                    
 [421] "assistant director, presidential support"                                                                                                              
 [422] "lead presidential support specialist"                                                                                                                  
 [423] "deputy director of white house personnel and director of the white house internship program"                                                           
 [424] "director of administration"                                                                                                                            
 [425] "deputy assistant to the president & director of public liaison"                                                                                        
 [426] "deputy assistant to the president and director of public liaison"                                                                                      
 [427] "special assistant to the president for science, technology and innovation"                                                                             
 [428] "deputy assistant to the president and director intergovernmental affairs"                                                                              
 [429] "deputy director for whitehouse.gov"                                                                                                                    
 [430] "special assistant to the president for justice and regulatory policy"                                                                                  
 [431] "director of the office of national aids policy and senior advisor on disability policy"                                                                
 [432] "director of agency liaison"                                                                                                                            
 [433] "honorary chair and awards coordinator"                                                                                                                 
 [434] "deputy assistant to the president and director of scheduling and advance"                                                                              
 [435] "assistant to the president and director of scheduling and advance"                                                                                     
 [436] "deputy director, presidential correspondence"                                                                                                          
 [437] "deputy director of message planning and senior writer"                                                                                                 
 [438] "senior writer and deputy director of messaging"                                                                                                        
 [439] "economics staff assistant"                                                                                                                             
 [440] "director of fact-checking"                                                                                                                             
 [441] "director of digital content"                                                                                                                           
 [442] "director of white house operations"                                                                                                                    
 [443] "senior scheduler"                                                                                                                                      
 [444] "deputy director of scheduling"                                                                                                                         
 [445] "assistant to the president for special projects"                                                                                                       
 [446] "advisor to the president"                                                                                                                              
 [447] "assistant to the president and deputy senior advisor"                                                                                                  
 [448] "legal assistant"                                                                                                                                       
 [449] "scheduler and trip coordinator"                                                                                                                        
 [450] "director of digital response for correspondence"                                                                                                       
 [451] "special assistant to the president and deputy associate director of public engagement"                                                                 
 [452] "associate director of communications for the office of public engagement"                                                                              
 [453] "deputy director of stenography"                                                                                                                        
 [454] "director of stenography"                                                                                                                               
 [455] "consultant"                                                                                                                                            
 [456] "associate director of political affairs"                                                                                                               
 [457] "energy and environment staff assistant"                                                                                                                
 [458] "senior legislative affairs analyst"                                                                                                                    
 [459] "board member"                                                                                                                                          
 [460] "policy advisor for health care"                                                                                                                        
 [461] "press advance administrative assistant"                                                                                                                
 [462] "deputy associate director of press advance"                                                                                                            
 [463] "deputy assistant to the president for management and administration"                                                                                   
 [464] "director of white house services"                                                                                                                      
 [465] "deputy assistant to the president and staff secretary"                                                                                                 
 [466] "assistant speechwriter"                                                                                                                                
 [467] "assistant to the president and deputy chief of staff for legislative, cabinet, intergovernmental affairs and implementation"                           
 [468] "special assistant to the president and deputy director, national economic council"                                                                     
 [469] "deputy assistant to the president for communication"                                                                                                   
 [470] "senior assistant staff secretary"                                                                                                                      
 [471] "chief of staff for the office of the staff secretary"                                                                                                  
 [472] "presidential support specialist"                                                                                                                       
 [473] "director of information services"                                                                                                                      
 [474] "director of the white house switchboard"                                                                                                               
 [475] "director of the white house swrtchboard"                                                                                                               
 [476] "director, presidential messages and proclamations"                                                                                                     
 [477] "intake staff assistant"                                                                                                                                
 [478] "counselor to the president and director of the white house office for health care reform"                                                              
 [479] "assistant to the president and deputy chief of staff for policy"                                                                                       
 [480] "associate director of communications for production"                                                                                                   
 [481] "special assistant to the president and associate director of communications for production"                                                            
 [482] "special assistant to the president and associate dirrector of comm for production"                                                                     
 [483] "special assistant to the president & associate director of communication for production"                                                               
 [484] "policy advisor to the council on women and girls"                                                                                                      
 [485] "assistant to the president and director of presidential personnel"                                                                                     
 [486] "counselor to the office of legislative affairs"                                                                                                        
 [487] "communications adviser"                                                                                                                                
 [488] "special assistant to the president and deputy director of media affairs"                                                                               
 [489] "deputy assistant staff secretary"                                                                                                                      
 [490] "special assistant to the president and deputy counsel to the president"                                                                                
 [491] "special assistant to the president and director of private sector engagement"                                                                          
 [492] "deputy assistant to the president and director of policy and interagency coordination"                                                                 
 [493] "director, office of the  chief of staff"                                                                                                               
 [494] "deputy associate director of correspondence for the first lady"                                                                                        
 [495] "deputy director, proclamations"                                                                                                                        
 [496] "director, presidential proclamations"                                                                                                                  
 [497] "special assistant to the chief of staff for the office of public engagement and intergovernmental affairs"                                             
 [498] "assistant to the president and director, white house faith-based and community initiatives"                                                            
 [499] "special assistant to the president and deputy director of political affairs"                                                                           
 [500] "policy assistant for urban affairs and economic mobility"                                                                                              
 [501] "special assistant and policy advisor for the office of urban affairs, justice, and opportunity"                                                        
 [502] "chairman"                                                                                                                                              
 [503] "associate policy director"                                                                                                                             
 [504] "boards and commissions director for presidential personnel"                                                                                            
 [505] "special assistant to the president for native american affairs"                                                                                        
 [506] "deputy director, video"                                                                                                                                
 [507] "west wing receptionist"                                                                                                                                
 [508] "special assistant to the president and advisor for planning"                                                                                           
 [509] "director, preparedness policy"                                                                                                                         
 [510] "director, cyber policy"                                                                                                                                
 [511] "deputy assistant to the president and special counsel to the president and chief of staff to the white house counsel"                                  
 [512] "assistant to the president and national security advisor"                                                                                              
 [513] "special assistant to the president and deputy director of scheduling"                                                                                  
 [514] "special assistant to the president and deputy director of presidential personnel"                                                                      
 [515] "associate director for boards, commissions, and delegations"                                                                                           
 [516] "deputy director for operations"                                                                                                                        
 [517] "director of congressional communications"                                                                                                              
 [518] "deputy director of advance and special events for the office of public engagement and intergovernmental affairs"                                       
 [519] "director of planning and events for the office of public engagement and intergovernmental affairs"                                                     
 [520] "deputy chief of staff for the office of public engagement and intergovernmental affairs"                                                               
 [521] "correspondence manager"                                                                                                                                
 [522] "special assistant to the president for urban affairs"                                                                                                  
 [523] "director for response and planning"                                                                                                                    
 [524] "special assistant for management"                                                                                                                      
 [525] "director of white house management"                                                                                                                    
 [526] "director of the white house business council and policy advisor"                                                                                       
 [527] "chief of staff to the white house counsel"                                                                                                             
 [528] "director of preparedness policy"                                                                                                                       
 [529] "senior communications advisor"                                                                                                                         
 [530] "executive assistant to the deputy assistant to the president for homeland security"                                                                    
 [531] "director of records management"                                                                                                                        
 [532] "deputy director, office of records management"                                                                                                         
 [533] "executive assistant to the deputy chief of staff"                                                                                                      
 [534] "special assistant to the president and executive director of the white house office of faith-based and neighborhood partnerships"                      
 [535] "special assistant to the president and deputy director of advance for press"                                                                           
 [536] "deputy assistant to the president and deputy press secretary"                                                                                          
 [537] "associate director of online engagement"                                                                                                               
 [538] "special assistant to the senior advisor and the deputy chief of staff"                                                                                 
 [539] "chief of staff for the office of digital strategy"                                                                                                     
 [540] "project manager"                                                                                                                                       
 [541] "executive assistant to the director of the presidential personnel office"                                                                              
 [542] "assistant to the president and director of communications"                                                                                             
 [543] "civil participation liaison"                                                                                                                           
 [544] "policy assistant, urban policy and mobility and opportunity"                                                                                           
 [545] "associate director for policy and events let's move! initiative"                                                                                       
 [546] "political coordinator"                                                                                                                                 
 [547] "deputy director and hotel program manager"                                                                                                             
 [548] "deputy director and hotel program director"                                                                                                            
 [549] "greetings coordinator"                                                                                                                                 
 [550] "director of african american media"                                                                                                                    
 [551] "special assistant to the president and principal deputy press secretary"                                                                               
 [552] "special assistant to the president, principal deputy press secretary and chief of staff"                                                               
 [553] "lead press representative"                                                                                                                             
 [554] "deputy assistant to the president for faith-based and community initiatives"                                                                           
 [555] "special assistant to the president for economic and technology policy"                                                                                 
 [556] "new media analyst"                                                                                                                                     
 [557] "assistant supervisor for classification"                                                                                                               
 [558] "deputy assistant to the president and deputy nsa for international economic affairs"                                                                   
 [559] "deputy assistant to the president for international economic affairs and deputy national security advisor"                                             
 [560] "special assistant to the president , deputy director of advance for press"                                                                             
 [561] "special assistant to the president, deputy director of advance for press"                                                                              
 [562] "deputy assistant to the president and deputy counsel to the president for national security affairs and legal advisor to the national security council"
 [563] "deputy assistant to the president and deputy director of the national economic council and international economic affairs"                             
 [564] "research analyst"                                                                                                                                      
 [565] "senior lead advance representative"                                                                                                                    
 [566] "special assistant to the president and senior associate counsel to the president and deputy legal advisor to the national security council"            
 [567] "legal director"                                                                                                                                        
 [568] "deputy director of presidential messages"                                                                                                              
 [569] "associate director/volunteer office"                                                                                                                   
 [570] "executive director of let's move! and senior policy advisor for nutrition policy"                                                                      
 [571] "senior policy director for immigration"                                                                                                                
 [572] "special assistant to the president for immigration policy"                                                                                             
 [573] "deputy assistant to the president and director of media affairs"                                                                                       
 [574] "deputy assistant to the president and director of global communication"                                                                                
 [575] "intern coordinator"                                                                                                                                    
 [576] "president's personal secretary"                                                                                                                        
 [577] "special assistant to the president and cabinet communications director"                                                                                
 [578] "deputy director of scheduling for the first lady"                                                                                                      
 [579] "associate director of public engagement and senior policy advisor"                                                                                     
 [580] "assistant director for cabinet affairs"                                                                                                                
 [581] "assistant ot the executive clerk"                                                                                                                      
 [582] "assistant to the executive clerk"                                                                                                                      
 [583] "department of commerce liaison"                                                                                                                        
 [584] "deputy assistant to the president and deputy homeland security advisor"                                                                                
 [585] "assistant to the president and director of the office of legislative affairs"                                                                          
 [586] "deputy assistant to the president for economic policy"                                                                                                 
 [587] "deputy assistant to the president & deputy counsel to the president"                                                                                   
 [588] "deputy counsel to the president"                                                                                                                       
 [589] "director of students correspondence and engagement for presidential correspondence"                                                                    
 [590] "assistant to the president and director of speechwriting"                                                                                              
 [591] "director of white house personnel"                                                                                                                     
 [592] "director of white house personnel and advisor for management and administration"                                                                       
 [593] "special assistant to the president for management and administration and director of white house personnel"                                            
 [594] "special assistant to the president and senior advisor to the chief of staff"                                                                           
 [595] "deputy assistant to the president & director of political affairs"                                                                                     
 [596] "deputy assistant to the president and director of political affairs"                                                                                   
 [597] "assistant counsel of ethics"                                                                                                                           
 [598] "special assistant to the president and chief of staff of the domestic policy council"                                                                  
 [599] "speechwriter for the first lady"                                                                                                                       
 [600] "special assistant to the president and director of oval office operations"                                                                             
 [601] "special assistant to the president and director of events and protocol"                                                                                
 [602] "special assistant to the president and director of media affairs"                                                                                      
 [603] "counsel to the president"                                                                                                                              
 [604] "executive assistant to the director of scheduling and appointments"                                                                                    
 [605] "deputy director of appointments and scheduling"                                                                                                        
 [606] "domestic director for presidential personnel"                                                                                                          
 [607] "special assistant and press manager"                                                                                                                   
 [608] "associate director of press advance and press pool wrangler"                                                                                           
 [609] "deputy director of advance for the first lady"                                                                                                         
 [610] "deputy director of advance and trip director for the first lady"                                                                                       
 [611] "director, surface transportation security"                                                                                                             
 [612] "deputy assistant to the president and deputy counsel"                                                                                                  
 [613] "economics director"                                                                                                                                    
 [614] "director of veterans and wounded warrior policy"                                                                                                       
 [615] "assistant to the president and white house press secretary"                                                                                            
 [616] "special assistant to the director of presidential personnel"                                                                                           
 [617] "senior director for cabinet affairs"                                                                                                                   
 [618] "assistant director for information technology"                                                                                                         
 [619] "director, training and exercise policy"                                                                                                                
 [620] "public engagement advisor"                                                                                                                             
 [621] "special assistant to the president for healthcare and economic policy"                                                                                 
 [622] "senior presidential speechwriter"                                                                                                                      
 [623] "special assistant to the president and senior presidential speechwriter"                                                                               
 [624] "special assistant to the president and senior  presidential speechwriter"                                                                              
 [625] "deputy assistant to the president & deputy press secretary"                                                                                            
 [626] "outreach and recruitment director for presidential personnel and associate director of public engagement"                                              
 [627] "counselor for energy and climate change"                                                                                                               
 [628] "senior management analyst"                                                                                                                             
 [629] "senior advisor for strategic communications for the national economic council"                                                                         
 [630] "special assistant to the president, deputy press secretary and senior advisor to the press secretary"                                                  
 [631] "assistant to the president for economic policy, and director, national economic council"                                                               
 [632] "assistant to the president and deputy national security advisor for international economics"                                                           
 [633] "special assistant to the president for economic speech writing"                                                                                        
 [634] "deputy assistant to the president and director of policy and projects for the first lady"                                                              
 [635] "acting director of white house personnel"                                                                                                              
 [636] "director of coop pollcy"                                                                                                                               
 [637] "director, continuity policy"                                                                                                                           
 [638] "special assistant to the executive secretary"                                                                                                          
 [639] "deputy assistant to the president  for economic policy"                                                                                                
 [640] "assistant to the president and principal deputy director of the national economic council"                                                             
 [641] "press assistant and press wrangler"                                                                                                                    
 [642] "director of video images"                                                                                                                              
 [643] "special assistant to the director of public engagement"                                                                                                
 [644] "special assistant and policy advisor for education"                                                                                                    
 [645] "senior advisor and chief of staff of the national economic council"                                                                                    
 [646] "deputy assistant to the president and director, oval office operations"                                                                                
 [647] "deputy assistant to the president for management, administration and oval office operations"                                                           
 [648] "dep assistant to the president for management and administration"                                                                                      
 [649] "deputy assistant to the president for management & administration"                                                                                     
 [650] "deputy director, gift office"                                                                                                                          
 [651] "director of video for digital strategy"                                                                                                                
 [652] "director of video and special projects for the office of digital strategy"                                                                             
 [653] "associate director of public engagement and intergovernmental affairs"                                                                                 
 [654] "senior correspondence analyst"                                                                                                                         
 [655] "associate director of digital outbound"                                                                                                                
 [656] "executive assistant to the deputy assistant to the president for presidential personnel"                                                               
 [657] "assistant to the president and director of political affairs"                                                                                          
 [658] "director of principal trip accommodations"                                                                                                             
 [659] "senior advance manager and director of principal trip accommodations"                                                                                  
 [660] "deputy assistant to the president for advance and operations"                                                                                          
 [661] "deputy assistant to the president and director of speechwriting"                                                                                       
 [662] "assistant to the president for speechwriting and policy advisor"                                                                                       
 [663] "assistant to the president for policy and strategic planning"                                                                                          
 [664] "boards and commissions director"                                                                                                                       
 [665] "deputy director of mail analysis"                                                                                                                      
 [666] "deputy director of comment line and greetings"                                                                                                         
 [667] "deputy assistant to the president and director of presidential advance"                                                                                
 [668] "senior policy advisor for native american affairs"                                                                                                     
 [669] "special assistant to the president and cabinet communicatons director"                                                                                 
 [670] "caseworker"                                                                                                                                            
 [671] "education advisor"                                                                                                                                     
 [672] "director of online resources and interdepartmental development"                                                                                        
 [673] "special assistant to the president and dep dir of public liaison"                                                                                      
 [674] "special assistant to the president & deputy director of public liaison"                                                                                
 [675] "associate director of public liaison"                                                                                                                  
 [676] "special assistant to the president and deputy director office of public liaison"                                                                       
 [677] "deputy assistant to the president and chief digital officer"                                                                                           
 [678] "assistant to the president and white house counsel"                                                                                                    
 [679] "special assistant to the president and  associate counsel to the president"                                                                            
 [680] "deputy chief of staff for presidential personnel and policy advisor to the council on women and girls"                                                 
 [681] "director, office of records management"                                                                                                                
 [682] "special assistant to the president for financial markets"                                                                                              
 [683] "assistant to the president for homeland security"                                                                                                      
 [684] "deputy assistant to the president and strategist"                                                                                                      
 [685] "communications staff assistant"                                                                                                                        
 [686] "special assistant to the president and personal aide"                                                                                                  
 [687] "boards and commissions staff assistant"                                                                                                                
 [688] "associate counsel for ethics"                                                                                                                          
 [689] "special assistant to the president for administrative reform"                                                                                          
 [690] "special assistant to the president and deputy director, office of faith-based and community initiatives"                                               
 [691] "special assistant to the president and deputy director, ofbci"                                                                                         
 [692] "deputy director of presidential writers"                                                                                                               
 [693] "special assistant for presidential personnel"                                                                                                          
 [694] "vetting advisor for presidential personnel"                                                                                                            
 [695] "director of presidentialgifts"                                                                                                                         
 [696] "deputy assistant to the president & director of intergovernmental affairs"                                                                             
 [697] "deputy director of scheduling-surrogate scheduling"                                                                                                    
 [698] "deputy director of scheduling - surrogate scheduling"                                                                                                  
 [699] "special assistant to the president and deputy director of trade and manufacturing policy"                                                              
 [700] "assistant to the president and cabinet secretary"                                                                                                      
 [701] "special assistant to the director of the domestic policy council"                                                                                      
 [702] "special assistant and policy advisor to the director of the domestic policy council"                                                                   
 [703] "director of advance for the first lady"                                                                                                                
 [704] "deputy special counsel to the president"                                                                                                               
 [705] "policy advisor to the office of the chief of staff"                                                                                                    
 [706] "assistant to the president and special representative for international negotiations"                                                                  
 [707] "special assistant to the president and director, office of social innovation and civic participation"                                                  
 [708] "deputy director of finance"                                                                                                                            
 [709] "director for finance"                                                                                                                                  
 [710] "executive assistant/paralegal"                                                                                                                         
 [711] "assistant to the president for presidential personnel"                                                                                                 
 [712] "special assistant to the president and deputy director, office of public affairs"                                                                      
 [713] "special assistant to the president and deputy director, opa"                                                                                           
 [714] "special assistant to the cabinet secretary"                                                                                                            
 [715] "director of radio services"                                                                                                                            
 [716] "spokesman and director of radio"                                                                                                                       
 [717] "director of operations"                                                                                                                                
 [718] "associate director, white house comments line and greetings office"                                                                                    
 [719] "director of specialty media"                                                                                                                           
 [720] "associate staff secretary"                                                                                                                             
 [721] "special assistant to the president and deputy staff secretary"                                                                                         
 [722] "deputy director for information services"                                                                                                              
 [723] "assistant to the president for national security affairs"                                                                                              
 [724] "paralegal specialist"                                                                                                                                  
 [725] "assistant to the president & deputy chief of staff"                                                                                                    
 [726] "special assistant to the president and deputy strategist"                                                                                              
 [727] "director of whrte house travel office"                                                                                                                 
 [728] "special assistant to the president and director of correspondence"                                                                                     
 [729] "special assistant to the president and advisor for strategy and speechwriting"                                                                         
 [730] "associate director and trip manager"                                                                                                                   
 [731] "presidential videographer"                                                                                                                             
 [732] "director, immigration and visa security policy"                                                                                                        
 [733] "director of white house internship program"                                                                                                            
 [734] "regional director"                                                                                                                                     
 [735] "communications director and senior policy advisor for the domestic policy council"                                                                     
 [736] "editor/quality control"                                                                                                                                
 [737] "intergovernmental liaison"                                                                                                                             
 [738] "domestic staff assistant"                                                                                                                              
 [739] "director, presidential personal correspondence"                                                                                                        
 [740] "director presidential personal correspondence"                                                                                                         
 [741] "press staff assistant"                                                                                                                                 
 [742] "special assistant to the president for domestic policy and director of policy and projects for the first lady"                                         
 [743] "senior policy analyst"                                                                                                                                 
 [744] "associate director of presidential advance"                                                                                                            
 [745] "assistant director of the white house business council"                                                                                                
 [746] "special asstistant to the president for legislative affairs"                                                                                           
 [747] "assistant to the president and secretary to the cabinet"                                                                                               
 [748] "director, law enforcement policy"                                                                                                                      
 [749] "white house travel specialist"                                                                                                                         
 [750] "communications coordinator"                                                                                                                            
 [751] "associate director of communications"                                                                                                                  
 [752] "director of response policy"                                                                                                                           
 [753] "director of projects"                                                                                                                                  
 [754] "deputy assistant to the president and director of the office of faith-based and community initiatives"                                                 
 [755] "deputy assistant to the president and deputy to the senior advisor"                                                                                    
 [756] "assistant to the president for economic policy and director, national economic council"                                                                
 [757] "director of broadcast media"                                                                                                                           
 [758] "director of agency liaison for correspondence"                                                                                                         
 [759] "presidential writer"                                                                                                                                   
 [760] "deputy assistant to the president and assistant to the senior advisor"                                                                                 
 [761] "special assistant to the assistant to the president for leg affairs"                                                                                   
 [762] "special projects coordinator"                                                                                                                          
 [763] "member relations advisor"                                                                                                                              
 [764] "senior advisor for congressional engagement and legislative relations"                                                                                 
 [765] "assistant to the president and director of strategic communications"                                                                                   
 [766] "director of scheduling and advance for the first lady"                                                                                                 
 [767] "deputy  assistant to the president and deputy director of the domestic policy council"                                                                 
 [768] "deputy assistant to the president and deputy director of the domestic policy council"                                                                  
 [769] "confidential assistant"                                                                                                                                
 [770] "special assistant to the office of cabinet affairs"                                                                                                    
 [771] "director for domestic counterterrorism policy"                                                                                                         
 [772] "assistant press secretary and white house spokesperson"                                                                                                
 [773] "western political director"                                                                                                                            
 [774] "acting director of presidential correspondence"                                                                                                        
 [775] "special assistant to the president & director of presidential correspondence"                                                                          
 [776] "special assistant to the social secretary"                                                                                                             
 [777] "white house leadership development fellow"                                                                                                             
 [778] "deputy assistant to the president for legislative affairs (house)"                                                                                     
 [779] "senior designer for the office of digital strategy"                                                                                                    
 [780] "director, international programs border security policy"                                                                                               
 [781] "special assistant to the president and chief of staff for presidential personnel"                                                                      
 [782] "deputy assistant to the president and director of presidential personnel"                                                                              
 [783] "director of presidential messages"                                                                                                                     
 [784] "associate director of scheduling for invitations and correspondence"                                                                                   
 [785] "special projects manager"                                                                                                                              
 [786] "computer specialist"                                                                                                                                   
 [787] "special assistant to the deputy assistant to the president for legislative affairs (house)"                                                            
 [788] "special assistant to the president and director of research"                                                                                           
 [789] "director, correspondence personnel"                                                                                                                    
 [790] "special assistant to the president for policy"                                                                                                         
 [791] "assistant director of correspondence for agency liaision"                                                                                              
 [792] "special assistant to the president for coop policy"                                                                                                    
 [793] "policy advisor to the senior advisor"                                                                                                                  
 [794] "e-mail content/design lead and new media liaison"                                                                                                      
 [795] "special assistant and advisor to the senior advisor"                                                                                                   
 [796] "special assistant to the staff secretary"                                                                                                              
 [797] "special assistant to the president and deputy director of appointments and scheduling"                                                                 
 [798] "deputy assistant to the president and deputy director for legislative affairs"                                                                         
 [799] "acting senior director of response and recovery"                                                                                                       
 [800] "asst to the president for economic policy and director, nec"                                                                                           
 [801] "assistant to the president for economic policy & director, national economic council"                                                                  
 [802] "invitation assistant"                                                                                                                                  
 [803] "deputy assistant to the president and chief of staff to the senior counselor"                                                                          
 [804] "associate director of content"                                                                                                                         
 [805] "executive assistant to the cabinet secretary and special projects coordinator"                                                                         
 [806] "executive assistant to the deputy chief of staff and senior advisor"                                                                                   
 [807] "senior editor"                                                                                                                                         
 [808] "associate director for operations"                                                                                                                     
 [809] "special assistant to the president and executive assistant to the chief of staff"                                                                      
 [810] "associate director of scheduling - surrogate scheduling"                                                                                               
 [811] "director of regional media"                                                                                                                            
 [812] "associate director of speechwriting and senior presidential speechwriter"                                                                              
 [813] "special assistant to the president, senior advisor to the council on women and girls, and senior presidential speechwriter"                            
 [814] "special assistant to the president, senior strategic and policy advisor to the council on women and girls, and senior presidential speechwriter"       
 [815] "director of student and children's correspondence"                                                                                                     
 [816] "associate director for policy and events"                                                                                                              
 [817] "special assistant to the assistant to the president"                                                                                                   
 [818] "director of speciality media"                                                                                                                          
 [819] "assistant for arrangements"                                                                                                                            
 [820] "director for incident management"                                                                                                                      
 [821] "logistical specialist"                                                                                                                                 
 [822] "director of white house internship program and volunteers"                                                                                             
 [823] "deputy assistant to the president and director of strategic initiatives"                                                                               
 [824] "dep asstistant to the president and deputy to the senior advisor"                                                                                      
 [825] "deputy assistant to the president & deputy to the senior advisor"                                                                                      
 [826] "assistant to the president for strategic initiatives and external affairs"                                                                             
 [827] "scheduler to the first lady"                                                                                                                           
 [828] "director, immigration security policy"                                                                                                                 
 [829] "director of immigration security policy"                                                                                                               
 [830] "outreach and recruitment staff assistant for presidential personnel"                                                                                   
 [831] "production assistant"                                                                                                                                  
 [832] "special assistant to the president and advisor for development and speechwriting"                                                                      
 [833] "senior advisor and assistant to the president for intergovernmental affairs and public engagement"                                                     
 [834] "research director"                                                                                                                                     
 [835] "special assistant for scheduling and traveling aide to the first lady"                                                                                 
 [836] "deputy director of advance and traveling aide for the first lady"                                                                                      
 [837] "deputy senior advisor and director of external relations for the first lady"                                                                           
 [838] "northeast political director"                                                                                                                          
 [839] "special assistant to the president and deputy director of advance press"                                                                               
 [840] "executive assistant to the deputy chief of staff & senior advisor"                                                                                     
 [841] "executive assistant and director, office of strategic initiatives and external affairs"                                                                
 [842] "special assistant to the president and deputy director for political affairs"                                                                          
 [843] "special assistant to the president & deputy director for political affairs"                                                                            
 [844] "deputy assistant director"                                                                                                                             
 [845] "personal aide"                                                                                                                                         
 [846] "principal assistant press secretary"                                                                                                                   
 [847] "assistant to the president for presidential personnel and deputy to the chief of staff"                                                                
 [848] "personal secretary to the president"                                                                                                                   
 [849] "assistant director of correspondence for gifts"                                                                                                        
 [850] "deputy director of the office of records management"                                                                                                   
 [851] "director of presidential personal correspondence"                                                                                                      
 [852] "deputy director of correspondence"                                                                                                                     
 [853] "invitations assistant"                                                                                                                                 
 [854] "senior advisor  for social innovation and civic participation"                                                                                         
 [855] "deputy director of media affairs"                                                                                                                      
 [856] "deputy director of media affairs and senior spokesman"                                                                                                 
 [857] "assistant supervisor, document management and tracking unit"                                                                                           
 [858] "assistant supervisor for document management and tracking unit"                                                                                        
 [859] "assistant supervisor, data entry unit"                                                                                                                 
 [860] "assistant supervisor of data entry"                                                                                                                    
 [861] "assistant supervisor document management and tracking unit"                                                                                            
 [862] "assistant agency coordinator/correspondence analyst"                                                                                                   
 [863] "director of white house administration"                                                                                                                
 [864] "national security advisor"                                                                                                                             
 [865] "special assistant and personal aide to the first lady"                                                                                                 
 [866] "personal aide to the first lady and east wing operations coordinator"                                                                                  
 [867] "special assistant and director of special projects for the first lady"                                                                                 
 [868] "special assistant to the deputy assistant to the president"                                                                                            
 [869] "special assistant to the director of the office of public engagement"                                                                                  
 [870] "special assistant to the chief of staff for policy"                                                                                                    
 [871] "assistant director of correspondence for student correspondence"                                                                                       
 [872] "white house services manager"                                                                                                                          
 [873] "research coordinator for presidential personnel"                                                                                                       
 [874] "special assistant to the president for homeland security and senior director for bio defense policy"                                                   
 [875] "deputy executive clerk"                                                                                                                                
 [876] "executive clerk"                                                                                                                                       
 [877] "special assistant to the president and director of white house operations"                                                                             
 [878] "assistant to the president for management and administration"                                                                                          
 [879] "associate counsel for presidential personnel"                                                                                                          
 [880] "special assistant to the president and traveling aide"                                                                                                 
 [881] "director of response and recovery policy"                                                                                                              
 [882] "special assistant to the president for homeland security &senior director for response policy"                                                         
 [883] "special assistant to the president for homeland security and senior director for response policy"                                                      
 [884] "special assistant to the president"                                                                                                                    
 [885] "assistant to the president and dep chief of staff for policy"                                                                                          
 [886] "special assistant to the president and deputy director of presidential advance"                                                                        
 [887] "director of digital operations"                                                                                                                        
 [888] "west wing receptionist and coordinator for operations"                                                                                                 
 [889] "research assistant and junior speechwriter"                                                                                                            
 [890] "deputy assistant to the president and deputy director of the national economic council and economic policy"                                            
 [891] "executive director for white house council on native american affairs"                                                                                 
 [892] "special assistant to the president and deputy director of speechwriting"                                                                               
 [893] "deputy director for proclamations"                                                                                                                     
 [894] "deputy director of proclamations"                                                                                                                      
 [895] "special assistant to the president and director of presidential correspondence"                                                                        
 [896] "special assistant to the president and personal secretary"                                                                                             
 [897] "special assistant to the president and chief of staff of the national economic council"                                                                
 [898] "assistant to the president and executive secretary and chief of staff for the national security council"                                               
 [899] "senior vetter"                                                                                                                                         
 [900] "assistant director for vetting"                                                                                                                        
 [901] "deputy assistant to the president and director of white house management and administration and director of the office of administration"              
 [902] "climate and domestic director for presidential personnel"                                                                                              
 [903] "director of counsel operations"                                                                                                                        
 [904] "senior policy advisor for economic policy"                                                                                                             
 [905] "deputy associate director for scheduling advance"                                                                                                      
 [906] "records management technician"                                                                                                                         
 [907] "outreach and recruitment staff assistant"                                                                                                              
 [908] "attorney"                                                                                                                                              
 [909] "director of the white house internship program"                                                                                                        
 [910] "director of the white house internship program and dc scholars program"                                                                                
 [911] "senior associate director of intergovernmental affairs and public engagement"                                                                          
 [912] "special assistant to the president for healthcare"                                                                                                     
 [913] "scheduler for chief of staff"                                                                                                                          
 [914] "deputy director of advance and special events for the office of intergovernmental affairs and public engagement"                                       
 [915] "director of advance and special events for the office of intergovernmental affairs and public engagement"                                              
 [916] "deputy assistant director of broadcast media"                                                                                                          
 [917] "chief of staff for presidential personnel"                                                                                                             
 [918] "special assistant to the president, chief of staff, and advisor to the director of presidential personnel"                                             
 [919] "senior video producer"                                                                                                                                 
 [920] "special assistant to the president and deputy director of the office of public liaison"                                                                
 [921] "national security staff assistant"                                                                                                                     
 [922] "chief of staff of the national economic council"                                                                                                       
 [923] "special assistant to the president and director of public and political affairs, usa freedom corps"                                                    
 [924] "special assistant to the assistant to the president for legis affairs"                                                                                 
 [925] "director of presidential writers"                                                                                                                      
 [926] "assistant to the director of research"                                                                                                                 
 [927] "special assistant to the counselor to the senior advisor for strategic engagement"                                                                     
 [928] "deputy director for finance"                                                                                                                           
 [929] "assistant counsel for nominations"                                                                                                                     
 [930] "director of special projects for cabinet affairs"                                                                                                      
 [931] "special assistant to the president and senior director, critical infrastructure protection"                                                            
 [932] "administrative assistant to the director"                                                                                                              
 [933] "special assistant to the president for cabinet liaison"                                                                                                
 [934] "economics director for presidential personnel"                                                                                                         
 [935] "senior mail clerk"                                                                                                                                     
 [936] "deputy assistant to the president for health policy"                                                                                                   
 [937] "assistant to the president and counselor to the chief of staff"                                                                                        
 [938] "usaid liaison"                                                                                                                                         
 [939] "director of the comment line"                                                                                                                          
 [940] "special assistant to the president and director, office of administration"                                                                             
 [941] "mail clerk/correspondence analyst"                                                                                                                     
 [942] "special assistant to the chief of staff of the office of intergovernmental affairs and publc engagement"                                               
 [943] "associate director and advance coordinator"                                                                                                            
 [944] "supervisor for search and file section"                                                                                                                
 [945] "special assistant to the president for presidential personnel and lead for national security and foreign policy"                                       
 [946] "advisor to the council on women and girls"                                                                                                             
 [947] "manager, the president's young artists program"                                                                                                        
 [948] "associate director of correspondence for the first lady"                                                                                               
 [949] "associate director for correspondence and records management"                                                                                          
 [950] "director of message planning"                                                                                                                          
 [951] "deputy director finance"                                                                                                                               
 [952] "special assistant to the director of the presidential personnel office"                                                                                
 [953] "associate director for confirmations"                                                                                                                  
 [954] "director of online programs"                                                                                                                           
 [955] "director of progressive media and online response"                                                                                                     
 [956] "special assistant to the president and director of progressive media and online response"                                                              
 [957] "special assistant to the president and director of rapid response"                                                                                     
 [958] "deputy assistant to the president for domestic policy"                                                                                                 
 [959] "special assistant to the president and director of message events"                                                                                     
 [960] "website assistant"                                                                                                                                     
 [961] "deputy director of response"                                                                                                                           
 [962] "midwestern regional communications director"                                                                                                           
 [963] "assistant director of online engagement"                                                                                                               
 [964] "director and press secretary to the first lady"                                                                                                        
 [965] "associate director of press advance"                                                                                                                   
 [966] "southern political director"                                                                                                                           
 [967] "deputy chief of staff for the national economic council"                                                                                               
 [968] "special assistant to the president for economic policy and chief of staff of the national economic council"                                            
 [969] "director of television"                                                                                                                                
 [970] "senior policy director"                                                                                                                                
 [971] "director of african-american media"                                                                                                                    
 [972] "associate director, mail analysis"                                                                                                                     
 [973] "supervisor of search and file"                                                                                                                         
 [974] "assistant to the president and chief of staff to the vice president"                                                                                   
 [975] "assistant to the president for strategic initiatives"                                                                                                  
 [976] "director of comment line greetings and volunteers"                                                                                                     
 [977] "deputy director of advance and director of press advance"                                                                                              
 [978] "director of press advance"                                                                                                                             
 [979] "director of transportation security policy"                                                                                                            
 [980] "director, transportation security policy"                                                                                                              
 [981] "operations staff assistant for presidential personnel"                                                                                                 
 [982] "senior technical program manager"                                                                                                                      
 [983] "deputy associate director of advance for personnel"                                                                                                    
 [984] "deputy director of online engagement"                                                                                                                  
 [985] "assistant to the president and director, national economic council"                                                                                    
 [986] "special assisant and personal aide to the first lady"                                                                                                  
 [987] "deputy assistant to the president and chief of staff for national security operations"                                                                 
 [988] "special assistant to the president for international  economic affairs"                                                                                
 [989] "special assistant to the president for innovation policy and initiatives"                                                                              
 [990] "special assistant to the president and dep press secretary"                                                                                            
 [991] "special assistant to the president for management and administration"                                                                                  
 [992] "associate for law and policy"                                                                                                                          
 [993] "new media creative director"                                                                                                                           
 [994] "legislative counsel and policy advisor"                                                                                                                
 [995] "senior policy advisor for economic development"                                                                                                        
 [996] "policy advisor to the deputy chief of staff for implementation"                                                                                        
 [997] "special assistant to the president and principal deputy director of scheduling"                                                                        
 [998] "special assistant to the president and clearance counsel"                                                                                              
 [999] "director of technology"                                                                                                                                
[1000] "deputy assistant to the president and director of usa freedom corps"                                                                                   
[1001] "director for public liaison"                                                                                                                           
[1002] "research assistant and executive assistant"                                                                                                            
[1003] "special assistant to the president for international economics"                                                                                        
[1004] "deputy director of special projects"                                                                                                                   
[1005] "director of finance"                                                                                                                                   
[1006] "special assistant to the president and director of whue house events and presidential scheduling"                                                      
[1007] "director of radio media"                                                                                                                               
[1008] "deputy assistant to the president for legislative affairs and senate liaison"                                                                          
[1009] "deputy assistant to the president for legislative affairs and senate liaision"                                                                         
[1010] "special assistant to the deputy senior advisor for communications and strategy"                                                                        
[1011] "director of planning for the office of political strategy and outreach"                                                                                
[1012] "special assistant to the president and deputy director of the office of political strategy and outreach"                                               
[1013] "trip coordinator for the first lady"                                                                                                                   
[1014] "principal deputy director"                                                                                                                             
[1015] "senior director of regional media"                                                                                                                     
[1016] "special assistant to the president and director of media affrs"                                                                                        
[1017] "deputy assistant to the president & director of media affairs"                                                                                         
[1018] "assistant to the president and director of communications for the office of public liaison"                                                            
[1019] "legislative correspondent"                                                                                                                             
[1020] "director, public health policy"                                                                                                                        
[1021] "deputy director for digital outbound"                                                                                                                  
[1022] "special assistant to the president and deputy director of presidential correspondence"                                                                 
[1023] "special assistant to the president and chief of staff of the national economic council and economic policy"                                            
[1024] "special assistant to the president and director of organizational structure and human capital"                                                         
[1025] "special assistant to the president and principal deputy director of public engagement"                                                                 
[1026] "deputy director of correspondence and director of writers"                                                                                             
[1027] "director, presidential messages"                                                                                                                       
[1028] "director of correspondence for the  first lady"                                                                                                        
[1029] "deputy assistant to the president and deputy director of communications for policy and planning"                                                       
[1030] "dep assistant to the president and deputy director of communications for policy and planning"                                                          
[1031] "deputy assistant to the president & deputy director of communication for policy & planning"                                                            
[1032] "associate director of confirmations and legislative correspondence"                                                                                    
[1033] "special assistant to the president and deputy cabinet secretary"                                                                                       
[1034] "printer and photograph coordinator"                                                                                                                    
[1035] "director of mail analysis"                                                                                                                             
[1036] "printer"                                                                                                                                               
[1037] "director, aviation security policy"                                                                                                                    
[1038] "economics staff assistant for presidential personnel"                                                                                                  
[1039] "special assistant and policy advisor for the white house office of faith-based and neighborhood partnerships"                                          
[1040] "director, presidential letters and messages"                                                                                                           
[1041] "operations staff assistant"                                                                                                                            
[1042] "director of rapid response"                                                                                                                            
[1043] "speech writer for the first lady"                                                                                                                      
[1044] "dep assistant to the president and chief of staff to the first lady"                                                                                   
[1045] "assistant to the president and chief of staff to the first lady"                                                                                       
[1046] "director, international programs and border security policy"                                                                                           
[1047] "assistant executive clerk"                                                                                                                             
[1048] "deputy assistant to the president and principal deputy press secretary"                                                                                
[1049] "chief of staff to the office of the white house counsel"                                                                                               
[1050] "chief of staff and advisor to the white house counsel office"                                                                                          
[1051] "deputy associate counsel to the president"                                                                                                             
[1052] "deputy assistant to the president, deputy director of speechwriting and assistant to the vice president"                                               
[1053] "deputy assistant to the president for strategic initiatives and external affairs"                                                                      
[1054] "deputy assistant to the pres and deputy national security adviser for international economic afairs"                                                   
[1055] "correspondence analyst and web mail administrator"                                                                                                     
[1056] "associate director of communications for policy and planning"                                                                                          
[1057] "exec assistant to the director for strategic initiatives"                                                                                              
[1058] "executive assistant to the director of strategic initiatives"                                                                                          
[1059] "deputy assistant to the president and national security spokesperson"                                                                                  
[1060] "deputy assistant to the president and national security council chief of staff"                                                                        
[1061] "deputy assistant to the president and cabinet secretary"                                                                                               
[1062] "advisor"                                                                                                                                               
[1063] "senior policy advisor for education"                                                                                                                   
[1064] "assistant to the president for speechwriting"                                                                                                          
[1065] "deputy assistant to the president & deputy staff secretary"                                                                                            
[1066] "education, women and families, and workforce policy advisor"                                                                                           
[1067] "white house telephone service chief operator"                                                                                                          
[1068] "deputy assistant to the president for presidential personnel"                                                                                          
[1069] "senior associate counsel to the president and general counsel of the office of homeland security"                                                      
[1070] "assistant director of correspondence for volunteers and comment line"                                                                                  
[1071] "executive assistant to the press secretary"                                                                                                            
[1072] "associate director for security"                                                                                                                       
[1073] "special assistant to the president and deputy director for press advance"                                                                              
[1074] "special assistant to the president and director of white house management"                                                                             
[1075] "deputy director of email and petitions"                                                                                                                
[1076] "special assistant to the president & deputy director, office of faith-based and community initiatives"                                                 
[1077] "deputy chief of staff to the first lady"                                                                                                               
[1078] "assistant director of projects and policy advisor"                                                                                                     
[1079] "special assistant to the president for domestic policy and director of projects for the first lady"                                                    
[1080] "special assistant to the president for domestic policy and director of projects for first lady"                                                        
[1081] "deputy assistant to the president for domestic policy and director of projects for the first lady"                                                     
[1082] "senior vetting counsel for presidential personnel"                                                                                                     
[1083] "deputy director of policy and projects for the first lady"                                                                                             
[1084] "special assistant to the president for higher education policy"                                                                                        
[1085] "special assistant to the president and chief of staff of the office of legislative affairs"                                                            
[1086] "senior advisor, tax and fiscal policy"                                                                                                                 
[1087] "aviation security director"                                                                                                                            
[1088] "deputy assistant to the president for legislative affairs and house deputy director"                                                                   
[1089] "special assistant to the president & deputy director of advance"                                                                                       
[1090] "deputy assistant to the president and deputy director of speechwriting"                                                                                
[1091] "assistant director of cabinet affairs"                                                                                                                 
[1092] "outreach and recruitment director for presidential personnel (congressional)"                                                                          
[1093] "special assistant to the president for manufacturing policy"                                                                                           
[1094] "director of product management"                                                                                                                        
[1095] "director, response recovery"                                                                                                                           
[1096] "deputy director of projects for the first lady"                                                                                                        
[1097] "deputy director of projects for the  first lady"                                                                                                       
[1098] "assistant to the president and senior advisor for policy"                                                                                              
[1099] "senior records management analyst"                                                                                                                     
[1100] "assistant supervisor for search and file"                                                                                                              
[1101] "director of hispanic media"                                                                                                                            
[1102] "procurement liaison"                                                                                                                                   
[1103] "deputy associate director of let's move!"                                                                                                              
[1104] "deputy director of scheduling (invitation and correspondence)"                                                                                         
[1105] "special assistant to the president and director of strategic planning"                                                                                 
[1106] "special assistant to the president and director of strategic planning for the first lady"                                                              
[1107] "assistant to the president for homeland security and counterterrorism and deputy national security advisor"                                            
[1108] "senior policy advisor for social innovation and civic participation"                                                                                   
[1109] "deputy associate director of public engagement"                                                                                                        
[1110] "research analyst and executive assistant"                                                                                                              
[1111] "assistant to the office of american innovation"                                                                                                        
[1112] "special assistant to the president for presidential personnel and lead for boards, commissions, and presidential delegations"                          
[1113] "associate director for policy"                                                                                                                         
[1114] "deputy policy director for immigration"                                                                                                                
[1115] "deputy director for buy american/hire american"                                                                                                        
[1116] "senior director of scheduling"                                                                                                                         
[1117] "advisor to the press secretary"                                                                                                                        
[1118] "special assistant to the first lady"                                                                                                                   
[1119] "executive assistant to the deputy assistant to the president for homeland sec"                                                                         
[1120] "deputy director of oval office operations"                                                                                                             
[1121] "director of oval office operations"                                                                                                                    
[1122] "deputy director of operations"                                                                                                                         
[1123] NA                                                                                                                                                      
[1124] "deputy assistant to the president and principal deputy director of the office of public liaison"                                                       
[1125] "northeast regional communications director"                                                                                                            
[1126] "senior analyst and presidential writer"                                                                                                                
[1127] "associate director and deputy press secretary to the first lady"                                                                                       
[1128] "assistant to the president and director, office of legislative affairs"                                                                                
[1129] "director, white house telephone service"                                                                                                               
[1130] "director, nuclear detection policy"                                                                                                                    
[1131] "supervisor, optical disk unit"                                                                                                                         
[1132] "deputy assistant to the president and director of trade and manufacturing policy"                                                                      
[1133] "deputy director of the gift office"                                                                                                                    
[1134] "director of visas and screening policy"                                                                                                                
[1135] "director, immigration & visa security policy"                                                                                                          
[1136] "special assistant to the president for legislative affairs and house legislative affairs liaison"                                                      
[1137] "deputy director of scheduling and scheduling manager"                                                                                                  
[1138] "principal deputy director of scheduling and scheduling manager"                                                                                        
[1139] "special assistant to the president and senior advisor for the national economic council"                                                               
[1140] "director of aviation security policy"                                                                                                                  
[1141] "gift analysis"                                                                                                                                         
[1142] "special assistant to the president for economic speechwriting"                                                                                         
[1143] "director of travel office"                                                                                                                             
[1144] "special assistant to the president and social secretary"                                                                                               
[1145] "director for cyberspace security"                                                                                                                      
[1146] "special assistant to the president and trip director"                                                                                                  
[1147] "special assistant to the president, trip director and personal aide to the president"                                                                  
[1148] "special assistant to the president and sr director for preparedness and response"                                                                      
[1149] "special assistant to the president for prevention, preperations and response policy"                                                                   
[1150] "special assistant to the president and director of communications and press secretary to the first lady"                                               
[1151] "associate director for technology"                                                                                                                     
[1152] "director of research"                                                                                                                                  
[1153] "director, communications systems & cyber security policy"                                                                                              
[1154] "director, communications systems and cyber security policy"                                                                                            
[1155] "director continuity policy"                                                                                                                            
[1156] "special assistant to the president and director of special projects, office of the chief of staff"                                                     
[1157] "special assistant to the president and advisor for the office of political strategy and outreach"                                                      
[1158] "chief tax counsel"                                                                                                                                     
[1159] "deputy assistant to the president for legislative affairs (senate)"                                                                                    
[1160] "senior policy advisor for labor and workforce"                                                                                                         
[1161] "special assistant to the president for labor and workforce policy"                                                                                     
[1162] "chief of staff of the domestic policy council"                                                                                                         
[1163] "director of internet news service"                                                                                                                     
[1164] "director of internet news services"                                                                                                                    
[1165] "legislative assistant and assistant to the director's office"                                                                                          
[1166] "legislative assistant and special assistant to the director"                                                                                           
[1167] "director for plans and exercises"                                                                                                                      
[1168] "assistant director of public engagement"                                                                                                               
[1169] "director of special projects for communications"                                                                                                       
[1170] "special assistant to the president and director of message planning"                                                                                   
[1171] "senior advisor for health, domestic policy council"                                                                                                    
[1172] "director of communications for the office of health reform"                                                                                            
[1173] "senior legal assistant"                                                                                                                                
[1174] "director of agency outreach for cabinet affairs"                                                                                                       
[1175] "director of coalitions media"                                                                                                                          
[1176] "advisor for technology"                                                                                                                                
[1177] "assistant supervisor of classification"                                                                                                                
[1178] "executive assistant to the assistant to the president for homeland security &counterterrorism"                                                         
[1179] "executive assistant to the deputy assistant to the president for homeland"                                                                             
[1180] "senior advisor for housing, national economic council"                                                                                                 
[1181] "assistant to the executive clerk for legislation"                                                                                                      
[1182] "director of policy for the office of intergovernmental affairs and public engagement"                                                                  
[1183] "policy and special projects coordinator"                                                                                                               
[1184] "director of presidential proclamations"                                                                                                                
[1185] "special assistant to the president and principal travel aide"                                                                                          
[1186] "deputy director and surrogate scheduler"                                                                                                               
[1187] "special assistant to the president and senior advisor to the deputy chief of staff"                                                                    
[1188] "director, cyber infrastructure protection"                                                                                                             
[1189] "director, physical ip policy"                                                                                                                          
[1190] "aide to the assistant to the president for homeland security &counterterrorism"                                                                        
[1191] "deputy assistant to the president for legislative affairs and house liaison"                                                                           
[1192] "national security staff assistant for presidential personnel"                                                                                          
[1193] "dep assistant to the president and deputy press secretary"                                                                                             
[1194] "deputy assistant to the president & principal deputy press secretary"                                                                                  
[1195] "operations director for presidential personnel"                                                                                                        
[1196] "special assistant to the president and senior director of cabinet affairs"                                                                             
[1197] "associate director of the white house internship program"                                                                                              
[1198] "special assistant to the president and director of new media"                                                                                          
[1199] "special assistant to the president and director of digital strategy"                                                                                   
[1200] "priority placement staff assistant"                                                                                                                    
[1201] "leadership development director for presidential personnel"                                                                                            
[1202] "director or administration"                                                                                                                            
[1203] "senior editor/writer"                                                                                                                                  
[1204] "director of the travel office"                                                                                                                         
[1205] "director of white house operations and advisor for management and administration"                                                                      
[1206] "attorney, ethics assistant"                                                                                                                            
[1207] "director for recovery"                                                                                                                                 
[1208] "deputy press secretary and executive secretary"                                                                                                        
[1209] "senior writer for correspondence"                                                                                                                      
[1210] "assistant to the president and white house staff secretary"                                                                                            
[1211] "deputy director of operations and continuity"                                                                                                          
[1212] "assistant to the president and deputy national security advisor for strategy"                                                                          
[1213] "finance and logistics officer"                                                                                                                         
[1214] "principal deputy associate counsel"                                                                                                                    
[1215] "senior advisor to the director and deputy chief of staff of the national economic council"                                                             
[1216] "assistant to president for international economic affairs and deputy national security advisor for international economic affairs"                     
[1217] "special assistant and advisor to the director of legislative affairs"                                                                                  
[1218] "director, white house visitor's office"                                                                                                                
[1219] "attorney advisor"                                                                                                                                      
[1220] "special assistant to the president for financial and international markets"                                                                            
[1221] "deputy assistant to the president and advisor to the chief of staff"                                                                                   
[1222] "director, white house personnel"                                                                                                                       
[1223] "deputy director and intern coordinator"                                                                                                                
[1224] "strategic communications advisor"                                                                                                                      
[1225] "strategic communications advisor and special projects manager"                                                                                         
[1226] "special assistant to president and associate director of presidential personnel"                                                                       
[1227] "special assistant to the president and chief of staff for economic initiatives"                                                                        
[1228] "deputy assistant to the president and communications advisor"                                                                                          
[1229] "deputy director of records management"                                                                                                                 
[1230] "deputy director and senior advisor for records management"                                                                                             
[1231] "outreach and recruitment director (congressional)"                                                                                                     
[1232] "special assistant to the director of communications"                                                                                                   
[1233] "special assistant and advisor to the press secretary"                                                                                                  
[1234] "special assistant to the president for presidential personnel and lead for economics and justice"                                                      
[1235] "deputy assistant to the president for homeland security and executive secretary"                                                                       
[1236] "deputy assistant to the president for homeland security and exec"                                                                                      
[1237] "director of cabinet communications"                                                                                                                    
[1238] "vice chairman"                                                                                                                                         
[1239] "special assistant to the president and deputy director of advance for event coordination"                                                              
[1240] "special assistant to the president & trip director"                                                                                                    
[1241] "special assistant to the president and director of white house information technology"                                                                 
[1242] "special assistant to the president for homeland security and senior director for continuity policy"                                                    
[1243] "director, maritime security"                                                                                                                           
[1244] "deputy assistant to the president, deputy national security advisor for strategic communications and speechwriting"                                    
[1245] "assistant to the president and deputy national security advisor for strategic communications and speechwriting"                                        
[1246] "regional communicatons director"                                                                                                                       
[1247] "senior regional communications director"                                                                                                               
[1248] "assistant to the deputy counsel to the president"                                                                                                      
[1249] "interim chief digital officer"                                                                                                                         
[1250] "executive assistant to the director of speechwriting"                                                                                                  
[1251] "executive assistant to the communication director"                                                                                                     
[1252] "executive assistant to the communications director"                                                                                                    
[1253] "supervisor of classification"                                                                                                                          
[1254] "executive director"                                                                                                                                    
[1255] "data entry"                                                                                                                                            
[1256] "assistant director of correspondence for mail analysis"                                                                                                
[1257] "director, mail analysis"                                                                                                                               
[1258] "director of digital analytics"                                                                                                                         
[1259] "receptionist"                                                                                                                                          
[1260] "special assistant to the president and senior deputy director of public engagement"                                                                    
[1261] "director of communications and press secretary to the first lady"                                                                                      
[1262] "special assistant to the president for education policy"                                                                                               
[1263] "deputy assistant to the president for education policy"                                                                                                
[1264] "special assistant to the president and director of special projects and research"                                                                      
[1265] "senior associate director and trip manager"                                                                                                            
[1266] "press secretary and deputy communications director for the first lady"                                                                                 
[1267] "principal associate director of scheduling"                                                                                                            
[1268] "deputy director, white house correspondence agency liaison"                                                                                            
[1269] "senior advisor to the president"                                                                                                                       
[1270] "assistant to the president, deputy chief of staff and senior advisor"                                                                                  
[1271] "asst to the president, deputy chief of staff and senior advisor"                                                                                       
[1272] "assistant to the president, deputy chief of staff & senior advisor"                                                                                    
[1273] "special assistant to the deputy director for legislative affairs"                                                                                      
[1274] "director of strategy and performance measurement"                                                                                                      
[1275] "associate director white house comments line and greetings office"                                                                                     
[1276] "special assistant to the president and speechwriter"                                                                                                   
[1277] "deputy director of strategic initiatives"                                                                                                              
[1278] "senior advance coordinator"                                                                                                                            
[1279] "deputy assistant to the president for urban affairs and economic mobility"                                                                             
[1280] "associate regional communications director"                                                                                                            
[1281] "senior director of specialty media"                                                                                                                    
[1282] "assistant director of technology"                                                                                                                      
[1283] "director of systems development for presidential personnel"                                                                                            
[1284] "office manager"                                                                                                                                        
[1285] "deputy director, online programs and email"                                                                                                            
[1286] "director of online engagement"                                                                                                                         
[1287] "special assistant to the president and director of message strategy"                                                                                   
[1288] "senior lead press representative"                                                                                                                      
[1289] "records systems analyst"                                                                                                                               
[1290] "records management information systems specialist"                                                                                                     
[1291] "coordinator, white house intern program"                                                                                                               
[1292] "deputy regional political director"                                                                                                                    
[1293] "director response policy"                                                                                                                              
[1294] "deputy assistant to the president and director of u.s.a. freedom corps"                                                                                
[1295] "deputy assistant to the president and director of strategic initiative"                                                                                
[1296] "assistant to the president and director of social media"                                                                                               
[1297] "director of visitors office"                                                                                                                           
[1298] "special assistant to the president and director of visitors office"                                                                                    
[1299] "special assistant to the president for management and administration and director of the visitors office"                                              
[1300] "assistant to the president and special advisor"                                                                                                        
[1301] "deputy assistant to the president and director of oval office operations"                                                                              
[1302] "data entry/ quality control"                                                                                                                           
[1303] "special assistant to the president and director of political affairs"                                                                                  
[1304] "director preparedness policy"                                                                                                                          
[1305] "communications assistant"                                                                                                                              
[1306] "deputy executive director and director of outreach for the council on women and girls"                                                                 
[1307] "director for consular and international programs"                                                                                                      
[1308] "special assistant to the president and deputy director of digital strategy"                                                                            
[1309] "special assistant to the president, principal deputy press secretary and senior advisor to the press secretary"                                        
[1310] "deputy chief of staff of the national economic council"                                                                                                
[1311] "senior policy advisor and deputy chief of staff of the national economic council"                                                                      
[1312] "director, protection & information sharing policy"                                                                                                     
[1313] "special assistant to the president for homeland security and senior director for cyber-security and information sharing policy"                        
[1314] "associate director for community outreach"                                                                                                             
[1315] "special assistant to the president and senior speechwriter"                                                                                            
[1316] "special assistant to the president and senior speechwriter for the president"                                                                          
[1317] "administrative assistant to the director/photos"                                                                                                       
[1318] "gift analyst/writer"                                                                                                                                   
[1319] "special assistant to the president and deputy director of communications for production"                                                               
[1320] "special assistant to the president and deputy director of communication for production"                                                                
[1321] "dep assistant to the president and deputy director of communications for production"                                                                   
[1322] "deputy assistant to the president & deputy director of communications for production"                                                                  
[1323] "assistant director for constituent engagement for presidential correspondence"                                                                         
[1324] "deputy assistant to the president and deputy director of communications and director of research"                                                      
[1325] "deputy assistant to the president and director, office of social innovation and civic participation"                                                   
[1326] "deputy assistant to the president and director, office  of social innovation and civic participation"                                                  
[1327] "director law enforcement policy"                                                                                                                       
[1328] "night staff supervisor and director of special projects"                                                                                               
[1329] "special assistant to the president for white house mgmt"                                                                                               
[1330] "executive assistant to the deputy chief of staff for operations"                                                                                       
[1331] "assistant to the president, chief of staff to the first lady and counsel"                                                                              
[1332] "labor advisor"                                                                                                                                         
[1333] "special assistant to the president for strategic initiatives and external affairs"                                                                     
[1334] "deputy assistant to the president for international economic affairs and deputy nsa"                                                                   
[1335] "deputy assistant to the president for inational economic affairs and deputy nsa"                                                                       
[1336] "assistant supervisor, classification section"                                                                                                          
[1337] "assistant supervisor, classification unit"                                                                                                             
[1338] "director, office of presidential support"                                                                                                              
[1339] "director, support"                                                                                                                                     
[1340] "deputy press secretary and executive secretary for the domestic policy council"                                                                        
[1341] "deputy executive director for the council on women and girls"                                                                                          
[1342] "assistant to the president and director of the office of public liaison"                                                                               
[1343] "director of the  travel office"                                                                                                                        
[1344] "director and aide to the senior advisor"                                                                                                               
[1345] "assistant to the president and deputy senior advisor for communications and strategy"                                                                  
[1346] "assistant to the president and director of the office of political strategy and outreach"                                                              
[1347] "director of international affairs and senior policy advisor"                                                                                           
[1348] "senior gift analyst"                                                                                                                                   
[1349] "supervisor search and file unit"                                                                                                                       
[1350] "supervisor, search and file unit"                                                                                                                      
[1351] "associate director of digital content"                                                                                                                 
[1352] "associate digital producer"                                                                                                                            
[1353] "special assistant to the president and senior director of cabinet affairs for the my brother\u0092s keeper initiative"                                 
[1354] "special assistant to the president and senior director of cabinet affairs for the my brother's keeper initiative"                                      
[1355] "urban affairs and revitalization policy advisor"                                                                                                       
[1356] "systems administrator"                                                                                                                                 
[1357] "principal deputy director of presidential correspondence"                                                                                              
[1358] "deputy director for digital initiatives"                                                                                                               
[1359] "research director for presidential personnel"                                                                                                          
[1360] "deputy director of scheduling and advance and travel aide for the first lady"                                                                          
[1361] "special assistant to the president and director of scheduling and advance for the first lady"                                                          
[1362] "special assistant to the deputy director of the office of public liaison"                                                                              
[1363] "deputy assistant to the president and white house social secretary"                                                                                    
[1364] "assistant to the president & press secretary"                                                                                                          
[1365] "analytics and reports coordinator/it liaison"                                                                                                          
[1366] "director of digital rapid response"                                                                                                                    
[1367] "special assistant and policy advisor to the director of intergovernmental affairs"                                                                     
[1368] "senior telephone operator/training assistant"                                                                                                          
[1369] "deputy director presidential correspondence"                                                                                                           
[1370] "midwest political director"                                                                                                                            
[1371] "assistant to the president for economic policy and director of the national economic council"                                                          
[1372] "coordinator of student writing and materials"                                                                                                          
[1373] "director, food agriculture and water security policy"                                                                                                  
[1374] "director for white house citizen participation"                                                                                                        
[1375] "deputy associate director for outreach"                                                                                                                
[1376] "special assistant to the director of media affairs"                                                                                                    
[1377] "website coordinator"                                                                                                                                   
[1378] "special assistant to the president and director of whrte house personnel"                                                                              
[1379] "senior correspondent analyst"                                                                                                                          
[1380] "deputy director for technology"                                                                                                                        
[1381] "executive secretary"                                                                                                                                   
[1382] "senior writer for messages"                                                                                                                            
[1383] "special assistant to the president and chief of staff of the office of intergovernmental affairs and public engagement"                                
[1384] "deputy assistant to the president and counselor to the senior  advisor for strategic engagement"                                                       
[1385] "deputy assistant to the president and counselor to the senior advisor for strategic engagement"                                                        
[1386] "assistant press secretary and senior writer"                                                                                                           
[1387] "deputy director of the office of presidential correspondence"                                                                                          
[1388] "associate director for outreach"                                                                                                                       
[1389] "deputy assistant to the president and deputy director of the national economic council"                                                                
[1390] "associate director, new media operations"                                                                                                              
[1391] "corrspondence analyst"                                                                                                                                 
[1392] "deputy assistant to the president for legislative affairs and senate deputy director"                                                                  
[1393] "associate director for technology and operations for presidential personnel"                                                                           
[1394] "assistant supervisor of search and file"                                                                                                               
[1395] "assistant supervisor, search and file unit"                                                                                                            
[1396] "special assistant to the president for healthcare policy"                                                                                              
[1397] "special assistant to the president for public engagement"                                                                                              
[1398] "deputy director, gift unit"                                                                                                                            
[1399] "special assistant to the president for economic mobility"                                                                                              
[1400] "deputy director of nominations"                                                                                                                        
[1401] "associate director continuity policy"                                                                                                                  
[1402] "aide to the assistant to the president for homeland security"                                                                                          
[1403] "dep assistant to the president and director of political affairs"                                                                                      
[1404] "associate director for presidential correspondence"                                                                                                    
[1405] "acting director, operations"                                                                                                                           
[1406] "director, homeland security council public liaison"                                                                                                    
[1407] "deputy director of message events"                                                                                                                     
[1408] "director, student correspondence"                                                                                                                      
[1409] "director of comment line, greetings and visitors"                                                                                                      
[1410] "director of comment line, greetings and volunteers"                                                                                                    
[1411] "special assistant to the president and dep dir of speechwriting"                                                                                       
[1412] "deputy assistant to the president & deputy director of speechwriting"                                                                                  
[1413] "assistant executive clerk for messages and executive actions"                                                                                          
[1414] "senior associate communications director"                                                                                                              
[1415] "senior research associate"                                                                                                                             
[1416] "associate director of presidential personnel"                                                                                                          
[1417] "assistant to the president and director of the office of faith-based and community initiatives"                                                        
[1418] "deputy assistant to the president and director, office of faith-based and community initiatives"                                                       
[1419] "assistant to the president for homeland security and cntrtrsm"                                                                                         
[1420] "assistant to the president for homeland security & counterterrorism"                                                                                   
[1421] "director of regional operations"                                                                                                                       
[1422] "manager of mail and messenger operations"                                                                                                              
[1423] "manager, data entry"                                                                                                                                   
[1424] "staff assistant for projects"                                                                                                                          
[1425] "special assistant to the president and deputy chief of staff of operations for the first lady"                                                         
[1426] "first daughter and advisor to the president"                                                                                                           
[1427] "southern regional communications director"                                                                                                             
[1428] "communications advisor, domestic policy council and office of national aids policy"                                                                    
[1429] "senior writer for policy"                                                                                                                              
[1430] "supervisor of computer administration"                                                                                                                 
[1431] "supervisor of computer administration for records management"                                                                                          
[1432] "assistant supervisor, optical disk unit"                                                                                                               
[1433] "senior financial manager"                                                                                                                              
[1434] "special assistant to the deputy chief of staff for operations"                                                                                         
[1435] "deputy director of policy & projects for the first lady"                                                                                               
[1436] "director, presidential support"                                                                                                                        
[1437] "deputy director for energy and climate change"                                                                                                         
[1438] "special assistant to the president for energy and climate change"                                                                                      
[1439] "deputy assistant to the president for energy and climate change"                                                                                       
[1440] "white house business liaison"                                                                                                                          
[1441] "senior technical advisor to the director of white house information technology"                                                                        
[1442] "personnel assistant"                                                                                                                                   
[1443] "supervisor for classification"                                                                                                                         
[1444] "supervisor for records management classification"                                                                                                      
[1445] "director of surrogate booking"                                                                                                                         
[1446] "special assistant to the president and director of broadcast media"                                                                                    
[1447] "senior press assistant and special assistant to the deputy director of communications"                                                                 
[1448] "immigration advisor"                                                                                                                                   
[1449] "senior director and national security staff spokesman"                                                                                                 
[1450] "special assistant to the president, senior director and national security staff spokesman"                                                             
[1451] "associate director of communications for economics"                                                                                                    
[1452] "special assistant to the president and advisor to the office of the chief of staff"                                                                    
[1453] "senior operations manager"                                                                                                                             
[1454] "deputy press secretary for the first lady"                                                                                                             
[1455] "senior director of cabinet affairs and senior advisor for the domestic policy council"                                                                 
[1456] "executive director and policy advisor, reach higher initiative"                                                                                        
[1457] "director of advance for the.first lady"                                                                                                                
[1458] "special assistant to the president and deputy press secretary and advisor to the press secretary"                                                      
[1459] "presidential aide"                                                                                                                                     
[1460] "special assistant and advisor to the chief of staff"                                                                                                   
[1461] "deputy director for white house correspoindence"                                                                                                       
[1462] "senior advisor for economics division of presidential personnel"                                                                                       
[1463] "director of writers and production"                                                                                                                    
[1464] "deputy director of white house travel office"                                                                                                          
[1465] "deputy director of scheduling for research"                                                                                                            
[1466] "legal and boards staff assistant"                                                                                                                      
[1467] "executive assistant to the executive director"                                                                                                         
[1468] "special assistant to the president and deputy director, speechwriting"                                                                                 
[1469] "deputy assistant to the president & director of strategic initiatives"                                                                                 
[1470] "senior advisor for technology and innovation to the national economic council director"                                                                
[1471] "deputy director of online platform"                                                                                                                    
[1472] "special assistant, visitors office"                                                                                                                    
[1473] "special assistant to the president and executive assistant to the president"                                                                           
[1474] "senior director of african-american media"                                                                                                             
[1475] "associate director of outreach"                                                                                                                        
[1476] "advance representative"                                                                                                                                
[1477] "special assistant for scheduling correspondence"                                                                                                       
[1478] "special assistant to the president and deputy associate director for outreach and personal aide"                                                       
[1479] "director, office of public liaison"                                                                                                                    
[1480] "deputy director of presidential support"                                                                                                               
[1481] "director of personal correspondence"                                                                                                                   
[1482] "policy assistant for urban affairs and mobility and opportunity policy"                                                                                
[1483] "special assistant to the president and deputy director of communications for planning"                                                                 
[1484] "director, office of social innovation and civic participation"                                                                                         
[1485] "director, office of the senior advisor"                                                                                                                
[1486] "special assistant to the president and director of law and policy"                                                                                     
[1487] "technology project manager"                                                                                                                            
[1488] "special assistant to the president for homeland sec and senior director for nuclear defense policy"                                                    
[1489] "director of nuclear defense policy"                                                                                                                    
[1490] "director for investigation and law enforcement"                                                                                                        
[1491] "special assistant to the president and deputy director"                                                                                                
[1492] "deputy director for radio"                                                                                                                             
[1493] "deputy director for broadcast media"                                                                                                                   
[1494] "deputy assistant to the president and deputy director of the domestic policy council and director of budget policy"                                    
[1495] "special assistant to the president and deputy chief of staff  and director of operations for the first lady"                                           
[1496] "special assistant to the president and deputy chief of staff and director of operations for the first lady"                                            
[1497] "deputy assistant to the president and senior advisor to the first lady"                                                                                
[1498] "assistant press secretary and director of television"                                                                                                  
[1499] "special assistant to the chief of staff of the office of intergovernmental affairs and public engagement"                                              
[1500] "deputy executive director & counsel"                                                                                                                   
[1501] "security advisor"                                                                                                                                      
[1502] "deputy director for white house operations and director for finance"                                                                                   
[1503] "deputy director of scheduling for the president"                                                                                                       
[1504] "associate director for the management and administration front office"                                                                                 
[1505] "deputy director for white house operations"                                                                                                            
[1506] "associate deputy director, boards and commissions"                                                                                                     
[1507] "deputy director of white house management"                                                                                                             
[1508] "special assistant to the president and deputy director of  usa freedom corps"                                                                          
[1509] "senior policy advisor for health and the office of national aids policy"                                                                               
[1510] "supervisor, classification unit"                                                                                                                       
[1511] "senior public engagement advisor"                                                                                                                      
[1512] "special assistant and policy advisor to the chief of staff of the office of public engagement and intergovernmental affairs"                           
[1513] "department of education liaison"                                                                                                                       
[1514] "special assistant to the president for justice and homeland security policy"                                                                           
[1515] "deputy director for energy policy"                                                                                                                     
[1516] "special assistant to the president & white house social secretary"                                                                                     
[1517] "director, financial management and planning"                                                                                                           
```


Basic stringr
========================================================
class: small-code
- ```str_``` functions take vectors of text strings, return new vectors
- ```str_detect()``` simply returns a logical vector
    - Elements are true when the pattern was found, false when not

```r
unique(salaries$position) %>%
  str_detect("advisor")
```

```
   [1]  TRUE  TRUE FALSE  TRUE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE
  [12] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
  [23] FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE
  [34] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
  [45] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
  [56] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
  [67] FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE
  [78] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
  [89] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [100] FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [111] FALSE FALSE FALSE FALSE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE
 [122] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [133] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [144] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [155]  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [166]  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [177] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [188] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [199] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE
 [210] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [221] FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [232] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
 [243] FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [254] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [265] FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE
 [276] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE
 [287] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [298] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
 [309] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [320] FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE
 [331] FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [342] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE
 [353] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [364] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
 [375] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [386] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [397] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [408] FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE
 [419] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [430] FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [441] FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE FALSE FALSE FALSE FALSE
 [452] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE
 [463] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [474] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
 [485] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [496] FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE
 [507] FALSE  TRUE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE
 [518] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE
 [529]  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE
 [540] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [551] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE
 [562]  TRUE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE  TRUE FALSE FALSE
 [573] FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE
 [584]  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE  TRUE
 [595] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [606] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [617] FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [628] FALSE  TRUE  TRUE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE
 [639] FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE FALSE FALSE FALSE FALSE
 [650] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [661] FALSE  TRUE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE  TRUE
 [672] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE
 [683] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [694]  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE
 [705]  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [716] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [727] FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE
 [738] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [749] FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE
 [760]  TRUE FALSE FALSE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE
 [771] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [782] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [793]  TRUE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [804] FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE
 [815] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE
 [826] FALSE FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE FALSE FALSE FALSE
 [837]  TRUE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [848] FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE
 [859] FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE
 [870] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [881] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [892] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [903] FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [914] FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE
 [925] FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [936] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
 [947] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [958] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [969] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [980] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 [991] FALSE FALSE FALSE  TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE
[1002] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE
[1013] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
[1024] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
[1035] FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE
[1046] FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE
[1057] FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE FALSE FALSE  TRUE FALSE
[1068] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
[1079] FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE
[1090] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE
[1101] FALSE FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE FALSE FALSE FALSE
[1112] FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE
[1123]    NA FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
[1134] FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE
[1145] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
[1156] FALSE  TRUE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE
[1167] FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE  TRUE FALSE
[1178] FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE
[1189] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
[1200] FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE
[1211] FALSE  TRUE FALSE FALSE  TRUE  TRUE  TRUE FALSE  TRUE FALSE  TRUE
[1222] FALSE FALSE  TRUE  TRUE FALSE FALSE  TRUE FALSE  TRUE FALSE FALSE
[1233]  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
[1244]  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
[1255] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
[1266] FALSE FALSE FALSE  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE
[1277] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
[1288] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
[1299] FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
[1310] FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
[1321] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
[1332]  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
[1343] FALSE  TRUE  TRUE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE
[1354] FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
[1365] FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
[1376] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE FALSE
[1387] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
[1398] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
[1409] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
[1420] FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE  TRUE FALSE FALSE
[1431] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
[1442] FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE  TRUE
[1453] FALSE FALSE  TRUE  TRUE FALSE  TRUE FALSE  TRUE FALSE  TRUE FALSE
[1464] FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE
[1475] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
[1486] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
[1497]  TRUE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE
[1508] FALSE  TRUE FALSE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE
```

Basic stringr
========================================================
class: small-code
- ```str_detect()``` is useful for subsetting data

```r
advisors <- salaries %>%
  filter(str_detect(position, "advisor")) %>%
  .$position %>% unique()
advisors
```

```
  [1] "ethics advisor"                                                                                                                                        
  [2] "policy advisor"                                                                                                                                        
  [3] "advisor to the chief of staff"                                                                                                                         
  [4] "deputy assistant to the president for intergovernmental affairs and public engagement and senior advisor to the national economic council"             
  [5] "senior confirmations advisor"                                                                                                                          
  [6] "senior policy advisor"                                                                                                                                 
  [7] "senior legislative affairs advisor"                                                                                                                    
  [8] "senior advisor for the national economic council"                                                                                                      
  [9] "chief of staff and senior advisor to the director of the office of legislative affairs"                                                                
 [10] "special advisor to the assistant to the president/deputy national security advisor"                                                                    
 [11] "assistant to the president and senior advisor"                                                                                                         
 [12] "special assistant and advisor for the press secretary"                                                                                                 
 [13] "deputy director of research and rapid response advisor"                                                                                                
 [14] "special assistant to the president and assistant to the senior advisor"                                                                                
 [15] "special assistant to the president and policy advisor to the office of the chief of staff"                                                             
 [16] "assistant to the president and deputy national security advisor"                                                                                       
 [17] "senior public engagement advisor for labor and working families"                                                                                       
 [18] "executive assistant to the senior advisor"                                                                                                             
 [19] "special assistant to the senior advisor"                                                                                                               
 [20] "director of special projects and special assistant to the senior advisor"                                                                              
 [21] "assistant to the president and deputy national security advisor for counterterrorism and homeland security"                                            
 [22] "clearance advisor"                                                                                                                                     
 [23] "special assistant to the senior advisor and deputy chief of staff"                                                                                     
 [24] "senior policy advisor for economic policy and director of techhire"                                                                                    
 [25] "deputy assistant to the president and senior advisor to the chief of staff"                                                                            
 [26] "special assistant to the president and advisor to the chief of staff"                                                                                  
 [27] "communications advisor"                                                                                                                                
 [28] "advisor to the counselor to the president"                                                                                                             
 [29] "director of the office of national aids policy and senior advisor on disability policy"                                                                
 [30] "advisor to the president"                                                                                                                              
 [31] "assistant to the president and deputy senior advisor"                                                                                                  
 [32] "policy advisor for health care"                                                                                                                        
 [33] "policy advisor to the council on women and girls"                                                                                                      
 [34] "special assistant and policy advisor for the office of urban affairs, justice, and opportunity"                                                        
 [35] "special assistant to the president and advisor for planning"                                                                                           
 [36] "assistant to the president and national security advisor"                                                                                              
 [37] "director of the white house business council and policy advisor"                                                                                       
 [38] "senior communications advisor"                                                                                                                         
 [39] "special assistant to the senior advisor and the deputy chief of staff"                                                                                 
 [40] "deputy assistant to the president for international economic affairs and deputy national security advisor"                                             
 [41] "deputy assistant to the president and deputy counsel to the president for national security affairs and legal advisor to the national security council"
 [42] "special assistant to the president and senior associate counsel to the president and deputy legal advisor to the national security council"            
 [43] "executive director of let's move! and senior policy advisor for nutrition policy"                                                                      
 [44] "associate director of public engagement and senior policy advisor"                                                                                     
 [45] "deputy assistant to the president and deputy homeland security advisor"                                                                                
 [46] "director of white house personnel and advisor for management and administration"                                                                       
 [47] "special assistant to the president and senior advisor to the chief of staff"                                                                           
 [48] "public engagement advisor"                                                                                                                             
 [49] "senior advisor for strategic communications for the national economic council"                                                                         
 [50] "special assistant to the president, deputy press secretary and senior advisor to the press secretary"                                                  
 [51] "assistant to the president and deputy national security advisor for international economics"                                                           
 [52] "special assistant and policy advisor for education"                                                                                                    
 [53] "senior advisor and chief of staff of the national economic council"                                                                                    
 [54] "assistant to the president for speechwriting and policy advisor"                                                                                       
 [55] "senior policy advisor for native american affairs"                                                                                                     
 [56] "education advisor"                                                                                                                                     
 [57] "deputy chief of staff for presidential personnel and policy advisor to the council on women and girls"                                                 
 [58] "vetting advisor for presidential personnel"                                                                                                            
 [59] "special assistant and policy advisor to the director of the domestic policy council"                                                                   
 [60] "policy advisor to the office of the chief of staff"                                                                                                    
 [61] "special assistant to the president and advisor for strategy and speechwriting"                                                                         
 [62] "communications director and senior policy advisor for the domestic policy council"                                                                     
 [63] "deputy assistant to the president and deputy to the senior advisor"                                                                                    
 [64] "deputy assistant to the president and assistant to the senior advisor"                                                                                 
 [65] "member relations advisor"                                                                                                                              
 [66] "senior advisor for congressional engagement and legislative relations"                                                                                 
 [67] "policy advisor to the senior advisor"                                                                                                                  
 [68] "special assistant and advisor to the senior advisor"                                                                                                   
 [69] "executive assistant to the deputy chief of staff and senior advisor"                                                                                   
 [70] "special assistant to the president, senior advisor to the council on women and girls, and senior presidential speechwriter"                            
 [71] "special assistant to the president, senior strategic and policy advisor to the council on women and girls, and senior presidential speechwriter"       
 [72] "dep asstistant to the president and deputy to the senior advisor"                                                                                      
 [73] "deputy assistant to the president & deputy to the senior advisor"                                                                                      
 [74] "special assistant to the president and advisor for development and speechwriting"                                                                      
 [75] "senior advisor and assistant to the president for intergovernmental affairs and public engagement"                                                     
 [76] "deputy senior advisor and director of external relations for the first lady"                                                                           
 [77] "executive assistant to the deputy chief of staff & senior advisor"                                                                                     
 [78] "senior advisor  for social innovation and civic participation"                                                                                         
 [79] "national security advisor"                                                                                                                             
 [80] "senior policy advisor for economic policy"                                                                                                             
 [81] "special assistant to the president, chief of staff, and advisor to the director of presidential personnel"                                             
 [82] "special assistant to the counselor to the senior advisor for strategic engagement"                                                                     
 [83] "advisor to the council on women and girls"                                                                                                             
 [84] "legislative counsel and policy advisor"                                                                                                                
 [85] "senior policy advisor for economic development"                                                                                                        
 [86] "policy advisor to the deputy chief of staff for implementation"                                                                                        
 [87] "special assistant to the deputy senior advisor for communications and strategy"                                                                        
 [88] "special assistant and policy advisor for the white house office of faith-based and neighborhood partnerships"                                          
 [89] "chief of staff and advisor to the white house counsel office"                                                                                          
 [90] "advisor"                                                                                                                                               
 [91] "senior policy advisor for education"                                                                                                                   
 [92] "education, women and families, and workforce policy advisor"                                                                                           
 [93] "assistant director of projects and policy advisor"                                                                                                     
 [94] "senior advisor, tax and fiscal policy"                                                                                                                 
 [95] "assistant to the president and senior advisor for policy"                                                                                              
 [96] "assistant to the president for homeland security and counterterrorism and deputy national security advisor"                                            
 [97] "senior policy advisor for social innovation and civic participation"                                                                                   
 [98] "advisor to the press secretary"                                                                                                                        
 [99] "special assistant to the president and senior advisor for the national economic council"                                                               
[100] "special assistant to the president and advisor for the office of political strategy and outreach"                                                      
[101] "senior policy advisor for labor and workforce"                                                                                                         
[102] "senior advisor for health, domestic policy council"                                                                                                    
[103] "advisor for technology"                                                                                                                                
[104] "senior advisor for housing, national economic council"                                                                                                 
[105] "special assistant to the president and senior advisor to the deputy chief of staff"                                                                    
[106] "director of white house operations and advisor for management and administration"                                                                      
[107] "assistant to the president and deputy national security advisor for strategy"                                                                          
[108] "senior advisor to the director and deputy chief of staff of the national economic council"                                                             
[109] "assistant to president for international economic affairs and deputy national security advisor for international economic affairs"                     
[110] "special assistant and advisor to the director of legislative affairs"                                                                                  
[111] "attorney advisor"                                                                                                                                      
[112] "deputy assistant to the president and advisor to the chief of staff"                                                                                   
[113] "strategic communications advisor"                                                                                                                      
[114] "strategic communications advisor and special projects manager"                                                                                         
[115] "deputy assistant to the president and communications advisor"                                                                                          
[116] "deputy director and senior advisor for records management"                                                                                             
[117] "special assistant and advisor to the press secretary"                                                                                                  
[118] "deputy assistant to the president, deputy national security advisor for strategic communications and speechwriting"                                    
[119] "assistant to the president and deputy national security advisor for strategic communications and speechwriting"                                        
[120] "senior advisor to the president"                                                                                                                       
[121] "assistant to the president, deputy chief of staff and senior advisor"                                                                                  
[122] "asst to the president, deputy chief of staff and senior advisor"                                                                                       
[123] "assistant to the president, deputy chief of staff & senior advisor"                                                                                    
[124] "assistant to the president and special advisor"                                                                                                        
[125] "special assistant to the president, principal deputy press secretary and senior advisor to the press secretary"                                        
[126] "senior policy advisor and deputy chief of staff of the national economic council"                                                                      
[127] "labor advisor"                                                                                                                                         
[128] "director and aide to the senior advisor"                                                                                                               
[129] "assistant to the president and deputy senior advisor for communications and strategy"                                                                  
[130] "director of international affairs and senior policy advisor"                                                                                           
[131] "urban affairs and revitalization policy advisor"                                                                                                       
[132] "special assistant and policy advisor to the director of intergovernmental affairs"                                                                     
[133] "deputy assistant to the president and counselor to the senior  advisor for strategic engagement"                                                       
[134] "deputy assistant to the president and counselor to the senior advisor for strategic engagement"                                                        
[135] "first daughter and advisor to the president"                                                                                                           
[136] "communications advisor, domestic policy council and office of national aids policy"                                                                    
[137] "senior technical advisor to the director of white house information technology"                                                                        
[138] "immigration advisor"                                                                                                                                   
[139] "special assistant to the president and advisor to the office of the chief of staff"                                                                    
[140] "senior director of cabinet affairs and senior advisor for the domestic policy council"                                                                 
[141] "executive director and policy advisor, reach higher initiative"                                                                                        
[142] "special assistant to the president and deputy press secretary and advisor to the press secretary"                                                      
[143] "special assistant and advisor to the chief of staff"                                                                                                   
[144] "senior advisor for economics division of presidential personnel"                                                                                       
[145] "senior advisor for technology and innovation to the national economic council director"                                                                
[146] "director, office of the senior advisor"                                                                                                                
[147] "deputy assistant to the president and senior advisor to the first lady"                                                                                
[148] "security advisor"                                                                                                                                      
[149] "senior policy advisor for health and the office of national aids policy"                                                                               
[150] "senior public engagement advisor"                                                                                                                      
[151] "special assistant and policy advisor to the chief of staff of the office of public engagement and intergovernmental affairs"                           
```

Basic stringr
========================================================
class: small-code
- ```str_replace()``` is critical for text cleaning
- Looks for given pattern, and replaces with new string

```r
advisors[1:3] %>% str_replace("advisor", "party")
```

```
[1] "ethics party"                "policy party"               
[3] "party to the chief of staff"
```
- If that new string is empty, text is simply deleted

```r
advisors[1:3] %>% str_replace("advisor", "")
```

```
[1] "ethics "                "policy "               
[3] " to the chief of staff"
```

Basic stringr
========================================================
class: small-code
- ```str_replace_all()``` replaces all intances of pattern if it appears more than once in a string

```r
advisors[1:3] %>% str_replace(" ", "-")
```

```
[1] "ethics-advisor"                "policy-advisor"               
[3] "advisor-to the chief of staff"
```

```r
advisors[1:3] %>% str_replace_all(" ", "-")
```

```
[1] "ethics-advisor"                "policy-advisor"               
[3] "advisor-to-the-chief-of-staff"
```

Joins and Merges
========================================================
- Having multiple objects means you can merge them!
    - ```dplyr``` has a number of "two-table" verbs for this
- ```inner_join()``` only returns rows where IDs match
- ```left_join()``` returns all rows, empty cells where IDs don't match
    - ```right_join()``` is same, but with different column order
- ```merge()``` from base package is most commonly used
    - Use ```by.x``` and ```by.y``` arguments if ID columns have different names

The broom package
========================================================
- Finally, I want to mention the ```broom``` package
- Transforms output of many ```stats``` functions into a "tidy" format
    - We'll focus on linear regression models
- Two main functions: ```tidy()``` and ```augment()```
    - ```tidy()``` describes the model coefficients
    - ```augment()``` collects observation-level attributes
    
The broom package
========================================================
class: small-code
- Run a linear regression model

```r
out <- salaries %>%
  mutate(year_sub = year - 2000) %>%
  lm(salary ~ as.factor(gender) + year_sub + tenure, data = .)
out
```

```

Call:
lm(formula = salary ~ as.factor(gender) + year_sub + tenure, 
    data = .)

Coefficients:
          (Intercept)  as.factor(gender)male               year_sub  
                49715                  11608                   1674  
               tenure  
                 2095  
```

The broom package
========================================================
class: small-code

```r
summary(out)
```

```

Call:
lm(formula = salary ~ as.factor(gender) + year_sub + tenure, 
    data = .)

Residuals:
   Min     1Q Median     3Q    Max 
-92303 -29533 -13326  25046 139815 

Coefficients:
                      Estimate Std. Error t value Pr(>|t|)    
(Intercept)            49714.9     1167.2  42.593   <2e-16 ***
as.factor(gender)male  11607.6      909.1  12.769   <2e-16 ***
year_sub                1674.4      101.2  16.543   <2e-16 ***
tenure                  2095.0      223.8   9.362   <2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 38300 on 7104 degrees of freedom
Multiple R-squared:  0.08186,	Adjusted R-squared:  0.08147 
F-statistic: 211.1 on 3 and 7104 DF,  p-value: < 2.2e-16
```

The broom package
========================================================
class: small-code

```r
str(out)
```

```
List of 13
 $ coefficients : Named num [1:4] 49715 11608 1674 2095
  ..- attr(*, "names")= chr [1:4] "(Intercept)" "as.factor(gender)male" "year_sub" "tenure"
 $ residuals    : Named num [1:7108] 2016 17426 -29903 -33672 77951 ...
  ..- attr(*, "names")= chr [1:7108] "1" "2" "3" "4" ...
 $ effects      : Named num [1:7108] -6442223 -501135 -741259 358594 79036 ...
  ..- attr(*, "names")= chr [1:7108] "(Intercept)" "as.factor(gender)male" "year_sub" "tenure" ...
 $ rank         : int 4
 $ fitted.values: Named num [1:7108] 53484 88534 71903 75672 78601 ...
  ..- attr(*, "names")= chr [1:7108] "1" "2" "3" "4" ...
 $ assign       : int [1:4] 0 1 2 3
 $ qr           :List of 5
  ..$ qr   : num [1:7108, 1:4] -84.309 0.0119 0.0119 0.0119 0.0119 ...
  .. ..- attr(*, "dimnames")=List of 2
  .. .. ..$ : chr [1:7108] "1" "2" "3" "4" ...
  .. .. ..$ : chr [1:4] "(Intercept)" "as.factor(gender)male" "year_sub" "tenure"
  .. ..- attr(*, "assign")= int [1:4] 0 1 2 3
  .. ..- attr(*, "contrasts")=List of 1
  .. .. ..$ as.factor(gender): chr "contr.treatment"
  ..$ qraux: num [1:4] 1.01 1.01 1.01 1
  ..$ pivot: int [1:4] 1 2 3 4
  ..$ tol  : num 1e-07
  ..$ rank : int 4
  ..- attr(*, "class")= chr "qr"
 $ df.residual  : int 7104
 $ contrasts    :List of 1
  ..$ as.factor(gender): chr "contr.treatment"
 $ xlevels      :List of 1
  ..$ as.factor(gender): chr [1:2] "female" "male"
 $ call         : language lm(formula = salary ~ as.factor(gender) + year_sub + tenure, data = .)
 $ terms        :Classes 'terms', 'formula'  language salary ~ as.factor(gender) + year_sub + tenure
  .. ..- attr(*, "variables")= language list(salary, as.factor(gender), year_sub, tenure)
  .. ..- attr(*, "factors")= int [1:4, 1:3] 0 1 0 0 0 0 1 0 0 0 ...
  .. .. ..- attr(*, "dimnames")=List of 2
  .. .. .. ..$ : chr [1:4] "salary" "as.factor(gender)" "year_sub" "tenure"
  .. .. .. ..$ : chr [1:3] "as.factor(gender)" "year_sub" "tenure"
  .. ..- attr(*, "term.labels")= chr [1:3] "as.factor(gender)" "year_sub" "tenure"
  .. ..- attr(*, "order")= int [1:3] 1 1 1
  .. ..- attr(*, "intercept")= int 1
  .. ..- attr(*, "response")= int 1
  .. ..- attr(*, ".Environment")=<environment: 0x7fabe737cb78> 
  .. ..- attr(*, "predvars")= language list(salary, as.factor(gender), year_sub, tenure)
  .. ..- attr(*, "dataClasses")= Named chr [1:4] "numeric" "factor" "numeric" "numeric"
  .. .. ..- attr(*, "names")= chr [1:4] "salary" "as.factor(gender)" "year_sub" "tenure"
 $ model        :'data.frame':	7108 obs. of  4 variables:
  ..$ salary           : num [1:7108] 55500 105960 42000 42000 156552 ...
  ..$ as.factor(gender): Factor w/ 2 levels "female","male": 1 2 1 1 1 2 2 2 2 2 ...
  ..$ year_sub         : num [1:7108] 1 15 12 13 16 3 4 5 15 9 ...
  ..$ tenure           : num [1:7108] 1 1 1 2 1 1 2 3 1 1 ...
  ..- attr(*, "terms")=Classes 'terms', 'formula'  language salary ~ as.factor(gender) + year_sub + tenure
  .. .. ..- attr(*, "variables")= language list(salary, as.factor(gender), year_sub, tenure)
  .. .. ..- attr(*, "factors")= int [1:4, 1:3] 0 1 0 0 0 0 1 0 0 0 ...
  .. .. .. ..- attr(*, "dimnames")=List of 2
  .. .. .. .. ..$ : chr [1:4] "salary" "as.factor(gender)" "year_sub" "tenure"
  .. .. .. .. ..$ : chr [1:3] "as.factor(gender)" "year_sub" "tenure"
  .. .. ..- attr(*, "term.labels")= chr [1:3] "as.factor(gender)" "year_sub" "tenure"
  .. .. ..- attr(*, "order")= int [1:3] 1 1 1
  .. .. ..- attr(*, "intercept")= int 1
  .. .. ..- attr(*, "response")= int 1
  .. .. ..- attr(*, ".Environment")=<environment: 0x7fabe737cb78> 
  .. .. ..- attr(*, "predvars")= language list(salary, as.factor(gender), year_sub, tenure)
  .. .. ..- attr(*, "dataClasses")= Named chr [1:4] "numeric" "factor" "numeric" "numeric"
  .. .. .. ..- attr(*, "names")= chr [1:4] "salary" "as.factor(gender)" "year_sub" "tenure"
 - attr(*, "class")= chr "lm"
```

The broom package
========================================================
class: small-code
Make it a tidy table!

```r
install.packages("broom", repos = 0)
library(broom)

tidy(out)
```

```
                   term  estimate std.error statistic      p.value
1           (Intercept) 49714.946 1167.2097 42.592987 0.000000e+00
2 as.factor(gender)male 11607.595  909.0790 12.768523 6.245711e-37
3              year_sub  1674.428  101.2190 16.542617 2.408943e-60
4                tenure  2094.954  223.7674  9.362196 1.027398e-20
```

The broom package
========================================================
class: small-code
Look at predictions and residuals

```r
augment(out) %>% head()
```

```
  salary as.factor.gender. year_sub tenure  .fitted   .se.fit     .resid
1  55500            female        1      1 53484.33 1054.4007   2015.672
2 105960              male       15      1 88533.91  927.9655  17426.085
3  42000            female       12      1 71903.04  782.6497 -29903.036
4  42000            female       13      2 75672.42  752.8070 -33672.417
5 156552            female       16      1 78600.75 1022.6063  77951.253
6  45000              male        3      1 68440.78  923.7084 -23440.779
          .hat   .sigma      .cooksd .std.resid
1 0.0007578095 38305.06 5.254688e-07  0.0526452
2 0.0005869651 38304.51 3.040960e-05  0.4550946
3 0.0004175260 38303.42 6.367449e-05 -0.7808728
4 0.0003862923 38302.98 7.469455e-05 -0.8792908
5 0.0007127965 38293.89 7.391283e-04  2.0358805
6 0.0005815921 38304.06 5.452009e-05 -0.6121709
```

Bonus: Modeling in R
========================================================
- Details of linear models

- Running OLS:

```r
lm(formula = , data = , subset = , weights = , na.action = , ...)
```

Modeling: GLMs
========================================================
- Using generalized linear models
- Different from STATA, only one function for all GLM
    - Specify the link function as "family =" argument
    - List of http://www.statmethods.net/advstats/glm.html
    

```r
glm(formula = , family = , data = , subset = , weights = , na.action = , ...)
```


Modeling: Ordered Logistic
========================================================
- Not included as a built-in function
    - Install and library the ```MASS``` package
    - "Proportional odds logistic regrssion"
    - Use an ordered factor! (see intro slides)
- More info (plus multinomial logit models) here:
    - https://www.princeton.edu/~otorres/LogitR101.pdf
    

```r
polr(formula = , data = , subset = , weights = , na.action = , 
     Hess = , model = , ...)
```


Questions?
========================================================
