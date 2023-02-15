# Assignment: EXERCISE 5.2
# Name: Cable, Kimberly
# Data: 2022-4-16

#imports
library(readxl)
library(dplyr)
library(magrittr)
library(purrr)
library(stringr)
library(tidyr)

## Set the working directory to the root of your DSC 520 directory
setwd("/Kim/Data Science/Bellevue Univ/BU_DSC/DSC520/Week5")

## Check your current working directory
getwd()

## Load the housing file
housing6_df = read_excel("data/week-6-housing.xlsx")
housing6_df %>% head(4)

# a. Using the dplyr package, use the 6 different operation to analyze/transform
#    the data

#    GroupBy
#       group Sales price by zip code
salesPrice_by_zip <- housing6_df %>% 
    group_by(zip5) %>% 
    summarize(mean(Sale_Price))
salesPrice_by_zip


#    Summarize
#       get the mean Sales price and the median Sales price
mean_median_salePrice <- housing6_df %>% 
    summarize(AveragePrice = mean(Sale_Price),
            MedianPrice = median(Sale_Price))
mean_median_salePrice


#    Mutate
#       get the price per sq feet
price_per_sq_ft <- housing6_df %>% 
    select(Sale_Price, square_feet_total_living) %>% 
    mutate(Price_per_Sq_Ft = Sale_Price / square_feet_total_living)
price_per_sq_ft

#    get the percentage difference between house price and average house price
#       per zip code
price_percentage_diff <- housing6_df %>% 
    select(Sale_Price, zip5) %>% 
    group_by(zip5) %>% 
    mutate(zipMean = mean(Sale_Price), percentage_diff = ( 
        (Sale_Price - zipMean) / zipMean) * 100)
price_percentage_diff


#    Filter
#       get all house greater than or equal to $1 million 
one_million_club <- housing6_df %>% 
    filter(Sale_Price >= 1000000)
one_million_club


#    Select
#       select all sales price and zip code columns
sales_zip <- housing6_df %>% 
    select(Sale_Price, zip5)
sales_zip

#       select everything that starts with an S
s_stuff <- housing6_df %>% 
    select(starts_with('S'))
s_stuff

#    Arrange
#       get the average sales price by zip code and sort by the average
average_price_per_zip <- housing6_df %>% 
    group_by(zip5) %>% 
    summarize(AvgPrice = mean(Sale_Price)) %>% 
    arrange(AvgPrice)
average_price_per_zip


# b. using the purrr package - perform 2 functions on your dataset

#    map_dbl
#       select the Sales Price and get the mean
housing6_df %>% select(Sale_Price) %>% map_dbl(mean)

#       get the mean of all columns
housing6_df %>% map_dbl(mean)

#    map_chr
#       get the class of each element of the Sales Price
housing_SalesPrice_classes <- housing6_df$Sale_Price %>% map_chr(class)
head(housing_SalesPrice_classes)


#    keep
housing6_df %>% select(square_feet_total_living) %>%  
    keep(function(x) mean(x) > 2500)


# c. Use the cbind and rbind function on your dataset

#    cbind
#       Combine Sales Price and Square Feet into one array
pricePerSqft <- cbind(SalePrice = housing6_df$Sale_Price, 
                      SquareFeet = housing6_df$square_feet_total_living)
head(pricePerSqft)

#    rbind
#       Add a new row to the Price Per Sq Ft created in the previous step
newData <- c(100000, 5321)
newData

pricePerSqft_new = rbind(pricePerSqft, newData)
tail(pricePerSqft_new)


# d. Split a string, then concatenate the results back together

#       Split Sale Date into Month Day Year
housing_df_new <- housing6_df %>%
    separate(Sale_Date, sep="-", into = c("Year", "Month", "Day"))

head(housing_df_new)


# Concatenate date to format from mm/dd/yy to mm-dd-yyyy
housing_df_new['NewDate'] <- str_c(housing_df_new$Month, '-', housing_df_new$Day, 
                                   '-', housing_df_new$Year)

select_newDate <- housing_df_new %>% 
    select(Month, Day, Year, NewDate)
select_newDate
