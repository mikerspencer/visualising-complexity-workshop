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

f = list.files("../data/raw", pattern="csv")
dl = lapply(f, function(i){
   print(i)
   read.csv(paste0("../data/raw/", i), skip=8, stringsAsFactors=F)
})

# shp file
LAs = readOGR(paste0(normalizePath(".."), "/data/prepared"), "Scot_LAs")


# ---------------------------------------
# Clean

# Drop first column
dl = lapply(dl, function(i){
   i[, -1]
})

# Duplicates
dl = lapply(dl, function(i){
   i$Reference.Area[i$Reference.Area=="Na h-Eileanan Siar"] = "Eilean Siar"
   # Use shp file as reference list
   i = i[i$Reference.Area %in% LAs@data$geo_label, ]
   # Average duplicates
   i %>% 
      group_by(Reference.Area) %>% 
      summarise_all(mean)
})

# Combine Q1:Q4 for employment
dl[[4]] = dl[[4]] %>% 
   gather(year, value, -Reference.Area) %>% 
   mutate(year=str_sub(year, 1, 5)) %>% 
   group_by(Reference.Area, year) %>% 
   summarise(value=mean(value)) %>% 
   ungroup() %>% 
   spread(year, value)

lapply(seq_along(f), function(i){
   write.csv(dl[[i]], paste0("../data/prepared/", f[i]), row.names=F)
})


# ---------------------------------------
# Normalise

n = c("household-size", "businesses-count", "electricity-consumption", "employment", "population", "road-vehicles")

dl_norm = lapply(seq_along(dl), function(i){
   dl[[i]] %>% 
      gather_("year", n[i],
              gather_cols=colnames(dl[[i]])[colnames(dl[[i]])!="Reference.Area"]) %>% 
      gather(variable, value, -Reference.Area, -year, na.rm=T) %>% 
      mutate(year=str_sub(year, 2, 5))
})

dl_norm = do.call("rbind.data.frame", dl_norm)

write.csv(dl_norm, "../data/prepared/normalised_data.csv", row.names=F)
