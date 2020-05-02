clear
cd "/Users/greendoor/Documents/GitHub/ekc-stats/may/" 
use "wbmay.dta"

tabulate country

// To make dataset balanced drop any countries that have less than 23 years of data
egen id = group(country)
bysort id : drop if _N < 23
// This will make the dataset strongly balanced, check with 

//These are the countries we have left
tabulate country


rename date year
move id country
destring year, replace



gen gge = log(GGE_PCAP)
//gen dgge = d.gge
gen en = log(EN_PCAP)
gen y = log(GDP_PCAP_PP)
//gen dy = d.y
gen y2  = y^2
gen y3 = y^3

describe

twoway (scatter foo year, msymbol(Oh)) (scatter EN_PCAP year,  msymbol(Th)) if inlist(country, "Denmark")
twoway (scatter foo year, msymbol(Oh)) (scatter EN_PCAP year,  msymbol(Th)) if inlist(country, "Denmark" "Sweden" "Island")

twoway (scatter foo year, msymbol(Oh)) (lfit foo year) (scatter EN_PCAP year,  msymbol(Th)) if inlist(country, "Denmark")
scatter GDP_PCAP_PP year || qfit GDP_PCAP_PP year
scatter GDP_PCAP_PP year if inlist(country, "Denmark") || qfit GDP_PCAP_PP year  if inlist(country, "Denmark")
scatter EN_PCAP year if inlist(country, "Denmark") || qfit EN_PCAP year  if inlist(country, "Denmark")
scatter GGE_PCAP year,  msymbol(Oh)  || lpoly GGE_PCAP year   ||, by(country), if inlist(country, "Denmark", "Finland","Norway","Germany"), tit(Greenhouse Gas Emission Per Capita)

lpoly GGE_PCAP GDP_PCAP_PP, degree(2) kernel(epan2),  if inlist(country, "Denmark") 

global id "id"
global t "year"
global ylist "gge"
global xlist1 "y y2" 

sort $id $t
xtset $id $t, year

xtdescribe 

xtline GGE_PCAP, overlay legend(off)


xtsum $id $t $ylist $xlist

xtreg $ylist $xlist

global xlist1en "y y2 en" //Simple Quadratic Model with Energy Use
xtreg $ylist $xlist1en

global xlist2 "y y2 y3" //Simple Cubic Model

xtreg $ylist $xlist2

global xlist2en "y y2 y3 en" //Simple Cubic Model with Energy Use
xtreg $ylist $xlist2en


global xlist2en "y y2 y3 en" //Simple Cubic Model with Energy Use and 1st difference
xtreg $ylist $xlist2en
Try with First differennces using d. notation 

xtpcse gge y y2 i.id, pairwise
xtpcse gge y y2 y3 en i.id, pairwise
