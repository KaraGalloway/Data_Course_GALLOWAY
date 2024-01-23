#### COMMANDS ####

# get working directory
getwd()
# get files in directory
list.files()
# get files in specific folder
list.files(path = "Assignments/",recursive = TRUE)
# csv files
write.csv()
read.csv()

#### PACKAGES ####
#   qr code package to make one for free
install.packages("qrcode")
library(qrcode)
url <- ____
qr <- qrcode::qr_code(url)
plot(qr)

# tidyverse
install.packages("tidyverse")
library(tidyverse)
stats::filter() # no, I'd rather have the stats version of filter()
dplyr::filter() # no, I'd rather have the dplyr version of filter()

#### NOTES ####

## for loop ####

x <- c(1,2,3,4,5)

for (i in x){
  print(i+1)
}

## vector ####
# has a class (numeric, character, logical, data.frame,)
# has one dimension
# must all be the same class
# length can = 0
# can be made by:

y <- c(2,3,4,5)
v = 1:5
b = seq(1,100,by=8)

# class of a vector use class(var)
# length of a vector use length(var)

# vector things 
1:5 + 1:5 # 1+1, 2+2, 3+3, etc
x <- c(1,2,3)
x^3 # cubes everything in the vector 

head(letters,n=10)
c <- letters[c(1,3,5)] #concatenates certain values out of letters

## data frame ####
a <- c(1,2,3,4,5)
b <- c("a","b","c","d","e")

z <- data.frame(a,b)
length(z) # 2
class(z) # data.frame
dim(z) # 5 2

# data frames have to combine data of the same length but 
# they do not have to be the same class
# data frames have 2 dimensions [row, column]
# leaving row or column blank will just give all of them


## logical class vectors ####
#   can be asked T/F questions
t <- rep(TRUE, 10)

1>0 # answer: TRUE
0 >= 0 # answer: TRUE
3 < 1 # answer: FALSE
1 == 1 # answer: TRUE
1 != 1 # answer: FALSE

5 > a # answer: TRUE,TRUE,TRUE,TRUE,FALSE
t == TRUE # answer: TRUE x 10

a[5 > a] # give me the values of a where a is less than 5
t[t == FALSE] # no values are FALSE
z[5 > a,]
z[b == "b",]

## access data set ####
iris
iris[iris$Sepal.Length > 5,]
nrow(iris[iris$Sepal.Length > 5,]) # number of rows where this is true
# use $ to access columns in a data set

big_iris <- iris[iris$Sepal.Length > 5,]
# new column in big_iris that is equal to Sepal.Length * Sepal.Width
big_iris$Sepal.Area <- big_iris$Sepal.Length * big_iris$Sepal.Width
# show just 'setosa' from big_iris
big_setosa <- big_iris[big_iris$Species == "setosa",]
# mean of big setosa sepal areas
mean(big_setosa$Sepal.Area)
sd()
sum()
min()
max()
summary()
cumsum()
cumprod()

# ugly plot... but a plot
plot(big_setosa$Sepal.Length,big_setosa$Sepal.Width)

# using mtcars to get all the cars with more than four cyl
four_plus_cyl <- mtcars[mtcars$cyl > 4,]
mean(four_plus_cyl$mpg) # mean of the mpg of just those cars


## object types ####
# logical
c(TRUE,TRUE,FALSE)

# numeric
1:10

# character
letters[3] # vectors just need one dimension

# integer 
c(1L,2L,3L)

# data.frame
mtcars[rows,cols] # two dimensions needed to access a data.frame
str(mtcars) # structure
# ex $ mpg : num : 21, 21, 22
# means there is a column called mpg thats numerical with values ___
names(mtcars) # names of columns
View(mtcars) # pops it up for you to see
# turn each column into its own character and assigns it back to itself
mtcars[,"mpg"]
for(col in names(mtcars)){
  mtcars[,col] <- as.character(mtcars[,col])
}
data(mtcars) # resets built-in data.frame

# factor
# annoying but useful
as.factor(letters) # for categorical type data. stored differently
haircolors <- c("brown","blonde","black","red","red","black")
haircolors_factor <- as.factor(haircolors) # gives levels of colors, possible category options
haircolors[7] <- "purple" # adds just fine
haircolors_factor[7] <- "purple" # can't add since it doesn't fit into a level
levels(haircolors_factor) # shows possible levels


## type conversions ####
1:5 # numeric
as.character(1:5) # convert to character
as.numeric(letters) # gives NA

c("1","b","35") # character
as.numeric(c("1","b","35")) # it tries its best to convert
as.logical(c("1","b","35")) # gives NA
as.(lots of things, try them)
x <- as.logical(c("true","t","F","false","T")) # tries its best
sum(x) # gives NA
sum(TRUE) # 1
TRUE + TRUE # 2
FALSE + 3 # 3
NA + 2 + 100 # NA
1 + NA + 2 # NA
sum(x,na.rm = TRUE) # now it works!


path <- "./Data/cleaned_bird_data.csv" # always treat originals as read-only
df <- read.csv(path)
str(df)
# convert all columns to character
for(col in names(df)){
  df[,col] <- as.character(df[,col])
}
str(df)
# write the new file to your computer
write.csv(df,file = "./Data/cleaned_bird_data_chr.csv")


## 'apply' family functions ####
# same function to every column? apply 2
# same function to every row? apply 1
apply(mtcars,2,as.character)
lapply(list, function) # for lists
apply(mtcars,2,as.logical)
apply(mtcars,2,as.factor)

## pipe ####
mtcars %>% # control shift m 
  filter(mpg > 19 & vs == 1) # selected rows that have an mpg greater than 19 and vs is 1
?filter # ask R for help
# %>% pipe
# thing on the left becomes first argument to thing on the right
mtcars$mpg %>% mean()

abs(mean(mtcars$mpg))
# OR
mtcars$mpg %>% 
  mean() %>% 
  abs() 
# both the same but pipes can be easier to read