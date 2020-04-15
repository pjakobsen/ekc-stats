# Simple Join  with Help From Excel
# Eurostat Data goes back to 1990
library(stringr)
wind=read.csv("data/nrg_inf_epcrw_1_Data.csv")

# Drop all data without values aka ":"
wind = wind %>% select(-SIEC,-PLANT_TEC,-UNIT)  
#wind$GEO[wind$GEO=="Germany (until 1990 former territory of the FRG)"] = "Germany"

wind = wind %>% str_replace(GEO, "^Germany (until", "Germany") 

wind = wind %>% filter(!str_detect(GEO, "^Euro")) 
               
head(wind,300)
# Drop some useless columns
# Drop all data without values aka ":"
wind=wind %>% 
  filter(!is.na(Value))  %>%
  filter(!is.na(GEO)) %>%
  filter(Value!=":")

wind=arrange(wind,GEO)


wind=wind %>% filter(GEO %in% country_names) 

head(wind,600)
# 1990="Belgium","Denmark","Greece","Italy","Netherlands","Portugal","Spain","Sweden","United Kingdom"
# 1991="Finland","France"
# 1992="Ireland"
# 1993="Norway","Austria"



write.csv(wind, file="data_output/more_simple_wind_europe.csv",
          row.names=FALSE)