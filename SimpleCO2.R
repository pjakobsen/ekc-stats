#SimpleCO2

library(dplyr)

co2=read.csv("data/co-emissions-per-capita-vs-gdp-per-capita-international-.csv")
colnames(co2)

co2 <- co2 %>% rename(CO2TonnesPC = names(.)[4] ,
                      GDPPC2011 = names(.)[5],
                      Population=names(.)[6])
colnames(co2)

co2_wrangled = co2 %>%
  filter(Code %in% country_codes) %>%
  filter(Year %in% (1993:2017) ) %>%
  filter(!is.na(CO2TonnesPC)) %>%
  filter(!is.na(GDPPC2011))

head(co2_wrangled,600)  


write.csv(co2_wrangled, file="data/co2GdpPop.csv",
          row.names=FALSE)