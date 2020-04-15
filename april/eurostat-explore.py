import eurostat

toc_df = eurostat.get_toc_df()
f = eurostat.subset_toc_df(toc_df, 'environment')





code = "sdg_17_50" #Share of environmental taxes in total tax revenues
#code = "urb_cenv"
#code = "env_ac_epneec"
code = "env_air_gge"  # GHG Emmisions
code = "ei_bssi_m_r2"  # Sentiment

eurostat = {("ENVTR", "t2020_rt"  , "Environmental tax revenues.  % of total revenues from taxes andsocial contributions")
df = eurostat.get_data_df(code, flags=False)

#dic = eurostat.get_sdmx_dic('DS-066341','FREQ')



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
