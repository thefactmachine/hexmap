fn.create.JS.function.hover.out <- function() {
   # this function creates a string which is a JavaScript function...
   # this function simply restores the opacity of a polygon back to 1 ...
   
   line1 <- "function m_out(hover_id) { \n"
   line2 <- "    document.getElementById(hover_id).setAttribute(\"fill-opacity\", \"1.0\");\n"
   line3 <- "}";
   returnString <- paste0(line1, line2, line3)
   return(returnString)
   # testCase:  cat(fn.create.JS.function.pop.text())
}