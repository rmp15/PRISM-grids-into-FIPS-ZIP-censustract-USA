# PRISM data converted into FIPS and ZIP summaries in the USA

## Introduction:
[Parameter-elevation Regressions on Independent Slopes Model (PRISM)](https://prism.oregonstate.edu/recent/) by PRISM Climate group Oregon State temperature, precipitation 4km daily weather variable grids that I have converted to daily county FIPS and ZIP Code summaries for use in several papers.

Available for download (see [Data](#Data) below) in [RDS](https://www.r-bloggers.com/2016/12/remember-to-use-the-rds-format/) (compact) format. csv available on request.

In Python it is [easy to load RDS files](https://stackoverflow.com/questions/40996175/loading-a-rds-file-in-pandas) and much more compact files than csvs too.

Note that ZIP Code throughout is actually [ZIP Code Tablulation Area (ZCTA)](https://en.wikipedia.org/wiki/ZIP_Code_Tabulation_Area), which was developed to overcome the difficulties in precisely defining the land area covered by each ZIP Code. Defining the extent of an area is necessary in order to tabulate census data for that area.

Work in progress by Robbie M Parks.

2018...2022... and beyond.

## Data (covers 1981-2020)

### County (FIPS) (using [shapefiles](https://www.census.gov/cgi-bin/geo/shapefiles/index.php?year=2021&layergroup=Counties+%28and+equivalent%29))

#### Mean daily temperature (tmean; °C) 

[Entire mainland USA](output/fips/tmean)

#### Total daily precipitation (ppt; mm)

[Entire mainland USA](output/fips/ppt) 

### ZIP Code (ZCTAs) (using [shapefiles](https://www2.census.gov/geo/tiger/TIGER2010/ZCTA5/2010/?C=D;O=A))

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

#### Total daily precipitation (ppt; mm)

[Alabama](output/zip/01/ppt),
[Arizona](output/zip/04/ppt),
[Arkansas](output/zip/05/ppt),
[California](output/zip/06/ppt),
[Colorado](output/zip/08/ppt),
[Connecticut](output/zip/09/ppt),
[Delaware](output/zip/10/ppt),
[Florida](output/zip/12/ppt),
[Georgia](output/zip/13/ppt),
[Idaho](output/zip/16/ppt),
[Illinois](output/zip/17/ppt),
[Indiana](output/zip/18/ppt),
[Iowa](output/zip/19/ppt),
[Kansas](output/zip/20/ppt),
[Kentucky](output/zip/21/ppt),
[Louisiana](output/zip/22/ppt),
[Maine](output/zip/23/ppt),
[Maryland](output/zip/24/ppt),
[Massachusetts](output/zip/25/ppt),
[Michigan](output/zip/26/ppt),
[Minnesota](output/zip/27/ppt),
[Mississippi](output/zip/28/ppt),
[Missouri](output/zip/29/ppt),
[Montana](output/zip/30/ppt),
[Nebraska](output/zip/31/ppt),
[Nevada](output/zip/32/ppt),
[New Hampshire](output/zip/33/ppt),
[New Jersey](output/zip/34/ppt),
[New Mexico](output/zip/35/ppt),
[New York](output/zip/36/ppt),
[North Carolina](output/zip/37/ppt),
[North Dakota](output/zip/38/ppt),
[Ohio](output/zip/39/ppt),
[Oklahoma](output/zip/40/ppt),
[Oregon](output/zip/41/ppt),
[Pennsylvania](output/zip/42/ppt),
[Rhode Island](output/zip/44/ppt),
[South Carolina](output/zip/45/ppt),
[South Dakota](output/zip/46/ppt),
[Tennessee](output/zip/47/ppt),
[Texas](output/zip/48/ppt),
[Utah](output/zip/49/ppt),
[Vermont](output/zip/50/ppt),
[Virginia](output/zip/51/ppt),
[Washington](output/zip/53/ppt),
[West Virginia](output/zip/54/ppt),
[Wisconsin](output/zip/55/ppt),
[Wyoming](output/zip/56/ppt).

### Census tracts (using [shapefiles](https://www.census.gov/cgi-bin/geo/shapefiles/index.php?year=2021&layergroup=Census+Tracts))

#### Mean daily temperature (tmean; °C) 

[Alabama](output/ct/01/tmean),
[Arizona](output/ct/04/tmean),
[Arkansas](output/ct/05/tmean),
[California](output/ct/06/tmean),
[Colorado](output/ct/08/tmean),
[Connecticut](output/ct/09/tmean),
[Delaware](output/ct/10/tmean),
[Florida](output/ct/12/tmean),
[Georgia](output/ct/13/tmean),
[Idaho](output/ct/16/tmean),
[Illinois](output/ct/17/tmean),
[Indiana](output/ct/18/tmean),
[Iowa](output/ct/19/tmean),
[Kansas](output/ct/20/tmean),
[Kentucky](output/ct/21/tmean),
[Louisiana](output/ct/22/tmean),
[Maine](output/ct/23/tmean),
[Maryland](output/ct/24/tmean),
[Massachusetts](output/ct/25/tmean),
[Michigan](output/ct/26/tmean),
[Minnesota](output/ct/27/tmean),
[Mississippi](output/ct/28/tmean),
[Missouri](output/ct/29/tmean),
[Montana](output/ct/30/tmean),
[Nebraska](output/ct/31/tmean),
[Nevada](output/ct/32/tmean),
[New Hampshire](output/ct/33/tmean),
[New Jersey](output/ct/34/tmean),
[New Mexico](output/ct/35/tmean),
[New York](output/ct/36/tmean),
[North Carolina](output/ct/37/tmean),
[North Dakota](output/ct/38/tmean),
[Ohio](output/ct/39/tmean),
[Oklahoma](output/ct/40/tmean),
[Oregon](output/ct/41/tmean),
[Pennsylvania](output/ct/42/tmean),
[Rhode Island](output/ct/44/tmean),
[South Carolina](output/ct/45/tmean),
[South Dakota](output/ct/46/tmean),
[Tennessee](output/ct/47/tmean),
[Texas](output/ct/48/tmean),
[Utah](output/ct/49/tmean),
[Vermont](output/ct/50/tmean),
[Virginia](output/ct/51/tmean),
[Washington](output/ct/53/tmean),
[West Virginia](output/ct/54/tmean),
[Wisconsin](output/ct/55/tmean),
[Wyoming](output/ct/56/tmean).

#### Total daily precipitation (ppt; mm)

[Alabama](output/ct/01/ppt),
[Arizona](output/ct/04/ppt),
[Arkansas](output/ct/05/ppt),
[California](output/ct/06/ppt),
[Colorado](output/ct/08/ppt),
[Connecticut](output/ct/09/ppt),
[Delaware](output/ct/10/ppt),
[Florida](output/ct/12/ppt),
[Georgia](output/ct/13/ppt),
[Idaho](output/ct/16/ppt),
[Illinois](output/ct/17/ppt),
[Indiana](output/ct/18/ppt),
[Iowa](output/ct/19/ppt),
[Kansas](output/ct/20/ppt),
[Kentucky](output/ct/21/ppt),
[Louisiana](output/ct/22/ppt),
[Maine](output/ct/23/ppt),
[Maryland](output/ct/24/ppt),
[Massachusetts](output/ct/25/ppt),
[Michigan](output/ct/26/ppt),
[Minnesota](output/ct/27/ppt),
[Mississippi](output/ct/28/ppt),
[Missouri](output/ct/29/ppt),
[Montana](output/ct/30/ppt),
[Nebraska](output/ct/31/ppt),
[Nevada](output/ct/32/ppt),
[New Hampshire](output/ct/33/ppt),
[New Jersey](output/ct/34/ppt),
[New Mexico](output/ct/35/ppt),
[New York](output/ct/36/ppt),
[North Carolina](output/ct/37/ppt),
[North Dakota](output/ct/38/ppt),
[Ohio](output/ct/39/ppt),
[Oklahoma](output/ct/40/ppt),
[Oregon](output/ct/41/ppt),
[Pennsylvania](output/ct/42/ppt),
[Rhode Island](output/ct/44/ppt),
[South Carolina](output/ct/45/ppt),
[South Dakota](output/ct/46/ppt),
[Tennessee](output/ct/47/ppt),
[Texas](output/ct/48/ppt),
[Utah](output/ct/49/ppt),
[Vermont](output/ct/50/ppt),
[Virginia](output/ct/51/ppt),
[Washington](output/ct/53/ppt),
[West Virginia](output/ct/54/ppt),
[Wisconsin](output/ct/55/ppt),
[Wyoming](output/ct/56/ppt).

## Code

[fips_tmean.R](prog/02_grid_county_intersection/fips_tmean.R) - processing tmean by FIPS\
[fips_ppt.R](prog/02_grid_county_intersection/fips_ppt.R) - processing ppt by FIPS

[zips_tmean.R](prog/02_grid_county_intersection/zips_tmean.R) - processing tmean by ZIP Code\
[zips_ppt.R](prog/02_grid_county_intersection/zips_ppt.R) - processing ppt by ZIP Code

[census_tract_tmean.R](prog/02_grid_county_intersection/census_tract_tmean.R) - processing tmean by census tract\
[census_tract_ppt.R](prog/02_grid_county_intersection/census_tract_ppt.R) - processing ppt by census tract

[processing_code.R](prog/02_grid_county_intersection/processing_code.R) - does the heavy lifting called in by bash files for either FIPS or ZIP Code
