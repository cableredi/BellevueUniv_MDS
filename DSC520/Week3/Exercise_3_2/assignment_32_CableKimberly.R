# Assignment: ASSIGNMENT 2
# Name: Cable, Kimberly
# Data: 2022-4-02

# Load ggplot2 package
library(ggplot2)
theme_set(theme_minimal())

## Set the working directory to the root of your DSC 520 directory
setwd("/Kim/Data Science/Bellevue Univ/BU_DSC/DSC520/")


# i. What are the elements including categories and data types
community_df <- read.csv(
    "data/acs-14-1yr-s0201.csv", 
    header = TRUE, 
    stringsAsFactors = FALSE
)


# ii. Output from the following functions: str(), nrow(), ncol()
str(community_df)
nrow(community_df)
ncol(community_df)


#iii. Create a Histogram of the HSDegree variable
#     Include bin size, Title, X/Y axis labels
ggplot(community_df, aes(HSDegree)) + 
    ggtitle("HS Degrees per County") +
    xlab("Number of HS Degrees") + ylab("% of HS Degrees") +
    geom_histogram(bins = 10)


# iv Answer the following questions
#   1. Based on  what you see in the histogram, is the data distributed unimodal?
#      Yes, as it only has one peak
#   2. Is it approximately symmetrical?
#      No as it has a long tail on the left side
#   3. Is it approximately bell-shaped?
#      No because it is skewed
#   4. Is it approximately normal?
#      No because it is skewed
#   5. If not normal, is the distribution skewed? If so, in what direction?
#      Yes, it is negatively skewed
#   6. Include a normal curve to the Histogram that you plotted
ggplot(community_df, aes(HSDegree)) + 
    labs(title = "HS Degrees per County", 
        x = "Number of HS Degrees", y = "% of HS Degrees") +
    geom_histogram(bins = 10, aes(y = ..density..), color = "black", fill = "white") +
    stat_function(fun = dnorm, 
                  args = list(mean = mean(community_df$HSDegree, na.rm = TRUE), 
                              sd = sd(community_df$HSDegree, na.rm = TRUE)),
                              color = 'red', size = 1)

#   7. Explain whether a normal distribution can accurately be used as a model 
#      for this data
#        As the distribution is negative, the normal distribution model would
#        not reflect the data properly. There are more data with HS Degrees
#        than not so the model would be biased.

# v. Create a Probability Plot of the HSDegree variable
ggplot(mapping = aes(sample = community_df$HSDegree)) + 
      stat_qq() + stat_qq_line(color = 2)

      
# vi. Answer the following based on the probability plot
#   1. Is the distribution approximately normal?
#      No, because the values are not in a straight line meaning the data is
#      not normal
#   2. If not normal, is the distribution skewed? If so, in what direction? 
#      Explain how you know.
#        Yes, it is negatively skewed as it is a curve with more values at 
#        the higher end of a straight line

# vi. use the stat.desc() function, include a screen capture of the results produced
library(pastecs)
round(stat.desc(community_df$HSDegree, basic = FALSE, norm = TRUE), digits = 3)


# vii. Explanation of the results produced for skew, kurtosis, and z-scores.
#      and explain how a change in the sample size may change your explanation.
#   skew: it is negative so the distribution is negatively skewed
#   kurtosis: it is positive so the distribution is pointy and heavily tailed
#   z-scores: Skew: significant skew as absolute number > 1
#             Kurtosis: significant kurtosis as abs number > 1
#   A change in sample size affects the z-scores. The smaller sample sizes you
#   can use the z-scores in the desc() function but for larger sample sizes
#   you it is best to look at the shape of the distribution visually and consider
#   the actual values of the skew and kurtosis not their normalized values