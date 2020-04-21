#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Apr 15 18:47:27 2020

@author: Peter Jakobsen
"""

from pandasdmx import Request


estat = Request('ESTAT')

# Download the metadata and expose it as a dict mapping resource names to pandas DataFrames
flow_response = estat.dataflow('une_rt_a')

structure_response = flow_response.dataflow.une_rt_a.structure(request=True, target_only=False)

# Show some code lists.
structure_response.write().codelist.loc['GEO'].head()
#We use codes from the code list ‘GEO’ to obtain data on Greece, Ireland and Spain only.
resp = estat.data('une_rt_a', key={'GEO': 'EL+ES+IE'}, params={'startPeriod': '2007'})

# We use a generator expression to select some columns
# and write them to a pandas DataFrame
data = resp.write(s for s in resp.data.series if s.key.AGE == 'TOTAL')


