# This script will:

# load raster file for particular year
# load shapefile
# isolate each Census Tract's data in raster via shapefile and then find area-weighted mean
# output result

# Robbie M Parks 2022

rm(list=ls())

# declare root directory, folder locations and load essential stuff
project.folder = paste0(print(here::here()),'/')

# arguments from Rscript
args <- commandArgs(trailingOnly=TRUE)
seed.arg <- as.numeric(args[1])

# create grid of years an countries
source(paste0(project.folder,'data/objects/objects.R'))
seed.grid = expand.grid(state=states, year=years_total_ppt)
chosen.row <- seed.grid[seed.arg,]

# year of interest
year = as.numeric(chosen.row[1,1])
dname = 'ppt'
time.res = 'daily'
space.res = 'ct'
state = as.character(chosen.row[1,2])
  
# process from grids into shapefiles
source('prog/02_grid_county_intersection/processing_code.R')
