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

# print message detailing what is being processed
if(space.res=='fips'){print(paste0('processing ',year, ' ' , dname, ' ', time.res, ' ' , space.res))}
if(space.res=='zip'){print(paste0('processing ',year, ' ' , dname, ' ', time.res, ' ' , space.res, ' ', state))}
if(space.res=='ct'){print(paste0('processing ',year, ' ' , dname, ' ', time.res, ' ' , space.res, ' ', state))}

# create directory to place output files into
dir.output = paste0(project.folder,"output/")
if(space.res=='zip'){dir.output=paste0(dir.output,'zip/',state,'/')}
if(space.res=='fips'){dir.output=paste0(dir.output,'fips/')}
if(space.res=='ct'){dir.output=paste0(dir.output,'ct/')}
dir.output=paste0(dir.output,dname,'/')
ifelse(!dir.exists(dir.output), dir.create(dir.output, recursive = T), FALSE)

# load shapefiles of either FIPS or ZIP Codes (ZCTAs) or Census Tracts
if(space.res=='fips'){
    # load shapefile of entire United States from TBD
    us.national = readOGR(dsn=paste0(project.folder,"data/shapefiles/fips/cb_2015_us_county_500k"),layer="cb_2015_us_county_500k")
    
    # remove non-mainland territories (assuming it's for entire mainland US)
    us.main = us.national[!us.national$STATEFP %in% c("02","15","60","66","69","71","72","78"),]
}
if(space.res=='zip'){
    # load shapefile (just one state at a time) from TBD
    us.national = readOGR(dsn=paste0(project.folder,'data/shapefiles/zips/tl_2010_',state,'_zcta500'),layer=paste0('tl_2010_',state,'_zcta500'))
    us.national$STATEFP = us.national$STATEFP00 ; us.national$STATEFP00 = NULL
    us.national = us.national[us.national$STATEFP %in% c(state),]
    
    us.main = us.national
}
if(space.res=='ct'){
    # load shapefile (just one state at a time) from https://www.census.gov/cgi-bin/geo/shapefiles/index.php?year=2021&layergroup=Census+Tracts
    us.national = readOGR(dsn=paste0(project.folder,'data/shapefiles/ct/tl_2021_',state,'_tract'),layer=paste0('tl_2021_',state,'_tract'))
    # us.national$STATEFP = us.national$STATEFP00
    us.national = us.national[us.national$STATEFP %in% c(state),]
    
    us.main = us.national
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
        
        # perform over entire of mainland USA (FIPS) or chosen state (ZIP or CENSUS TRACT)
        weighted.area.national  = extract(x=raster.full,weights = TRUE, normalizeWeights=TRUE,y=us.main,fun=mean,df=TRUE,na.rm=TRUE)
        
        # create some unique ids for each area
        if(space.res=='fips'){weighted.area.national = data.frame(code=paste0(us.main$STATEFP,us.main$COUNTYFP), weighted.area.national[,2])}
        if(space.res=='zip'){weighted.area.national = data.frame(code=us.main$ZCTA5CE00, weighted.area.national[,2])}
        if(space.res=='ct'){weighted.area.national = data.frame(code=us.main$GEOID, weighted.area.national[,2])}

        # order by the unique id area code
        weighted.area.national = weighted.area.national[order(weighted.area.national$code),]
        
        # fix row names
        rownames(weighted.area.national) = NULL
        
        # fix column names
        if(space.res=='fips'){names(weighted.area.national) = c('fips',dname)}
        if(space.res=='zip'){names(weighted.area.national) = c('zcta',dname)}
        if(space.res=='ct'){names(weighted.area.national) = c('ct_id',dname)} # TBC
        
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
