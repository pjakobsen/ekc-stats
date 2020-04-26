cd "/Users/greendoor/Documents/GitHub/ekc-stats/april/"
use "final.dta"
egen country = group(geo)

move country geo
