
fnCalculateOffSets <- function(centroidX, centroidy, height) {
# writtten my mark.hatcher@mbie.govt.nz

# purpose is to help placement of hexagons in Visio
# In Visio if we need to place hexagon B next to hexagon A  we 
# need to do this with precision....

   # so this function receives parameters for hexagon A: (two centroids and a height)
# Hexagon A can be surrounded by six hexagons (you [dear reader] may need to draw this)
# [See Visio hexagon-design [sheet = hex-geometry]]
# This function will return the centroids for the six surrounding hexagons...
# These are returned as x,y pairs. Therefore, there are 6 x 2 = 12 numbers returned.
# These numbers are returned in 6 x 2 matrix.
# The six surrounding hexagons are labelled going clockwise: "Nth", "NW", "SW", "Sth", "SE", "NE"
   

   
# calculate the radian value for 60 degrees. 
# R needs radians for trig. functions
# Internal angle of a hexagon is 120. 
# 120 / 2 helps form a right-angled triangle   
radian60 <- (60 * pi) / 180

# calculate length of a hexagon side
sidelength <- ( height / 2 ) / sin(radian60)
   
# X offset is 1.5 x sidelength
# this is the x distance from our reference hexagon to the
# NE, SE, SW, NW hexagons (i.e. the diagonal hexagons)
xoffset <- sidelength * 1.5
   
# calculate X values
nX <-  centroidX
nwX <- centroidX + xoffset
swX <- centroidX + xoffset
sx <- centroidX
seX <- centroidX - xoffset
neX <- centroidX - xoffset

# club these into a vector
vct.x <- c(nX, nwX, swX, sx, seX, neX)
   
# calculate Y values
nY <-  centroidy + height
nwY <- centroidy + (0.5 * height)
swY <- centroidy - (0.5 * height)
sY <-  centroidy - height
seY <- centroidy - (0.5 * height)
neY <- centroidy + (0.5 * height)
   
# into a vector
vct.y <- c(nY, nwY, swY, sY, seY, neY)
   
row.names <- c("Nth", "NW", "SW", "Sth", "SE", "NE")
col.names <- c("x", "y")
   
mat.res <- matrix(c(vct.x, vct.y), ncol = 2)
rownames(mat.res) <- row.names
colnames(mat.res) <- col.names
return(mat.res)
   
}


