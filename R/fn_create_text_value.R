fn.create.text.value <- function(str.id, a.vct.vb, x.off, y.off, size, fill) {
   # this function creates an svg text element to display the hexagon's name
   # the id of this element must be consistent with the id which is used by the ..
   # JavaScript functions....which reference this element.
   
   quote <- intToUtf8(34)
   space <- intToUtf8(32)
   tab <- paste(space,space,space,space)
   
   
   # calculate the x position of the element
   x.pos <- round(x.off + a.vct.vb['left.x'],2)
   # calculate the y position of the element [y.off is the number pixels from the TOP horizontal ]
   y.pos <- round(y.off + a.vct.vb['top.y'],2)
   
   comp1 <- paste0("<text id = ", quote, str.id, quote)
   comp2 <- paste0("x = ", quote, x.pos, quote)
   comp3 <- paste0("y = ", quote, y.pos, quote)
   comp4 <- paste0("font-family = ", quote, "sans-serif", quote)
   comp5 <- paste0("font-size = ", quote, size, "px", quote)
   comp6 <- paste0("fill = ", quote, fill, quote, ">")
   comp7 <- paste0("</text>")
   
   returnString <- paste0(comp1, space, comp2, space, 
         comp3, space, comp4, space, comp5, space, comp6, comp7, "\n")
   
   return(returnString)
   # test case: fn.create.text.value("test", vct.vp, 10, 20, 10, "#FF00FF")
}

