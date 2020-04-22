********** Step 1: Set up variables for analysis *********
drop y y2 y3 gh et
gen y = logGDP_PCAP_PP
gen y2 = y^2
gen y3 = y^3
gen gh = iLogGreenhouse
gen et = log(env_tax)
//General government final consumption expenditure (% of GDP) "NE.CON.GOVT.ZS"
//gen gov = ln(iGovernment)
// Industry (including construction), value added (% of GDP)
//gen va = ln(INDVA)
//Research and development expenditure (% of GDP)
//gen rd = ln(iRD)

global id country_id
global t year
global ylist gh
global xlist y y2 et //Simple GDP + environmental tax % 

sort $id $t
xtset $id $t
xtdescribe 
xtsum $id $t $ylist $xlist

************ Run Regression  ************

******** Run Hausemann Test ************





************ Test the model *************



