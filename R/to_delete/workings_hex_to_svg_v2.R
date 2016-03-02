rm(list = ls())
library(dplyr)
library(XML)
setwd("F:\\Hexagons")


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

# load prepared data: hex_gg.rda contains 3 dataframes. These are: 
# ..region_hex_gg (16 hexagons); rto_hex_gg (31 hexagons); ta_hex_gg (66 hexagons)
load("data\\output\\hex_gg.rda")


# declare constants
c.blanklines <- "\n\n\n"
c.space <- intToUtf8(32)
c.tab <- paste0(c.space,c.space,c.space,c.space)
#c.stroke.colour <- "#CCCCCC"
#c.stroke.width <- 1

# =====set parameters ==== user to change the following to suit.....


# following defines which of the 3 dataframes to use....valid values are:
# "region_hex_gg", "rto_hex_gg",  "ta_hex_gg"
df.hex.values <- region_hex_gg                  # name of the dataframe to use.
svg.id <- "svdid"                               # id of svg id property
svg.width <- 175                                # svg's width. height is set automatically dependendant on width (and aspect)         
svg.bg.colour <- "#FFFFFF"                      # svg's background colour

hex.stroke.colour <- "#000000"                  # the colour of stroke for all hexagons
hex.stroke.width <- "0.5"                         # the width of the stroke (pixels) for all hexagons

txt.x.oset <- 0                                 # number of pixels from left edge to offset both text elements
txt.names.y.oset <- 46                          # number of pixels from top edge to offset the hexagon names
txt.values.y.oset <- 69                         # number of pixels from top edge to offset the hexagon values
txt.font.size <- 12                             # font size in pixels (both text elements)
txt.font.colour <- "#000000"                    # font colour (both text elements)


#==========Prepare the data=================

# create viewport object...this is a bounding box for underlying geometry
vct.vp <- fn.create.viewport(df.hex.values)

# create offsets and name individual items
vct.offsets <- fn.create.offsets(df.hex.values)


# create a data frame of centroids with starting vertices (start of drawing coordinates) 
df.cent <- fn.create.centroid.df(df.hex.values, vct.offsets, vct.vp)

# use substr to lop off the two trailing transparency values
df.cent$colour <- substr(terrain.colors(nrow(df.cent)),1,7)




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


writeLines(svg_output, "svg_test_to_delete\\outfile.svg")


