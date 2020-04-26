******** Explore data set from ekc-setup.do with graphics etc. 

*** Look at differences between countries 
** Ideas from CrunchEconometrics YouTube: 
** Panel Data Descriptive Analysis (Scatterplots)




* Try some Graphics explore the raw data

cd "/Users/greendoor/Documents/GitHub/ekc-stats/april/"
use "wb2.dta",clear


*. Fixed effects: Heterogeneity across countries (or entities)
bysort country_id: egen y_mean=mean(y)
twoway scatter y country_id, msymbol(circle_hollow) || connected y_mean country_id, msymbol(diamond) || , xlabel(1 "Austria" 2 "Belgium" 3 "Denmark" 4 "Finland" 5 "France" 6 "Germany" 7 "Iceland" 8 "Ireland" 9 "Italy" 10 "Netherlands" 11 "Norway" 12 "Poland" 13 "Portugal" 14 "Spain" 15 "Sweden" 16 "UK", ang(45))


*. Fixed effects: Heterogeneity across years
bysort year: egen y_mean1=mean(y)
twoway scatter y year, msymbol(circle_hollow) || connected y_mean1 year,
msymbol(diamond) || , xlabel(2000(1)2017)

twoway line  Greenhouse_PCAP FossilFuel year, by(country)

describe  iLogGreenhouse_PCAP iLogFossilFuel Renewables 
summarize iLogGreenhouse_PCAP iLogFossilFuel Renewables

* We can see immediately that icelands collapse in 2009 skews the data 
* Perhaps just as well as it has tiny population
drop if country=="Iceland" || country=="Ireland"


// I will argue for the removal of GDP due to 2008 crisis

summarize iLogGreenhouse_PCAP iLogFossilFuel Renewables

* The very thing we're looking for 
collapse (mean) Greenhouse_PCAP FossilFuel, by(country)
drop if country=="Iceland"
twoway (scatter Greenhouse_PCAP FossilFuel, sort mlabel(country))


// growth vs. existing per capita
collapse (mean) GDP_PCAP GDP_PCAP_GRO, by(country)
br
twoway (scatter GDP_PCAP GDP_PCAP_GRO, sort mlabel(country))

// dump some outliers

. drop if country=="Norway"
(1 observation deleted)

. drop if country=="Ireland"
(1 observation deleted)

. drop if country=="Poland"
(1 observation deleted)

twoway (scatter GDP_PCAP GDP_PCAP_GRO, sort mlabel(country))


cd "/Users/greendoor/Documents/GitHub/ekc-stats/april/"
use "wb2.dta",clear
describe
collapse (mean) Greenhouse_PCAP GDP_PCAP_GRO, by(country_id)
br
twoway (scatter Greenhouse_PCAP GDP_PCAP_GRO, sort mlabel(country))


* Relationship between GHG and Renewables
cd "/Users/greendoor/Documents/GitHub/ekc-stats/april/"
use "wb2.dta",clear
describe
collapse (mean) Greenhouse_PCAP Renewables, by(country)
br
twoway (scatter Greenhouse_PCAP Renewables, sort mlabel(country))


* Relationship between GHG and Renewables without Hydrp
cd "/Users/greendoor/Documents/GitHub/ekc-stats/april/"
use "wb2.dta",clear
describe
collapse (mean) Greenhouse_PCAP RenewablesLessHydro, by(country)
br
twoway (scatter Greenhouse_PCAP RenewablesLessHydro, sort mlabel(country))


* Relationship between GHG and Renewables without Hydrp
cd "/Users/greendoor/Documents/GitHub/ekc-stats/april/"
use "wb2.dta",clear
describe
collapse (mean) Greenhouse_PCAP RD, by(country)
br
twoway (scatter Greenhouse_PCAP RD, sort mlabel(country))


* Relationship between GHG and Renewables without Hydrp
cd "/Users/greendoor/Documents/GitHub/ekc-stats/april/"
use "wb2.dta",clear
describe
collapse (mean) Greenhouse_PCAP IndustryValueAdded, by(country)
br
twoway (scatter Greenhouse_PCAP IndustryValueAdded, sort mlabel(country))

