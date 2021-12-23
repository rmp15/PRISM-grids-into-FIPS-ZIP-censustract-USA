PRISM temperature and other weather variable grids (from https://prism.oregonstate.edu/recent/) that have been converted to political entities for use in:

Parks, R.M., Anderson, G.B., Nethery, R.C. et al. Tropical cyclone exposure is associated with increased hospitalization rates in older adults. Nat Commun 12, 1545 (2021). https://doi.org/10.1038/s41467-021-21777-1

Elser H, Parks RM, Moghavem N, Kiang MV, Bozinov N, Henderson VW, Rehkopf DH, Casey JA. (2021). Anomalously warm weather and acute care visits in patients with multiple sclerosis: A retrospective study of privately insured individuals in the US, PLoS Medicine https://journals.plos.org/plosmedicine/article?id=10.1371/journal.pmed.1003580

Other papers to be posted here very soon once published.

Work in progress by Robbie M Parks et al.

2018...2022... and beyond

Variable:

tmean - mean daily temperature\
ppt - daily precipitation

Contents of project:

Countries covered (I have other countries in another location):

USA 

Input:

PRISM 4k values

Code (prog):

Bash files:

grid_county_intersection_prism_fips.sh  - Perform for chosen year by county for each day in chosen year\
grid_county_intersection_prism_zip.sh   - Perform for chosen year by zip code for each day in chosen year

Actual processing function:

02_grid_county_intersection/grid_county_intersection_raster_prism.R - does the heavy lifting called in by bash files for either fips or zip

Output:

grid_county_intersection_raster_prism - either fips or zip files by year
