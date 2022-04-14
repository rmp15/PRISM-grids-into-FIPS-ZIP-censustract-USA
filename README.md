# PRISM data converted into FIPS and ZIP summaries in the USA

## Introduction:
[Parameter-elevation Regressions on Independent Slopes Model (PRISM)](https://prism.oregonstate.edu/recent/) by PRISM Climate group Oregon State temperature, precipitation 4km daily weather variable grids that I have converted to daily county FIPS and ZIP Code summaries for use in several papers.

Available for download (see [Data](#Data) below) in [RDS](https://www.r-bloggers.com/2016/12/remember-to-use-the-rds-format/) (compact) or csv (large) format.

In Python it is [easy to load RDS files](https://stackoverflow.com/questions/40996175/loading-a-rds-file-in-pandas) and much more compact files than csvs too.

Work in progress by Robbie M Parks.

2018...2022... and beyond.

## Data

### County FIPS

[Mean daily temperature (tmean; °C) for 1981-2020](https://github.com/rmp15/PRISM-grids-into-FIPS-ZIP-USA/tree/main/output/fips/tmean) \
[Mean daily precipitation (ppt; mm) for 1981-2020](https://github.com/rmp15/PRISM-grids-into-FIPS-ZIP-USA/tree/main/output/fips/ppt) 

### ZIP Code

#### New York State

[Mean daily temperature (tmean; °C) for 1981-2020](https://github.com/rmp15/PRISM-grids-into-FIPS-ZIP-USA/tree/main/output/zip/36/tmean) \
[Mean daily precipitation (ppt; mm) for 1981-2020](https://github.com/rmp15/PRISM-grids-into-FIPS-ZIP-USA/tree/main/output/zip/36/ppt)

Let me know if you'd like me to run any other specific states, but others slowly in progress.

## Code

fips_tmean - processing tmean by FIPS\
fips_ppt - processing ppt by FIPS\
fips_wbgtmax - processing wbgtmax by FIPS

zips_tmean - processing tmean by ZIP (ZCTA) Code\
zips_ppt - processing ppt by ZIP (ZCTA) Code\
zips_wbgtmax - processing wbgtmax by ZIP (ZCTA) Code

processing_code.R - does the heavy lifting called in by bash files for either FIPS or ZIP (ZCTA) Code
