

fnCalcHexCoords <- function(centroidX, centroidy, height) {
   # functions receives:
   #  1)    x, y cordinates of a hexagon's centroid 
   #  2)    hexagon's total height (distance beween horizontals)
   # function then calculates the coordinates for 6 points of the hexagon
   # starting at the lower left and working clockwise
   
   # each internal angle of a hexagon is equal to 120 degrees. Half of this is 60 degrees.
   # calculate the length of a side using trigonemtry
   # first we need to convert 60 degrees to radions
   radian60 <- (60 * pi) / 180
   sidelength <- ( height / 2 ) / sin(radian60)
   # following is the distinace from the vertial centroid () to the inner 4 points of hexagon
   innerPointsOffset <- sidelength - (sidelength * cos(radian60))
   
   #setup two vectors to store 6 x & y coordinates
   x <- rep(NA,6)
   y <- rep(NA,6)
   
   # create cordinates for x and y points starting with lower left point and working clockwise
   # first the x vector
   
   # should re-factor this show the points go straight into a matrix
   x[1] <- centroidX - innerPointsOffset
   x[2] <- centroidX - sidelength
   x[3] <- centroidX - innerPointsOffset
   x[4] <- centroidX + innerPointsOffset
   x[5] <- centroidX + sidelength
   x[6] <- centroidX + innerPointsOffset
   
   # second, the y vector
   y[1] <- centroidy - (height / 2)
   y[2] <- centroidy
   y[3] <- centroidy + (height / 2)
   
   y[4] <- centroidy + (height / 2)
   y[5] <- centroidy
   y[6] <- centroidy - (height / 2)
   
   # create a matrix 
   mat.cordinates <- matrix(c(x, y), nrow = 6)
   colnames(mat.cordinates) <- c("x", "y")
   rownames(mat.cordinates) <- 1:6
   return(mat.cordinates)

}


