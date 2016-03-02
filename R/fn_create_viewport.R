fn.create.viewport <- function(df.hex.points) {
   # function receives df of hexagon points...this input is...
   # nrow(df.hex.points) == 6 x number of polygons..eg regions: 16 * 6 = 96
   # a viewpoint object is created: this is x,y of top left corner, width, height
   left.x <- min(df.hex.points$vct.x)
   top.y <- max(df.hex.points$vct.y)
   
   right.x  <- max(df.hex.points$vct.x)
   bottom.y  <- min(df.hex.points$vct.y)
   
   height <- top.y - bottom.y
   width <-  right.x - left.x
   
   viewport <- c(left.x = left.x, top.y = top.y, width = width, height = height)
   return(viewport)
   
}
