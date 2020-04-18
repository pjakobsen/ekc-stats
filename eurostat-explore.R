# From Article Retrieval and Analysis of Eurostat Open Data with the eurostat package
# Lahti, Huovari, Kainu, Biecek
install.packages("eurostat")
install.packages("knitr")
library("eurostat")


# Get Eurostat data listing
toc <- get_eurostat_toc()

# Check the first items
library(knitr)
kable(head(toc))
