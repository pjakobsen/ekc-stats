******** Explore data set from ekc-setup.do with graphics etc. 

*** Look at differences between countries 

collapse (mean) logGreenhouse logGDP_PCAP_PP, by(country)
describe	
twoway (scatter logGreenhouse logGDP_PCAP_PP, sort mlabel(country))
