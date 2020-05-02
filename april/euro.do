cd "/Users/greendoor/Documents/GitHub/ekc-stats/april/"

/*

TOTXMEMO All sectors and indirect CO2 (excluding memo items)
CRF1-6X4_MEMONIA	All sectors (excluding LULUCF and memo items, including international aviation)
--CRF1	Energy
--CRF2	Industrial processes and product use
CRF2A	Mineral industry
CRF2A1	Cement production
CRF1A2A  Fuel combustion in manufacture of iron and steel
CRF1A2B  Fuel combustion in manufacture of non-ferrous metals
CRF1A1B	 Fuel combustion in petroleum refining
*/

clear
eurostatuse env_air_gge, noflags start(1995) end(2017) nolabel long keepdim(GHG ; CRF1 CRF2 ; THS_T) geo(AT BE DE DK ES FR FI IE IS IT NL NO PL PT SE UK)
keep if strpos(src_crf, "CRF1")

save "env_air_gge.dta", replace

/*
CLV_I10_HAB	Chain linked volumes, Index 2010=100, per capita
  --CLV10_EUR_HAB	Chain linked volumes (2010), euro per capita
CLV_PCH_PRE_HAB	Chain linked volumes, percentage change on previous period, per capita
B1GQ	Gross domestic product at market prices
P3	Final consumption expenditure
P3_S13	Final consumption expenditure of general government
P31_S13	Individual consumption expenditure of general government
P32_S13	Collective consumption expenditure of general government
P31_S14_S15	Household and NPISH final consumption expenditure
P31_S14	Final consumption expenditure of households
P31_S15	Final consumption expenditure of NPISH
P41	Actual individual consumption

*/
clear
eurostatuse nama_10_pc, noflags start(1995) end(2017) nolabel long keepdim(B1GQ P31_S14_S15  ; CLV10_EUR_HAB) geo(AT BE DE DK ES FR FI IE IS IT NL NO PL PT SE UK)

keep if strpos(na_item, "B1GQ")
save "nama_10_pc.dta", replace


/******** Merge ********/
use "env_air_gge.dta" 
merge 1:1 geo time using "nama_10_pc.dta"

drop unit airpol src na_item _merge

save "final.dta", replace

/*

  EU Member States
   BE    Belgium
   BG    Bulgaria
   CZ    Czech Republic
   DK    Denmark
   DE    Germany
   EE    Estonia
   IE    Ireland
   EL    Greece
   ES    Spain
   FR    France
   HR    Croatia
   IT    Italy
   CY    Cyprus
   LV    Latvia
   LT    Lithuania
   LU    Luxembourg
   HU    Hungary
   MT    Malta
   NL    Netherlands
   AT    Austria
   PL    Poland
   PT    Portugal
   RO    Romania
   SI    Slovenia
   SK    Slovakia
   FI    Finland
   SE    Sweden
   UK    United Kingdom

   Other countries
   IS    Iceland
   LI    Liechtenstein
   NO    Norway
   CH    Switzerland
   ME    Montenegro
   TR    Turkey
   US    United States


*/
