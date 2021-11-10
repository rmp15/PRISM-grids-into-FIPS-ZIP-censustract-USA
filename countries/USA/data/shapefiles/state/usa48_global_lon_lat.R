## Trying to plot the global points (global_lat_long)

install.packages("rgdal")
install.packages("maptools")
install.packages("ggplot2")
install.packages("plyr")
install.packages("dplyr")

library("rgdal")
library("maptools")
library("ggplot2")
library("plyr")
library("dplyr")

setwd("C:/Users/lmitchis/Documents/R/usa_shapefiles")

usa48.df = read.csv("usa48.csv", header=TRUE)
global_lon_lat.df = read.csv("global_lon_lat.csv", header=TRUE)

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

# Plots usa48.df over global_lon_lat
globalmap + geom_polygon(data=usa48.df, aes(x=long, y=lat, group=group))

# Plots global_lon_lat over usa48.df
# http://zevross.com/blog/2014/07/16/mapping-in-r-using-the-ggplot2-package/
ggplot() +
  geom_polygon(data=usa48.df, aes(x=long, y=lat, group=group)) +
  geom_path(color="white") + 
  geom_point(data=global_lon_lat.df, aes(x=long, y=lat), color="navy") + 
  theme_void()

## Plotting boundary boxes for each state

# Trial run for WA

# Points for WA
a = -116.9191323 #max long
b = -124.7327693 #min long
c = 48.99993137 #max lat
d = 45.54309237 #min lat

# Makes df of coordinate pairs for each vertex
ends.df <- data.frame(long=c(a,b,a,b),lat=c(c,c,d,d))
view(ends.df)

# Plots box transparent box over WA
ggplot() +
  geom_rect(data=ends.df, aes(xmin=min(long), xmax=max(long), ymin=min(lat), ymax=(max(lat)))) +
  geom_polygon(data=usa48.df, aes(x=long, y=lat, group=group, alpha=0.8), color="black", fill="white")


## Trying to create way to automatically plot for each state

# Produces dataframe of max and min of long and lat by state
rect.long.lat <- ddply(usa48.df,.(STATE_ABBR),summarize,min.long=min(long),max.long=max(long),min.lat=min(lat),max.lat=max(lat))

a <- rect.long.lat$max.long #max long
b <- rect.long.lat$min.long #min long
c <- rect.long.lat$max.lat #max lat
d <- rect.long.lat$min.lat #min lat
corners.df <- data.frame(long=c(a,b,a,b),lat=c(c,c,d,d))

ggplot() +
  geom_rect(data=corners.df, aes(xmin=min(long), xmax=max(long), ymin=min(lat), ymax=(max(lat)))) +
  geom_polygon(data=usa48.df, aes(x=long, y=lat, group=group, alpha=0.8), color="black", fill="white")

# Function to plot rectangle around a state

points <- function(staterow) { # staterow based on rect.long.lat
  #staterow <- which(rect.long.lat$STATE_ABBR = "STATE_ABBR")
  a <- rect.long.lat[staterow, 3] # max long
  b <- rect.long.lat[staterow, 2] # min long
  c <- rect.long.lat[staterow, 5] # max lat
  d <- rect.long.lat[staterow, 4] # min lat
  corners.df <- data.frame(long=c(a,b,a,b),lat=c(c,c,d,d))
  #return(corners.df)
  
  statebox <- ggplot() +
    geom_rect(data=corners.df, aes(xmin=min(long), xmax=max(long), ymin=min(lat), ymax=(max(lat)))) +
    geom_polygon(data=usa48.df, aes(x=long, y=lat, group=group, alpha=0.8), color="black", fill="white") +
    scale_fill_brewer("STATE_ABBR")
  return(statebox)
}

# Try to write for loop to go through and do points() for each state
#for (n in rect.long.lat) {
#  points(n)
#}

# Function points2()

points2 <- function(staterow) {
  #staterow <- which(rect.long.lat$STATE_ABBR = "STATE_ABBR")
  a <- rect.long.lat[staterow, 3] # max long
  b <- rect.long.lat[staterow, 2] # min long
  c <- rect.long.lat[staterow, 5] # max lat
  d <- rect.long.lat[staterow, 4] # min lat
  corners.df <- data.frame(long=c(a,b,a,b),lat=c(c,c,d,d))
  return(corners.df) }

# Plots 3 state boxes manually

ggplot() +
  geom_rect(data=points2(1), aes(xmin=min(long), xmax=max(long), ymin=min(lat), ymax=(max(lat)))) +
  geom_rect(data=points2(2), aes(xmin=min(long), xmax=max(long), ymin=min(lat), ymax=(max(lat)))) +
  geom_rect(data=points2(3), aes(xmin=min(long), xmax=max(long), ymin=min(lat), ymax=(max(lat)))) +
  geom_polygon(data=usa48.df, aes(x=long, y=lat, group=group, alpha=0.8), color="black", fill="white") +
  scale_fill_brewer("STATE_ABBR")

ggplot() +
  geom_rect(data=points2(3), aes(xmin=min(long), xmax=max(long), ymin=min(lat), ymax=(max(lat)))) +
  geom_polygon(data=usa48.df, aes(x=long, y=lat, group=group, alpha=0.8), color="black", fill="white") +
  scale_fill_brewer("STATE_ABBR")