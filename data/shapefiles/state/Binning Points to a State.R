install.packages("ggplot2")
install.packages("plyr")
install.packages("dplyr")
install.packages("sp")
install.packages("rgdal")
install.packages("rgeos")
install.packages("maps")
install.packages("maptools")
library("ggplot2")
library("plyr")
library("dplyr")
library("sp")
library("rgdal")
library("rgeos")
library("maps")
library("maptools")


setwd("C:/Users/lmitchis/Documents/R/usa_shapefiles")

usa48.df = read.csv("usa48.csv", header=TRUE)
global_lon_lat.df = read.csv("global_lon_lat.csv", header=TRUE)
rect.long.lat = read.table(file="rect-long-lat.txt", header=TRUE)
fips_codes <- read.csv("fips_codes_website.csv")
#rect.long.lat2 = join(rect.long.lat, fips_codes, by="STATE_ABBR")

### Trying to bin points in a state box

## Function/loop to find area of each state's box

# Function for a single state area
statearea <- function(i) { #"staterow" from rect.long.lat
  # Put i value in quotations
  staterow <- which(rect.long.lat$STATE_ABBR==i)
  a <- rect.long.lat[staterow, 3] # max long
  b <- rect.long.lat[staterow, 2] # min long
  c <- rect.long.lat[staterow, 5] # max lat
  d <- rect.long.lat[staterow, 4] # min lat
  box_area <- (a-b)*(c-d)
  return(box_area)  
}
# Function looping through state rectangle areas
box.areas.df <- data.frame()
for (i in rect.long.lat$STATE_ABBR) {
  dummy <- data.frame(state=i,approx.area=statearea(i))
  box.areas.df <- rbind(box.areas.df,dummy) 
}


## Outputs all points from global_lon_lat.df that fall within a given state

state.points <- function(state) { # STATE_ABBR from rect.long.lat.df
  staterow <- which(rect.long.lat$STATE_ABBR==state)
  
  min.long <- rect.long.lat[staterow, 2]
  max.long <- rect.long.lat[staterow, 3]
  min.lat <- rect.long.lat[staterow, 4]
  max.lat <- rect.long.lat[staterow, 5]
  state.pts <- subset(global_lon_lat.df, min.long<long & long<max.long & min.lat<lat & lat<max.lat)
  STATE_ABBR <- c(state)
  
  state.pts <- cbind(STATE_ABBR, state.pts)
  return(state.pts)
}


####


install.packages("SpatialEpi")
library("SpatialEpi")

# Saving blank usa48 plot
usa48map <- ggplot(usa48.df) + 
  aes(long,lat,group=group) +  
  geom_polygon(fill="white") +
  geom_path(color="black") +
  coord_equal() +
  theme_void()

# Saving global long/lat plot
globalmap <- ggplot(global_lon_lat.df) + 
  aes(long, lat) + 
  geom_point() +
  theme_void()

# Plotting usa48.df points (long/lat not km) as Spatial Points
coords_usa48 <- as.data.frame(cbind(usa48.df$long, usa48.df$lat))
points_usa48 <- SpatialPoints(coords_usa48)
plot(points_usa48)

# Plots global_lon_lat.df as Spatial Points
coords_global <- as.data.frame(cbind(global_lon_lat.df$long, global_lon_lat.df$lat))
points_global <- SpatialPoints(coords_global)
plot(points_global)



## Binning global_lon_lat.df points

# Function that returns state given a coordinate pair (long, lat)
latlong2state <- function(pointsDF) {
  states <- map('state', fill=TRUE, col="transparent", plot=FALSE)
  IDs <- sapply(strsplit(states$names, ":"), function(x) x[1])
  states_sp <- map2SpatialPolygons(states, IDs=IDs,
                                   proj4string=CRS("+proj=longlat +datum=WGS84"))
  pointsSP <- SpatialPoints(pointsDF, 
                            proj4string=CRS("+proj=longlat +datum=WGS84"))
  indices <- over(pointsSP, states_sp)
  stateNames <- sapply(states_sp@polygons, function(x) x@ID)
  stateNames[indices]
}

# globalpoints.DF is just the long lat pairs from global_lon_lat; this can then be fed into latlong2state function
globalpointsDF <- data.frame(long=global_lon_lat.df$long, lat=global_lon_lat.df$lat)
tempdat <- data.frame(point_id=global_lon_lat.df$point_id, statename=latlong2state(globalpointsDF))
tempdat <- as.data.frame(na.omit(tempdat))
# tempdat now has point_id and full state name
# Note: There's a large difference between number of points returned from state.points("STATE_ABBR") function vs. in tempdat DF.
# This is because state.points is based off the rectangle estimate, not the actual state boundaries.



### Attaching FIPS codes

# Table with STATE_ABBR and statename (lowercase)
state.name <- data.frame(STATE_ABBR=state.abb, statename=tolower(state.name))

# Table with states and their state codes based on fips_codes DF
state.codes <- unique(fips_codes[c("STATE_ABBR", "state_fips")])

# Using join() to add on info to points
state.points.codes.df <- join(tempdat, state.name, by="statename")
state.points.codes.df <- join(state.points.codes.df, state.codes, by="STATE_ABBR")
state.points.codes.df <- join(state.points.codes.df, global_lon_lat.df, by="point_id")

write.csv(state.points.codes.df, file="state.points.codes.csv")
state.points.codes.df <- read.csv(file="state.points.codes.csv", header=TRUE)



### Manually adding states and state points to state.points.codes.df
# Collected points for the missing/underrepresented states via state.points function

## Getting all the points for those states

manual.state.points <- data.frame(STATE_ABBR=NA, point_id=NA, long=NA, lat=NA)
manual.state.points <- na.omit(manual.state.points)

#Need for find point for DC??
manual.state.points <- rbind(manual.state.points, state.points("MA"))
manual.state.points <- rbind(manual.state.points, state.points("DE"))
manual.state.points <- rbind(manual.state.points, state.points("RI"))
manual.state.points <- rbind(manual.state.points, state.points("NH"))
manual.state.points <- rbind(manual.state.points, state.points("NJ"))
manual.state.points <- rbind(manual.state.points, state.points("VT"))
manual.state.points <- rbind(manual.state.points, state.points("MD"))
manual.state.points <- rbind(manual.state.points, state.points("ME"))
manual.state.points <- rbind(manual.state.points, state.points("CT"))

## Seeing if any of those points lie in the ocean
smallstates <- ggplot(manual.state.points) + aes(long,lat) + geom_point()

# Took point coordinates from smallstates and mapped them on "http://batchgeo.com/"
# Removed points that were in the ocean or out of state and reassigned the points' state if needed be, and added fips (did this in Excel)
# Saved this edited set of points as smallstates.csv
smallstates.df <- read.csv("smallstates.csv", header=TRUE)


## Adding fips codes

# Table with STATE_ABBR and statename (lowercase) and adding DC
state.names <- data.frame(STATE_ABBR=state.abb, statename=tolower(state.name))
dc <- data.frame(STATE_ABBR="DC", statename=tolower("Washington DC"))
state.names <- rbind(state.names, dc)

# Table with states and their state codes based on fips_codes DF
state.codes <- unique(fips_codes[c("STATE_ABBR", "state_fips")])

# Using merge() to add on info to points
state.info <- merge(state.codes, state.names, by="STATE_ABBR")
small.points.codes.df <- merge(smallstates.df, state.info, by=c("STATE_ABBR"))

## Removing those states from the original state.points.codes.df
# Removed them so there wouldn't be duplicates when I add in manual.state.points

state.points.codes.df <- state.points.codes.df[-1]

state.points.codes.df <- subset(state.points.codes.df, STATE_ABBR!="MA")
state.points.codes.df <- subset(state.points.codes.df, STATE_ABBR!="DE")
state.points.codes.df <- subset(state.points.codes.df, STATE_ABBR!="DC")
state.points.codes.df <- subset(state.points.codes.df, STATE_ABBR!="RI")
state.points.codes.df <- subset(state.points.codes.df, STATE_ABBR!="NH")
state.points.codes.df <- subset(state.points.codes.df, STATE_ABBR!="NJ")
state.points.codes.df <- subset(state.points.codes.df, STATE_ABBR!="VT")
state.points.codes.df <- subset(state.points.codes.df, STATE_ABBR!="MD")
state.points.codes.df <- subset(state.points.codes.df, STATE_ABBR!="ME")
state.points.codes.df <- subset(state.points.codes.df, STATE_ABBR!="CT")

## Adding in the new/complete sets of points for those states back into state.points.codes.df

state.points.codes.df <- rbind(state.points.codes.df, small.points.codes.df)

write.csv(state.points.codes.df, file="state.points.codes.csv")
state.points.codes.df <- read.csv(file="state.points.codes.csv", header=TRUE)

# state.points.codes.df is now updated with all states and DC
# Note: RI and DC still only have one point each

