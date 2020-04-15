# Country and Country Codes


country_codes =c("AUT","BEL", "DNK","DEU","GRC","FIN",
                 "FRA","IRL", "ITA","NLD","NOR","PRT",
                 "ESP","SWE","GBR")
country_names = c("Austria","Belgium","Denmark","Germany","Greece","Finland",
                  "France", "Ireland", "Italy", "Netherlands","Norway",
                  "Portugal","Spain", "Sweden","United Kingdom")

#fra, fin, uk,ned,swe,bel,deu,
nukes=c(0,1,0,1,0,1,1,0,0,1,0,0,0,1,1)
df=data.frame(ISOAlpha3=country_codes,CountryName=country_names,Nuclear=nukes)


write.csv(df, file="data/regions.csv",
          row.names=FALSE)
#regions =  data.frame(ISO=country_codes, Names=country_names)

df