#!/bin/bash

# this script
# identifies overlap between counties and temperature grids and outputs county-level summaries

clear

declare -a years=($(seq 1988 1998))
declare -a dnames=("tmean")
declare -a times=("daily")
declare -a spaces=("fips") # also "zip" for 2015-2017 when done (above)
declare -a states=("06")

#################################################
# 1. WEIGHTED MEAN CALCULATION
#################################################

for year in "${years[@]}"; do
for dname in "${dnames[@]}"; do
for time in "${times[@]}"; do
for space in "${spaces[@]}"; do
for state in "${states[@]}"; do

echo "Identifying overlap between rasters and zip codes for temperature processing";
echo $year;

:
# identifies the overlap between grids and zip codes and creates weighted means
Rscript ~/git/pollution/countries/USA/prog/02_grid_county_intersection/grid_county_intersection_raster_prism.R $year $dname $time $space $state &

echo "Hello";

done; done; done; done; done;

#################################################
# 2. SANITY CHECK
#################################################

# for year in "${years[@]}"; do
# for dname in "${dnames[@]}"; do
# for time in "${times[@]}"; do
# for space in "${spaces[@]}"; do
# for state in "${states[@]}"; do
#
# echo "Sanity check of values by plotting";
# echo $year;
# :
# # identifies the overlap between grids and zip codes and creates weighted means
# Rscript ~/git/pollution/countries/USA/prog/03_compare/check_prism.R $year $dname $time $space $state &
#
# echo "Hello";
#
# done; done; done; done; done;