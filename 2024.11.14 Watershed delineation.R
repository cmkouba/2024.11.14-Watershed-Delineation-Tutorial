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


# Data Retrieval and Cleaning; Save Local Copy ----------------------------

# We need a local copy of our big spatial data layers.
# We can download them and pull them in as R objects 
if(!file.exists(file.path(proj_dir,"project_data.RData"))){
  source(file.path(proj_dir,"01_DataRetrieval_Cleaning_SaveLocal.R")) 
}

# Plot some of our cool new spatial layers!
plot(conus$geometry) # the lower 48!
plot(us_counties$geometry[us_counties$NAME_1=="Connecticut",]) # Hello CT
plot(us_dem) # topography
plot(us_states$geometry) # pop quiz, what is state super far out on the right? (answer at the bottom)


# Pick our USGS gauge -----------------------------------------------------

w2_num = "01135300" #sleepers R

# Let's pull some data from the USGS!

# First we will retrieve the lat and long info from USGS
w2_info = readNWISdata(sites=w2_num, service="site")

# Alternatively, let's retrieve ALL the data records the USGS
# maintains for this site
w2_records = readNWISdata(sites=w2_num, service="site", seriesCatalogOutput=TRUE)

# How on earth do we decode this table? 
# Look at the "parm_cd", or Parameter Code, column. Then, look at a different 
# giant table for clarification.
# https://help.waterdata.usgs.gov/codes-and-parameters/parameters
w2_records$parm_cd
# when did they start measuring stuff? Looks like the 90s, with some exceptions
w2_records$begin_date
w2_records$end_date
# And many of the records end in the 90s as well! 

# Or, for a general picture, we can look at the parameter groups.
# https://help.waterdata.usgs.gov/codes-and-parameters/parameter-groups
unique(w2_records$parm_grp_cd)









# Pop quiz answer: It's the loooong tail of Aleutian islands!
plot(us_states$geometry[us_states$NAME_1=="Alaska"])

