# PRISM data converted into FIPS and ZIP summaries in the USA

## Introduction:
[Parameter-elevation Regressions on Independent Slopes Model (PRISM)](https://prism.oregonstate.edu/recent/) by PRISM Climate group Oregon State temperature, precipitation 4km daily weather variable grids that I have converted to daily county FIPS and ZIP Code summaries for use in several papers.

Available for download (see [Data](#Data) below) in [RDS](https://www.r-bloggers.com/2016/12/remember-to-use-the-rds-format/) (compact) format. csv available on request.

In Python it is [easy to load RDS files](https://stackoverflow.com/questions/40996175/loading-a-rds-file-in-pandas) and much more compact files than csvs too.

Note that ZIP Code throughout is actually [ZIP Code Tablulation Area (ZCTA)](https://en.wikipedia.org/wiki/ZIP_Code_Tabulation_Area), which was developed to overcome the difficulties in precisely defining the land area covered by each ZIP Code. Defining the extent of an area is necessary in order to tabulate census data for that area.

Testing out [Census Tracts](https://www.census.gov/cgi-bin/geo/shapefiles/index.php?year=2021&layergroup=Census+Tracts) too...

Work in progress by Robbie M Parks.

2018...2022... and beyond.

## Data

### County FIPS (1981-2020)

#### Mean daily temperature (tmean; °C) 

[Entire mainland USA](output/fips/tmean)

#### Total daily precipitation (ppt; mm)

[Entire mainland USA](output/fips/ppt) 

### ZIP Code (1981-2020)

#### Mean daily temperature (tmean; °C) 

[Alabama](output/zip/01/tmean),
[Arizona](output/zip/04/tmean),
[Arkansas](output/zip/05/tmean),
[California](output/zip/06/tmean),
[Colorado](output/zip/08/tmean),
[Connecticut](output/zip/09/tmean),
[Delaware](output/zip/10/tmean),
[Florida](output/zip/12/tmean),
[Georgia](output/zip/13/tmean),
[Idaho](output/zip/16/tmean),
[Illinois](output/zip/17/tmean),
[Indiana](output/zip/18/tmean),
[Iowa](output/zip/19/tmean),
[Kansas](output/zip/20/tmean),
[Kentucky](output/zip/21/tmean),
[Louisiana](output/zip/22/tmean),
[Maine](output/zip/23/tmean),
[Maryland](output/zip/24/tmean),
[Massachusetts](output/zip/25/tmean),
[Michigan](output/zip/26/tmean),
[Minnesota](output/zip/27/tmean),
[Mississippi](output/zip/28/tmean),
[Missouri](output/zip/29/tmean),
[Montana](output/zip/30/tmean),
[Nebraska](output/zip/31/tmean),
[Nevada](output/zip/32/tmean),
[New Hampshire](output/zip/33/tmean),
[New Jersey](output/zip/34/tmean),
[New Mexico](output/zip/35/tmean),
[New York](output/zip/36/tmean),
[North Carolina](output/zip/37/tmean),
[North Dakota](output/zip/38/tmean),
[Ohio](output/zip/39/tmean),
[Oklahoma](output/zip/40/tmean),
[Oregon](output/zip/41/tmean),
[Pennsylvania](output/zip/42/tmean),
[Rhode Island](output/zip/44/tmean),
[South Carolina](output/zip/45/tmean),
[South Dakota](output/zip/46/tmean),
[Tennessee](output/zip/47/tmean),
[Texas](output/zip/48/tmean),
[Utah](output/zip/49/tmean),
[Vermont](output/zip/50/tmean),
[Virginia](output/zip/51/tmean),
[Washington](output/zip/53/tmean),
[West Virginia](output/zip/54/tmean),
[Wisconsin](output/zip/55/tmean),
[Wyoming](output/zip/56/tmean).

### Census tracts

Watch this space...

## Code

[fips_tmean.R](prog/02_grid_county_intersection/fips_tmean.R) - processing tmean by FIPS\
[fips_ppt.R](prog/02_grid_county_intersection/fips_ppt.R) - processing ppt by FIPS

[zips_tmean.R](prog/02_grid_county_intersection/zips_tmean.R) - processing tmean by ZIP Code\
[zips_ppt.R](prog/02_grid_county_intersection/zips_ppt.R) - processing ppt by ZIP Code

[processing_code.R](prog/02_grid_county_intersection/processing_code.R) - does the heavy lifting called in by bash files for either FIPS or ZIP Code
