# Data wrangling Gapminder data in R using dplyr and tidyr
# https://jules32.github.io/2016-07-12-Oxford/dplyr_tidyr/
# and also https://benbestphd.com/dplyr-tidyr-tutorial/

# Jesse Piburn on wbstats
# https://jesse.netlify.com/2018/01/08/getting-started-with-wbstats-a-world-bank-r-package/

# do this once only to install the package on your computer.
# install.packages("dplyr") 
# install.packages('gapminder')
# install.packages("devtools")  #only needed if you want to install latest version of wbstats from github
# devtools::install_github("GIST-ORNL/wbstats")
# install.packages("wbstats")

library(wbstats)
library(dplyr)

str(wb_cachelist, max.level = 1)

# Search for relevant indicators
emissions_vars <- wbsearch("Emissions")

countries = c("DNK","SWE","FIN")

# Population growth (annual %)
co2_data_wide = wb(country = countries, 
                   indicator = c("EN.ATM.CO2E.PP.GD.KD","EN.ATM.NOXE.PC"), 
                   startdate = 1990, enddate = 2018,return_wide = TRUE)



## dplyr::summarize() or summarise() adds new column when grouping
co2_data  %>%
  #filter(country == "Denmark") %>%
  select(-indicatorID, -indicator, -iso3c) %>%
  #mutate(gdp = pop * gdpPercap) %>%
  group_by(country) %>%
  summarize(mean_co2 = mean(value)) %>%
  ungroup() # if you use group_by, also use ungroup() to save heartache later

# search for indicators
co2_vars = wbsearch(pattern = 'co2')

# CO2 emissions (kg per 2011 PPP $ of GDP)

pop_gdp_long <- wb(country = c("US", "NO"), indicator = c("SP.POP.GROW", "NY.GDP.MKTP.CD"),
                   startdate = 1971, enddate = 1971)

head(pop_gdp_long)


pop_gdp_wide <- wb(country = c("US", "NO"), indicator = c("SP.POP.GROW", "NY.GDP.MKTP.CD"),
                   startdate = 1971, enddate = 1971, return_wide = TRUE)

head(pop_gdp_wide)

pop_gdp_wide <- wb(country = c("US", "NO"), indicator = c("SP.POP.GROW", "NY.GDP.MKTP.CD"),
                   startdate = 1971, enddate = 1971, return_wide = TRUE)

head(pop_gdp_wide)
