******** Run Hausemann Test ************


************ Run Regression  ************



************ Test the model *************



********* Step 3: Analyze raw data ***************
summarize iLogGreenhouse


********** Step 4:  Set up variables for analysis *********


gen y = ln(GDP_PCAP)
gen y2 = y^2
gen y3 = y^3
gen gh = iLogGreenhouse
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
