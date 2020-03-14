# 1. Obtain data for years from 1997-2017 
# (since wind energy is a major predictor variable
# of the variable CO2 per capita)
data<-read.csv("data_output/co2wind_europe_subset.csv")
head(data)

library(dplyr)
#library("tidyr") 

co2_mean = data %>% 
  group_by(Year) %>%
  summarise (co2_mean=mean(CO2TonnesPC)) %>%
  .$co2_mean 

gdp_mean = data %>% 
  group_by(Year) %>%
  summarise (gdp_mean=mean(GDPPC2011)) %>%
  .$gdp_mean 

wind_mean = data %>% 
  mutate(wind_gw_pc = WindCapacityGigawatts / Population) %>%
  mutate(wind_kw_pc = wind_gw_pc  * 1000000) %>%
  group_by(Year) %>%
  summarise (wind_kw_mean=mean(wind_kw_pc)) %>%
  .$wind_kw_mean 

plot(data$GDPPC2011, data$CO2TonnesPC, main="Scatterplot of CO2 per capita vs. GDP per capita",
     xlab="GDP per capita", ylab="CO2 per capita", pch=19, cex=0.25)  

plot(gdp_mean, co2_mean, main="Scatterplot of CO2 per capita vs. GDP per capita",
       xlab="GDP per capita", ylab="CO2 per capita", pch=19, cex=0.25)

plot(gdp_mean, wind_mean, main="Scatterplot of Wind KW per capita vs. GDP per capita",
     xlab="GDP per capita", ylab="Wind Gigawatts", pch=19, cex=0.25)

#Fit a polynomial model
# lm(CO2pc~ gdppc+gdppc^2+wind+awareness)
co2pc<- co2
gdp2<- gdp^2 
gdp3<- gdp^3


#-------------------------------------------------------------------
#Basic Quadratric Model 
model1 <- lm(co2pc~ gdp+gdp2+gdp3)
summary(model1)
anova(model1) 

#Fitted regression equation
#co2pc = 1.120 + 5.685e-4*gdppc - 1.0627e-8*gdppc2 + 4.583e-14*gdppc3

#RMSE (root of MSE)
rmse<-sqrt(0.3685) #square root of the MSE from the Anova table
rmse
# 0.607042

#fitted values
cubic.fitted<- model1$fitted.values
#-------------------------------------------------------------------
# lm(CO2pc~ gdppc+gdppc^2+wind+awareness)

#-------------------------------------------------------------------
#Quadratic model
model2<- lm(co2pc~ gdp+gdp2)
model2
anova(model2)

#Fitted regression equation
#co2pc = 3.033 + 3.941e-4*gdppc - 5.608e-9*gdppc2

#RMSE (root of MSE)
rmse1<-sqrt(0.3493) #square root of the MSE from the Anova table
rmse1
# 0.5910161

#fitted values
quadratic.fitted<- model2$fitted.values
#-------------------------------------------------------------------


#-------------------------------------------------------------------
#Overlay plot of fitted values with original data
plot(gdp, co2, main="Scatterplot of CO2 per capita vs. GDP per capita",
     xlab="GDP per capita", ylab="CO2 per capita", pch=19, cex=0.25)
points(gdp, cubic.fitted, pch=20, cex=0.5, col="blue3")

plot(gdp, co2, main="Scatterplot of CO2 per capita vs. GDP per capita",
     xlab="GDP per capita", ylab="CO2 per capita", pch=19, cex=0.25)
points(gdp, quadratic.fitted, pch=20, cex=0.5, col="deeppink")

# Both the plots of the quadratic and the cubic models show similar trends and they seem
# to capture the essence of the data well.
#-------------------------------------------------------------------


#-------------------------------------------------------------------
# Hypothesis test of significance of the quadratic term in the linear model

# Ho: parameter of the quadratic model is equal to '0' (LINEAR MODEL IS A GOOD FIT)
# Ha: parameter of the quadratic model is NOT equal to '0' (QUADRATIC MODEL IS A GOOD FIT)

# significance level (alpha) equals 0.05

# Test statistics under H0
# F = 23.3136
# p-value = 1.442e-05

# Rejection region
# Reject H0 if p-value < alpha= 0.05
# Since the p-value of the quadratic term is equal to 0.00001442 < 0.05,
# we reject H0 (null hypothesis) and conclude that the coefficient of the quadratic term
# is SIGNIFICANT in the linear regression model.

# Conclusion
# At a significance level of alpha equal to 0.05, we reject H0 and conclude that
# the quadratic model is SIGNIFICANT. This implies that the linear model is inadequate in the
# data relating CO2 per capita and GDP per capita.
#-------------------------------------------------------------------


#-------------------------------------------------------------------
# Comparison between the quadratic and the cubic models
# We make use of the values of RMSE obtained from each of the cubic and quadratic models
# to ascertain which model provides a better performance

# Cubic model
# RMSE = 0.7774

# Quadratic model
# RMSE = 0.7701

# The value of RMSE provides an estimate of the standard deviation of the estimated regression
# equation. The smaller the value of RMSE the better fit is the model for the data.
# Since the RMSE for the quadratic model is lower than the RMSE for the cubic model, we 
# would choose the quadratic model as a better fit of the data.
#-------------------------------------------------------------------


#-------------------------------------------------------------------

# 2. Include a proxy for the variable 'renewable energy awareness' (this would provide
# the best possible control variable to include for capturing the effects on GDP)

# Use all the data to estimate the linear relationship among the independent variables and the
# response variable 'CO2 per capita'

# lm(CO2pc~ gdppc+gdppc^2+wind+awareness)

# The regression model for CO2 per capita is given as:
# CO2pc = b0 + b1*gdppc + b2*gdppc^2 + b3*wind + b4*awareness

#-------------------------------------------------------------------










