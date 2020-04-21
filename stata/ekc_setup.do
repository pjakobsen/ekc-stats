*********** Data Imports from Python Script *************


*************. Step 1: Import and clean up and modify  data *************
cd "/Users/greendoor/Documents/GitHub/ekc-stats/april/data"
use "wb.dta",clear
//set more off

// Create data labels. This code also acts as documentation for reader of .do file :)
***** World Bank *******
label variable  GDP_PCAP "GDP per capita (constant 2010 US$)"
label variable GDP_PCAP_GRO "GDP per capita growth (annual %)"
label variable RD  "Research and development expenditure (% of GDP)"
label variable FossilFuel "Fossil Fuel Energy Consumption (% of Total)"
label variable IndustryValueAdded "Industry (including construction), value added (% of GDP)"
label variable CO2E_PC "O2 emissions (metric tons per capita)"
label variable Government "General government final consumption expenditure (% of GDP)"
label variable Exports "Exports of goods and services (% of GDP)"
label variable Imports "Imports of goods and services (% of GDP)"
label variable Renewables "Renewable energy consumption (% of total final energy consumption)"
label variable RenewablesLessHydro "Electricity production from renewable sources, excluding hydroelectric (% of total)"
label variable Greenhouse "Total greenhouse gas emissions (kt of CO2 equivalent)"
***** Eurostat *******
label variable env_tax "% Share of environmental taxes in total tax revenues"

// Change year to integer
destring year, replace

//You need integers for countries in order to use xtgen
egen country_id = group(country)

/*
#ipolate in Stata will indeed average across panels unless you instruct it otherwise. Note that ipolate is totally independent of any tsset or xtset, and that is a good idea. Interpolation problems often occur with data with irregular "time" variables, and indeed with quite different variables too.


To use -ipolate- to interpolate within countries, prefix the command with -by country

gen logm = log(mangrove)
* to install mipolate:
* ssc inst mipolate
mipolate logm year, by(province) gen(loglinear)
replace loglinear = exp(loglinear)
twoway connected loglinear mangrove year, by(province, note("") yrescale) ///
cmissing(n n) ysc(log) ms(+ O) msize(*1.2)  yla(, ang(h)) xtitle("")

*/



// Fill missing values
ipolate  FossilFuel year, by(country) gen(iFossilFuel) epolate
ipolate  GHGPC  year, by(country) gen(iGHGPC) epolate
ipolate  Government   year, by(country) gen(iGovernment) epolate
ipolate  INDVA  year, by(country) gen(iINDVA) epolate
ipolate  RD year, by(country) gen(iRD) epolate

// Move some columns

********** Set up variables for analysis *********



gen y= ln(GDPC)
gen y2 = y^2
gen y3 = y^3
gen gh = ln(iGHGPC)
//General government final consumption expenditure (% of GDP) "NE.CON.GOVT.ZS"
gen g = ln(iGovernment)
// Industry (including construction), value added (% of GDP)
gen va = ln(INDVA)
//Research and development expenditure (% of GDP)
gen rd = ln(iRD)
xtset country year

//summarize  GDPC GDPCG  RD  FFEC  INDVA   GHGPC, detail f
//GDP totalGHG DARACCcost2010, detail f

/*
*********************Step1: estimate alpha and beta********************
gen alpha_GHG = 0
gen beta_GHG = 0
gen r2=0
gen r2adj=0
gen fvalue=0
gen totalGHG_sq= totalGHG^2
*Transform GDP from million$ to $
replace GDP=GDP*10^6

*For 194 countries, run regressions to estimate alpha and beta
forvalues i = 1(1)194 {
reg GDP totalGHG totalGHG_sq if countrycode2==`i', noconstant
estimates store reg`i'
replace alpha_GHG= _b[totalGHG] if countrycode2==`i'
replace beta_GHG = _b[totalGHG_sq] if countrycode2==`i'
replace r2=e(r2) if countrycode2==`i'
replace r2adj=e(r2_a) if countrycode2==`i'
replace fvalue=e(F) if countrycode2==`i'
}

drop if alpha_GHG<=0 | beta_GHG>=0
*/
