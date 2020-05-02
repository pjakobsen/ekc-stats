wbopendata, indicator(EN.ATM.CO2E.PC;NY.GDP.PCAP.KD) year(1960:2013) clear long
drop if regionname == "Aggregates"



drop if missing(ny_gdp_pcap_kd) 
drop if missing(en_atm_co2e_pc) 

gen y = log(ny_gdp_pcap_kd)
gen e = log(en_atm_co2e_pc*1000)
gen y2 = y^2

summarize e y y2

egen id = group(countrycode)


bysort id: drop if _N<20 // Dump crappy frequencies

replace e = e*100 // make me more like the others 

summarize y y2 e

sort id year
xtset id year
 
xtsum e y y2

* Hausman

xtreg e y y2, fe
estimates store fixed
xtreg e y y2, re
estimates store random
hausman fixed random
hausman fixed random, sigmamore

* Arrgggh!


xtreg e y y2 y3, fe
drop ehat
predict ehat
xtline ehat if  inlist(countryname, "Spain")
xtline ehat if  inlist(countryname, "Denmark","Finland","Norway","Sweden")

tabulate incomelevel
areg e y y2 y3 if inlist(incomelevel, "UMC"), absorb(id)
areg e y y2 y3 if inlist(incomelevel, "LMC"), absorb(id)
estimates store lmc
areg e y y2 y3 if inlist(incomelevel, "UMC"), absorb(id)
estimates store umc
areg e y y2 y3 if inlist(incomelevel, "HIC"), absorb(id)
estimates store hic
areg e y y2 y3 if inlist(incomelevel, "LIC"), absorb(id)
estimates store lic
tabulate incomelevel
estimates table hic umc lmc lic
