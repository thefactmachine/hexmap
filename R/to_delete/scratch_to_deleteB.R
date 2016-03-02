
fnVector <- function(fx, fy) {
   x1 <- fx + 1
   x2 <- fx + 2
   x3 <- fx + 3

   y1 <- fy + 1
   y2 <- fy + 2
   y3 <- fy + 3
   
   vctx <- c(x1, x2, x3)
   vcty <- c(y1, y2, y3)
   
   #vct.pair <- c(vctx, vcty)
   vct.series <-  c(x1, y1, x2, y2, x3, y3)
   return(vct.series)
   
}

vct.names <- c("a", "b")
vct.x <- c(10, 20)
vct.y <- c(100, 200)
df.data <- data.frame(name = vct.names, x = vct.x, y = vct.y)
aa <- fnVector(df.data$x, df.data$y)

# desired result [nrow(dataframe) * 3, 2] (i.e. 9 x 2 )
#row_a   11, 101 
#row_a   12, 102
#row_a   13, 103
#row_b   21, 201
#row_b   22, 202
#row_b   23, 203








