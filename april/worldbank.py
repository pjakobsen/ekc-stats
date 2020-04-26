import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import wbdata
import eurostat
import country_converter as coco
'''
AT THE WORLD BANK UK = GB

'''

rich_countries_json = wbdata.get_country(incomelevel="HIC")


# Selected by countries who have environmental tax data
# Or country names are different
country_tuple=("AT","BE","DE","DK","ES","FI","FR","IE","IS","IT","NL","NO","PL","PT","SE","GB")
euro_country_tuple=("AT","BE","DE","DK","ES","FI","FR","IE","IS","IT","NL","NO","PL","PT","SE","UK")


#CO2 emissions (metric tons per capita) EN.ATM.CO2E.PC
#"NE.CON.PRVT.ZS": "Households and NPISHs Final consumption expenditure (% of GDP)",
#"BX.KLT.DINV.WD.GD.ZS": "Foreign direct investment, net inflows (% of GDP)",

#Underscores make datanames complient with Stata

indicators = {
    "EN.ATM.GHGT.KT.CE":"Greenhouse", #Total greenhouse gas emissions (kt of CO2 equivalent)  
    "NY.GDP.PCAP.KD": "GDP.PCAP",#GDP per capita (constant 2010 US$)
    "NY.GDP.PCAP.PP.KD":"GDP.PCAP.PP", #GDP per capita, PPP (constant 2011 international $)
    "NY.GDP.PCAP.KD.ZG": "GDP.PCAP.GRO", #GDP per capita growth (annual %)
    "GB.XPD.RSDV.GD.ZS": "RD",  #Research and development expenditure (% of GDP)
    "EG.USE.COMM.FO.ZS": "FossilFuel",  # Fossil Fuel Energy Consumption (% of Total)
    "NV.IND.TOTL.ZS": "IndustryValueAdded", # Industry (including construction), value added (% of GDP)
    "EN.ATM.CO2E.PC":"CO2E.PC", #CO2 emissions (metric tons per capita) 
    "NE.CON.GOVT.ZS": "Government", #General government final consumption expenditure (% of GDP)
    "NE.EXP.GNFS.ZS": "Exports", #Exports of goods and services (% of GDP)
    "NE.IMP.GNFS.ZS": "Imports", #Imports of goods and services (% of GDP)
    "EG.FEC.RNEW.ZS":"Renewables", #Renewable energy consumption (% of total final energy consumption)
    "EG.ELC.RNWX.ZS":"RenewablesLessHydro", #Electricity production from renewable sources, excluding hydroelectric (% of total)"
    "SP.POP.TOTL":"Population"
}
import datetime
data_dates=(datetime.datetime(2000, 1, 1), datetime.datetime(2017, 1, 1))
#Create dataframe
df = wbdata.get_dataframe(indicators, 
                            country=country_tuple, 
                            data_date=data_dates, 
                            convert_date=False, keep_levels=True)

df.Population = df.Population.astype(int)
df.index.names = ['country','year']

#conda install -c konstantinstadler country_converter

#df.to_csv('data/wb.csv',convert_dates='ty')

code = "sdg_17_50" #Share of environmental taxes in total tax revenues
tdf = eurostat.get_data_df(code, flags=False)
tdf = tdf.rename(columns={ tdf.columns[0]: "country_code" })
tdf= tdf[tdf['country_code'].isin(list(euro_country_tuple))]
del tdf[2018]
iso2_codes =tdf['country_code'].tolist()
# Change back to standard - scary!!
iso2_codes[15]='GB'
del tdf['country_code']
tdf['country']=coco.convert(names=iso2_codes, to='name_short', not_found=None)


tax=tdf.melt(id_vars=["country"], 
            var_name="year", 
            value_name="env_tax")
tax['year'] = pd.to_numeric(tax['year'], errors='coerce')
tax.sort_values(by=['country','year'],inplace = True)


tax = tax.set_index(['country','year'])
df=df.reset_index()
df['year'] = df['year'].astype(int)
df = df.set_index(['country','year'])
df2 = pd.merge(df, tax,  how='left', left_on=['country', 'year'], right_on = ['country','year'])
df2 = df2.round(2)
'''
Python
# Apply function numpy.square() to square the value 2 column only i.e. with column names 'x' and 'y' only
modDfObj = dfObj.apply(lambda x: np.square(x) if x.name in ['x', 'y'] else x)
print("Modified Dataframe : Squared the values in column x & y :", modDfObj, sep='\n')
1
2
3
4
# Apply function numpy.square() to square the value 2 column only i.e. with column names 'x' and 'y' only
modDfObj = dfObj.apply(lambda x: np.square(x) if x.name in ['x', 'y'] else x)
 
print("Modified Dataframe : Squared the values in column x & y :", modDfObj, sep='\n')
df.round({'Y': 2, 'X': 2})
'''
df2.to_stata('data/wb.dta')
df2.to_csv('data/wb.csv')

import pysftp

with pysftp.Connection('hostname', username='me', password='secret') as sftp:
    with sftp.cd('public'):             # temporarily chdir to public
        sftp.put('/my/local/filename')