# clear the decks and add some libraries.
rm(list = ls())
library(dplyr)
library(RColorBrewer)

#setwd("F:\\Hexagons")
source("R\\fn_wrapper_create_hex_svg.R")
source("R\\fn_create_random_values.R")

# The following loads in lst.hex.vertices. This list contains hexagon vertices..
# for 3 regions: Region (16 hexagons)
load("data\\output\\hex_gg.rda")

# which region? Use names(lst.hex.vertices) to discover the possibilities
df.hex.region <- lst.hex.vertices[['region.hex']]

# create some test data to use...df.vals should be replaced with some REAL data..
# str.brewer.name  = one.of( display.brewer.all() )
df.vals <-  df.hex.region$name %>% unique() %>% 
   data.frame(name = ., stringsAsFactors = FALSE) %>% 
      fn.create.random.values(num.quantiles = 4, 
                           str.brewer.name = "Blues")

# now create the svg element...with a single function call.
svg.text <- fn.wrapper.create.hex.svg(df.vals, df.hex.region)
txt.file.path <- "svg_test_to_delete"

# valid values: "region_test.svg" "rto_test.svg"  "ta_test.svg"
txt.file.name <-  "ta_test.svg"         
writeLines(svg.text, paste0(txt.file.path, "\\", txt.file.name))
