fn.create.names.offset <- function(a.df.cent) {
   # this function calculate the proportion of the SVG image ...
   # to offset the names text element.  This proportion varies depending on the
   # region...i.e the proportion is different for TA compared to RTO...these 
   # proportions are hard-coded.
   
   n.row.geometry <- nrow(a.df.cent)
   
   if (n.row.geometry == 16) { proportion  <- 0.178 
   } else if (n.row.geometry == 31) { 
      proportion <- 0.248 
   } else if (n.row.geometry == 66) { 
      proportion <- 0.3308 
   } else 
      stop("error number of polygons is not a valid value") 
   
   return (proportion)
}