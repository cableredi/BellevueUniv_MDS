# Assignment: ASSIGNMENT 4
# Name: Cable, Kimberly
# Date: 2022-04-23

## Load the ggplot2 package
library(ggplot2)
theme_set(theme_minimal())

## Set the working directory to the root of your DSC 520 directory
setwd("/Kim/Data Science/Bellevue Univ/BU_DSC/DSC520/Week6")

## Load the `data/r4ds/heights.csv` to
heights_df <- read.csv("data/r4ds/heights.csv")
head(heights_df)

# https://ggplot2.tidyverse.org/reference/geom_boxplot.html
## Create boxplots of sex vs. earn and race vs. earn using `geom_point()` and `geom_boxplot()`
## sex vs. earn
ggplot(heights_df, aes(x = sex, y = earn)) + geom_point()+ geom_boxplot() +
  labs(x = "Gender", y = "Earnings")
## race vs. earn
ggplot(heights_df, aes(x = race, y = earn)) + geom_point() + geom_boxplot() +
  labs(x = "Race", y = "Earnings")

# https://ggplot2.tidyverse.org/reference/geom_bar.html
## Using `geom_bar()` plot a bar chart of the number of records for each `sex`
ggplot(heights_df, aes(sex)) + geom_bar() + labs(x = "Gender", y = "Count")

## Using `geom_bar()` plot a bar chart of the number of records for each race
ggplot(heights_df, aes(race)) + geom_bar() + labs(x = "Race", y = "Count")

## Create a horizontal bar chart by adding `coord_flip()` to the previous plot
ggplot(heights_df, aes(race)) + geom_bar() + coord_flip() + 
  labs(x = "Race", y = "Count")

# https://www.rdocumentation.org/packages/ggplot2/versions/3.3.0/topics/geom_path
## Load the file `"data/nytimes/covid-19-data/us-states.csv"` and
## assign it to the `covid_df` dataframe
covid_df <- read.csv("data/nytimes/covid-19-data/us-states.csv")
head(covid_df)

## Parse the date column using `as.Date()`
class(covid_df$date)
covid_df$date <- as.Date(covid_df$date)
head(covid_df)
class(covid_df$date)

## Create three dataframes named `california_df`, `ny_df`, and `florida_df`
## containing the data from California, New York, and Florida
california_df <- covid_df[ which( covid_df$state == "California"), ]
head(california_df)

ny_df <- covid_df[ which( covid_df$state == "New York"), ]
head(ny_df)

florida_df <- covid_df[ which( covid_df$state == "Florida"), ]
head(florida_df)

## Plot the number of cases in Florida using `geom_line()`
ggplot(data = florida_df, aes(x = date, y = cases, group = 1)) + geom_line(size = 2) +
  labs(x = "Date", y = "Cases")

## Add lines for New York and California to the plot
ggplot(data = florida_df, aes(x = date, group = 1)) +
  geom_line(aes(y = cases), size = 2) +
  geom_line(data = ny_df, aes(y = cases), size = 2) +
  geom_line(data = california_df, aes(y = cases), size = 2)

## Use the colors "darkred", "darkgreen", and "steelblue" for Florida, New York, and California
ggplot(data = florida_df, aes(x = date, group=1)) +
  geom_line(aes(y = cases), color = "darkred", size = 2) +
  geom_line(data = ny_df, aes(y = cases), color = "darkgreen", size = 2) +
  geom_line(data = california_df, aes(y = cases), color = "steelblue", size = 2)

## Add a legend to the plot using `scale_colour_manual`
## Add a blank (" ") label to the x-axis and the label "Cases" to the y axis
ggplot(data = florida_df, aes(x = date, group=1)) +
  geom_line(aes(y = cases, colour = "Florida"), size = 2) +
  geom_line(data = ny_df, aes(y = cases, colour="New York"), size = 2) +
  geom_line(data = california_df, aes(y = cases, colour="California"), size = 2) +
  scale_colour_manual("State",
                      breaks = c("Florida", "New York", "California"),
                      values = c("Florida" = "darkred", 
                                 "New York" = "darkgreen", 
                                 "California" = "steelblue")) +
  xlab(" ") + ylab("Cases")

## Scale the y axis using `scale_y_log10()`
ggplot(data = florida_df, aes(x = date, group = 1)) +
  geom_line(aes(y = cases, colour = "Florida"), size = 2) +
  geom_line(data = ny_df, aes(y = cases, colour = "New York"), size = 2) +
  geom_line(data = california_df, aes(y = cases, colour = "California"), size = 2) +
  scale_colour_manual("State",
                      breaks = c("Florida", "New York", "California"),
                      values = c("Florida" = "darkred", 
                                 "New York" = "darkgreen", 
                                 "California" = "steelblue")) +
  xlab(" ") + ylab("Cases") + scale_y_log10()
