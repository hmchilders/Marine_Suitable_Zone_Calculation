species_suitable_area = function(species_name, min_temp_C, max_temp_C, min_depth_m, max_depth_m){
  #Create a reclassification matrix for Temperature
  rcl_temp <- matrix(c(-Inf, min_temp_C, NA,
                       min_temp_C, max_temp_C, 1,
                       max_temp_C, Inf, NA ), ncol = 3, byrow = TRUE)
  #Reclassify the temp data
  temp_reclass <- classify(sst_stac, rcl = rcl_temp)
  #Create a reclassification matrix for depth
  rcl_depth <- matrix(c(-Inf, (max_depth_m*(-1)), NA,
                        (max_depth_m*(-1)), (min_depth_m*(-1)), 1,
                        (min_depth_m*(-1)), Inf, NA), ncol = 3, byrow = TRUE)
  #reclassify the depth data
  depth_reclass <- classify(depth_resampl, rcl = rcl_depth)
  #Create a function to multiply two outputs
  multiply = function(x,y){
    x*y
  }
  #Use lapp() to create an overlay from the product of the two reclassified datasets
  species_cond <- lapp(c(temp_reclass, depth_reclass), fun = multiply)
  #Make a mask from the overlay
  mask <- mask(coast_rast, species_cond)
  #Use the mask to crop the coastal data to our area of interest (suitable areas)
  EEZ <- crop(mask, coast_rast) 
  #Use the cellSize function to fin the area of each cell
  EEZ_area <- cellSize(EEZ)
  #Use the zonal function to calculate the sum of the suitable areas in each region 
  suit_zones = zonal(EEZ_area, EEZ, fun = 'sum', na.rm = TRUE) 
  #Use the cellSize function to fin the area of each cell
  total_area <- cellSize(coast_rast)
  #Use the zonal function to calculate the sum of the total areas in each region 
  fun_zones <- zonal(total_area, coast_rast, fun = 'sum', na.rm = TRUE)
  
  #Add the suitable area stats to the new variable zonal_stats
  zonal_stats <- suit_zones %>% 
    #Rename the area column to suitable area for clarity
    rename(suitable_area = area) %>% 
    #Convert to km2
    mutate(suitable_area = (suitable_area/1000000)) %>% 
    #Add a new column to the dataframe using the total area stats calculated above
    add_column(fun_zones$area) %>% 
    #Rename that area column to total-area for clarity
    rename(total_area = 'fun_zones$area') %>% 
    #Convert to km2
    mutate(total_area = (total_area/1000000)) %>% 
    #Add a new column that calculates the percentage of each region thats suitable
    mutate(pct_suitable = ((suitable_area/total_area)*100))
  
  #Add the geometry to the zonal stats dataset by using a left joim 
  zonal_rast <- left_join(coast, zonal_stats, by = 'rgn') 
  
  area_plot<- tm_shape(zonal_rast)+
    tm_polygons(fill = 'suitable_area', fill_alpha = 0.6, #Add geometry and opacity
                fill.scale = tm_scale(values = "YlGn"), #Add Color scheme
                fill.legend = tm_legend(title = 'Suitable Area (km^2)'))+ #Add legend title
    tm_title(text = paste0("Suitable Area by Region: ", species_name))+ # Add figure title
    tm_scalebar(position = c('left','bottom'))+ #Add a scalebar
    tm_basemap(server = "OpenStreetMap") #Add a basemap
  
  pct_plot <- tm_shape(zonal_rast)+
    tm_polygons(fill = 'pct_suitable', fill_alpha = 0.7, #Add geometry and opacity
                fill.scale = tm_scale(values = "YlGn"), #Add color scheme
                fill.legend = tm_legend(title = 'Suitable Area(%)'))+ #Add legend title
    tm_title(text = paste0("Suitable Area by Region: ", species_name))+ #Add figure title
    tm_scalebar(position = c('left','bottom'))+ #Add a scalebar
    tm_basemap(server = "OpenStreetMap") #Add a basemap
  
  return(list(area_plot,pct_plot))
  
}