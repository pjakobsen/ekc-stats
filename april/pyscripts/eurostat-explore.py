import eurostat
#from eurostatapiclient import EurostatAPIClient
import statsmodels.api as sm

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import wbdata
countries=("AT","BE","BG","CH","CY","CZ","DE", "DK","ES","FI","FR","HR","HU","IE","IS","IT","LI","LT","LU","LV","MT","NL","NO","PL","PT","RO","SE","SI","SK","TR","UK")
countries=("AT","BE","BG","CY","CZ","DE", "DK","ES","FI","FR","HU","IE","IS","IT","LT","LU","LV","MT","NL","NO","PL","PT","SE","SI","SK","UK")
countries=("AT","BE","DE","DK","ES","FI","FR","IE","IS","IT","NL","NO","PL","PT","SE","TR","GB")

code = "sdg_17_50" #Share of environmental taxes in total tax revenues
#code = "urb_cenv"
#code = "env_ac_epneec"
code = "env_air_gge"  # GHG Emmisions
#code = "ei_bssi_m_r2"  # Sentiment

toc_df = eurostat.get_toc_df()
f = eurostat.subset_toc_df(toc_df, 'environment')


def fetch_ghg_pc():
    # Eurostat Code 
    # Codes can be found at Eurostat data  browser 
    # https://ec.europa.eu/eurostat/data/database
    code = "t2020_rd300" #SGreenhouse gas emissions per capita [T2020_RD300]
    df = eurostat.get_data_df(code, flags=False)
    df.rename(columns={ df.columns[0]: "country" }, inplace = True)
    #Only individual countries
    df2 = df[df['country'].isin(list(countries))]
    # Reshape to put Years from column headers (1st row) to a column
    df2=df2.melt(id_vars=["country"], 
            var_name="year",
            value_name="ghg_e_pc")
    # Sort by geo and year
    df2.sort_values(by=['country','year'],inplace = True)
    return df2

def fetch_gdp():
    # Eurostat Code - always lower case
    # Codes can be found at Eurostat data  browser 
    # https://ec.europa.eu/eurostat/data/database
    code = "sdg_08_10" #
    df = eurostat.get_data_df(code, flags=False)
    df.rename(columns={ df.columns[2]: "country" }, inplace = True)
    #Only individual countries
    df2 = df[df['country'].isin(list(countries))]
    # Drop 2019 columm before melt
    del df2[2019]

    
    # Also with melting :
    # since this dataset contains two variables
    # I'll split it into two data sets

    df3=df2.melt(id_vars=["country", "unit"], 
            var_name="year",
            value_name="temp_value")
    df3.sort_values(by=['country','year'],inplace = True)
    return (df3[df3['unit']=='CLV10_EUR_HAB'], df3[df3['unit']=='CLV_PCH_PRE_HAB'])
    # rename that temp columns
    
    # Reshape to put Years from column headers (1st row) to a column
     

def fetch_tax():
    code = "sdg_17_50" #Share of environmental taxes in total tax revenues
    df = eurostat.get_data_df(code, flags=False)
    df.rename(columns={ df.columns[0]: "country" }, inplace = True)
    df = df[df['country'].isin(list(countries))]
    df=df.melt(id_vars=["country"], 
            var_name="year", 
            value_name="env_tax")
    df.sort_values(by=['country','year'],inplace = True)
    return df.query('year > 1999').query('year<2018')


ghg_pc_df = fetch_ghg_pc()
    
CLV_PCH_HAB_df,CLV_PCH_PRE_HAB_df = fetch_gdp()
gdp_df = pd.merge(CLV_PCH_HAB_df, tax_env_share_df,  how='left', left_on=['year','country'], right_on = ['year','country'])

#CLV10_EUR_HAB  Chain linked volumes (2010), euro per capita in the unit
#CLV_PCH_PRE_HABChain linked volumes, percentage change on previous period, per capita
gdp_df.rename(columns={'temp_value_x':'CLV10_EUR_HAB','temp_value_y':'CLV_PCH_PRE_HAB'}, inplace=True)
del gdp_df['unit_x']
del gdp_df['unit_y']

tax_env_share_df= fetch_tax()
tax_env_share_df.to_csv('data/eurostat-environmental-tax.csv', index=False)
# now we can merge datasets for use in Stata
new_df = pd.merge(ghg_pc_df, tax_env_share_df,  how='left', left_on=['year','country'], right_on = ['year','country'])


new_df2 = pd.merge(new_df, gdp_df,  how='left', left_on=['year','country'], right_on = ['year','country'])


new_df2.to_csv('data/eurostat-master.csv', index=False)
#dic = eurostat.get_sdmx_dic('DS-066341','FREQ')

## Without a constant



#X = wb_df["RM"]
#y = target["MEDV"]

# # Note the difference in argument order
# model = sm.OLS(y, X).fit()
# predictions = model.predict(X) # make the predictions by the model

# # Print out the statistics
# model.summary()

'''
Sentiment indicators - monthly data
Consumers - monthly data 
Consumers - quarterly data

How can we compare different regions.  NUTS Geospatical classification
Nomenclature of Territorial Units for Statistics
'''


print("-------")
'''
Using official statistics to calculate
greenhouse gas emissions
2010 edition
A statistical guide

data at http://epp.eurostat.ec.europa.eu/portal/page/portal/statistics/search_database

land use and agriculture;
n energy;
n business (industry and services);
n transport;
waste.

10 Using official statistics to calculate greenhouse gas emissions – a statistical guide
These five sections contain a selection of official statistics, usually based upon data that
has been collected by the statistical office of the European Union, Eurostat. A range of
indicators are presented: each may be viewed as an explanatory or contributing factor
that can potentially be linked to levels of greenhouse gas emissions.

'''
'''
#AT THE WORLD BANK UK = GB
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
'''