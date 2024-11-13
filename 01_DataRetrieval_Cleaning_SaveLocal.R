# Script 01. Data Retrieval and Cleaning; Save Local Copy

clean_as_go = F # if F, keep the datasets on local drive (for development)
proj_proj = 4269 # project projection for spatial layers. match HUC projection

# US state boundaries --------------------------------------------
us_states = gadm(country = "USA", level = 1, path = scratch_dir)
us_states = st_as_sf(us_states)
# US county boundaries ------------------------------------------

#Downloads a big polygon dataset
us_counties = gadm(country = "USA", level = 2, path = scratch_dir)
# convert to sf (simple feature) for compatibility with later functions
us_counties = st_as_sf(us_counties)

if(clean_as_go==T){file.remove(file.path(scratch_dir,"gadm41_USA_2_pk.rds"))}


# CONUS DEM layer (topography) ------------------------------------------------------

# get a mask for lower 48 states
conus = us_states[!us_states$NAME_1 %in% c("Alaska", "Hawaii"),]
conus$area = st_area(conus) #calculate areas for later


if(!file.exists(dem_path)){
  us_dem = geodata::elevation_30s("USA",
                                      path = scratch_dir)
  us_dem = mask(us_dem, conus)
  us_dem = project(us_dem, paste0("epsg:",proj_proj))
  writeRaster(us_dem, dem_path)
  
}


# Save all data in workspace as RData file --------------------------------

save.image(file = file.path(here::here(), "project_data.RData"))
