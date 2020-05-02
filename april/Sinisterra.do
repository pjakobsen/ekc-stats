wbopendata, indicator(EN.ATM.CO2E.PC;NY.GDP.PCAP.KD;EG.USE.PCAP.KG.OE;EG.USE.COMM.FO.ZS;EG.FEC.RNEW.ZS;) year(1960:2013) clear long
drop if regionname == "Aggregates"

describe

drop if missing(ny_gdp_pcap_kd) 
drop if missing(en_atm_co2e_pc) 
drop if missing(eg_use_pcap_kg_oe)

gen y = log(ny_gdp_pcap_kd)
gen g = log(en_atm_co2e_pc*1000)
gen e = log(eg_use_pcap_kg_oe)
gen y2 = y^2
gen y3 = y^3

summarize g y y2 y3 e

egen id = group(countrycode)


bysort id: drop if _N<20 // Dump crappy frequencies

replace g = g*100 // make me more like the others 


sort id year
xtset id year
 
xtsum g y y2 y3 e

* check for collinearity between g and e
collin g e

* Hausman - don't need it

xtreg g y y2 y3 e, fe
estimates store fixed
xtreg g y y2 y3 e, re
estimates store random
hausman fixed random
hausman fixed random, sigmamore

* Arrgggh!
* Regarding standard errors look at 
* http://chrisauld.com/2012/10/31/the-intuition-of-robust-standard-errors/

xtreg g y y2 y3 e, fe
predict ehat
xtline ehat if  inlist(countryname, "Denmark","Finland","Norway","Sweden")


quietly areg g y y2 y3 e if inlist(incomelevel, "LMC"), absorb(id)
estimates store lmc
quietly areg g y y2 y3 e  if inlist(incomelevel, "UMC"), absorb(id)
estimates store umc
quietly areg g y y2 y3 e  if inlist(incomelevel, "HIC"), absorb(id)
estimates store hic
quietly areg g y y2 y3 e  if inlist(incomelevel, "LIC"), absorb(id)
estimates store lic
quietly areg g y y2 y3 e, absorb(id)  //R2  0.8939
estimates store ALL
estimates table hic umc lmc lic ALL ,stats(r2 F)

collin g y e  if !missing(y)
vce, corr


quietly xtpcse g y y2 y3 e  if inlist(incomelevel, "LMC"), pairwise
estimates store LMC
quietly xtpcse g y y2 y3 e  if inlist(incomelevel, "UMC"), pairwise
estimates store UMC
quietly xtpcse g y y2 y3 e  if inlist(incomelevel, "HIC"), pairwise
estimates store HIC
quietly xtpcse g y y2 y3 e  if inlist(incomelevel, "LIC"), pairwise
estimates store LIC
quietly xtpcse g y y2 y3 e,  pairwise  //R2  0.8939
estimates store ALL
estimates table HIC UMC LMC LIC ALL,stats(r2) 

quietly xtpcse g y d.y2 d.y3 e  if inlist(incomelevel, "LMC"), pairwise
estimates store LMC
quietly xtpcse g y d.y2 d.y3 e  if inlist(incomelevel, "UMC"), pairwise
estimates store UMC
quietly xtpcse g y d.y2 d.y3 e  if inlist(incomelevel, "HIC"), pairwise
estimates store HIC
quietly xtpcse g y d.y2 d.y3 e  if inlist(incomelevel, "LIC"), pairwise
estimates store LIC
quietly xtpcse g y d.y2 d.y3 e,  pairwise  //R2  0.8939
estimates store ALL
estimates table HIC UMC LMC LIC ALL,stats(r2) 

collin g y e  if !missing(y)
vce, corr

