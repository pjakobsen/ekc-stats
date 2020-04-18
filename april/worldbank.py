import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import wbdata
'''
AT THE WORLD BANK UK = GB

'''
country_tuple=("AT","BE","BG","CH","CY","CZ","DE", "DK","ES","FI","FR","HR","HU","IE","IS","IT","LI","LT","LU","LV","MT","NL","NO","PL","PT","RO","SE","SI","SK","TR","GB")

indicators = {"NY.GDP.MKTP.CD": "GDP",
              "NE.CON.PRVT.ZS": "Households and NPISHs Final consumption expenditure (% of GDP)",
              "BX.KLT.DINV.WD.GD.ZS": "Foreign direct investment, net inflows (% of GDP)",
              "NE.CON.GOVT.ZS": "General government final consumption expenditure (% of GDP)",
              "NE.EXP.GNFS.ZS": "Exports of goods and services (% of GDP)",
              "NE.IMP.GNFS.ZS": "Imports of goods and services (% of GDP)" }
import datetime
data_dates=(datetime.datetime(1990, 1, 1), datetime.datetime(2017, 1, 1))
#Create dataframe
wb_df = wbdata.get_dataframe(indicators, 
                            country=country_tuple, 
                            data_date=data_dates, 
                            convert_date=False, keep_levels=True)