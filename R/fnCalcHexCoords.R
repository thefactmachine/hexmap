fnCalcHexCoords <- function(centroidX, centroidy, height) {
   # function creates x & y for 6 hexagon vertices (2 * 6 = 12 values)
   # height is the distance between the two horizontals
   # the first vertex created is lower left..then works through other vertices clockwise
   # in 1 iteratiion

   # 1) Preliminaries
   # internal angle of hexagon is 120 degrees. 120 / 2 = 60 deg. Convert this to radians
   radian60 <- (60 * pi) / 180
   
   # use trig. to calculate sidelength. (sidelength * 6) = total perimeter 
   sidelength <- ( height / 2 ) / sin(radian60)
   
   # innerPointsOffset = distance from the vertial center to the inner 4 points of hexagon
   innerPointsOffset <- sidelength - (sidelength * cos(radian60))
   
   # 2) Calculate six vertices
   
   # 2.1) first the x cordinates
   xv1  <- centroidX - innerPointsOffset
   xv2  <- centroidX - sidelength
   xv3  <- centroidX - innerPointsOffset
   xv4  <- centroidX + innerPointsOffset
   xv5  <- centroidX + sidelength
   xv6  <- centroidX + innerPointsOffset

   
   # 2.2) next, the y coordinates
   yv1 <- centroidy - (height / 2)
   yv2 <- centroidy
   yv3 <- centroidy + (height / 2)
   yv4 <- centroidy + (height / 2)
   yv5 <- centroidy
   yv6 <- centroidy - (height / 2)
   
   # 3) Prepare output
   # construct vectors
   vct.x <- c(rbind(xv1, xv2, xv3, xv4, xv5, xv6))
   vct.y <- c(rbind(yv1, yv2, yv3, yv4, yv5, yv6))


   
  # return a matrix (6 x 2)
   return(cbind(vct.x, vct.y))

}



