## To do:
x  - Color states differently
x  - Compare area of state vs. area of box (can find state area from original shp)
    x - automate process for all states
    x - get actual area of each state in km # Used state.area data as opposed to trying to calculate areas from usa48.df
        gArea() ?
    x - find way to convert lat/long based areas to km^2 # latlong2grid()
(6/2/16)        
x  - Match up STATE_ABBR with state FIPS
x  - check out Scandinavian mortality data
  - find contact people; send list to Robbie
x  - bin long lat data by state (see Robbies email)
    x - Connect point_id to state and FIPS code
(6/3/16)
x  - Talk to Dave or Eric (next door) aout getting ArcGIS (6/1/16)
      - Ask him to authorize liscence
#  - look up using "intersect" in R (similar functionality as in ArcGIS) # No longer needed
#  - fix column names from global_temp.R # Don't worry about for now
(6/1/16)


Below should take ~to end of week of 6/10

- systematic review of literature


## Locations of important files/coding

- blank map of USA map (48) in "usa48_global_lon_lat.R"
- code for creating and coloring all state boxes is in "usa48-squares.R"
- code for all state box areas is in "usa48-squares.R"
- converting long/lat to grid points in km units (km_usa48.df) in "usa48-squares.R"
- code for finding all global_lon_lat points within a given state is in "Binning Points to a State.R"
- Binned points to state, along with FIPS codes (state.points.codes.df) in "Binning Points to a State.R"

##

do it out manually for one state
write a function that does it for input state
automate it with a for loop

##

rm(d)
rm(d2)
rm(dat)
rm(dat2)
rm(mtcars2)
rm(t.df)
rm(t.table)
rm(tab)
rm(count)
rm(count2)
rm(pres)
rm(p.tmp)
rm(a)
rm(b)
rm(c)
rm(d)
rm(i)