# PRISM data converted into FIPS and ZIP summaries in the USA

PRISM temperature, precipitation, wet bulb global tempearture (WBGT) weather variable grids (from https://prism.oregonstate.edu/recent/) that have been converted to political entities (county FIPS and ZIP (ZCTA) Codes) for use in several papers.

Currently in RDS from R but in process of converting to csv. In Python easy to load RDS files (https://stackoverflow.com/questions/40996175/loading-a-rds-file-in-pandas).

Work in progress by Robbie M Parks et al.\ 
WGBT grids provided by Cascade Tuloske. Great to work together!

2018...2022... and beyond

Actual output to use found at: https://github.com/rmp15/PRISM-grids-into-political-entities-USA/tree/main/output/

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
