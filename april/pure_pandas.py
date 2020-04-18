#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Apr 15 21:24:23 2020

@author: P Jakobsen
"""
import pandas as pd
import numpy

#----Unemployment Rate---------
dataEU_unempl=pd.read_json('http://ec.europa.eu/eurostat/wdds/rest/data/v2.1/json/en/ei_lmhr_m?geo=EA&indic=LM-UN-T-TOT&s_adj=NSA&unit=PC_ACT',typ='series',orient='table',numpy=True) #,typ='DataFrame',orient='table'
x=[]
for i in range(int(sorted(dataEU_unempl['value'].keys())[0]),1+int(sorted(dataEU_unempl['value'].keys(),reverse=True)[0])):
    x=numpy.append(x,dataEU_unempl['value'][str(i)])
EU_unempl=pd.Series(x,index=pd.date_range((pd.to_datetime((sorted(dataEU_unempl['dimension']['time']['category']['index'].keys())[(sorted(int(v) for v in dataEU_unempl['value'].keys())[0])]),format='%YM%M')), periods=len(x), freq='M')) #'1/1993'


#----GDP---------
dataEU_GDP=pd.read_json('http://ec.europa.eu/eurostat/wdds/rest/data/v2.1/json/en/namq_10_gdp?geo=EA&na_item=B1GQ&s_adj=NSA&unit=CP_MEUR',typ='series',orient='table',numpy=True) #,typ='DataFrame',orient='table'
x=[]
for i in range((sorted(int(v) for v in dataEU_GDP['value'].keys())[0]),1+(sorted((int(v) for v in dataEU_GDP['value'].keys()),reverse=True))[0]):
    x=numpy.append(x,dataEU_GDP['value'][str(i)])
EU_GDP=pd.Series(x,index=pd.date_range((pd.Timestamp(sorted(dataEU_GDP['dimension']['time']['category']['index'].keys())[(sorted(int(v) for v in dataEU_GDP['value'].keys())[0])])), periods=len(x), freq='Q'))

'''

#----Money market interest rates---------
dataEU_intRates=pd.read_json('http://ec.europa.eu/eurostat/wdds/rest/data/v2.1/json/en/irt_st_m?geo=EA&intrt=MAT_ON',typ='series',orient='table',numpy=True) #,typ='DataFrame',orient='table'
x=[]
for i in range((sorted(int(v) for v in dataEU_intRates['value'].keys())[0]),1+(sorted((int(v) for v in dataEU_intRates['value'].keys()),reverse=True))[0]):
    x=numpy.append(x,dataEU_intRates['value'][str(i)])
EU_intRates=pd.Series(x,index=pd.date_range((pd.to_datetime((sorted(dataEU_intRates['dimension']['time']['category']['index'].keys())[(sorted(int(v) for v in dataEU_intRates['value'].keys())[0])]),format='%YM%M')), periods=len(x), freq='M'))

'''