rm(list = ls())
library(dplyr)
library(RColorBrewer)
#library(XML)
setwd("F:\\Hexagons")

# CODE SUMMARY - PURPOSE
# The purpose of this code is to create an interative SVG Hexagaon map for use in an HTML page....
# This SVG component contains: the SVG geometry; a JSON file containing the data and some... 
# JavaScript event handlers and related functions that provide interactivity by "glueing" the JSON ...
# data file and SVG geometry together.  Each SVG element is a hexagon. The JavaScript event handlers are..
# hardcoded directly into heach SVG element. This functionality could also have been achieved with JQuery..
# However, this 'hard-coded' approach makes the SVG element more self contained.

# There are three types of maps which can be generated. These are: 
# region_hex_gg (16 hexagons); rto_hex_gg (31 hexagons); ta_hex_gg (66 hexagons)


# The code below relies on data frames contained in hex_gg.rda .  This rda file contains the hexagon
# geometry which is used by GGplot2.geom_poly() to produce a static hexagon map. Each dataframe contained...
# in the RDA file contains 1 row for each hexagaon vertex. Therefore, region_hex_gg (16 hexagons) contains..
# 16 * 6 = 96 rows. The following code converts these six vertices into a single element for display in an 
# SVG element. This means that the resultant SVG file will (assuming region_hex_gg) contain 16 SVG paths --
# each of these is a hexagon.

# The aspect ratio (i.e. height / width) of each hexagaon map has previously been determined and cannot 
# changed.  However, the user can enter a parameter for width (see below) and the height will be computed..
# by the computer program.

# USER RESPONSBILITIES
#  ...to be completed.



# basic strategy here:
# 1) Prepare the data...
# 2) Create the 7 xml elements are explained below
# 3) club the 7 xml elements together and save the resultant svg file

#===============================

# The SVG file has the following components (in order)
# 1)  XML header           xml version..doctype..just boiler plate text
# 2)  SVG header           defined by parameters, contains height, viewport, color attributes
# 3)  <defs>               contains the svg style information
# 4)  <text>               two elements here: 1) display the hexagon's name; 2) display hexagon's value
# 5)  <path>               this is where the hexagons are drawn. The number of paths == number of hexagons
# 6)  <script>             contains Javascript. 2 components: 1) JSON object 2) mouseOver / moveOut functions


# Preparation stuff ==================================


# load some functions....
source("R\\fn_create_offsets.R")
source("R\\fn_create_viewport.R")
source("R\\fn_create_centroid_df.R")
source("R\\fn_create_json_object.R")
source("R\\fn_create_text_value.R")
source("R\\fn_create_text_name.R")
source("R\\fn_create_svg_header.R")
source("R\\fn_create_path_element.R")

source("R\\fn_create_random_values.R")

# load prepared data: hex_gg.rda contains 3 dataframes. These are: 
# ..region_hex_gg (16 hexagons); rto_hex_gg (31 hexagons); ta_hex_gg (66 hexagons)
load("data\\output\\hex_gg.rda")


# declare constants
c.blanklines <- "\n\n\n"
c.space <- intToUtf8(32)
c.tab <- paste0(c.space,c.space,c.space,c.space)


# =====set parameters ==== user to change the following to suit.....


# following defines which of the 3 dataframes to use....valid values are:
# "region_hex_gg", "rto_hex_gg",  "ta_hex_gg"
df.hex.values <- ta_hex_gg                     # name of the dataframe to use.
svg.id <- "svdid-ta"                            # id of svg id property ... <svg id == "idName" .../>
svg.width <- 175                                # svg's width. height is set automatically dependendant on width (and aspect)         
svg.bg.colour <- "#FFFFFF"                      # svg's background colour

hex.stroke.colour <- "#000000"                  # the colour of stroke for all hexagons
hex.stroke.width <- "0.5"                       # the width of the stroke (pixels) for all hexagons

txt.x.oset <- 0                                 # number of pixels from left edge to offset both text elements
txt.names.y.oset <- 46                          # number of pixels from top edge to offset the hexagon names
txt.values.y.oset <- 90                         # number of pixels from top edge to offset the hexagon values
txt.font.size <- 36                             # font size in pixels (both text elements)
txt.font.colour <- "#000000"                    # font colour (both text elements)

txt.file.path <- "svg_test_to_delete"           # path relative to the current work directory
txt.file.name <- "ta_test.svg"                  # file name

#==========Prepare the data=================

# create viewport object...this is a bounding box for underlying geometry
vct.vp <- fn.create.viewport(df.hex.values)

# create offsets and name individual items
vct.offsets <- fn.create.offsets(df.hex.values)


# create a data frame of centroids with starting vertices (start of drawing coordinates) 
df.cent <- fn.create.centroid.df(df.hex.values, vct.offsets, vct.vp)

# Add random "value" and "colour" columns. This line is for test purposes only...
# it will be the user's responsiblity to change these column values into something more meaningful.
# the second argument is the number of quantiles.
df.cent <- fn.create.random.values(df.cent, 5, "Greens")



#==========Prepare the SVG elements=================

# 1) get the xml header...just grab a pre-formatted text file
fileName <- "R\\text_files\\xml_header.txt"
xml_header <- readChar(fileName, file.info(fileName)$size)

#========================
# 2) Create svg.header (id, viewport, width, b/g colour)
xml.element.svg.header <- fn.create.svg.header(svg.id, vct.vp, svg.width, svg.bg.colour)

#========================
# 3) Create <defs> ...</defs> elements
fileName <- "R\\text_files\\style_text.txt"
css_style_text <- readChar(fileName, file.info(fileName)$size)

# here is a hack to make the css_style_text parameter driven:
css_style_text <- gsub("stroke: #AAAAAA;", 
               paste0("stroke: ", hex.stroke.colour, ";"), css_style_text)


css_style_text <- gsub("stroke-width: 1;", 
               paste0("stroke-width: ", hex.stroke.width, ";"), css_style_text)


xml.element.style <- paste0("<style type=\"text/css\">", "\n",
                            css_style_text, "\n", "</style>")
xml.element.defs <- paste0("<defs>", "\n", xml.element.style, "\n", "</defs>")

#========================
# 4) Create two <text>. Format: id, viewport, x.offset (from left), y.offset (top top), fontsize (pixels), colour
text.svg.text.name <- fn.create.text.name("TEXT_NAME", vct.vp, txt.x.oset, 
               txt.names.y.oset, txt.font.size, txt.font.colour)


text.svg.text.value <- fn.create.text.value("TEXT_VALUE", vct.vp, txt.x.oset, 
               txt.values.y.oset, txt.font.size, txt.font.colour)

xml.element.text <- paste0(text.svg.text.name, text.svg.text.value)
#========================

# 5) Create path elements
xml.element.paths <- fn.create.path.elements(df.cent, vct.offsets, 
                  hex.stroke.colour, hex.stroke.width) 

#========================

# 6) Assemble 3 Javascript components: 
# 6.a) JSON (constructed dynamically) 6.b) MouseOver / MouseOut funtions (static text)

# 6.a) Create JSON object representing the data to be displayed.
txt.json <- fn.create.json.object(df.cent)


# 6.b) grab the mouse_event functions...just grab a pre-formatted text file
fileName <- "R\\text_files\\mouse_event_functions.txt"
js_mouse_event <- readChar(fileName, file.info(fileName)$size)

# Assemeble the two components above into a <script> element
txt.js.compile <-paste0("<![CDATA[", c.blanklines, txt.json, 
                        c.blanklines, js_mouse_event, c.blanklines, "]]>")

xml.element.js <- paste0("<script type=\"text/javascript\">", 
                         c.blanklines, txt.js.compile, c.blanklines, "</script>")

#==========Club the SVG elements together into a single string=================

svg_output <- paste0(xml_header, c.blanklines, xml.element.svg.header, 
                     c.blanklines, xml.element.defs, c.blanklines, xml.element.text,
                     xml.element.paths, c.blanklines, xml.element.js, 
                     c.blanklines, "</svg>")


# save the file
writeLines(svg_output, paste0(txt.file.path, "\\", txt.file.name))
