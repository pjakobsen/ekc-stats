import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import wbdata
import re



indicators = {"NY.GDP.MKTP.CD": "GDP",
              "NE.CON.PRVT.ZS": "Households and NPISHs Final consumption expenditure (% of GDP)",
              "BX.KLT.DINV.WD.GD.ZS": "Foreign direct investment, net inflows (% of GDP)",
              "NE.CON.GOVT.ZS": "General government final consumption expenditure (% of GDP)",
              "NE.EXP.GNFS.ZS": "Exports of goods and services (% of GDP)",
              "NE.IMP.GNFS.ZS": "Imports of goods and services (% of GDP)" }
import datetime
data_dates=(datetime.datetime(1995, 1, 1), datetime.datetime(2015, 1, 1))
#Create dataframe
data = wbdata.get_dataframe(indicators, 
                            country=('DNK'), 
                            data_date=data_dates, 
                            convert_date=False, keep_levels=True)

print(data)