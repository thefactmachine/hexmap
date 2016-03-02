

fnCalcHexCoords2 <- function(centroidX, centroidy, height) {
   # function creates x & y for 6 hexagon vertices (2 * 6 = 12 values)
   # height is the distance between the two horizontals
   # the first vertex created is lower left..then works through other vertices clockwise

   
   # internal angle of hexagon is 120 degrees. 120 / 2 = 60 deg. Convert this to radians
   radian60 <- (60 * pi) / 180
   
   # use trig. to calculate sidelength. s(idelength * 6) = total perimeter 
   sidelength <- ( height / 2 ) / sin(radian60)
   
   # innerPointsOffset = distance from the vertial center to the inner 4 points of hexagon
   innerPointsOffset <- sidelength - (sidelength * cos(radian60))
   
   #setup two vectors to store six x & y coordinates
   x <- vector(mode = "double", length = 6)
   y <- vector(mode = "double", length = 6)
   
   # first the x vector
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
   
   # return a vector of 12 values
   x_ret <- c(x[1], x[2], x[3], x[4], x[5],x[6])
   y_ret <- c(y[1], y[2], y[3], y[4], y[5],y[6])
   clubbed <-c(x_ret, y_ret)
   
   return(clubbed)

}


