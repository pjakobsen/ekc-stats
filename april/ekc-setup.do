*********** Data Imports from Python Script *************

***********. Rune your special sauce segments with Shift-Ctrl-d ***********

*************. Step 1: Import and clean up and modify  data *************
cd "/Users/greendoor/Documents/GitHub/ekc-stats/april/data"
use "wb.dta",clear
//set more off

// Create data labels. This code also acts as documentation for reader of .do file :) 

***. Round and replace 
replace FossilFuel = round(FossilFuel, 0.1)
replace RD = round(RD, 0.1)
replace Government = round(FossilFuel, 0.1)

***** World Bank *******
label variable Greenhouse "Greenhouse Gas Emissions pr. Capita"
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


gen Greenhouse_PCAP = (Greenhouse*1000)/Population
***** Eurostat *******
label variable env_tax "% Share of environmental taxes in total tax revenues"

// Change year to integer in case it wasn't done in Pandas DataFrame (Python)
destring year, replace


//You need integers for countries in order to use xtgen
egen country_id = group(country)

// Move some columns 
order country_id country year Greenhouse_PCAP GDP_PCAP_PP GDP_PCAP_GRO FossilFuel Renewables RenewablesLessHydro

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


**************** Step 3: Generate variables for model 
// Log and Mipolate every relevant variable 

gen logGreenhouse_PCAP = log(Greenhouse_PCAP)
mipolate logGreenhouse_PCAP year, gen(iLogGreenhouse_PCAP) pchip
gen logFossilFuel = log(FossilFuel)
mipolate logFossilFuel year, gen(logFossilFuel) pchip


gen logGDP_PCAP_PP  = log(GDP_PCAP_PP) //No need interpolate, full 288 obs



save "/Users/greendoor/Documents/GitHub/ekc-stats/april/wb2.dta", replace
