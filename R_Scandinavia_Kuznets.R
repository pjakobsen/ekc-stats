#importing data
data<-read.csv("~/Desktop/Chendur/df99.csv")
head(data)

#subsetting data
country<- data[, "Country"]
data.denmark<- subset(data, country==("Denmark"))
data.finland<- subset(data, country==("Finland"))
data.norway<- subset(data, country==("Norway"))
data.sweden<- subset(data, country==("Sweden"))
data.scandinavia<- rbind(data.denmark, data.finland, data.norway, data.sweden)

#Aggregating across the four countries
scan.CO2PC.mean<- tapply(data.scandinavia$CO2PC, data.scandinavia$Year.1, mean)
scan.GDPPC.mean<- tapply(data.scandinavia$GDPPC, data.scandinavia$Year.1, mean)

scan.GDPPC.mean

plot(scan.GDPPC.mean, scan.CO2PC.mean, main="Scatterplot of CO2 per capita vs. GDP per capita",
     xlab="GDP per capita", ylab="CO2 per capita", pch=19, cex=0.25)

#Fit a polynomial model
co2pc<- scan.CO2PC.mean
gdppc<- scan.GDPPC.mean
gdppc2<- scan.GDPPC.mean^2 
gdppc3<- scan.GDPPC.mean^3


#-------------------------------------------------------------------
#Cubic model
reg0<- lm(co2pc~ gdppc+gdppc2+gdppc3)
summary(reg0)
anova(reg0)

#Fitted regression equation
#co2pc = 1.120 + 5.685e-4*gdppc - 1.0627e-8*gdppc2 + 4.583e-14*gdppc3

#RMSE (root of MSE)
rmse0<-sqrt(0.6044) #square root of the MSE from the Anova table
rmse0
# 0.7774

#fitted values
cubic.fitted<- reg0$fitted.values
#-------------------------------------------------------------------


#-------------------------------------------------------------------
#Quadratic model
result = lm(co2pc~ gdppc+gdppc2)
summary(result)
# Residual Sum of Squares
SSR = deviance(result)
LL = logLik(result)
DegreesOfFreedom=result$df
# The vector of fitted values
Yhat <- result$fitted.values
Coef <- result$coefficients
Resid <- result$residuals
s <- output$sigma
RSquared <- output$r.squared
# The variance-coVariance matrix of the co-efficients
CovMatrix <- s^2*outp
aic <- AIC(result)




#Fitted regression equation
#co2pc = 3.033 + 3.941e-4*gdppc - 5.608e-9*gdppc2

#RMSE (root of MSE)
rmse1<-sqrt(0.5931) #square root of the MSE from the Anova table
rmse1
# 0.7701

#fitted values
quadratic.fitted<- reg0$fitted.values
#-------------------------------------------------------------------


#-------------------------------------------------------------------
#Overlay plot of fitted values with original data
plot(scan.GDPPC.mean, scan.CO2PC.mean, main="Scatterplot of CO2 per capita vs. GDP per capita",
     xlab="GDP per capita", ylab="CO2 per capita", pch=19, cex=0.25)
points(scan.GDPPC.mean, cubic.fitted, pch=20, cex=0.5, col="blue3")

plot(scan.GDPPC.mean, scan.CO2PC.mean, main="Scatterplot of CO2 per capita vs. GDP per capita",
     xlab="GDP per capita", ylab="CO2 per capita", pch=19, cex=0.25)
points(scan.GDPPC.mean, quadratic.fitted, pch=20, cex=0.5, col="deeppink")

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


