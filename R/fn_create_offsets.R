fn.create.offsets <- function(df.hex.points)  {
   # function receives df of hexagon points...this input is...
   # nrow(df.hex.points) == 6 x number of polygons..eg regions: 16 * 6 = 96 but returns a single row vector
   # creates a 2 (i.e. x, y) x 1 vector. x = horizontal shift, y = vertical shift
   # assuming a hexagon's bottom horizontal.... 
   #...the next relative point is out (x axis) and up (y axis)
   
   # a hexagon's internal angle is 60 degres...need to convert to radians
   radian60 <- (60 * pi) / 180
   
   # get the hexagon's height.  This is hardcoded into df.hex.points$height..we could..
   # ..have chosen any row...
   height <- df.hex.points[1, "height"]
   
   # y.shift is the absolute distance from horizontal to the center point
   y.shift <- height / 2
   
   # horizontal shift is the length of the horizontal lines ( length of all sides)
   horizonal.length <- ( height / 2 ) / sin(radian60)
   
   # absolute distance in x dimension from the horizontal to center point
   x.shift <- horizonal.length - (horizonal.length  * cos(radian60))
   
   # asssemble a vector to return
   offsets <- c(x.shift = x.shift, yshift = y.shift, h.length = horizonal.length )
   return(offsets)
   
}