fn.wrapper.create.hex.svg <-
   
   function (
      df.values,                             # data frame of values and colours  
      df.hex.values,                         # which vertices: 6 per hexagon
      svg.id = "svdid-ta",                   # <svg id == "svg.id" .../>
      svg.width = 175,                       # height is set automatically dependendant on width (and aspect)
      svg.bg.colour = "#FFFFFF",             # svg's background colour
      hex.stroke.colour = "#000000",         # stoke colour (in pixels) for all hexagons
      hex.stroke.width = 0.5,                # the width of the stroke (pixels) for all hexagons
      txt.x.oset = 0,                        # pixels from left edge to offset both text elements
      txt.names.y.oset = 46,                 # pixels from top edge to offset the hexagon NAMES
      txt.values.y.oset = 90,                # pixels from top edge to offset the hexagon VALUES
      txt.font.size = 12,                    # font size in pixels (both text elements)
      txt.font.colour = "#000000"            # font colour (both text elements)
      
   )

{
      
      # CODE SUMMARY - PURPOSE
      # The purpose of this code is to create an interative SVG Hexagaon map for use in an HTML page....
      # This SVG component contains: the SVG geometry; a JSON file containing the data and some... 
      # JavaScript event handlers and related functions that provide interactivity by "glueing" the JSON ...
      # data file and SVG geometry together.  Each SVG element is a hexagon. The JavaScript event handlers are..
      # hardcoded directly into each SVG element. This functionality could also have been achieved with JQuery..
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
      source("R\\fn_create_names_offset.R")
      
      
      # load prepared data: hex_gg.rda contains 3 dataframes. These are: 
      # ..region_hex_gg (16 hexagons); rto_hex_gg (31 hexagons); ta_hex_gg (66 hexagons)
      # load("data\\output\\hex_gg.rda")
      
      
      # declare constants
      c.blanklines <- "\n\n\n"
      c.space <- intToUtf8(32)
      c.tab <- paste0(c.space,c.space,c.space,c.space)
      
      #==========Prepare the data=================
      
      # create viewport object...this is a bounding box for underlying geometry
      vct.vp <- fn.create.viewport(df.hex.values)
      
      # create offsets and name individual items
      vct.offsets <- fn.create.offsets(df.hex.values)
      
      # the width / viewBox.width determines a scaling factor which helps us work out...
      # what size the svg font will be rendered. We work backwards from this to scale the..
      # supplied font-size such that it will be rendered at the appropriate size.
      scale.constant <- svg.width / vct.vp['width']
      
      calc.font.size <- as.numeric(txt.font.size / scale.constant)
      
      calc.stroke.width <- as.numeric(hex.stroke.width / scale.constant)
      
      # create a data frame of centroids with starting vertices (start of drawing coordinates) 
      df.cent <- fn.create.centroid.df(df.hex.values, vct.offsets, vct.vp)
      
      
      # join the centroids with the values to get a unified data.frame
      df.cent <- dplyr::inner_join(df.cent, df.values, by = c("name" = "name"))
      
      
      #==========Prepare the SVG elements=================
      
      # 1) get the xml header...just grab a pre-formatted text file
      fileName <- "R\\text_files\\xml_header.txt"
      xml_header <- readChar(fileName, file.info(fileName)$size)
      
      #========================
      # 2) Create svg.header (id, viewport, width, b/g colour)
      
      # 2.1) first calculate height based on aspect ratio
      aspect <- vct.vp['height'] / vct.vp['width'] 
      height <- round(aspect * vct.vp['width'] ,2)
      
      xml.element.svg.header <- fn.create.svg.header(svg.id, vct.vp, svg.width, svg.bg.colour)
      
      #========================
      # 3) Create <defs> ...</defs> elements
      fileName <- "R\\text_files\\style_text.txt"
      css_style_text <- readChar(fileName, file.info(fileName)$size)
      
      # here is a hack to make the css_style_text parameter driven:
      # firstly to change the stroke colour
      css_style_text <- gsub("stroke: #AAAAAA;", 
                             paste0("stroke: ", hex.stroke.colour, ";"), css_style_text)
      
      # and secondly to change the stroke width.
      css_style_text <- gsub("stroke-width: 1;", 
                             paste0("stroke-width: ", calc.stroke.width, ";"), css_style_text)
      
      
      xml.element.style <- paste0("<style type=\"text/css\">", "\n",
                                  css_style_text, "\n", "</style>")
      
      xml.element.defs <- paste0("<defs>", "\n", xml.element.style, "\n", "</defs>")
      
      #========================
      
      
      
      
      # 4) Create two <text>. Format: id, viewport, x.offset (from left), y.offset (top top), fontsize (pixels), colour
      
      # 4.1) Before doing anything we need to work out where to put the text elements. This depends on which region..
      # the text elements are placed such that the regions name is vertically placed such that it has the maximum..
      # horizontal space before overlapping the hexagaons
      
      proportion <- fn.create.names.offset(df.cent)
      
      
      # now just calulate the offset for the text element
      txt.names.y.oset <- height * proportion
      text.svg.text.name <- fn.create.text.name("TEXT_NAME", vct.vp, txt.x.oset, 
                                                txt.names.y.oset, calc.font.size , txt.font.colour)
      
      # the offset for the values element is based on the text element
      txt.values.y.oset <- txt.names.y.oset + ( calc.font.size * 2)
      
      text.svg.text.value <- fn.create.text.value("TEXT_VALUE", vct.vp, txt.x.oset, 
                                                  txt.values.y.oset, calc.font.size, txt.font.colour)
      
      
      xml.element.text <- paste0(text.svg.text.name, text.svg.text.value)
      #========================
      
      # 5) Create path elements
      xml.element.paths <- fn.create.path.elements(df.cent, vct.offsets) 
      
      #========================
      
      # 6) Assemble 3 Javascript components: 
      # 6.a) JSON (constructed dynamically) 6.b) MouseOver / MouseOut funtions (static text)
      
      # 6.a) Create JSON object representing the data to be displayed.
      txt.json <- fn.create.json.object(df.cent)
      
      
      # 6.b) grab the mouse_event functions...its just grabs a pre-formatted text file..nothing high-tech here
      fileName <- "R\\text_files\\mouse_event_functions.txt"
      js_mouse_event <- readChar(fileName, file.info(fileName)$size)
      
      # Assemble the two components above into a <script> element
      txt.js.compile <-paste0("<![CDATA[", c.blanklines, txt.json, 
                              c.blanklines, js_mouse_event, c.blanklines, "]]>")
      
      xml.element.js <- paste0("<script type=\"text/javascript\">", 
                               c.blanklines, txt.js.compile, c.blanklines, "</script>")
      
      
      
      #==========Club the SVG elements together into a single string=================
      svg_output <- paste0(xml_header, c.blanklines, xml.element.svg.header, 
                           c.blanklines, xml.element.defs, c.blanklines, xml.element.text,
                           xml.element.paths, c.blanklines, xml.element.js, 
                           c.blanklines, "</svg>")
      
      # and finally return the output
      return(svg_output)
      
      
   } # function