# Assignment: EXERCISE 4.2 #2
# Name: Cable, Kimberly
# Data: 2022-4-09

# Load readxl package
library(readxl)
library(ggplot2)
library(plyr)
theme_set(theme_minimal())

## Set the working directory to the root of your DSC 520 directory
setwd("/Kim/Data Science/Bellevue Univ/DSC 520/Week4")

## Check your current working directory
getwd()

## Load the housing file
housing_df = read_excel("data/week-6-housing.xlsx")

# a - Use apply on a variable
# get the average Sale_Price and put it in a vector
salesPrice_mean <- sapply(housing_df['Sale_Price'], mean)
salesPrice_mean

# b - use aggregate on a variable
# get the average Sale Price per zoning
zoningPrice_agg <- aggregate(Sale_Price ~ current_zoning, housing_df, mean)
zoningPrice_agg

# c - use plyr (split some data, perform a modification, bring back together)
# get the average Sale Price per month per year
salesPrice_byMonth_mean <- ddply(housing_df, .(format(Sale_Date, "%m-%Y")), 
                                 summarize, monthly_mean = mean(Sale_Price))
salesPrice_byMonth_mean

# d - check distributions of the data
salesPrice_hist <- ggplot(housing_df) + geom_histogram(aes(Sale_Price)) +
    scale_x_continuous(labels = scales::comma) +
    labs(x = "Sales Price", y = "Count")
salesPrice_hist

sqFeet_hist <- ggplot(housing_df) + geom_histogram(aes(square_feet_total_living)) +
    labs(x = "Total Square Feet Living Space", y = "Count")
sqFeet_hist


# e - identify any outliers
#      Sales Price: there are a few prices above $2,000,000 that outside the norm
#      Total Sq Feet Living Space: there are a couple above 5,500 sq ft

# f - create at least 2 new variables
housing_df['cost_per_sq_foot'] <- ifelse(housing_df$square_feet_total_living >= 0, 
    housing_df$Sale_Price / housing_df$square_feet_total_living, 0)
housing_df['cost_per_sq_foot']

num_baths <- function(bath_full, bath_half, bath_3qtr)
{
    ifelse (bath_full > 0, total <- bath_full * 1, NA)
    
    ifelse (bath_half > 0, total <- total + (bath_half * 0.5), NA)
    
    ifelse (bath_3qtr > 0, total <- total + (bath_3qtr * 0.75), NA)
    
    return (total)
}

housing_df['total_bath_count'] <- num_baths(
    bath_full = housing_df$bath_full_count, 
    bath_half = housing_df$bath_half_count, 
    bath_3qtr = housing_df$bath_3qtr_count)
housing_df['total_bath_count']
