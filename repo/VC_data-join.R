# ---------------------------------------
# ---------------------------------------
# Visualising complexity
# Data join
# ---------------------------------------
# ---------------------------------------

library(rgdal)


# ---------------------------------------
# Read

# Single file
pop = read.csv("../data/prepared/population-estimates-historical-geographic-boundaries.csv", skip=8, header=T)

# All files
f = list.files("../data/prepared", pattern="csv")
f = f[f!="normalised_data.csv"]
dl = lapply(f, function(i){
   print(i)
   read.csv(paste0("../data/prepared/", i))
})

# Normalised data
df = read.csv("../data/prepared/normalised_data.csv")

# shp file
LAs = readOGR(paste0(normalizePath(".."), "/data/prepared"), "Scot_LAs")


# ---------------------------------------
# Join

# e.g.
LAs = merge(LAs, dl[[1]], by.x="geo_label", by.y="Reference.Area")

