install.packages('sf')
install.packages("eurostat")
library("eurostat")

query <- search_eurostat("road accidents", type= "table")

query$code[[1]]

query$title[[1]]


dat <- get_eurostat(id = "tsdtr420", time_format = "num")

countries <- c("UK", "SK", "FR", "PL", "ES", "PT")
t1 <- get_eurostat("tsdtr420", filters = list(geo = countries))