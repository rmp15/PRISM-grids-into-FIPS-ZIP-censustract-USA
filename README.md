# PRISM data converted into FIPS and ZIP summaries in the USA

## Introduction:
[Parameter-elevation Regressions on Independent Slopes Model (PRISM)](https://prism.oregonstate.edu/recent/) by PRISM Climate group Oregon State temperature, precipitation 4km daily weather variable grids that I have converted to daily county FIPS and ZIP Code summaries for use in several papers.

Available for download (see [Data](#Data) below) in [RDS](https://www.r-bloggers.com/2016/12/remember-to-use-the-rds-format/) (compact) or csv (large) format. In Python [easy to load RDS files](https://stackoverflow.com/questions/40996175/loading-a-rds-file-in-pandas) and much more compact files than csvs too.

Work in progress by Robbie M Parks.

2018...2022... and beyond.

## Available variables

tmean - mean daily temperature (°C)\
ppt - daily precipitation (mm)

## Data

fips - FIPS output files by exposure and year\
zip - ZIP (ZCTA) Code output files by state FIPS, exposure and year

## Input:

[PRISM 4km daily weather variable grids values](https://prism.oregonstate.edu/recent/)

## Code:

Actual processing scripts:

02_grid_county_intersection/

fips_tmean - processing tmean by FIPS\
fips_ppt - processing ppt by FIPS\
fips_wbgtmax - processing wbgtmax by FIPS

zips_tmean - processing tmean by ZIP (ZCTA) Code\
zips_ppt - processing ppt by ZIP (ZCTA) Code\
zips_wbgtmax - processing wbgtmax by ZIP (ZCTA) Code

processing_code.R - does the heavy lifting called in by bash files for either FIPS or ZIP (ZCTA) Code
