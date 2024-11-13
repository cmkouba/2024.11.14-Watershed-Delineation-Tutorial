# Saiers Group tutorial for 11/14/2024

# Step 1. Save this R script in a new folder. Name it whatever you'd like,
# maybe something like "2024.11.14 Watershed Delineation Tutorial"

# Step 2. Open this R script in RStudio. In the upper right, click "Project", 
#"New Project", "Existing Directory", and navigate to the folder in which
# you just saved this R script. 

# This will create a new type of file, e.g. xxxxx.RProj. Then, we will be able
# to use something called "relative path names" in which we can
# specify the location of a data file in our computer without
# fulling typing out the pathname 
# (e.g. "C:/Users/username/Documents/GitHub/Tutorials/2024.11.14 Watershed Delineation Tutorial")

# 

# Load packages -----------------------------------------------------------

library(dataRetrieval) # usgs water quality retrieval package
library(sf) # for vector spatial data
library(terra) # for raster spatial data
library(geodata) # for counties layer
# library(maptools) # for labeling points
library(SAiVE) # for watershed delineation
library(here) # for relative directories


# Directories and Files ---------------------------------------------------

proj_dir = here::here() # Directs to the project folder (by pointing to the .Rproj file.)
scratch_dir = file.path(proj_dir, "scratch_work")
data_dir = file.path(proj_dir, "Data")
if(!dir.exists(data_dir)){dir.create(data_dir)}
dem_path =  file.path(data_dir, "CONUS_dem.tif") # where to find the big DEM file


# Spatial Data ----------------------------

# We need a local copy of our big spatial data layers.
# We can download them and pull them in as R objects 
if(!file.exists(file.path(proj_dir,"project_data.RData")) |
   !file.exists(dem_path)){
  source(file.path(proj_dir,"01_DataRetrieval_Cleaning_SaveLocal.R")) 
} else {
  load(file.path(proj_dir, "project_data.RData")) # Load data layers/tables
}
us_dem = rast(dem_path) # read in the raster data, since it doesn't like loading from an .RData file


# Plot some of our cool new spatial layers!
plot(us_counties$geometry[us_counties$NAME_1=="Connecticut",]) # Hello CT
plot(us_dem) # topography


# Look at our USGS gauge -----------------------------------------------------

w5_num = "01135300" #sleepers R

# Let's pull some data from the USGS!

# First we will retrieve the lat and long info from USGS
w5_info = readNWISdata(sites=w5_num, service="site")

# Convert lat and long into a spatial object in R
w5_spatial = st_as_sf(w5_info,
                      coords = c("dec_long_va","dec_lat_va"),
                      crs = st_crs(4326)) #assign WGS84 projection to coordinates

# Calculate Drainage Basin ------------------------------------------------

# Designate a pathname to save your delineated basin info
basins_path = file.path(data_dir,"basin.shp")

if(!file.exists(basins_path)){
  basin_info = drainageBasins(DEM=dem_path,
                              points=w5_spatial,
                              points_name_col = "site_no",
                              save_path = data_dir)
  basins = st_as_sf(basin_info$delineated_basins)
} else {
  basins = st_read(dsn = data_dir, layer = basins_path, quiet=T)
}
 
# What does our basin look like?
plot(basins$geometry, col = "darkcyan") # Pretty blocky! Why is this?
plot(w5_spatial$geometry, add=T, pch = 19, cex = 2, col = "darkblue")

# What about some context?
plot(us_counties$geometry[us_counties$NAME_1=="Vermont"])
plot(basins$geometry, add=T, col = "darkcyan") 
plot(w5_spatial$geometry, add=T, pch = 19, cex = 2, col = "darkblue")





# Side Quest: Let's look at w5 records ----------------------------------

# Let's retrieve ALL the data records the USGS maintains for this site
w5_records = readNWISdata(sites=w5_num, service="site", seriesCatalogOutput=TRUE)

# How on earth do we decode this table? 
# Look at the "parm_cd", or Parameter Code, column. Then, look at a different 
# giant table for clarification.
# https://help.waterdata.usgs.gov/codes-and-parameters/parameters
w5_records$parm_cd
# when did they start measuring stuff? Looks like the 90s, with some exceptions
w5_records$begin_date
w5_records$end_date
# And many of the records end in the 90s as well! 
# Perhaps they did an intensive data collection campaign for a short time?
# But why?

# Also, for a general picture, we can look at the parameter groups.
# https://help.waterdata.usgs.gov/codes-and-parameters/parameter-groups
unique(w5_records$parm_grp_cd)



# Geography side quest: Maps of the US

# plot(conus$geometry) # the lower 48!
# plot(us_states$geometry) # Pop Quiz, what is the state super far out on the right? (answer at the bottom)
# 
# # Pop quiz answer: It's the loooong tail of Aleutian islands!
# plot(us_states$geometry[us_states$NAME_1=="Alaska"])

