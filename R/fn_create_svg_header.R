fn.create.svg.header <- function(svg.id, a.vct.vp, a.width, bg.col) {
   a.vct.vp <- round(a.vct.vp, 2)
   
   quote <- intToUtf8(34)
   space <- intToUtf8(32)
   tab <- paste(space,space,space,space)
   
   aspect <- a.vct.vp['height'] / a.vct.vp['width'] 
   height <- round(aspect * a.width,2)
   
   comp1 <- "<svg " 
   comp1a <- paste0("xmlns=", quote, "http://www.w3.org/2000/svg", quote, space)
   comp2 <- paste0("id=", quote, svg.id, quote, " ")
   comp3 <- paste0("viewBox=", quote, a.vct.vp['left.x'], space, 
                      a.vct.vp['top.y'], space, a.vct.vp['width'], space,
                      a.vct.vp['height'], quote, "\n")
   

   
   comp4 <- paste0("width=", quote, a.width, quote, 
               space, "height =", quote, height, quote, "\n")
   comp5 <- paste0("xml:space =",quote, "preserve", quote, "\n")
   comp6 <- paste0("style =", quote, 
               "background-color:", space, bg.col, ";", quote, ">", "\n")
   
   return.string <- paste0(comp1, comp1a, comp2, comp3, tab, comp4, tab, comp5, tab, comp6)
   return(return.string)

   # test.case fn.create.svg.header("test", vct.vp, 175, "#CCCCCC")
}




