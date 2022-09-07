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

# print message detailing what is being processed
if(space.res=='fips'){print(paste0('processing ',year, ' ' , dname, ' ', time.res, ' ' , space.res))}
if(space.res=='zip'){print(paste0('processing ',year, ' ' , dname, ' ', time.res, ' ' , space.res, ' ', state))}
if(space.res=='ct'){print(paste0('processing ',year, ' ' , dname, ' ', time.res, ' ' , space.res, ' ', state))}
if(space.res=='prison'){print(paste0('processing ',year, ' ' , dname, ' ', time.res, ' ' , space.res))}

# create directory to place output files into
dir.output = paste0(project.folder,"output/")
if(space.res=='zip'){dir.output=paste0(dir.output,'zip/',state,'/')}
if(space.res=='fips'){dir.output=paste0(dir.output,'fips/')}
if(space.res=='ct'){dir.output=paste0(dir.output,'ct/',state,'/')}
if(space.res=='prison'){dir.output=paste0(dir.output,'prison/')}
dir.output=paste0(dir.output,dname,'/')
ifelse(!dir.exists(dir.output), dir.create(dir.output, recursive = T), FALSE)

# load shapefiles of either FIPS or ZIP Codes (ZCTAs), Census Tracts or Prisons
if(space.res=='fips'){
    # load shapefile of entire United States from https://www.census.gov/geographies/mapping-files/2015/geo/carto-boundary-file.html
    us.national = readOGR(dsn=paste0(project.folder,"data/shapefiles/fips/cb_2015_us_county_500k"),layer="cb_2015_us_county_500k")
    
    # remove non-mainland territories (assuming it's for entire mainland US)
    us.main = us.national[!us.national$STATEFP %in% c("02","15","60","66","69","71","72","78"),]
}
if(space.res=='zip'){
    
    # load zcta by state from https://www2.census.gov/geo/tiger/TIGER2010/ZCTA5/2010/?C=D;O=A
    us.national = readOGR(dsn=paste0(project.folder,'data/shapefiles/zips/tl_2010_',state,'_zcta510'),layer=paste0('tl_2010_',state,'_zcta510'))
    us.national$STATEFP = us.national$STATEFP10 ; us.national$STATEFP10 = NULL
    us.national = us.national[us.national$STATEFP %in% c(state),]
    
    # OLD CODE previously in development but stalled
    skip=1; if(skip==0){
        # load shapefile (just one state at a time) from https://www.census.gov/cgi-bin/geo/shapefiles/index.php?year=2021&layergroup=ZIP+Code+Tabulation+Areas
        us.national = readOGR(dsn=paste0('~/data/climate/prism/shapefiles/tl_2021_us_zcta520'),layer=paste0('tl_2021_us_zcta520'))
        
        # load zip fips lookup to obtain state fips https://www.huduser.gov/portal/datasets/usps_crosswalk.html
        zip.fips.lookup = read.csv('~/data/climate/prism/shapefiles/ZIP_COUNTY_122021.csv',colClasses='character')[,c(1:2)]
        # manual addendum for unmatching values based on https://www.zipdatamaps.com/
        zip.fips.lookup.addendum = read.csv('~/data/climate/prism/shapefiles/ZIP_COUNTY_122021_addendum.csv',colClasses='character')[,c(1:2)]
        zip.fips.lookup = rbind(zip.fips.lookup,zip.fips.lookup.addendum)
        
        # join zip codes to county codes and extract state fips
        us.national.data = dplyr::left_join(us.national@data,zip.fips.lookup, by=c('ZCTA5CE20'='zip'))
        us.national.data$STATEFP = substr(us.national.data$county,1,2)
        us.national.data.zips = subset(us.national.data, STATEFP %in% c(state))$ZCTA5CE20
        
        # attach data with state FIPS back into shapefile 
        # us.national@data = us.national.data
        
        # what are the zip codes which do not match to a FIPs (and hence a state FIPS code?) and optional saving below
        # us.national.data.na <- as.data.frame(us.national.data[is.na(us.national.data$STATEFP),][,c('ZCTA5CE20')])
        # names(us.national.data.na) = 'zip'
        # write.csv(us.national.data.na, '~/data/climate/prism/shapefiles/ZIP_COUNTY_122021_addendum.csv',row.names = F) 
    }
    
    # OLD CODE previously in development but stalled
    skip=1; if(skip==0){
    # us.national = subset(us.national, ZCTA5CE20 %in% us.national.data.zips)
    
    # load shapefile for all ZIP Codes in US from https://www.census.gov/cgi-bin/geo/shapefiles/index.php?year=2021&layergroup=ZIP+Code+Tabulation+Areas
    # us.national = readOGR(dsn=paste0('~/data/climate/prism/shapefiles/tl_2021_us_zcta520'),layer=paste0('tl_2021_us_zcta520'))
    }
    
    us.main = us.national
}
if(space.res=='ct'){
    # load shapefile (just one state at a time) from https://www.census.gov/cgi-bin/geo/shapefiles/index.php?year=2021&layergroup=Census+Tracts
    us.national = readOGR(dsn=paste0(project.folder,'data/shapefiles/ct/tl_2021_',state,'_tract'),layer=paste0('tl_2021_',state,'_tract'))
    us.national = us.national[us.national$STATEFP %in% c(state),]
    
    us.main = us.national
}
if(space.res=='prison'){
    # load shapefile that was fixed in covert_prison_shapefile.R
    us.main = readOGR(dsn=paste0(project.folder,"data/shapefiles/Prison_Boundaries/"),
                           layer="Prison_Boundaries_Edited")
    
    # load shapefile of all prisons in United States from https://hifld-geoplatform.opendata.arcgis.com/datasets/geoplatform::prison-boundaries/about
    # projection of this shape file seems to be https://epsg.io/3857
    # us.national = readOGR(dsn=paste0(project.folder,"data/shapefiles/Prison_Boundaries/"),layer="Prison_Boundaries")
    # us.national$STATEFP = substr(us.national$COUNTYFIPS,1,2)
    # 
    # # remove non-mainland territories (assuming it's for entire mainland US) 
    # us.main = us.national[!us.national$STATEFP %in% c("02","15","60","66","69","71","72","78","NO"),]

    # make projection match the FIPS one on local computer (obtained by code just below)
    # us.fips.proj = proj4string(readOGR(dsn=paste0(project.folder,"data/shapefiles/fips/cb_2015_us_county_500k"),layer="cb_2015_us_county_500k"))
    # us.fips.proj = proj4string(readOGR(dsn=paste0(project.folder,"data/shapefiles/fips/cb_2015_us_county_500k"),layer="cb_2015_us_county_500k"))
    # us.main = spTransform(us.main, CRS("+proj=longlat +datum=NAD83 +no_defs"))
    # us.main = spTransform(us.main, CRS(us.fips.proj))
    
}

# get projection of shapefile
original.proj = proj4string(us.main)
# original.proj = comment(slot(us.main, "proj4string"))

# load raster and make same projection as zip code map
if(time.res=='annual'){
    raster.full = raster(paste0('~/data/climate/prism/asc/PRISM_',dname,'_stable_4kmM3_',year,'_all_asc/PRISM_',dname,'_stable_4kmM3_',year,'_asc.asc'))
}

# perform analysis across every day of selected year
if(time.res=='daily'){
    # loop through each raster file for each day and summarise
    dates = seq(as.Date(paste0('0101',year),format="%d%m%Y"), as.Date(paste0('3112',year),format="%d%m%Y"), by=1)
    
    # empty dataframe to load summarised national daily values into
    weighted.area.national.total = data.frame()
    
    # loop through each day of the year and perform analysis
    print(paste0('Processing dates in ',year))
    for(date in dates){
        
        print(format(as.Date(date), "%d/%m/%Y"))
        
        day = format(as.Date(date), "%d")
        month = format(as.Date(date), "%m")
        day.month = paste0(month,day)
        
        # load raster for relevant date
        if(dname!='wbgtmax'){
            raster.full = raster(paste0('~/data/climate/prism/bil/PRISM_',dname,'_stable_4kmD2_',year,'0101_',year,'1231_bil/PRISM_',dname,'_stable_4kmD2_',year,day.month,'_bil.bil'))
            raster.full = projectRaster(raster.full, crs=original.proj)
        }
        if(dname == 'wbgtmax'){ 
            raster.full = raster(paste0('~/data/climate/prism/tif/PRISM_',dname,'_stable_4kmD2_',year,'0101_',year,'1231_tif/PRISM_',dname,'_stable_4kmD2_',year,day.month,'.tif'))
            raster.full = projectRaster(raster.full, crs=original.proj)
            raster.full = reclassify(raster.full, cbind(-Inf, -1000, NA), right=FALSE) # get rid of huge negative values if it's wbgtmax
        }
        pdf('~/a.pdf')
        plot(raster.full); plot(us.main,add=T)
        dev.off()
        
        # perform over entire of mainland USA (FIPS or ZIP) or chosen state (CENSUS TRACT)
        weighted.area.national  = extract(x=raster.full, # raster (x) to extract from
                                          y=us.main,  # shapefile (y) to overlay and take values forward 
                                          weights = TRUE, # calculate weights used for averaging (area-weighted mean)
                                          normalizeWeights=TRUE, # normalize weights to always add up to 1 if, say, some of the shapefile is not covered by a raster 
                                          fun=mean, # take the mean of the values
                                          df=TRUE, # return as a dataframe object
                                          na.rm=TRUE # remove NAs before function (mean) applied so that NAs aren't returned
                                          )
        
        # create some unique ids for each area
        if(space.res=='fips'){weighted.area.national = data.frame(code=paste0(us.main$STATEFP,us.main$COUNTYFP), weighted.area.national[,2])}
        if(space.res=='zip'){weighted.area.national = data.frame(code=us.main$ZCTA5CE10, weighted.area.national[,2])}
        if(space.res=='ct'){weighted.area.national = data.frame(code=us.main$GEOID, weighted.area.national[,2])}
        if(space.res=='prison'){weighted.area.national = data.frame(code=us.main$FID, weighted.area.national[,2])}
        
        # order by the unique id area code
        weighted.area.national = weighted.area.national[order(weighted.area.national$code),]
        
        # fix row names
        rownames(weighted.area.national) = NULL
        
        # fix column names
        if(space.res=='fips'){names(weighted.area.national) = c('fips',dname)}
        if(space.res=='zip'){names(weighted.area.national) = c('zcta',dname)}
        if(space.res=='ct'){names(weighted.area.national) = c('ct_id',dname)}
        if(space.res=='prison'){names(weighted.area.national) = c('prison_id',dname)}
        
        # add date details
        weighted.area.national$date = format(as.Date(date), "%d/%m/%Y")
        weighted.area.national$day = day
        weighted.area.national$month = month
        weighted.area.national$year = year
        
        # add iteratively to total table of year
        weighted.area.national.total = data.table::rbindlist(list(weighted.area.national.total,weighted.area.national))
    }
}

# save output
if(space.res=='zip'){
    saveRDS(weighted.area.national.total,paste0(dir.output,'weighted_area_raster_zip_',state,'_',dname,'_',time.res,'_',as.character(year),'.rds'))
    write.csv(weighted.area.national.total,paste0(dir.output,'weighted_area_raster_zip_',state,'_',dname,'_',time.res,'_',as.character(year),'.csv'),
              row.names = F)
}
if(space.res=='fips'){
    saveRDS(weighted.area.national.total,paste0(dir.output,'weighted_area_raster_fips_',dname,'_',time.res,'_',as.character(year),'.rds'))
    write.csv(weighted.area.national.total,paste0(dir.output,'weighted_area_raster_fips_',dname,'_',time.res,'_',as.character(year),'.csv'),
                     row.names = F)
}
if(space.res=='ct'){
    saveRDS(weighted.area.national.total,paste0(dir.output,'weighted_area_raster_census_tract_',dname,'_',time.res,'_',as.character(year),'.rds'))
    write.csv(weighted.area.national.total,paste0(dir.output,'weighted_area_raster_census_tract_',dname,'_',time.res,'_',as.character(year),'.csv'),
              row.names = F)
}
if(space.res=='prison'){
  saveRDS(weighted.area.national.total,paste0(dir.output,'weighted_area_raster_prison_',dname,'_',time.res,'_',as.character(year),'.rds'))
  write.csv(weighted.area.national.total,paste0(dir.output,'weighted_area_raster_prison_',dname,'_',time.res,'_',as.character(year),'.csv'),
            row.names = F)
}