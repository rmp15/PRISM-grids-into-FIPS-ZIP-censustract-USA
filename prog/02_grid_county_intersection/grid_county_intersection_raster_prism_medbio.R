# This script will:

# load raster file for particular year
# load shapefile
# isolate each FIPS code's data in raster via shapefile and then find area-weighted mean
# output result

# Robbie M Parks 2022

rm(list=ls())

# 1a Declare root directory, folder locations and load essential stuff
project.folder = paste0(print(here::here()),'/')

library(data.table)
library(maptools)
library(mapproj)
library(rgeos)
library(rgdal)
library(RColorBrewer)
library(ggplot2)
library(raster)
library(sp)
library(plyr)
library(graticule)
library(zoo)

# arguments from Rscript
args = commandArgs(trailingOnly=TRUE)

# year of interest
year = as.numeric(args[1])
dname = 'tmean'
time.res = 'daily'
space.res = 'fips'

print('running grid_county_intersection_raster_prism.R')
print(year); print(dname); print(time.res); print(space.res)

# create directory to place output files into
dir.output = paste0(project.folder,"output/grid_county_intersection_raster_prism/")
if(space.res=='zip'){dir.output=paste0(dir.output,'zip/',state,'/')}
if(space.res=='fips'){dir.output=paste0(dir.output,'fips/')}
ifelse(!dir.exists(dir.output), dir.create(dir.output), FALSE)

if(space.res=='zip'){
    # load shapefile (just one state at a time)
    us.national = readOGR(dsn=paste0(project.folder,'data/shapefiles/zips/tl_2010_',state,'_zcta500'),layer=paste0('tl_2010_',state,'_zcta500'))
    us.national$STATEFP = us.national$STATEFP00 ; us.national$STATEFP00 = NULL
    us.national = us.national[us.national$STATEFP %in% c(state),]

    us.main = us.national
}
if(space.res=='fips'){
    # load shapefile of entire United States
    us.national <- readOGR(dsn=paste0(project.folder,"data/shapefiles/cb_2015_us_county_500k"),layer="cb_2015_us_county_500k")

    # remove non-mainland territories (assuming it's for entire mainland US)
    us.main = us.national[!us.national$STATEFP %in% c("02","15","60","66","69","71","72","78"),]
}

# get projection of shapefile
original.proj = proj4string(us.national)

# load raster and make same projection as zip code map
if(time.res=='annual'){
    raster.full = raster(paste0('~/data/climate/prism/asc/PRISM_',dname,'_stable_4kmM3_',year,'_all_asc/PRISM_',dname,'_stable_4kmM3_',year,'_asc.asc'))
}

# perform analysis across every day of selected year
if(time.res=='daily'){
    # loop through each raster file for each day and summarise
    dates <- seq(as.Date(paste0('0101',year),format="%d%m%Y"), as.Date(paste0('3112',year),format="%d%m%Y"), by=1)

    # empty dataframe to load summarised national daily values into
    weighted.area.national.total = data.frame()

    # loop through each day of the year and perform analysis
    print(paste0('Processing dates in ',year))
    for(date in dates){

        print(format(as.Date(date), "%d/%m/%Y"))

        day = format(as.Date(date), "%d")
        month = format(as.Date(date), "%m")
        day.month = paste0(month,day)

        print(day.month)

        # load raster for relevant date
        raster.full = raster(paste0('~/data/climate/prism/bil/PRISM_',dname,'_stable_4kmD2_',year,'0101_',year,'1231_bil/PRISM_',dname,'_stable_4kmD2_',year,day.month,'_bil.bil'))
        raster.full = projectRaster(raster.full, crs=original.proj)
        
        # perform over entire of mainland USA
        weighted.area.national  = extract(x=raster.full,weights = TRUE, normalizeWeights=TRUE,y=us.main,fun=mean,df=TRUE,na.rm=TRUE)
        weighted.area.national = data.frame(zip=paste0(us.main$STATEFP,us.main$COUNTYFP), weighted.area.national[,2])
        weighted.area.national = weighted.area.national[order(weighted.area.national$zip),]
        rownames(weighted.area.national) = NULL
        names(weighted.area.national) = c('zip',dname)
        
        weighted.area.national$date = format(as.Date(date), "%d/%m/%Y")
        weighted.area.national$day = day
        weighted.area.national$month = month
        weighted.area.national$year = year

        weighted.area.national.total = data.table::rbindlist(list(weighted.area.national.total,weighted.area.national))
    }
}

if(space.res=='fips'){names(weighted.area.national.total)[1]='fips'}

if(space.res=='zip'){
    saveRDS(weighted.area.national.total,paste0(dir.output,'weighted_area_raster_zip_',state,'_',dname,'_',time.res,'_',as.character(year),'.rds'))
}
if(space.res=='fips'){
    saveRDS(weighted.area.national.total,paste0(dir.output,'weighted_area_raster_fips_',dname,'_',time.res,'_',as.character(year),'.rds'))
}
