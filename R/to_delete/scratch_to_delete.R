rm(list = ls())

vct.names <- c("mark", "fred", "ben")
vct.days <- c(1, 3, 5)
vct.salary <- c(1000, 4000, 5000)
df.data <- data.frame(name = vct.names, days = vct.days, sal = vct.salary)

#look aat this
# example of seq_along
#a <- c(8, 9, 10)
#seq_along(a)
# replace testVariable by:
# syntax do.call(what (is a function), args, quote = FALSE, envir = parent.frame())



fnHexTest <- function(x, y) {
  vct1 <- (x * y) + 1
  vct2 <- (x * y) + 2
  vct3 <- (x * y) + 3
  vct4 <- (x * y) + 4
  vct5 <- (x * y) + 5
  vct6 <- (x * y) + 6
  vectx <- c(vct1, vct2, vct3, vct4, vct5, vct6)
  vecty <- vectx *3
  return(c(vectx, vecty))
  #mat.result <- matrix(c(vecta, vectb), nrow = 6)
  #return(mat.result)
}
# df.data is 3 rows for each row there are 12 points.
result <- fnHexTest(df.data$days, df.data$sal)





matNames <- list(NULL, c("x", "y"))

# can add by column or by row here to help
matResult <- matrix(result, nrow = nrow(df.data) * 6, dimnames = matNames)



# repeat the data frame
tmp.row <- rep(1: nrow(df.data), each = 6)
df.multi <- df.data[tmp.row, ]

df.final <- cbind(df.multi, matResult)

# construct row names --- need to fix 
# repeat ids
repIds <- rep(ids, each = 6)
vxtNum <- rep(1:6, time = nrow(df.data))
rNames <- paste0(repIds, "_", vxtNum)

row.names(df.final) <- rNames


# apply an anonymous function to all elements in a dataframe -- returns a matrix
# lapply returns a list (this is the workhorse)
# apply for matrix

#sapply is a user-friendly version and wrapper of lapply by default returning a 
# vector, matrix or, if simplify = "array", an array if appropriate, defaults to returning
# ..a vector or matrix where possible.

#rapply - For when you want to apply a function to each element of a nested list structure, 

# do.call(rbind, lapply(my.list, data.frame, stringsAsFactors=FALSE))







