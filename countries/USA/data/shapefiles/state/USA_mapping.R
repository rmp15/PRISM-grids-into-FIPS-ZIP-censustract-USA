## Plotting USA shapefile map using ggplot2

install.packages("rgdal")
install.packages("maptools")
install.packages("ggplot2")
install.packages("plyr")
install.packages("dplyr")

library("rgdal")
library("maptools")
library("ggplot2")
library("plyr")
library("dyplyr")

setwd("C:/Users/lmitchis/Documents/R/usa_shapefiles")

usa = readOGR(dsn=".", layer="states")
usa@data$STATE_NAME = rownames(usa@data)
usa.points <- broom::tidy(usa)
usa.df = join(usa.points, usa@data, by="id")
# Problem was that "usa.points" and "usa@data" didn't have a common column name


# Made new version of "usa" and renamed "STATE_NAME" as "id" to match the "id" column in "usa.points".
write.table(usa, file="usa.table.txt")
usa2 = read.table(file="usa2.table.txt", header=TRUE)

# Making the table to base map on via joining "usa.points" and
# "usa2" with the common factor
usa.df = join(usa.points, usa2, by="id")

# Plotting
ggplot(usa.df) + 
  aes(long,lat,group=group,fill=SUB_REGION) + 
  geom_polygon() +
  geom_path(color="white") +
  coord_equal() +
  scale_fill_brewer("")

## Trying to add health data

# Data on asthma in US by state. Saved as .csv file.
# Data from: http://www.cdc.gov/asthma/most_recent_data_states.htm
asthma = read.table(file="asthma_prevalence.txt", header=TRUE)

# Edited column name to match the one in usa2
head(asthma)

# Joining usa2 and asthma by "STATE_ABBR"
usa.asthma.df = join(usa2, asthma, by="STATE_ABBR")
head(usa.asthma.df)

# Tried to plot ggplot(usa.asthma.df)
# "Error in eval(expr, envir, enclos) : object 'long' not found"

# Joining asthma table to usa.df - now has lat, long data
usa.asthma.df = join(usa.df, asthma, by="STATE_ABBR")
head(usa.asthma.df)

# Plotting map with asthma data
ggplot(usa.asthma.df) + 
  aes(long, lat, group=group, fill=prev_percent) + 
  geom_polygon() +
  geom_path(color="white") +
  coord_equal() +
  labs(list(title="Adult Asthma in the USA, 2013", x="Longitude", y="Latitude")) +
# Put edits for legend within the scale(...) part
  scale_fill_distiller(palette="Reds", direction=1, name="Prevalence %")
# Adding below makes the scale look discrete instead of continous
  #guides(fill=guide_legend(keywidth=2, keyheight=1))



## Same as above but without Alaska (AK) and Hawaii (HI)


# Joining asthma table to usa.df - now has lat, long data
usa48.df = read.csv("usa48.csv", header=TRUE)
usa48.asthma.df = join(usa48.df, asthma, by="STATE_ABBR")
head(usa48.asthma.df)

ggplot(usa48.asthma.df) + 
  aes(long, lat, group=group, fill=prev_percent) + 
  geom_polygon() +
  geom_path(color="white") +
  coord_equal() +
  labs(list(title="Adult Asthma in the USA, 2013", x="Longitude", y="Latitude")) +
  # Put edits for legend within the scale(...) part
  scale_fill_distiller(palette="Reds", direction=1, name="Prevalence %") + 
  # Removes background and axis & legend labels
  #theme_void()
  theme(panel.background = element_blank())
