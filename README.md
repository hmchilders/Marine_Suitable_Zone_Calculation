# Quantifying Suitable Growth Area for Aquaculture Species Along the West Coast

## Overview

Marine aquaculture has the potential to play an important role in the global food supply as a more sustainable protein option than land-based meat production. Gentry et al. mapped the potential for marine aquaculture globally based on multiple constraints, including ship traffic, dissolved oxygen, bottom depth .

This exercise uses suitable temperature and depth data for each Exclusive Economic Zones (EEZ) on the West Coast of the US to find the area that are best suited to developing marine aquaculture for several species of oysters.

This workflow is then expanded to create a function that can take in temperature and depth limits and produce graphs that show the area in square kilometers and the percentage of each EEZ that is suitable for that species' suitable conditions.

This repository also contains an R script with the finalized function inside.

## Skills used in this workflow:

combining vector/raster data

resampling raster data

masking raster data

map algebra

## Data

#### Sea Surface Temperature

We will use average annual sea surface temperature (SST) from the years 2008 to 2012 to characterize the average sea surface temperature within the region. The data we are working with was originally generated from NOAA's 5km Daily Global Satellite Sea Surface Temperature Anomaly v3.1.

#### Exclusive Economic Zones

We will be designating maritime boundaries using Exclusive Economic Zones off of the west coast of US from Marineregions.org.

#### Bathymetry

To characterize the depth of the ocean we will use the General Bathymetric Chart of the Oceans (GEBCO).

**Note:** the data associated with this assignment is too large to include in the GitHub repo. Instead, download data from [here](https://drive.google.com/file/d/1u-iwnPDbe6ZK7wSFVMI-PpCKaRQ3RVmg/view?usp=sharing). Unzip the folder and all the contents and store them in your .Rproj

```         
Marine_Aquaculture_Repository
│   README.md
│   Rmd/Proj files    
│
└───data
    │   wc_regions_clean.shp
    │   depth.tif
    │   average_annual_sst_2008.tif
    │   average_annual_sst_2009.tif        
    │   average_annual_sst_2010.tif        
    │   average_annual_sst_2011.tif
    │   average_annual_sst_2012.tif     
```
