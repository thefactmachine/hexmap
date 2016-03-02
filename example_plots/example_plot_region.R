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
df.hex.geom.region <- region_hex_gg



# get some data from REAR.db .. region
PlayPen <- odbcConnect("PlayPen_Prod")
region.internet <- sqlQuery(PlayPen, "SELECT 
                     Area, Value 
                  FROM dbo.REARdbReport 
                  WHERE ValueName = 'Percentage of households having access to Internet' AND
                  AreaType = 'Regional Council' AND 
                  Year = 2013")


# convert factors to strings
region.internet$Area <- as.character(region.internet$Area)




# the data from tred uses a different naming convention...so load a lookup table:
mappingTable <- 
   read.csv("data/input/mbie_maps_to_rearDb_lookup_region.csv", stringsAsFactors = FALSE)


# append mbie_maps_name by joining to the mapping table...
# ..we can then get rid of the original names
region.internet <- dplyr::inner_join(mappingTable, 
   region.internet, by = c("rearDb_name" = "Area")) %>%
   dplyr::select(-c(rearDb_name))



# the columns of the second name used is appended to the right
# change Uppercase("V") to lowercase("v")
df.hex.geom.region <- dplyr::inner_join(df.hex.geom.region, region.internet, 
   by =  c("name" = "mbie_maps_name")) %>%
   dplyr::rename(value = Value)


# set.seed(123)

# df.hex.geom$value <- 
#    rep(rnorm(nrow(df.hex.geom) / 6, mean = 100, sd = 15), each = 6)

# prepare some text labels
region.labels <- unique(df.hex.geom.region[, c("name_abbr", "x_centre", "y_centre")])

# now we can make the plot
p <- ggplot(df.hex.geom.region, aes(x = vct.x, y = vct.y))

# set the border (can comment this out)
p <- p + geom_polygon(aes(fill = value, group = name_abbr), 
   colour = "white", linetype = "solid")


#p <- p + geom_polygon(aes(fill = value, group = name_abbr))

# add some labels
p <- p + geom_text(data = region.labels, colour = "white", size = 2.2,
          aes(x = x_centre, y = y_centre, label = name_abbr ))


p <- p + coord_fixed(ratio = 1)
p <- p +  mbie::theme_nothing()
p <- p + theme(legend.position = "none")
p



