# Assignment: EXERCISE 4.2 #1
# Name: Cable, Kimberly
# Data: 2022-4-09

# Load ggplot2 package
library(ggplot2)
theme_set(theme_minimal())

## Set the working directory to the root of your DSC 520 directory
setwd("/Kim/Data Science/Bellevue Univ/DSC 520/Week 4/Exercise_4_2/")

## Check your current working directory
getwd()

## Load the scores file
scores_df <- read.csv("data/scores.csv", header=TRUE, stringsAsFactors = TRUE)

# 1 - What are the observational units in this study
scores_df
#       The Course the professor is teaching would be the observational unit as 
#       that is what we are studying

# 2 - Identify the variables mentioned and determine which are categorical and 
#     quantitative
sapply(scores_df, class)
#         Count and Score are quantitative
#         Section is categorical

# 3 - Create one variable to hold a subset of your data set that contains only
#     the Regular Section and one variable for the Sports Section
sportsSec_df <- subset(scores_df, scores_df$Section == "Sports")
sportsSec_df

regularSec_df <- subset(scores_df, scores_df$Section == "Regular")
regularSec_df

# 4 - Plot each sections scores and the number of students achieving that score
plot(sportsSec_df$Score, sportsSec_df$Count,
     main = "Sports Section Scores",
     type = "p",
     ylab = "Number of Students",
     xlab = "Score")

plot(regularSec_df$Score, regularSec_df$Count,
     main = "Regular Section Scores",
     type = "p",
     ylab = "Number of Students",
     xlab = "Score")

# Scatter plot of both sections
scatter <- ggplot(scores_df, aes(Score, Count))
scatter + geom_point() +
    geom_smooth(method = 'lm', aes(fill = Section), alpha = 0.1) +
                    labs(x = "Score", y = "Number of Students", color = "Section")
    
#  a - Can you say that one section tended to score more points than the other?
#       Looking at both graphs, the Regular Section scores seem to be higher 
#       and a higher count rate than the Sports Section. The curve looks to be 
#       negatively skewed meaning higher counts and scores for the Regular Section


#  b - Did every student in one section score more points than every student
#      in the other section?
#         If you calculated the means of the scores it shows that the Regular 
#         Section did better but without having all of the individual scores 
#         its hard to say if every student did better.

#  c - What could one additional variable that was not mentioned in the 
#      narrative that could be influencing the point distributions between
#      the two sections?
#         I think if the student is sports minded or not.  If the student doesnt
#         know sports and took the sports section it would influence how well
#         they do