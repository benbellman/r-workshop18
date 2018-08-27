### READ ME

# Use this file to copy code from slides and reproduce results
# Add comments that won't be run by computer with '#'
# Same as '*' in Stata
# Try creating a new .R notes file for each section of slides

# If a library(pkg) command fails, run install.packages("pkg")

library(here)

# this package will use the workshop directory for all relative paths
# how does the package know where the "project" starts?
dr_here()

# I created this this system file with the command:
# set_here("/filepath/r-workshop18")

# here() interfaces with this project relative path,
# so you can access data/code with same code across computers
here("data","white-house-salaries.csv")

# use setwd() as a quick fix to change directories

# Now, let the coding begin!
###########################



