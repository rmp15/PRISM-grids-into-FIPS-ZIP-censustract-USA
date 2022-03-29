# This script will:

# load results from particular year
# plot various combinations of data
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
dname = 'tmean'
time.res = 'daily'
space.res = 'fips'
state = 'XX' # unused here

print('running check_prism.R')
print(args)

# create directory for file loading
dir.input = paste0(project.folder,"output/grid_county_intersection_raster_prism/")
if(space.res=='zip'){dir.input=paste0(dir.input,'zip/',state,'/')}
if(space.res=='fips'){dir.input=paste0(dir.input,'fips/')}
ifelse(!dir.exists(dir.input), dir.create(dir.input), FALSE)

# output directory
dir.output = paste0(project.folder,'plots/tmean/')
ifelse(!dir.exists(dir.output), dir.create(dir.output,recursive=TRUE), FALSE)

# x-axis title
if(dname=='tmean'){x_axis_title='Daily temperature (C)'}
if(dname=='ppt'){x_axis_title='Daily precipitation (mm)'}
if(dname=='wbgtmax'){x_axis_title='Wet bulb globe temperature (C)'}

pdf(paste0(dir.output,'by_state_',dname,'_',time.res,'_1988_2020.pdf'),paper='a4r',width=0,height=0)

for(year in c(1988:2020)){
    
    print(year)

    if(space.res=='zip'){
        dat = readRDS(paste0(dir.input,'weighted_area_raster_zip_',state,'_',dname,'_',time.res,'_',as.character(year),'.rds'))
    
        # output directory
        dir.output = paste0(dir.input,'plots/',year,'/',state,'/')
        ifelse(!dir.exists(dir.output), dir.create(dir.output,recursive=TRUE), FALSE)
    
    }
    if(space.res=='fips'){
        dat = readRDS(paste0(dir.input,'weighted_area_raster_fips_',dname,'_',time.res,'_',as.character(year),'.rds'))
    
        # attach state names
        dat$state.fips = as.numeric(substr(dat$fips,1,2))
        fips.lookup <- read.csv('~/git/mortality/USA/state/data/fips_lookup/name_fips_lookup.csv')
        fips.lookup = fips.lookup[!(fips.lookup$fips%in%c(2,15)),c(1:2)]
        dat = merge(dat,fips.lookup,by.x='state.fips',by.y='fips',all.x=TRUE)
    }

    
    # plot histogram of entire year by state
    print(
    ggplot() +
        geom_histogram(data=dat,aes(get(dname))) +
        xlab(x_axis_title) + ylab('Count') +
        xlim(c(-100,40)) + 
        facet_wrap(~full_name, scales = 'free_y') +
        ggtitle(year) + 
        theme_bw() + theme( panel.grid.major = element_blank(),axis.text.x = element_text(angle=90),
        axis.ticks.x=element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),
        panel.border = element_rect(colour = "black"),strip.background = element_blank(),
        legend.position = 'bottom',legend.justification='center',
        legend.background = element_rect(fill="white", size=.5, linetype="dotted"))
    )
}

dev.off()
