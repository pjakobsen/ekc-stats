/*

EN.ATM.GHGT.KT.CE.  Total greenhouse gas emissions (kt of CO2 equivalent)  
NY.GDP.PCAP.PP.KD   GDP per capita, PPP (constant 2011 international $)
EG.USE.PCAP.KG.OE   Energy use (kg of oil equivalent per capita)"
EG.USE.COMM.FO.ZS.  Fossil Fuel Energy Consumption (% of Total)
EG.FEC.RNEW.ZS.     Renewables"
SP.POP.TOTL         Population
EN.ATM.CO2E.PC      CO2 emmissions, to be used as a proxy for ghg?

Carbon dioxide emissions are those stemming from the burning of fossil fuels and the manufacture of cement. 
They include carbon dioxide produced during consumption of solid, liquid, and gas fuels and gas flaring.
*/

//Scandinavian only wbopendata, country(dnk;fin;isl;nor;swe) indicator(EN.ATM.GHGT.KT.CE;NY.GDP.PCAP.PP.KD;EG.USE.PCAP.KG.OE;SP.POP.TOTL) year(1990:2012) clear long

* Get everythin, then take what I need
wbopendata,  indicator(EN.ATM.CO2E.PC;EN.ATM.GHGT.KT.CE;NY.GDP.PCAP.PP.KD;EG.USE.PCAP.KG.OE;EG.USE.COMM.FO.ZS;EG.FEC.RNEW.ZS;SP.POP.TOTL) year(1960:2018) clear long

//keep if region == "ECS" //Erope * Central Asia
//keep if incomelevel == "HIC" || incomelevel == "UMC"
drop if regionname == "Aggregates"
//drop countrycode region regionname adminregion adminregionname  lendingtype lendingtypename 



* Rename, generate and drop variables 
rename en_atm_ghgt_kt_ce gge, label "Greenhouse" //keep to categorize with dummies
rename sp_pop_totl population
generate gge_pcap = (gge*100)/population
label variable gge_pcap "Greenhouse Gas Emmisions Per Capita"

rename ny_gdp_pcap_pp_kd gdp_pcap
label variable  gdp_pcap "GDP per capita, PPP 2011" 

rename en_atm_co2e_pc co2e_pcap
label variable  co2e_pcap "CO2 emissions (metric tons per capita)"

rename eg_use_pcap_kg_oe eg_pcap 
label variable eg_pcap  "Energy use (kg of oil equivalent per capita)"

rename eg_use_comm_fo_zs fossil
label variable fossil "Fossil Fuel Energy Consumption (% of Total)"

rename eg_fec_rnew_zs renew
label variable renew "Renewable energy consumption (% of total final energy consumption)"

 drop if inrange(year, 1960,1969) | inrange(year, 2013,2018)
asdoc mdesc gge co2e gdp_pcap eg_pcap fossil renew
* What do we have left?
tabulate countryname

* Summary Stats for ASDOC

bysort incomelevelname: sum gge co2e gdp_pcap fossil renew
bysort incomelevelname: asdoc sum gge co2e
bysort incomelevelname: asdoc sum gge co2e, stat(N)

* Correlation tables

correlate gdp_pcap eg_pcap fossil_fuel_use Renewables

* Dump countries that don't have data we need 
drop if missing(gdp_pcap)
drop if missing(fossil_fuel_use)
* Lets invent a sepculative mesure of how "Green" a country is for potential dummy 
* Should be recoded into categories using recode
generate green = (gge*fossil_fuel_use)/Renewables

** Or, even better, simply set a starting point for 1990 for how 
* energy greedy a country was as a starting point, as we want to measure 
* if wealthy countries actually get richer and use less energy. 

sort countryname year

******. Prepare Panel Data Estimation ********
egen id = group(countryname)

gen gg = log(gdp_pcap)
gen y = log(gdp_pcap)

//gen dy = d.y
//gen dgge = d.gge
gen y2  = y^2
gen y3 = y^3
gen eg = log(eg_pcap)
gen ff = log(fossil_fuel_use)

global id "id"
global t "year"
global ylist "gge"
global xlist1 "y y2 y3 eg" 


* prepare stata to run panel data analysis
sort $id $t
xtset $id $t, year
xtdescribe


xtsum $id $t $ylist $xlist

xtpcse gge y y2 y3 eg ff i.id, pairwise

asdoc sum , stat(N mean sd) replace label
asdoc regress gge y y2 if inlist(country, "Denmark"), replace

* A very high R-2 for this combo 
regress gge y y2 y3 eg ff if inlist(country, "Denmark","Sweden")

twoway (scatter fossil_fuel_use year, msymbol(Oh)) (scatter Renewables year,  msymbol(Th)) if inlist(country, "Denmark","Sweden")

