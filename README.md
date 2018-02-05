# Visualising complexity datasets


## Introduction

This repository contains code and data for working with datasets for the SEFARI visualising complexity workshop <https://visualisingcomplexity.wordpress.com>.


## Datasets

These datasets were taken from <http://statistics.gov.scot>.
Visit the website for more datasets, but remember to concentrate on data visualisation, not data acquisition and preparation!
Files are contained in two folders, raw and clean.
You can view the cleaning process in the file `repo/VC_clean.R`, some liberties were taken.


* `population-estimates-historical-geographic-boundaries`  <http://statistics.gov.scot/data/population-estimates-historical-geographic-boundaries> Mid-year population estimates. Higher geographies are aggregated from 2001 Data Zones.
* `electricity-consumption.csv` <http://statistics.gov.scot/data/energy-consumption> Consumption (GWh) by energy (electricity) and customer type (all)
* `average-household-size.csv` <http://statistics.gov.scot/data/average-household-size> The average number of people per household in each council area and in Scotland.
* `business-site-counts.csv` <http://statistics.gov.scot/data/business-site-counts> Number of business sites by employee size band.
* `employment.csv` <http://statistics.gov.scot/data/employment> Employment level.
* `road-vehicles.csv` <http://statistics.gov.scot/data/road-vehicles> Road vehicle fuel consumption.

Additionally, there is spatial data for the Scottish local authorities.
These were adapted from Ordnance Survey Boundary Line data <https://www.ordnancesurvey.co.uk/business-and-government/products/boundary-line.html>.


## Code

A sample `R` script is included for joining data together.
Please adapt and reuse as required.
