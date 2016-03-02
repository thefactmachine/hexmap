fn.create.path.elements <- function  (df.cent, vct.offsets)  {
   
   quote <- intToUtf8(34)
   space <- intToUtf8(32)
   
   #=============================================================================
   # To create an SVG path we need to create a string that contains 8 operations...
   # These are:
   # 1) Move to the initial coordination in SVG space. The top left point..indicated my mneumonic "M"
   # 2) Draw a line to the second point. Down and Right ..draw a relative line indicated by mneumonic "l"
   # 3) Draw a line to the third point Down and left ,..mneumonic "l"
   # 4) Draw a horizontal line accross [4th point] relative horizontal line indicated by mneumonic "h"
   # 5) Draw a line to the 5th point. Up and Right... mneumonic "l"
   # 6) Draw a line to the 6th point Up and Left ...mneumonic "l"
   # 7) Draw an absolute horizontal line to the original X cordinate  ... indicated by mneumonic "H"
   # 8) terminate drawing indicated by mneumonic "z"
   
   # the above will create a string that is contained in the d attribute.  d = "string"
   #==============================================================================
   
   fn.create.geometry <- function(x.start, y.start, horiz.move, x.shift, y.shift) {
      # this function creates the actual geometry which is added to the <path .../> element
      op_1 <- paste0("M", x.start,",", y.start)
      op_2 <- paste0("l", x.shift * -1, ",", y.shift * -1)
      op_3 <- paste0("l", x.shift * 1,  ",", y.shift * -1)
      op_4 <- paste0("h",horiz.move)
      op_5 <- paste0("l", x.shift * 1, ",", y.shift * 1)
      op_6 <- paste0("l", x.shift * -1, ",", y.shift * 1)
      op_7 <- paste0("H",x.start)
      op_8 <- paste0("z")
      returnString <- paste0(op_1, op_2, op_3, op_4, op_5, op_6, op_7, op_8)
      return(returnString)
      
   }
   
    
   fn.create.path.string <- function(id.string, a.fill.color, 
                     geometry.string) {
      # this function assembles a <path ..... /> string.
      # the "geometry.string is a complex string and this is outsourced to the ...
      # ... 
      quote <- intToUtf8(34)
      comp.1 <- "<path id="
      comp.2 <- paste0(quote,id.string,quote,space)
      
      
      # comp_3 <- paste0("style=",quote,"fill:",fill.color, ";", quote)
      
      # the following sequence of 4 items (3a to 3d ) creates something similar....
      # ...to the following: style="stroke:white; stroke-width:1px; fill:#35B800;" 
      
      comp.3a <- paste0("style=", quote)

      comp.3d <- paste0("fill:", a.fill.color, ";", quote, space)
      
      # add the Javascript functions to the path element
      comp.4a <- paste0("onmouseover=", quote, "m_over(this.id);", quote, space)
      comp.4b <- paste0("onmouseout=", quote, "m_out(this.id);", quote, space)
      
      
      comp.5 <- paste0("d=",quote, geometry.string, quote, "/>", "\n")
      returnString <- paste0(comp.1, comp.2, comp.3a, comp.3d, comp.4a, comp.4b, comp.5)
   
   
   }
   

   
   # create a null string for use in the following for loop
   str.all.paths <- ""
   # no more calculations required for vct.offsets so round the suckers!! 2 decimal places is more than enough for HTML
   vct.offsets <- round(vct.offsets,2)

   
   for (i in 1:nrow(df.cent)) {
      # iterate through centroids.....
      x.st <- round(df.cent[i, "x_pnt_1"],4)
      y.st <- round(df.cent[i, "y_pnt_1"],4)
      
      str.path <- 
         fn.create.path.string(df.cent[i, "name_abbr"], 
         df.cent[i, "colour"], 
         fn.create.geometry(x.st, y.st, vct.offsets['h.length'], vct.offsets['x.shift'], vct.offsets['yshift'])
         )
      
      
      str.all.paths <- paste0(str.all.paths, str.path)
   }
   return(str.all.paths)
   
}





