#importing data from master data folder on laptop
#install.packages("dplyr")
# Make use of https://jules32.github.io/2016-07-12-Oxford/dplyr_tidyr/
library(dplyr)

co2=read.csv("data/co-emissions-per-capita-vs-gdp-per-capita-international-.csv")
colnames(co2)

co2 <- co2 %>% rename(CO2TonnesPC = names(.)[4] ,
                      GDPPC2011 = names(.)[5],
                      Population=names(.)[6])
colnames(co2)

co2_wrangled = co2 %>%
  filter(Code %in% country_codes) %>%
  filter(Year %in% (1991:2019) ) %>%
  filter(!is.na(CO2TonnesPC)) %>%
  filter(!is.na(GDPPC2011))

head(co2_wrangled)  

wind=read.csv("data/Europe-installed-wind-capacity-Gigawatts.csv")
wind <- wind %>% rename(WindCapacityGigawatts = names(.)[4])
colnames(wind)
head(wind)
str(wind)

country_codes =c("DNK","SWE","NOR","FIN","DEU","GBR","ESP","POL","NLD","FRA")
country_names =c("Denmark","Sweden","Norway","Finland","Germany","United Kingdom","Spain","Poland","Nederlands","France")

# Eurostat Data goes back to 1990
wind1990=read.csv("data/nrg_inf_epcrw_1_Data.csv")
wind1990=wind1990 %>% select(-SIEC,-PLANT_TEC) 

head(wind1990,100)

wind1990$GEO[wind1990$GEO=="Germany (until 1990 former territory of the FRG)"] = "Germany"

wind1990_wrangled = wind1990 %>%
  select(-SIEC,-PLANT_TEC) %>%
  filter(GEO %in% country_names)  %>%
  %>%
  filter(Value!=":")  %>%
  mutate(GEO = recode(GEO, 
                    "Denmark"="DNK",
                    "Sweden"="SWE",
                    "Norway"="NOR",
                    "Finland"="FIN",
                    "Germany"="DEU",
                    "United Kingdom"="GBR",
                    "Spain"="ESP",
                    "Poland"="POL",
                    "Nederlands"="NLD",
                    "France"="FRA"))


wind1990_wrangled <- wind1990_wrangled %>% 
      rename(Year = TIME , Code = GEO , Unit = UNIT,Megawatts=Value) %>% 
     
  
wind1990_wrangled <- wind1990_wrangled %>% arrange(Year, desc(Entity)) 

  
wind_wrangled = wind %>%
  filter(Code %in% country_codes) %>%
  filter(Year %in% (1997:2016) )

head(co2_wrangled,30)
head(wind1990_wrangled,30)
# Attempt Merge
mydata <- merge(co2_wrangled, wind1990_wrangled, by=c("Year","Code"), all=TRUE)

write.csv(mydata, file="data_output/co2wind_europe_subset.csv",
          row.names=FALSE)

# Europe-installed-wind-capacity-Gigawatts.csv
# fossil_fuel=read.csv("/Users/peder/Datasets/owid-datasets-master/datasets/Fossil fuel consumption per capita - BP & UN (2017 revision)/Fossil fuel consumption per capita - BP & UN (2017 revision).csv",header=TRUE,sep=",")
# head(fossil_fuel)
# 
# installed_wind=read.csv("data/cumulative-installed-wind-energy-capacity-gigawatts.csv",header=TRUE,sep=",")
# head(installed_wind)