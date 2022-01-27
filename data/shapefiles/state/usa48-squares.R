install.packages("rgdal")
install.packages("rgeos")
install.packages("maptools")
install.packages("ggplot2")
install.packages("plyr")
install.packages("dplyr")
install.packages("maps")
library("rgdal")
library("rgeos")
library("maptools")
library("ggplot2")
library("plyr")
library("dplyr")
library("maps")

setwd("C:/Users/lmitchis/Documents/R/usa_shapefiles")

usa48.df = read.csv("usa48.csv", header=TRUE)
global_lon_lat.df = read.csv("global_lon_lat.csv", header=TRUE)
#rect.long.lat <- ddply(usa48.df,.(STATE_ABBR),summarize,min.long=min(long),max.long=max(long),min.lat=min(lat),max.lat=max(lat))

## Adding State FIPSstate_fips
fips_codes <- read.csv("fips_codes_website.csv")
rect.long.lat2 = join(rect.long.lat, fips_codes, by="STATE_ABBR")
# Should probably remove some of the columns

#write.table(rect.long.lat, file="rect-long-lat.txt")
rect.long.lat = read.table(file="rect-long-lat.txt", header=TRUE)

#write.table(rect.long.lat2, file="rect-long-lat2.txt")
rect.long.lat2 = read.table(file="rect-long-lat2.txt", header=TRUE)

points <- function(staterow) {
  a <- rect.long.lat[staterow, 3] # max long
  b <- rect.long.lat[staterow, 2] # min long
  c <- rect.long.lat[staterow, 5] # max lat
  d <- rect.long.lat[staterow, 4] # min lat
  corners.df <- data.frame(long=c(a,b,a,b),lat=c(c,c,d,d))
  return(corners.df) }

# Empty dataframe
dat <- data.frame(state_rows=NA, long=NA, lat=NA)#, state_abbr=NA)
for (i in rect.long.lat$STATE_ABBR) {
  staterow <- which(rect.long.lat$STATE_ABBR==i)
  #state_abbr <- rect.long.lat$STATE_ABBR==i
  a <- rect.long.lat[staterow, 3] # max long
  b <- rect.long.lat[staterow, 2] # min long
  c <- rect.long.lat[staterow, 5] # max lat
  d <- rect.long.lat[staterow, 4] # min lat
  corners.df <- data.frame(state_rows=staterow, long=c(a,b,a,b), lat=c(c,c,d,d))#, state_abbr=state_abbr)
  dat <- rbind(corners.df,dat)
}
dat <- na.omit(dat)

### Function to color by state

usa.squares <- function(rect.long.lat) {  # input = rect.long.lat
  plot <- ggplot() +
    geom_polygon(data=usa48.df, aes(x=long, y=lat, group=group, alpha=1), color="black", fill="white")
  for (i in rect.long.lat$STATE_ABBR) {
    corners.temp <- points(which(rect.long.lat$STATE_ABBR==i))
    plot <- plot + geom_rect(data=corners.temp, alpha=0.2, fill=factor(which(rect.long.lat$STATE_ABBR==i)), aes(xmin=min(long), xmax=max(long), ymin=min(lat), ymax=(max(lat))))
    + theme_void()
  }
  return(plot)
}
usa.squares(rect.long.lat)

# Generate distinct colors for states
#install.packages("randomcoloR")
#library(randomcoloR)
#n <- 50
#palette <- distinctColorPalette(n)
# Shows colors
#pie(rep(1,n), col=palette)


## Function/loop to find area of each state's box

# Function for a single state
statearea <- function(i) { #"staterow" from rect.long.lat
  # Put i value in quotations
  staterow <- which(rect.long.lat$STATE_ABBR==i)
  a <- abs(rect.long.lat[staterow, 3]) # max long
  b <- abs(rect.long.lat[staterow, 2]) # min long
  c <- abs(rect.long.lat[staterow, 5]) # max lat
  d <- abs(rect.long.lat[staterow, 4]) # min lat
#  box_area <- (a-b)*(c-d)
  box_area <- (b-a)*(c-d)
return(box_area)  
}

# For loop to cycle through state rectangle areas using above function
box.areas.df <- data.frame()
for (i in rect.long.lat$STATE_ABBR) {
  dummy <- data.frame(STATE_ABBR=i,approx.area=statearea(i))
  box.areas.df <- rbind(box.areas.df,dummy) 
}
# box.areas.df now has box areas for all states


## Box areas in km

install.packages("SpatialEpi")
library("SpatialEpi")
library("sp")

# Plotting USA map in km (rather than long/lat coords)
temp_usa <- data.frame(long=usa48.df$long, lat=usa48.df$lat)
km_usa48.df <- latlong2grid(temp_usa)
# Keep x and y as those names rather than long/lat to distinguish between coordinate units
km_usa48.df <- cbind(STATE_ABBR=usa48.df$STATE_ABBR, km_usa48.df)
rm(temp_usa)

# Can compare plots in km to long/lat
plot(km_usa48.df$x, km_usa48.df$y)
plot(usa48.df$long, usa48.df$lat)

# rect.long.lat equivalent for units km
km_rect <- ddply(km_usa48.df,.(STATE_ABBR),summarize,min.x=min(x),max.x=max(x),min.y=min(y),max.y=max(y))

# Function for a single state in km
km_statearea <- function(i) { #"staterow" from rect.long.lat
  # Put i value in quotations
  staterow <- which(rect.long.lat$STATE_ABBR==i)
  a <- abs(km_rect[staterow, 3]) # max long
  b <- abs(km_rect[staterow, 2]) # min long
  c <- abs(km_rect[staterow, 5]) # max lat
  d <- abs(km_rect[staterow, 4]) # min lat
  #  box_area <- (a-b)*(c-d)
  km_box_area <- (b-a)*(c-d)
  return(km_box_area)  
}

# Returning area in km^2 for all states
km_box.areas.df <- data.frame()
for (i in km_rect$STATE_ABBR) {
  dummy <- data.frame(STATE_ABBR=i,approx.area.km2=km_statearea(i))
  km_box.areas.df <- rbind(km_box.areas.df,dummy) 
}
# km_box.areas.df now has box areas for all states

## Comparing box area vs actual area in km

#Note: used "real area" data from file "state.area" as opposed to area within boundies given in usa48.df
actual.area.df <- data.frame(STATE_ABBR=state.abb, actual.area.km2=state.area*2.58998811)

areas.compare.df <- join(km_box.areas.df, actual.area.df, by="STATE_ABBR")
areas.compare.df <- na.omit(areas.compare.df)
areas.compare.df <- data.frame(STATE_ABBR=areas.compare.df$STATE_ABBR, approx.area.km2=areas.compare.df$approx.area.km2, actual.area.km2=areas.compare.df$actual.area.km2, difference=areas.compare.df$approx.area.km2-areas.compare.df$actual.area.km2)

write.csv(areas.compare.df, file="statearea_comparison_km2.csv")
