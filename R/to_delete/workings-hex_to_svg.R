rm(list = ls())

library(dplyr)
setwd("F:\\Hexagons")
load("data\\output\\hex_gg.rda")
source("R\\fn_create_offsets.R")
source("R\\fn_create_viewport.R")
source("R\\fn_create_json_object.R")
source("R\\fn_create_centroid_df.R")
source("R\\fn_create_path_element.R")
source("R\\fn_create_json_object.R")
source("R\\fn_create_JS_function_hover_in.R")
source("R\\fn_create_JS_function_hover_out.R")
source("R\\fn_create_svg_header.R")
source("R\\fn_create_text_name.R")
source("R\\fn_create_text_value.R")

# set up some useful constants
c.quote <- intToUtf8(34)
c.space <- intToUtf8(32)
c.tab <- paste0(c.space,c.space,c.space,c.space)
c.blankline <- "\n"

stroke.colour <- "#CCCCCC"

# the following units are in pixels
stroke.width <- 1


# create viewport object...this is a bounding box for underlying geometry
vct.vp <- fn.create.viewport(region_hex_gg)
# create offsets and name individual items
vct.offsets <- fn.create.offsets(region_hex_gg)
# create a data frame of centroids with starting vertices (start of drawing coordinates) 
df.cent <- fn.create.centroid.df(region_hex_gg, vct.offsets, vct.vp )

# lets add some colours to df.cent
# use substr to lop off the two trailing transparency values
df.cent$colour <- substr(terrain.colors(nrow(df.cent)),1,7)



# these are the two text elements
# formatis: id, viewport, x.offset (from left), y.offset (top top), fontsize (pixels), colour
text.svg.text.name <- fn.create.text.name("TEXT_NAME", vct.vp, 10, 20, 10, "#FF00FF")
text.svg.text.value <- fn.create.text.value("TEXT_VALUE", vct.vp, 10, 40, 10, "#FF00FF")

TEXT_ELEMENTS <- paste0(text.svg.text.name, "\n", text.svg.text.value)
cat(TEXT_ELEMENTS)

#================Actung....hier are the paths....================================






# format for this function call is: (svg.id, viewport, width, background color)
txt.svg.header <- fn.create.svg.header("test", vct.vp, 175, "#CCCCCC")
txt.header.plus.txt.elements <- paste0(txt.svg.header, c.blankline, c.tab, text.svg.text.name, c.tab, text.svg.text.value )
txt.path.elements <- fn.create.path.elements(df.cent, vct.offsets, stroke.colour, stroke.width) 

txt.svg.sans.js <- paste0(txt.header.plus.txt.elements, "\n\n\n\n", txt.path.elements)








# https://en.wikipedia.org/wiki/Don%27t_repeat_yourself
# http://stackoverflow.com/questions/5378559/including-javascript-in-svg

# (str.id, a.vct.vb, x.off, y.off, size, fill)


#========================
# the Javascript components
#========================
txt.js.opentag <- paste0("<script type=", c.quote, "text/javascript", c.quote, "><![CDATA[") 


txt.json <- fn.create.json.object(df.cent)





txt.hover.in <- fn.create.JS.function.hover.in()
txt.hover.out <- fn.create.JS.function.hover.out()
txt.js.closetag <- "]]></script>"


js.components <-  paste0(txt.js.opentag, "\n\n\n\n", txt.json, "\n\n\n\n" , 
                  txt.hover.in, "\n\n\n" , txt.hover.out, 
                  "\n\n\n", txt.js.closetag)

#========================

text.complete <- paste0(txt.svg.sans.js, js.components, "\n\n\n\n", "</svg>")

cat(text.complete)


#========================
















