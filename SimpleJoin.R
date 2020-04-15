# Simple Join  with Help From Excel

wind2=read.csv("data_output/more_simple_wind_europe.csv")
co22=read.csv("data/co2GdpPop.csv")
nukes2=read.csv("data/regions.csv")

co22=co22 %>%filter(Year %in% (1993:2017)) 
# Change column headings for wind for merge
wind2= wind2 %>% rename(Year = "TIME" ,
                      Entity="GEO",
                      Megawatts="Value")
head(wind2,600)
head(co22,600)
head(nukes2)

joint =  merge(co22, wind2, by=c("Year","Entity"), all=TRUE)
head(joint,600)