clear all

cd "/Users/greendoor/Documents/GitHub/ekc-stats/april/"
use "final.dta"
egen country = group(geo)

move country geo


gen gge = log(env_air_gge)
gen y = log(nama_10_pc)
gen y2  = y^2
gen y3 = y^3
describe


global id "country"
global t "time"
* Derek global ylist "gh"
global ylist "gge"
global xlist "y y2" //Simple GDP (+ environmental tax % )

sort $id $t
xtset $id $t
xtdescribe 
xtsum $id $t $ylist $xlist
