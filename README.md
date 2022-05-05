# PRISM data converted into FIPS and ZIP summaries in the USA

## Introduction:
[Parameter-elevation Regressions on Independent Slopes Model (PRISM)](https://prism.oregonstate.edu/recent/) by PRISM Climate group Oregon State temperature, precipitation 4km daily weather variable grids that I have converted to daily county FIPS and ZIP Code summaries for use in several papers.

Available for download (see [Data](#Data) below) in [RDS](https://www.r-bloggers.com/2016/12/remember-to-use-the-rds-format/) (compact) or csv (large) format.

In Python it is [easy to load RDS files](https://stackoverflow.com/questions/40996175/loading-a-rds-file-in-pandas) and much more compact files than csvs too.

Note that ZIP Code throughout is actually [ZIP Code Tablulation Area (ZCTA)](https://en.wikipedia.org/wiki/ZIP_Code_Tabulation_Area), which was developed to overcome the difficulties in precisely defining the land area covered by each ZIP Code. Defining the extent of an area is necessary in order to tabulate census data for that area.

Testing out [Census Tracts](https://www.census.gov/cgi-bin/geo/shapefiles/index.php?year=2021&layergroup=Census+Tracts) too...

Work in progress by Robbie M Parks.

2018...2022... and beyond.

## Data

### County FIPS

[Mean daily temperature (tmean; °C) for 1981-2020](output/fips/tmean) \
[Mean daily precipitation (ppt; mm) for 1981-2020](output/fips/ppt) 

### ZIP Code

#### California

[Mean daily temperature (tmean; °C) for 1981-2020](output/zip/06/tmean)\
[Mean daily precipitation (ppt; mm) for 1981-2020](output/zip/06/ppt)

#### New York

[Mean daily temperature (tmean; °C) for 1981-2020](output/zip/36/tmean)\
[Mean daily precipitation (ppt; mm) for 1981-2020](output/zip/36/ppt)

Let me know if you'd like me to run any other specific states, but others in progress.

## Code

[fips_tmean.R](prog/02_grid_county_intersection/fips_tmean.R) - processing tmean by FIPS\
[fips_ppt.R](prog/02_grid_county_intersection/fips_ppt.R) - processing ppt by FIPS

[zips_tmean.R](prog/02_grid_county_intersection/zips_tmean.R) - processing tmean by ZIP Code\
[zips_ppt.R](prog/02_grid_county_intersection/zips_ppt.R) - processing ppt by ZIP Code

[processing_code.R](prog/02_grid_county_intersection/processing_code.R) - does the heavy lifting called in by bash files for either FIPS or ZIP Code
