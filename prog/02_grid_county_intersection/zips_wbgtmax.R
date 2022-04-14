# This script will:

# load raster file for particular year
# load shapefile
# isolate each ZIP Code's data in raster via shapefile and then find area-weighted mean
# output result

# Robbie M Parks 2022

rm(list=ls())

# arguments from Rscript
args = commandArgs(trailingOnly=TRUE)

# year of interest
year = as.numeric(args[1])
dname = 'wbgtmax'
time.res = 'daily'
space.res = 'zip'
state = '06'
  
# process from grids into shapefiles
source('prog/02_grid_county_intersection/processing_code.R')
