#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 27 11:48:22 2020

@author: Peter Jakobsen
"""
import pandas as pd
import wbdata

# HIC Countries, with help from Colab notebok MayWB
countries = ['ABW', 'AND', 'ARE', 'ATG', 'AUS', 'AUT', 'BEL', 'BHR', 'BHS', 'BMU', 'BRB', 'BRN', 'CAN', 'CHE', 'CHI', 'CHL', 'CUW', 'CYM', 'CYP', 'CZE', 'DEU', 'DNK', 'ESP', 'EST', 'FIN', 'FRA', 'FRO', 'GBR', 'GIB', 'GRC', 'GRL', 'GUM', 'HKG', 'HRV', 'HUN', 'IMN', 'IRL', 'ISL', 'ISR', 'ITA', 'JPN', 'KNA', 'KOR', 'KWT', 'LIE', 'LTU', 'LUX', 'LVA', 'MAC', 'MAF', 'MCO', 'MLT', 'MNP', 'NCL', 'NLD', 'NOR', 'NZL', 'OMN', 'PAN', 'PLW', 'POL', 'PRI', 'PRT', 'PYF', 'QAT', 'SAU', 'SGP', 'SMR', 'SVK', 'SVN', 'SWE', 'SXM', 'SYC', 'TCA', 'TTO', 'TWN', 'URY', 'USA', 'VGB', 'VIR']
countries 
indicators = {
        "EN.ATM.GHGT.KT.CE":"Greenhouse", #Total greenhouse gas emissions (kt of CO2 equivalent)  
        "NY.GDP.PCAP.PP.KD":"GDP.PCAP.PP", #GDP per capita, PPP (constant 2011 international $)
        "EG.USE.PCAP.KG.OE":"EG.PCAP", "Energy use (kg of oil equivalent per capita)"
        "SP.POP.TOTL":"Population"
}
import datetime
data_dates=(datetime.datetime(1990, 1, 1), datetime.datetime(2017, 1, 1))
#Create dataframe
df = wbdata.get_dataframe(indicators, 
                            country=countries,
                            data_date=data_dates, 
                            convert_date=False, keep_levels=True)

df.Population = df.Population.astype(int)
df.index.names = ['country','year']


#df2.to_stata('data/may.dta')



