wbopendata, indicator(EN.ATM.CO2E.PC;NY.GDP.PCAP.KD;EG.USE.PCAP.KG.OE;EG.USE.COMM.FO.ZS;EG.FEC.RNEW.ZS;) year(1960:2013) clear long
drop if regionname == "Aggregates"

describe

drop if missing(ny_gdp_pcap_kd) 
drop if missing(en_atm_co2e_pc) 
drop if missing(eg_use_pcap_kg_oe)

gen y = log(ny_gdp_pcap_kd)
gen g = log(en_atm_co2e_pc*100)
gen e = log(eg_use_pcap_kg_oe)
gen y2 = y^2
gen y3 = y^3

summarize g y y2 y3 e

egen id = group(countrycode)
egen ilid = group(incomelevel)

bysort id: drop if _N<30 // Dump crappy frequencies

replace g = g*100 // make me more like the others 


sort id year
xtset id year
 
xtsum g y y2 y3 e

sort year incomelevel
by year incomelevel: egen log_ghg = total(g) 
by year incomelevel: egen log_ene = total(e) 


twoway (scatter g year, msymbol(Oh) msize(.4) mcolor(blue)) (qfit g year, msize(2)), by (incomelevelname)
. twoway (scatter ny_gdp_pcap_kd year, msymbol(Oh) msize(.2) mcolor(blue)) (qfit ny_gdp_pcap_kd year, lwidth(.8)) if inlist(ilid, 3,4), by (incomelevelname) 
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

* estab or asdoc for below results
quietly areg g y y2 y3 e if inlist(incomelevel, "LMC"), absorb(id)
estimates store LMC
quietly areg g y y2 y3 e  if inlist(incomelevel, "UMC"), absorb(id)
estimates store UMC
quietly areg g y y2 y3 e  if inlist(incomelevel, "HIC"), absorb(id)
estimates store HIC
quietly areg g y y2 y3 e  if inlist(incomelevel, "LIC"), absorb(id)
estimates store LIC
quietly areg g y y2 y3 e, absorb(id)  //R2  0.8939
estimates store ALL
asdoc using "~/Desktop/foo.rtf" estimates table HIC UMC LMC LIC ALL ,stats(r2 F)



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

