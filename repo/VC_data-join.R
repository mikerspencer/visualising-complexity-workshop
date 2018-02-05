# ---------------------------------------
# ---------------------------------------
# Visualising complexity
# Data join
# ---------------------------------------
# ---------------------------------------

library(tidyr)
library(dplyr)
library(stringr)
library(rgdal)

pop = read.csv("~/Cloud/Michael/SRUC/visualising_complexity/population-estimates-historical-geographic-boundaries.csv", skip=8, header=T)

elec = read.csv("~/Cloud/Michael/SRUC/visualising_complexity/electricity-consumption.csv", skip=8, header=T)

renew = read.csv("~/Cloud/Michael/SRUC/visualising_complexity/renewable_electricity_percent.csv")

LAs = readOGR(paste0(normalizePath("~"), "/Cloud/Michael/SRUC/visualising_complexity/"), "Scot_LAs")

??? = read.csv("~/Cloud/Michael/SRUC/visualising_complexity/")


# ---------------------------------------
# Spatial

LAs$area_sqkm = round(raster::area(LAs) / 1000000)

LAs@data = LAs@data[, c("geo_label", "area_sqkm")]


# ---------------------------------------
# Merge

pop = pop %>% 
   select(-http...purl.org.linked.data.sdmx.2009.dimension.refArea) %>% 
   gather(year, population, -Reference.Area) %>% 
   mutate(year=str_sub(year, 2, 5))

elec = elec %>% 
   select(-http...purl.org.linked.data.sdmx.2009.dimension.refArea) %>% 
   gather(year, electricity_use, -Reference.Area) %>% 
   mutate(year=str_sub(year, 2, 5))
