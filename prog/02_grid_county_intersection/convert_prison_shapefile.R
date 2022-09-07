# WARNING: This is done locally on a computer which isn't the server where the rest is processed

rm(list=ls())

# declare root directory, folder locations and load essential stuff
project.folder = paste0(print(here::here()),'/')

# load required packages
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
library(purrr)

# load shapefile of all prisons in United States from https://hifld-geoplatform.opendata.arcgis.com/datasets/geoplatform::prison-boundaries/about
# projection of this shape file seems to be https://epsg.io/3857
us.national = readOGR(dsn=paste0(project.folder,"data/shapefiles/Prison_Boundaries/"),layer="Prison_Boundaries")
us.national$STATEFP = substr(us.national$COUNTYFIPS,1,2)

# remove non-mainland territories (assuming it's for entire mainland US) 
us.main = us.national[!us.national$STATEFP %in% c("02","15","60","66","69","71","72","78","NO"),]

# make projection match the FIPS one
us.fips.proj = proj4string(readOGR(dsn=paste0(project.folder,"data/shapefiles/fips/cb_2015_us_county_500k"),layer="cb_2015_us_county_500k"))
us.main = spTransform(us.main, CRS(us.fips.proj))

# save new shapefile
writeOGR(us.main, dsn=paste0(project.folder,"data/shapefiles/Prison_Boundaries/"),
         layer="Prison_Boundaries_Edited" ,driver = "ESRI Shapefile")

# Not run: test that original prison location file and new one are the same
# us.main.edited = readOGR(dsn=paste0(project.folder,"data/shapefiles/Prison_Boundaries/"),
#                          layer="Prison_Boundaries_Edited")
# plot(us.main); plot(us.main.edited,add=T,col='red')

