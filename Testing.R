
install.packages("lmtest")
library(lmtest)

## generate a regressor
x <- rep(c(-1,1), 50)
## generate heteroskedastic and homoskedastic disturbances
err1 <- rnorm(100, sd=rep(c(1,2), 50))
err2 <- rnorm(100)
## generate a linear relationship
y1 <- 1 + x + err1
y2 <- 1 + x + err2

plot(y1,y2)
## perform Breusch-Pagan test
bptest(y1 ~ x)
bptest(y2 ~ x)