# Housing Data

library(readxl)
library(dplyr)
library(magrittr)
library(Hmisc)
library(lm.beta)
library(car)

options(scipen=999)


### Data for this assignment is focused on real estate transactions recorded from 1964 to 2016 and can be found in Housing.xlsx. Using your skills in statistical correlation, multiple regression, and R programming, you are interested in the following variables: Sale Price and several other possible predictors.

### If you worked with the Housing dataset in previous week – you are in luck, you likely have already found any issues in the dataset and made the necessary transformations. If not, you will want to take some time looking at the data with all your new skills and identifying if you have any clean up that needs to happen.

## Load the `data/week-6-housing.csv` to
housing_df = read_excel("data/week-6-housing.xlsx")
housing_df %>% head(4)


### i Explain any transformations or modifications you made to the dataset
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

colnames(housing_df)[2] <- "Sale_Price"
colnames(housing_df)[1] <- "Sale_Date"

housing_df %>% head(4)
nrow(housing_df)


### ii: Create two variables; one that will contain the variables Sale Price and Square Foot of Lot 
### (same variables used from previous assignment on simple regression) and one that will contain 
### Sale Price and several additional predictors of your choice. Explain the basis for your additional 
### predictor selections.

# For my additional predictors, I chose total_bath_count, square_feet_total_living, 
# and bedrooms because they traditionally are used to calculate the price of a house

housing_df_model1 <- lm(Sale_Price ~ sq_ft_lot, data = housing_df)


housing_df_model2 <- lm(Sale_Price ~ total_bath_count + square_feet_total_living + 
                            bedrooms, data = housing_df)


### iii: Execute a summary() function on two variables defined in the previous step to compare the model 
### results. What are the R2 and Adjusted R2 statistics? Explain what these results tell you about the 
### overall model. Did the inclusion of the additional predictors help explain any large variations found 
### in Sale Price?

summary(housing_df_model1)

# The linear regression model for Sales Price and Square Feet per Lot is an 
# R^2 = 0.01435 tells us Sq feet per lot only accounts for 1.4% of the variation
# in the Sales Price.


summary(housing_df_model2)

# The linear regression model for Sales Price, total_bath_count, square_feet_total_living, 
# and bedrooms is an R^2 = .2096 tells us that adding other variables accounts for 1.2% of
# the price of a house.

# The adjusted R^2 with 1 variable is 0.01428 and with 3 variables it is 0.295 which 
# indicates that adding the additional variables does help but not a lot.


### iv: Considering the parameters of the multiple regression model you have created. What are the standardized 
### betas for each parameter and what do the values indicate?

beta_model1 <- lm.beta(housing_df_model1)
beta_model1


# Standard Deviation of Sale_Price:
    
sd(housing_df$Sale_Price)

# Standard Deviation of sq_ft_lot:
    
sd(housing_df$sq_ft_lot)
 


beta_model2 <- lm.beta(housing_df_model2)
beta_model2

#Standard Deviation of total_bath_count:
    
sd(housing_df$total_bath_count)

# As the number of bath increase by 1 standard deviation (0.70), Sales Price 
# increase by 0.49 standard deviations.  So for every 0.7 bathrooms, Sales Price 
# goes up by ($404,381 * 0.049) $19,815.

#Standard Deviation of square_feet_total_living:

sd(housing_df$square_feet_total_living)

# As the number of sq ft of living space increase by 1 standard deviation (990 sq ft), 
# Sales Price increases by 0.453 standard deviations. So for every 990 sq ft added, 
# Sales Price goes up by ($404,381 * 0.453) $183,185.

#Standard Deviation of bedrooms:

sd(housing_df$bedrooms)

# As the number of bedrooms increases by 1 standard deviation (.88), 
# Sales Price decrease by -0.060 standard deviations. So for every .88 bedrooms added, 
# Sales Price goes down by ($404,381 * -0.06) $24,263.


### v: Calculate the confidence intervals for the parameters in your model and explain what the results indicate.

model2.confInt <- confint(housing_df_model2)
model2.confInt

# None of the confidence intervals cross 0 but their intervals are not very small 
# so they are less representative in calculating the sales price but are significant

### vi: Assess the improvement of the new model compared to your original model (simple regression model)
### by testing whether this change is significant by performing an analysis of variance.

anova(housing_df_model1, housing_df_model2)

### vii: Perform casewise diagnostics to identify outliers and/or influential cases, 
### storing each function's output in a dataframe assigned to a unique variable name.

housing_df$residuals <- resid(housing_df_model2)
housing_df$standarized.residuals <- rstandard(housing_df_model2)
housing_df$studentized.residuals <- rstudent(housing_df_model2)
housing_df$cooks.distance <- cooks.distance(housing_df_model2)
housing_df$dfbeta <- dfbeta(housing_df_model2)
housing_df$dffit <- dffits(housing_df_model2)
housing_df$leverage <- hatvalues(housing_df_model2)
housing_df$covariance.ratios <- covratio(housing_df_model2)


### viii: Calculate the standardized residuals using the appropriate command, specifying those 
### that are +-2, storing the results of large residuals in a variable you create.

housing_df$large.residuals <- housing_df$standarized.residuals > 2 | housing_df$standarized.residuals < -2

### ix: Use the appropriate function to show the sum of large residuals.

sum(housing_df$large.residuals)

### x: Which specific variables have large residuals (only cases that evaluate as TRUE)?

housing_df[housing_df$large.residuals, c('Sale_Price', 'total_bath_count', 
                                         'square_feet_total_living', 'bedrooms', 'standarized.residuals')]

### xi: Investigate further by calculating the leverage, cooks distance, and covariance rations. 
### Comment on all cases that are problematics.

housing_df[housing_df$large.residuals, c('cooks.distance', 'leverage', 'covariance.ratios')]

### xii: Perform the necessary calculations to assess the assumption of independence and state if 
### the condition is met or not.

durbinWatsonTest(housing_df_model2)

# The durbin watson statistic is 1.957 which is very close to 2 so it has been met


### xiii: Perform the necessary calculations to assess the assumption of no multicollinearity and 
### state if the condition is met or not.

vif(housing_df_model2)

1 / vif(housing_df_model2)

mean(vif(housing_df_model2))

# The VIF for each variable is below 10, and average VIF for each variable is greater than 1,
# and the tolerance for all three are above 0.2, and the average VIF is close to 1 so we can 
# conclude that there is no collinearity within the data.


### xiv: Visually check the assumptions related to the residuals using the plot() and hist() functions. 
### Summarize what each graph is informing you of and if any anomalies are present.

hist(housing_df$studentized.residuals)


plot(housing_df_model2)


# The plots show that is it not normal and skewed

### xv: Overall, is this regression model unbiased? If an unbiased regression model, what does this 
### tell us about the sample vs. the entire population model?



