fn.create.json.object <- function(df.cent) {
   # this function creates a JSON object as a text file.
   # nrow(df.value) == number of hexagons; 
   # df.values has 3 columns: abbr (i.e AUK), name (i.e Auckland), value (993939)
   # the number value is interpreted as text and could be pre-formatted to include commmas.
   
   # the following code just reformats things a bit:
   
   # create a test set of data values
   df.value  <- data.frame(abbr = df.cent$name_abbr, 
                           name = df.cent$name, 
                           value = df.cent$value)
   
   
   # lets rip the " Region" out of region  
   df.value$name <- gsub(" Region" ,"", df.value$name)   
   
   quote <- intToUtf8(34)
   space <- intToUtf8(32)
   tab <- paste0(space,space,space,space)
   
   
   # this function gets used by the for loop below
   fn.create.JSON.primitive <- function(a.abbr, a.name, a.value) {
      # uses fully quoted keys. values are also quoted and will be interpreted as strings
      comp1 <- paste0(quote, a.abbr, quote, ":{")
      comp2 <- paste0(quote, "name", quote, ":", quote, a.name, quote, ",")
      comp3 <- paste0(quote, "value", quote, ":", quote, a.value, quote, "}")
      return.string <- paste0(tab, comp1, comp2, comp3)
      return(return.string)
      # test case: cat(fn.create.JSON.primitive("LTA", "Lake Taupo", "2000"))
   }
   # we will keep appending json primatives to this string.
   str.json.primitives <- ""   
   for (i in 1:nrow(df.value)) {
      # call the function above
      json.primitive <- fn.create.JSON.primitive(df.value[i, "abbr"], df.value[i, "name"], df.value[i, "value"])
      if (i < nrow(df.value)) {
         #if its not the last row, then add a comma 
         str.json.primitives <- paste0(str.json.primitives, json.primitive, "," , "\n")
      }
      else {
         #its the last row, so no commma neccessary 
         str.json.primitives <- paste0(str.json.primitives, json.primitive, "\n")
      }
   }
   str.init.lines <-  "var objNames =  \n {\n"
   str.terminator <- "}"
   returnString <- paste0(str.init.lines, str.json.primitives, str.terminator)
   return(returnString)
   # test case for this: cat(fn.create.json.object(df.value))
}


