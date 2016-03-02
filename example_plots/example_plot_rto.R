# Author: mark_hatcher
# purpose of this script is to demonstrate how to use a hexagon data frame...
# .. with an example data set and to demonstrate how this data set can be used with...
# ggplot2.

rm(list = ls())
library(ggplot2)
library(mbie)
library(RODBC)
library(dplyr)


# load in three data frames. These are originally created by "create_regions_hexes.R"
load("data/output/hex_gg.rda")

# comment in out which region you wish to test
#df.hex.geom <- region_hex_gg
# df.hex.geom <- rto_hex_gg
df.hex.geom.ta <- ta_hex_gg


# get some data from REAR.db
PlayPen <- odbcConnect("PlayPen_Prod")
ta.internet <- sqlQuery(PlayPen, "SELECT 
                     Area, Value, Year, AreaType
                  FROM dbo.REARdbReport 
                  WHERE ValueName = 'Percentage of households having access to Internet' AND
                  AreaType = 'Territorial Authority' AND 
                  Year = 2013")
# convert factors to strings
ta.internet$Area <- as.character(ta.internet$Area)



# the data from tred uses a different naming convention...so load a lookup table:
mappingTable <- 
   read.csv("data/input/mbie_maps_to_tred_lookup.csv", stringsAsFactors = FALSE)

# add mbie map names onto tread names
ta.internet <- dplyr::inner_join(mappingTable, 
               ta.internet, by = c("mbie_maps_name" = "Area"))





df.hex.geom <- dplyr::inner_join(ta.internet, 
                  df.hex.geom.ta, by =  c("tred_name" = "name"))






# set.seed(123)
# 
# # create some random values to display
# df.hex.geom$value <- 
#    rep(rnorm(nrow(df.hex.geom) / 6, mean = 100, sd = 15), each = 6)

# prepare some text labels
hex.geom.labels <- unique(df.hex.geom[, c("name_abbr", "x_centre", "y_centre")])

# now we can make the plot
p <- ggplot(df.hex.geom, aes(x = vct.x, y = vct.y))
#p <- p + geom_polygon(aes(fill = Value, group = name_abbr), colour = "white", linetype = "solid")
p <- p + geom_polygon(aes(fill = Value, group = name_abbr))

#  p <- p + geom_text(data = hex.geom.labels, colour = "white", size = 2.7,
#          aes(x = x_centre, y = y_centre, label = name_abbr))

p <- p + coord_fixed(ratio = 1)
p <- p +  mbie::theme_nothing()
p <- p + theme(legend.position = "none")
p






