# Assignment: Term Project
# Name: Cable, Kimberly
# Date: 2022-06-03

## Load the ggplot2 package
library(ggplot2)
library(dplyr)
library(magrittr)
theme_set(theme_minimal())

## Check Working Directory
getwd()

## Load data
intelligence_df <- read.csv("Final_Project/data/dog_intelligence.csv")
head(intelligence_df)

breed_df <- read.csv("Final_Project/data/AKC Breed Info.csv")
head(breed_df)

heterozygosity_4_df <- read.csv("Final_Project/data/Table_4_Heterozygosity_85_breeds.csv")
head(heterozygosity_4_df)

heterozygosity_5_df <- read.csv("Final_Project/data/Table_5_Expected_Heterozygosity_60_breeds.csv")
head(heterozygosity_5_df)


# Create New Dataframe from the Intelligence data
combined_df <- intelligence_df
head(combined_df)

# Join Breed data to new combined df
combined_df <- combined_df %>% 
    inner_join(breed_df, by = c("Breed" = "Breed"))
head(combined_df)

# Join Heterozygosity 4 to new combined df
combined_df <- combined_df %>% 
    inner_join(heterozygosity_4_df, by = c("Breed" = "Population"))
head(combined_df)

# Join Heterozygosity 5 to new combined df
combined_df <- combined_df %>% 
    inner_join(heterozygosity_5_df, by = c("Breed" = "Breed"))
head(combined_df)
