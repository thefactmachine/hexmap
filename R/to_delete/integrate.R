#rm(list = ls())
library(ggplot2)
library(dplyr)
library(mbie)
# this is work path
setwd('F:\\Hexagons')
# this is home path
# setwd("/Volumes/DTLplus 1/Hexagons")

# loads the function fnCalcHexCoords(...)
# this function recieves a hex centroid and then creates six pairs of points
source("R/fnCalcHexCoords.R")

# coords.csv is currently regional data. 16 rows. Each row has x,y for the ..
# .. 16 regions  There is also a notational 'value' amount this 'value' can be
# replaced with something meaningful The x,y points are created in Visio. The
# current (9.7.15) x,y should be more precise for regions

# format of the csv file is:  name, name_abbr, x.centre, y.centre
# names supplied as follows: name,abbr,x,y,value
df.coords <- read.csv("data/input/rto.csv", stringsAsFactors = FALSE)

df.vals.test <-  read.csv("data/test/rto_values_test.csv", stringsAsFactors = FALSE) 
  
# connect the values from df.vals.test
df.coords <- inner_join(df.coords, df.vals.test, by = c("name" = "name_test")) %>% 
   select(-name_abbr_test)

# size of hexagon: distance between the two horizontals
# the following number cannot be changed.

# get the height from the input file
hexHeight <- head(df.coords$height,1)


fnCreateDataFrame <- function(x, y, height, abbre, value) {
   # this is currently a wrapper for fnCalcHexCoords(...)
   # fnCalcHexCoords(...) probably needs to be re-factored to contain  this functionality
   # returns cordinates for 6 points of a hexagon in a format
   # suitable for ggplot2 to display.
   
   # heres a test call... returns 6 rows:  
   # fnCreateDataFrame(100, 100, 30, "mark", 30)
   
   # get a matrix of six points
   mat.hexCoords <- fnCalcHexCoords(x, y, height)
   vct.x =  mat.hexCoords[, "x"]  # 6 x 1 
   vct.y =  mat.hexCoords[, "y"]  # 6 x 1 
   vct.abbrev = rep(abbre, 6) # 6 x 1 
   vct.val = rep(value, 6) # 6 x 1 
   df.result = data.frame(abbre = vct.abbrev , value = vct.val, x = vct.x, y = vct.y) # 6 x 4
   return(df.result)
}


# create a blank data.frame
df.poly <- data.frame()

# need to add the following fields:
# 1) x.centre”, “y.centre”, “name_abbr”
# 2) "name"


for (i in 1:nrow(df.coords)) {
   # iterate through the centroid data (ie. df.coords)
   df.temp <- fnCreateDataFrame(x = df.coords[i, "x_centre"], y = df.coords[i, "y_centre"], 
   height =  hexHeight, abbre = df.coords[i, "name_abbr"],  value = df.coords[i, "value"]) 
   # keep stacking groups of 6 points onto df.poly
   df.poly <- rbind(df.poly, df.temp)

}

# use df.poly for this
# PENDING ready-to-use dataframe named reg_hex_gg ie basically what you’ve got up to line 54 of integrate.R creating as df.poly

# this is just a test...
# MODIFY THE DATA FRAME SO THAT THIS CAN GO IN
#+ geom_text(data = unique(reg_hex_gg[ , c(“x.centre”, “y.centre”, “name_abbr”)], aes(x = x.centre, y = y.centre, label = name_abbr))

p <- ggplot(df.poly, aes(x = x, y = y))
p <- p + geom_polygon(aes(fill = value, group = abbre),
      colour = "white", linetype = "solid")
p <- p + coord_fixed(ratio = 1)
p <- p +  mbie::theme_nothing()
p <- p + theme(legend.position = "none")
p


# TO DO:
#  Get Visio to export the height of the hexagon
#  Visio to export standard names see above
#  Visio should not export values...we will need to create a values file for the example
#  Separate this script so that 1) A #polygons * 6 row object is saved...this object will then 
#  be used by a Test script to create an image.



# p <- p + coord_fixed(ratio = 1)
# p <- p + theme(axis.title.x = element_blank())
# p <- p + theme(axis.title.y = element_blank())
# p <- p + theme(legend.position = "none")
# p <- p + theme(axis.ticks = element_blank())
# p <- p + theme(axis.text = element_blank())
# p <- p + theme(panel.background = element_rect(fill = 'white',  colour = 'white'))

# 
# Thanks, looking extremely promising, I think this is going to be a goer even at the regional level
# 
# Could you
#  PENDING Remove the absolute file paths --
#  PENDING modify it so that there is a script “create_regions_hexes.R” somewhere that creates and saves a 
#  PENDING ready-to-use dataframe named reg_hex_gg ie basically what you’ve got up to line 54 of integrate.R creating as df.poly
#  PENDING add the three letter abbreviations to that data frame
#  PENDING and the centre coordinates x.centre, y.centre to the data frame so it’s easy to add text labels with something like 
# + geom_text(data = unique(reg_hex_gg[ , c(“x.centre”, “y.centre”, “name_abbr”)], aes(x = x.centre, y = y.centre, label = name_abbr))
#  PENDING Move the demo / test to it’s own script
# DONE FOR INTEGRATE CHECK FOR OTHER SCRIPTS Put more spaces around the logical, arithmetic and assignment operators eg fill = value not fill=value (this is just a convention I’m trying to push for readability)
#             
#  DONE Also, assuming you have {mbie} loaded you can simplify your map-making with something like:
#               
# DONE              ggplot(df.poly, aes(x = x, y = y)) +
# DONE              geom_polygon(aes(fill = value, group = id))  +
# DONE              theme_nothing()
#             
# Once reg_hex_gg is ready it should go into {mbiemaps}; in fact once this project is stable all the creation from scratch should be
# ported into the mbiemaps project so it is all together, but for now it’s fine to work on this separately.
#             


