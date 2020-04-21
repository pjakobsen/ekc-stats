#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Apr 15 19:49:47 2020

@author: P.Jakobsen

From https://jsonstatpy.readthedocs.io/en/latest/notebooks/eurostat.html
"""


from __future__ import print_function
import os
import pandas as pd
import jsonstat

import matplotlib as plt

url_1 = 'http://ec.europa.eu/eurostat/wdds/rest/data/v1.1/json/en/nama_gdp_c?precision=1&geo=IT&unit=EUR_HAB&indic_na=B1GM'
file_name_1 = "eurostat-environmental-tax.json"

url_1="http://ec.europa.eu/eurostat/wdds/rest/data/v2.1/json/en/nama_10_gdp?geo=EU28&precision=1&na_item=B1GQ&unit=CP_MEUR&time=2010&time=2011"
#url_1="http://ec.europa.eu/eurostat/wdds/rest/data/v2.1/json/en/nama_gdp_c?precision=1&geo=IT&unit=EUR_HAB&indic_na=B1GM'"
file_path_1 = "data/"+file_name_1
if os.path.exists(file_path_1):
    print("using already donwloaded file {}".format(file_path_1))
else:
    print("download file")
    jsonstat.download(url_1, file_name_1)
    file_path_1 = file_name_1
collection_1 = jsonstat.from_file(file_path_1)
collection_1

nama_gdp_c_1 = collection_1.dataset('nama_gdp_c')
nama_gdp_c_1