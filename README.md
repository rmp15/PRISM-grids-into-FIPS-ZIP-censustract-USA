PRISM temperature and other weather variable grids that have been converted to political entities 

Work in progress by Robbie M Parks et al.

2018...2022... and beyond

note: 0_00_create_folder_structure.R is in all of the files to create list of file locations.

Contents of project:

Countries covered (I have other countries in another location):

USA 

Input:

PRISM 4k values

Code (prog):

Bash files:

grid_county_intersection_prism_fips.sh  - Perform for chosen year by county for each day in chosen year
grid_county_intersection_prism_zip.sh   - Perform for chosen year by zip code for each day in chosen year

Actual processing function:

02_grid_county_intersection/grid_county_intersection_raster_prism.R - does the heavy lifting called in by bash files for either fips or zip

Output:

grid_county_intersection_raster_prism - either fips or zip files by year
