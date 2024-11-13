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
library(maptools) # for labeling points
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
