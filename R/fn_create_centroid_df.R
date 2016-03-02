fn.create.centroid.df <- function(df.hexpoints, offsets, viewport) {
   # this function 
   # 1) shrinks a nrow(n *6 ) to nrow() and adds 2 columns
   # 2) calculates starting points for drawing the hexagons. Starting point is the top left vertex.
   df.centroids <- df.hexpoints %>% 
      dplyr::group_by(name, name_abbr) %>% 
      dplyr::summarise(x_cen = first(x_centre), y_cen = first(y_centre)) %>% 
      as.data.frame()
   
   # add the x & y  starting points
   df.centroids$x_pnt_1 <- df.centroids$x_cen - offsets['x.shift']
   # transform y such that the origin is at the top left (rather than the bottom left)
   df.centroids$y_pnt_1 <- (viewport['top.y'] * 2) + offsets['yshift'] - df.centroids$y_cen
   return(df.centroids)
   # test case :  fn.create.centroid.df(region_hex_gg, offsets, vp)
}