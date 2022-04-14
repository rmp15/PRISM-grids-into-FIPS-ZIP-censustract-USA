# PRISM data converted into FIPS and ZIP summaries in the USA

## Introduction 
[Parameter-elevation Regressions on Independent Slopes Model (PRISM)](https://prism.oregonstate.edu/recent/) temperature, precipitation 4km weather variable grids that have been converted to county FIPS and ZIP Code summaries for use in several papers.

In RDS from R and also csv. In Python [easy to load RDS files](https://stackoverflow.com/questions/40996175/loading-a-rds-file-in-pandas) and much more compact files than csvs too.

Work in progress by Robbie M Parks.

2018...2022... and beyond.

Actual output to use found at: https://github.com/rmp15/PRISM-grids-into-FIPS-ZIP-USA/tree/main/output

Variable:

tmean - mean daily temperature (°C)\
ppt - daily precipitation (mm)\
wbgtmax - maximum daily wet bulb globe temperature (WBGT) (°C)

Contents of project:

Input (not in GitHub project):

PRISM 4k values (https://prism.oregonstate.edu/recent/)

Code (prog):

Actual processing scripts:

02_grid_county_intersection/

fips_tmean - processing tmean by FIPS\
fips_ppt - processing ppt by FIPS\
fips_wbgtmax - processing wbgtmax by FIPS

zips_tmean - processing tmean by ZIP (ZCTA) Code\
zips_ppt - processing ppt by ZIP (ZCTA) Code\
zips_wbgtmax - processing wbgtmax by ZIP (ZCTA) Code

processing_code.R - does the heavy lifting called in by bash files for either FIPS or ZIP (ZCTA) Code

Output:

fips - FIPS output files by exposure and year\
zip - ZIP (ZCTA) Code output files by state FIPS, exposure and year
