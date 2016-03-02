fn.create.random.values <- function(a.df.cent, num.quantiles = 4, str.brewer.name = "Greens") {
   #function receives a data frame centroids and adds "value" and "colour" columns
   # str.brewer.name is the name of the color Brewer palette. for a list of color brewer palettes..
   # see display.brewer.all()
   
   fn.find.interval <- function(vct.values, int.num.intervals) {
      # function receives a vector of values and then clasifies these...
      # into a specific interval determined by which quantile the value is a member of
      # the number of quantiles is determined by int.num.intervals
      q.seq <- seq(from = 0, to  = 1, length.out = int.num.intervals + 1)
      quant <- quantile(vct.values , q.seq, na.rm = TRUE)
      interval <-  findInterval(vct.values, quant, all.inside = TRUE)
      return(interval)
      # test case
      # xx <- fn.find.interval(exp.both.years$per.change,3)
   }
   
   # create a vector of normally distributed integer random variables
   flt.values <- round(rnorm(nrow(a.df.cent), 1000000, 50000),0)
   
   # intervals returns a vector of length == nrow(a.df.cent)
   intervals <- fn.find.interval(flt.values, num.quantiles)
   
   # get a colour palette.  For a list of different palettes use: display.brewer.all()
   # the following gets rid of value closest to white (ie. the first value)
   col.pal <- tail(brewer.pal(num.quantiles + 1, str.brewer.name), num.quantiles)
   
   # we now need a colour vector which is has a length == nrow(a.df.cent)..we assign this to the data.frame
   a.df.cent$colour <- col.pal[intervals]
   
   # format the values to include commas and assign them to a column in the data.frame
   a.df.cent$value <- formatC(flt.values, format="d", big.mark = ',')
   
   
   return(a.df.cent)

   # test case fn.create.random.values(df.cent, 5)
}