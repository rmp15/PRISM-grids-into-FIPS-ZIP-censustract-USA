# This script will:

# load raster file for particular year
# load shapefile
# isolate each FIPS code's data in raster via shapefile and then find area-weighted mean
# output result

# Robbie M Parks 2022

rm(list=ls())

# 1a Declare root directory, folder locations and load essential stuff
project.folder = paste0(print(here::here()),'/')

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

# # create directory to place output files into
# dir.output = paste0(project.folder,"output/grid_county_intersection_raster_prism/")
# if(space.res=='zip'){dir.output=paste0(dir.output,'zip/',state,'/')}
# if(space.res=='fips'){dir.output=paste0(dir.output,'fips/')}
# ifelse(!dir.exists(dir.output), dir.create(dir.output), FALSE)
# 
# if(space.res=='zip'){
#     # load shapefile (just one state at a time)
#     us.national = readOGR(dsn=paste0(project.folder,'data/shapefiles/zips/tl_2010_',state,'_zcta500'),layer=paste0('tl_2010_',state,'_zcta500'))
#     us.national$STATEFP = us.national$STATEFP00 ; us.national$STATEFP00 = NULL
#     us.national = us.national[us.national$STATEFP %in% c(state),]
# 
#     us.main = us.national
# }
# if(space.res=='fips'){
#     # load shapefile of entire United States
#     us.national <- readOGR(dsn=paste0(project.folder,"data/shapefiles/cb_2015_us_county_500k"),layer="cb_2015_us_county_500k")
# 
#     # remove non-mainland territories (assuming it's for entire mainland US)
#     us.main = us.national[!us.national$STATEFP %in% c("02","15","60","66","69","71","72","78"),]
# }
# 
# # get projection of shapefile
# original.proj = proj4string(us.national)
# 
# ################################################################
# # function to perform analysis for entire state
# state.analysis = function(state.arg='01',output=0) {
# 
#     # isolate state
#     state.fips  = as.character(state.arg)
#     us.state = us.main[us.main$STATEFP %in% state.fips,]
# 
#     # plot state with highlighted county and grids that overlap
#     if(output==1){
#         pdf(paste0(dir.output,'county_graticule_highlighted_unproj_',state.fips,'.pdf'))}
# 
#     if(space.res=='zip'){
#         # obtain a list of zip codes in a particular state
#         zips = sort(unique(as.character(us.state$ZCTA5CE00)))
#         # print(zips)
#     }
#     if(space.res=='fips'){
#         # obtain a list of fips codes in a particular state
#         zips = sort(unique(as.character(us.state$GEOID)))
#         # print(zips)
#     }
# 
#     # create empty dataframe to fill with zip code summary information
#     weighted.area = data.frame()
# 
#     for(zip in zips) {
# 
#         # process zip preamble
#         zip      = as.character(zip)
#         # print(paste('current status:',zip))
# 
#         # isolate zip to highlight
#         if(space.res=='zip'){us.zip = us.state[us.state$ZCTA5CE00 %in% zip,]}
#         if(space.res=='fips'){us.zip = us.state[us.state$GEOID %in% zip,]}
# 
#         # crop raster by current zip code
#         # raster.crop = crop(x=raster.full,y=us.zip)
#         ## raster.crop = crop(x=raster.full,y=us.zip) TO PUT BACK IN IF USING BELOW
# 
#         # to plot if want to check that raster and shapefile overlap using manhattan
#         # plot(manhattan) ; plot(raster.manhattan,add=TRUE) ; plot(manhattan,add=TRUE)
#         # plot(raster.crop,add=TRUE, col='grey') ;  plot(us.zip,col='red',add=TRUE)
# 
#         # create polygon from cropped polygon
#         ## raster.crop[raster.crop[]<0] = NA TO PUT BACK IN IF USING BELOW
# 
#         # create weighted average of values from raster polygon
#         # from https://gis.stackexchange.com/questions/213493/area-weighted-average-raster-values-within-each-spatialpolygonsdataframe-polygon/213503#213503
#         current.value = extract(x=raster.full,weights = TRUE, normalizeWeights=TRUE,y=us.zip,fun=mean,df=TRUE,na.rm=TRUE)
# 
#         to.add = data.frame(zip,value=current.value[1,2])
#         weighted.area = rbind(weighted.area,to.add)
# 
#         # print(to.add)
#     }
# 
#     names(weighted.area) = c('zip',dname)
# 
#     return(weighted.area)
# 
# }
# 
# ################################################################
# 
# # record of every state in the current shapefile
# states = sort(unique(as.character(us.main$STATEFP)))
# 
# # load raster and make same projection as zip code map
# if(time.res=='annual'){
#     raster.full = raster(paste0('~/data/climate/prism/asc/PRISM_',dname,'_stable_4kmM3_',year,'_all_asc/PRISM_',dname,'_stable_4kmM3_',year,'_asc.asc'))
# }
# 
# # perform analysis across every day of selected year
# if(time.res=='daily'){
#     # loop through each raster file for each day and summarise
#     dates <- seq(as.Date(paste0('0101',year),format="%d%m%Y"), as.Date(paste0('3112',year),format="%d%m%Y"), by=1)
# 
#     # empty dataframe to load summarised national daily values into
#     weighted.area.national.total = data.frame()
# 
#     # loop through each day of the year and perform analysis
#     print(paste0('Processing dates in ',year))
#     for(date in dates){
# 
#         print(format(as.Date(date), "%d/%m/%Y"))
# 
#         day = format(as.Date(date), "%d")
#         month = format(as.Date(date), "%m")
#         day.month = paste0(month,day)
# 
#         print(day.month)
# 
#         # load raster for relevant date
#         raster.full = raster(paste0('~/data/climate/prism/bil/PRISM_',dname,'_stable_4kmD2_',year,'0101_',year,'1231_bil/PRISM_',dname,'_stable_4kmD2_',year,day.month,'_bil.bil'))
#         raster.full = projectRaster(raster.full, crs=original.proj)
# 
#         # create empty dataframe to fill with zip code summary information
#         weighted.area.national = data.frame()
# 
#         # perform loop across all states
#         system.time(
#         for(i in states){
#         analysis.dummy = state.analysis(i)
#         analysis.dummy$date = format(as.Date(date), "%d/%m/%Y")
#         analysis.dummy$day = day
#         analysis.dummy$month = month
#         analysis.dummy$year = year
# 
#         weighted.area.national = rbind(weighted.area.national,analysis.dummy)
#         }
#         )
# 
#         # weighted.area.national = weighted.area.national[,c(3,1,2)]
#         weighted.area.national.total = rbind(weighted.area.national.total,weighted.area.national)
#     }
# }
# 
# if(space.res=='fips'){names(weighted.area.national.total)[1]='fips'}
# 
# if(space.res=='zip'){
#     saveRDS(weighted.area.national.total,paste0(dir.output,'weighted_area_raster_zip_',state,'_',dname,'_',time.res,'_',as.character(year),'.rds'))
# }
# if(space.res=='fips'){
#     saveRDS(weighted.area.national.total,paste0(dir.output,'weighted_area_raster_fips_',dname,'_',time.res,'_',as.character(year),'.rds'))
# }
# 
# # LEGACY BELOW
# 
# # if desired for manhattan test if looking at New York
# # if(space.res=='zip'){
# #     manhattan = subset(us.main,ZCTA5CE00%in%c(10001:10286))
# #     raster.manhattan = crop(x=raster.full,y=manhattan)
# # }
