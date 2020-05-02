/*

EN.ATM.GHGT.KT.CE.  Total greenhouse gas emissions (kt of CO2 equivalent)  
NY.GDP.PCAP.PP.KD   GDP per capita, PPP (constant 2011 international $)
EG.USE.PCAP.KG.OE   Energy use (kg of oil equivalent per capita)"
EG.USE.COMM.FO.ZS.  Fossil Fuel Energy Consumption (% of Total)
EG.FEC.RNEW.ZS.     Renewables"
SP.POP.TOTL         Population


*/

//Scandinavian only wbopendata, country(dnk;fin;isl;nor;swe) indicator(EN.ATM.GHGT.KT.CE;NY.GDP.PCAP.PP.KD;EG.USE.PCAP.KG.OE;SP.POP.TOTL) year(1990:2012) clear long

* Get everythin, then take what I need
wbopendata,  indicator(EN.ATM.GHGT.KT.CE;NY.GDP.PCAP.PP.KD;EG.USE.PCAP.KG.OE;EG.USE.COMM.FO.ZS;EG.FEC.RNEW.ZS;SP.POP.TOTL) year(1990:2012) clear long

keep if region == "ECS" //Erope * Central Asia
keep if incomelevel == "HIC" || incomelevel == "UMC"
drop countrycode region regionname adminregion adminregionname  lendingtype lendingtypename 

* Dump countries with no Greenhouse Emmission data
drop if missing(en_atm_ghgt_kt_ce)


* Rename, generate and drop variables 
rename en_atm_ghgt_kt_ce gge, label "Greenhouse" //keep to categorize with dummies
rename sp_pop_totl Population
generate gge_pcap = (gge*1000)/Population
label variable gge_pcap "Greenhouse Gas Emmisions Per Capita"

rename ny_gdp_pcap_pp_kd gdp_pcap
label variable  gdp_pcap "GDP per capita, PPP 2011" 

rename eg_use_pcap_kg_oe eg_pcap 
label variable eg_pcap  "Energy use (kg of oil equivalent per capita)"

rename eg_use_comm_fo_zs fossil_fuel_use
label variable fossil_fuel_use "Fossil Fuel Energy Consumption (% of Total)"

rename eg_fec_rnew_zs Renewables
label variable Renewables "Renewable energy consumption (% of total final energy consumption)"


* What do we have left?
tabulate country

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
egen id = group(country)

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

