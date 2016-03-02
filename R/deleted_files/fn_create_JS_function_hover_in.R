fn.create.JS.function.hover.in <- function() {
   # this function creates a string which is a JavaScript function...
   # ...the JavaScript function will be called my a mouseOver() function...
   # ...assigned to each SVG polygon...
   # ...this current JS function will receive the ID of the SVG polygon over which the mouse hovers...
   # ...this JS function will then use this id to perform the following two functions:
   # a) reduce the opacity of the current SVG element...
   # b.1) obtain a value from the JSON object....
   # b.2) use the value obtain by the JSON object to populate two text fields.
   line1 <- "function m_over(hover_id) { \n"
   line2 <- "    var objName = objNames[hover_id].name;\n"
   line3 <- "    var objValue = objNames[hover_id].value;\n"
   line4 <- "    document.getElementById(\"TEXT_NAME\").innerHTML = objName;\n"
   line5 <- "    document.getElementById(\"TEXT_VALUE\").innerHTML = objValue;\n"
   line6 <- "    document.getElementById(hover_id).setAttribute(\"fill-opacity\", \"0.3\");\n"
   line7 <- "}";
   returnString <- paste0(line1, line2, line3, line4, line5, line6, line7)
   return(returnString)
   # testCase:  cat(fn.create.JS.function.pop.text())
}