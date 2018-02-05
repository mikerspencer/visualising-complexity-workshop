# ---------------------------------------
# ---------------------------------------
# Visualising complexity
# Cleaning
# ---------------------------------------
# ---------------------------------------

library(tidyr)
library(dplyr)
library(stringr)
library(rgdal)


# ---------------------------------------
# Read

f = list.files("../data", pattern="csv", full.names=T)
dl = lapply(f[2:5], function(i){
   print(i)
   read.csv(i, skip=8)
})
pop = read.csv("../data/population-estimates-historical-geographic-boundaries.csv", skip=8, header=T)

elec = read.csv("~/repo/vis-complex-workshop/data/electricity-consumption.csv", skip=8, header=T)

# shp file
LAs = readOGR(paste0(normalizePath("~"), "/repo/vis-complex-workshop/data/"), "Scot_LAs")


# ---------------------------------------
# Clean

pop = pop[pop$Reference.Area %in% elec$Reference.Area, ]

# largest of multiple row
# extra columns
# combine Q1:Q4 for employment

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
