# Author: mark_hatcher

# this script creates a data/output/hex_gg.rda file which contains three data frames
# these three data frames represent:
# 1) regions (16 polygons) [region_hex_gg]
# 2) regional tourism offices (31 polygons) [ rto_hex_gg ]
# 3) territorial authorities (66 polygons) [ ta_hex_gg ]
# Each of these data frames is designed to be used with ggplot2's geom_polygon() ...
# to create a hexagon map

rm(list = ls())

library(dplyr)


# this function (i.e fnCalcHexCoords) is used by fnCreateHexGeom() and... 
# returns 6 hexagon verticesfor each hexagon centroid..
source("R/fnCalcHexCoords.R")
#===================FUNCTION START ===================
fnCreateHexGeom <- function(df.cds) {
    # function input: centroids (1 row); function output: vertices (6 rows)
    # create x,y pairs for six vertices. Return length = nrow(df.cds) * 6 
    hexCoords <- fnCalcHexCoords(df.cds$x_centre, df.cds$y_centre, df.cds$height)
    # replicate the original centroids data frame 6 times
    df.cds.6 <- df.cds[rep(1:nrow(df.cds), each = 6),]
    # append two columns
    df.cds.6 <- cbind(df.cds.6, hexCoords)
    # add some meaningful row names
    row.names(df.cds.6)  <- paste0(df.cds.6$name_abbr,"_", "0",1:6)
    return(df.cds.6)
}

# create 3 data frames and then save the results to an rda file

# create data frame for regions. Expected rows: 6 * 6 = 96
region_hex_gg <- read.csv("data/input/regions.csv", stringsAsFactors = FALSE) %>%
  fnCreateHexGeom()

# create data frame for regional tourism offices. Expected rows: 31 * 6 = 186
rto_hex_gg <- read.csv("data/input/rto.csv", stringsAsFactors = FALSE) %>%
   fnCreateHexGeom()

# create data frame for territorial authorities. Expected rows: 66 * 6 = 396
ta_hex_gg <- read.csv("data/input/ta.csv", stringsAsFactors = FALSE) %>%
   fnCreateHexGeom()

# create a list to store all three components
lst.hex.vertices <- list(region.hex = region_hex_gg, 
            rto.hex = rto_hex_gg, ta.hex = ta_hex_gg)


# save the 3 data frames as a list in a single rda file. 
save(lst.hex.vertices, file = "data/output/hex_gg.rda")
