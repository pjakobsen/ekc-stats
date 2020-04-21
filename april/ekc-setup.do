*********** Data Imports from Python Script *************

***********. Rune your special sauce segments with Shift-Ctrl-d ***********

*************. Step 1: Import and clean up and modify  data *************
cd "/Users/greendoor/Documents/GitHub/ekc-stats/april/data"
use "wb.dta",clear
//set more off

// Create data labels. This code also acts as documentation for reader of .do file :) 
***** World Bank *******
label variable GDP_PCAP "GDP per capita (constant 2010 US$)"
label variable GDP_PCAP_PP "GDP per capita, PPP (constant 2011 international $)"
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
label variable Population "Polation, required for GHG per capity emmissions"
replace Greenhouse = (Greenhouse*1000)/Population
label variable Greenhouse "Greenhouse Gas Emissions pr. Capita"

***** Eurostat *******
label variable env_tax "% Share of environmental taxes in total tax revenues"

// Change year to integer in case it wasn't done in Pandas DataFrame (Python)
destring year, replace


//You need integers for countries in order to use xtgen
egen country_id = group(country)

// Move some columns 
order country_id country year

********** Step 2: Interpolation of missing values *******
//TODO: Experiment with varios interpolation libraries mipolate etc 

/*
ipolate in Stata will average across panels unless you instruct it otherwise. Note that ipolate is totally independent of any tsset or xtset, and that is a good idea. Interpolation problems often occur with data with irregular "time" variables, and indeed with quite different variables too.

mipolate uses one of the following methods: linear, cubic, cubic spline,
pchip (piecewise cubic Hermite interpolation), idw (inverse distance
weighted), forward, backward, nearest neighbour, groupwise. The default
method is linear.

ipolate  FossilFuel year, by(country) gen(iFossilFuel) epolate
ipolate  Greenhouse  year, by(country) gen(iGreenhouse) epolate
ipolate  Government   year, by(country) gen(iGovernment) epolate
ipolate  IndustryValueAdded  year, by(country) gen(iIndustryValueAdded) epolate
ipolate  RD year, by(country) gen(iRD) epolate
*/
//  Greenhouse Gas Emissions Per Capita


gen logGreenhouse = log(Greenhouse)
mipolate logGreenhouse year, gen(iLogGreenhouse) pchip



********* Step 3: Analyze raw data ***************
summarize iLogGreenhouse


********** Step 4:  Set up variables for analysis *********


gen y = ln(GDP_PCAP)
gen y2 = y^2
gen y3 = y^3
gen gh = ln(iGreenhouse)
//General government final consumption expenditure (% of GDP) "NE.CON.GOVT.ZS"
gen g = ln(iGovernment)
// Industry (including construction), value added (% of GDP)
gen va = ln(INDVA)
//Research and development expenditure (% of GDP)
gen rd = ln(iRD)
xtset country year

*************   STEP 5: Perform Hausmann Test to select fixed effects model. ***********

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


