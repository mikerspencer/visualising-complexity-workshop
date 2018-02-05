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


# ---------------------------------------
# Read

# Single file
pop = read.csv("../data/prepared/population-estimates-historical-geographic-boundaries.csv", skip=8, header=T)

# All files
f = list.files("../data/prepared", pattern="csv", full.names=T)
dl = lapply(f, function(i){
   print(i)
   read.csv(i, skip=8)
})


# shp file
LAs = readOGR(paste0(normalizePath("~"), "/repo/vis-complex-workshop/data/"), "Scot_LAs")



# ---------------------------------------
# Spatial

LAs = merge(LAs, pop[, 2:3], by.x="geo_label", by.y="Reference.Area")

# ---------------------------------------
# Normalise

pop = pop %>% 
   select(-http...purl.org.linked.data.sdmx.2009.dimension.refArea) %>% 
   gather(year, population, -Reference.Area) %>% 
   mutate(year=str_sub(year, 2, 5))

elec = elec %>% 
   select(-http...purl.org.linked.data.sdmx.2009.dimension.refArea) %>% 
   gather(year, electricity_use, -Reference.Area) %>% 
   mutate(year=str_sub(year, 2, 5))


# ---------------------------------------
# 
