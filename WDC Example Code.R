#######################################################################################################
#THE WEEKEND DATA COURSE - EXAMPLE CODE
#AUTHOR: GREGORY SWARD
#COPYRIGHT 2017
#######################################################################################################



# Help Functions ----------------------------------------------------------

#General Notes on Help Functions: 
#The internal help functions are good for a first look at a function or concept.
#R enjoys an immense online community and a google search of any issue will
#likely yield many useful links.
# The best online resource for R issues is Stack Overflow: https://stackoverflow.com/questions/tagged/r
# A list of R Mailing lists can be found here: https://www.r-project.org/mail.html


#Help Function: ?, help()
#To open help document for a function
? c
help(c)

#Special characters and reserved words require quotes
? "for"
help("for")

#Help for entire package
help(package="utils")

#Help Search Function: ??, help.search()
#To search the help system
help.search("normal distribution")
?? "normal distribution"

#Citation Function: citation()
#How to cite an R library in publications
citation(package = "base")

#Example Function: example()
#Runs all the R code from the examples part of the R online help document
example(lm)
example("smooth", package = "stats")



# Environment Functions ---------------------------------------------------

#General Notes on Environment Functions:
#With R Studio, the majority of environment and session attributes are most
#easily controled through the toolbar options.  Most of the time, we do not wish
#to include environment changes within our code.  Nevertheless, there are still
#a handful of R functions that are frequenty useful.

#An excellent tutorial of R Studio's settings and capabilities can be found here: 
#https://www.rstudio.com/resources/webinars/rstudio-essentials-webinar-series-part-1/


#Get working directory: getwd()
#The working directory is the default folder where R will look for files.  It is
#also the default folder for where R will write files. For example, if the
#working directory is C:\Data\, then read.csv("data.csv") will try to load data
#from a file called "data.csv" in the C:\Data\ folder. If we wanted to load data
#from another folder, we can specify the filepath of the file (e.g.
#read.csv("C:/Other Data/other data.csv") - note the forward slashes in the
#filepath this is because backslashes have a special property (escape character)
#You can also use two backslashes instead of one forward slash.)
getwd()

#Set working directory: setwd()
#Sets the working directory to a specified folder. 
#NOTE: YOU SHOULD NEVER SET THE WORKING DIRECTORY IN ANY CODE THAT YOU SHARE
#WITH OTHERS. To avoid having to set the working directory, and to make sharing
#code and data easier, you should develop you work within an R Project (File ->
#New Project)
setwd("C:/Other Data/")

#List objects: ls()
#Lists all the objects in the current R environment.
ls()

#Remove objects: rm()
#Removes objects from the R environment

#Remove one object
rm(a)

#Remove multiple objects
rm(b, c)

#Remove all objects
rm(list = ls(all = TRUE))



# Importing and Exporting Data --------------------------------------------

#General Notes on Importing and Exporting Data:
#The R Studio has a GUI for importing data.  The button to launch the GUI can be
#found in the Environment Widow. While it is useful to be familiar with the R
#GUI, it is better practice to include data imports in your script - doing so
#will make your code more easy to reporduce and share with others.

#Read data from csv file: read.csv()
read.csv("data.csv")

#Functions that read data typically have an argument called stringsAsFactors
#which if set to TRUE (the default value), all text data is coerced to factors.

#Read data from csv file - strings as character types.
#NOTE: If your raw data is stored in Excel, often the best way to import the
#data into the environment is to clean-up the Worksheet (i.e. remove blank rows,
#colomns, etc) and save the file as a CSV.  Then use read.csv to bring in your
#data.
data <- read.csv("data", stringsAsFactors = FALSE)

#There are often two versions of import functions (e.g. read.csv and read.csv2).
#The version ending with the number "2" is used for countries that use a ,
#instead of a . for decimals

#Write data to a csv file: write.csv()
write.csv(data, "data.csv")
write.csv(data, "data.csv", row.names = FALSE) #If we do not want a column of row names added to our file.

#To read tab deliminated data: read.delim()
data <- read.delim("data.txt", header=TRUE, sep="\t")

#Generic data input: read.table() read.csv() and read.delim() are just wrapper
#functions for the read.table() function.  That is, read.csv is read.table, with
#some different default parameters.
data <- read.table("data.txt", header = TRUE)

#A much faster way to load data is provided by the readRDS() function.  The
#readRDS function loads a saved R object.  In addition to being faster, it has
#the added benefit of preserving any comments attached to the object (see below
#for more information on attaching comments to objects).

#Read a serialized R data object (in other words, read a saved R data object): readRDS()
data <- readRDS("data.rds")

#Serialize an R object
saveRDS(data, "data.rds")

#We can serialize other objects like ggplot objects:
library(ggplot2)
p1 <- ggplot(data = mtcars, aes(x=mpg, y=disp)) +
  geom_point()
saveRDS(p1, "p1.rds")
rm(p1)
p1 <- readRDS("p1.rds")
p1


#R and databases 

#The easiest way to connect to a SQL database is to use the ODBC (Open Database
#Connectivity) facility through the RODBC package.  To make things easier still,
#it is useful to create a DSN (Data Source Name).  On a windows machine, you can
#create a DSN through a wizard by going to Control Panel -> Administrative Tools
#-> Data Sources (ODBC).  Searching 'ODBC' should also work.  There are also
#many online walkthroughs for this.  For a Mac OS X, search for 'ODBC Administrator'

#Newer versions of R Studio have a 'Connections Pane' which makes managing and
#exploring databases easier. NOTE: THE dplyr LIBRARY CAN ALSO BE USED TO MANAGE
#DATABASES.  This option does not require a knowledge of SQL; however it does
#require a knowledge of dplyr's SQL translations.  These SQL translations depend
#on the type of database being used.  R Studio provides an excellent resource
#for learning more about connecting and managing databases through R:
#https://db.rstudio.com/

#Connect to a database: odbcConnect() 
library(RODBC)
con <- odbcConnect('mydb1') #connects to a database specified by the mydb1 DSN
con2 <- odbcConnect('mydb2; password=abc123') #connects to a database specified by the mydb2 DSN

#Query the database: sqlQuery()
#This function allows any sqlQuery to be sent to the database
sqlQuery(channel, "SELECT Name, Age FROM Staff WHERE Age > 30 ORDER by Name")
odbcClose(channel)

#The above function requires a basic knowledge of SQL.  There are other functions that can be used for more specific tasks that require less SQL knowledge.  Note, 

#Get some or all of a database table: sqlFetch()
sqlFetch(channel, "Staff") # get the whole Staff table
sqlFetch(channel, "Staff", max = 20, rows_at_time = 10)

#Get a list of all the tables in a database: sqlTables()
sqlTables(channel)


#Write or update an database table: sqlSave(), sqlUpdate() NOTE: Be careful when
#using sqlSave, FAILED WRITES CAN SOMETIMES RESULT IN A DROPPED TABLE.  It is
#recommended that you backup any important data prior to using.

#Saves the staff_data data frame as a table called Staff, uses the data frame
#variable "Names" for the rownames in the database table. The rownames will be
#the primary key for the database table.
sqlSave(channel, dat = staff_data, tablename = "Staff", rownames = "Name", addPK=TRUE) 

#Appends data to an existing table.
sqlUpdate(channel, dat = staff_data, "Staff")


#Exporting graphs R has a variety of functions that start a given graphics
#device driver.  Each driver publishes to a different filetype: PDF, PNG, TIFF,
#JPEG, BMP.  To stop the graphics device, use dev.off().

#Publish to pdf: pdf()
library(ggplot2)
p1 <- ggplot(mtcars, aes(x = mpg, y = hp)) +
  geom_point()

pdf("p1.pdf")
p1
dev.off()

png("p1.png")
p1
dev.off()

tiff("p1.tiff")
p1
dev.off()

#R can also publish scalable vector graphics ("infinitely zoomable")
svg("p1.svg")
p1
dev.off()

cairo_pdf("p1b.pdf")
p1
dev.off()

#Tip: Exporting graphics can get tricky when you start adjusting the resolution 
#(the formatting often gets messed up).  This results in having to re-adjust the
#relative margins and sizes which can be tedious. I have found the overall best
#way to export graphics is to use the pdf() and adjust the height and width
#arguments as needed.  The quality of the pdf document looks nice, and it's easy
#enough to convert from a pdf file to whatever filetype I need.

#Changing resolution can sometimes hurt the formatting.
png("p1.png", res=200)
p1
dev.off()

png("p1.png", res=200, height = 600, width = 600)
p1
dev.off()


pdf("p1.pdf", width = 8, height = 6)
p1
dev.off()

#We can add multiple graphs to the same document.
p2 <- ggplot(mtcars, aes(x = cyl, y= wt)) +
  geom_point()

pdf("p1_and_p2.pdf")
p1
p2
dev.off()


#Final points on data import/export

#When we import data, we want to provide it with a name that gives well 
#describes the information.  Avoid using single letter names like 'x' and 'a'. 
#If you need to include more information on the data, you can add a comment
#(see below).

#Attach a comment to a data object: comment()
grades <- c('A', 'A', 'B', 'B', 'B', 'A-')
comment(grades) <- "Grade data from ECON 101, 2011"

#Note we won't see the comment when we call our object:
grades #no comment appears
#We have to call the function again:
comment(grades) #shows the comment.

#Be careful with comments! They can get passed on to other objects:
grades2 <- grades #now both grades2 and grades have the comment.

#Remove comment:
comment(grades2) <- NULL




# Vectors -----------------------------------------------------------------
# General Notes on Vectors: 

# Vectors are the fundamental building block in R.  Vectors store a series of
# values of the same mode (i.e. each value must be the same 'type' of data (e.g.
# numeric, character, boolean, etc.)).  In R, there is no such thing as scalars,
# single values are store as a vector of length 1.


#Creating vectors

#Create an empty vector: vector()
#This is useful when creating a vector to store the values of an iteration.
v <- vector(mode="numeric", length = 10)

#Storing a single value (vector of length 1)
v <- 1

#Storing a simple sequence of values (more complicated seqences can be handled
#by seq())
v <- 1:10
v <- 1:100
v <- -10:10
v <- -10:-100

#Combining values together: c()
v <- c(1,2,3)
v <- c(5, 10, 30)
v <- c("A", "String", "Vector")

#c() can also accept other vectors as arguments
v1 <- 1:10
v2 <- 31:40
v3 <- c(v1, v2)
v4 <- 20:100
v4 <- c(v3, v4)

#The c() function can also be nested within itself
v <- c(c(1,2,3), c(1,2,3))

#NOTE: RECALL THAT VECTORS CAN ONLY CONTAIN ONE TYPE (MODE) OF DATA.  THEREFORE
#WE WOULD EXPECT TO RECEIVE AN ERROR WHEN WE BREAK THIS RULE.  HOWEVER, WE OFTEN
#DO NOT (SEE BELOW)
v1 <- c(1,"A")

v2 <- 1:10
v3 <- c("A", "V", "C")
v4 <- c(v2, v3)

v5 <- c(1, TRUE)

v6 <- c(100, FALSE, "ABC")

#NONE OF THE ABOVE EXAMPLES THROW AN ERROR. INSTEAD R WILL COERCE THE DATA INTO
#A SINGLE MODE.  THIS IS AN EXAMPLE OF WHY IT IS IMPORTANT TO ALWAYS EXAMINE
#YOUR OBJECTS.


#Create Named Vectors

#Assign names when vector is created
v <- c(one=1, two=2, three=3)
rm(v)

#Assign after vector is created
v <- c(1,2,3)
names(v) <- c("one", "two", "three")
rm(v)


#Combining Vectors

#As shown above, the c() function can be used to combine vectors
v1 <- 1:10
v2 <- 31:40
v3 <- c(v1, v2)
v4 <- 20:100
v4 <- c(v3, v4)


#Combining vectors by rows: rbind() rbind() and cbind often produces a matrices
#- use data.frame() for combining vectors into a data.frame.
v1 <- 1:5
v2 <- 11:15
v3 <- c("A", "B", "C", "D", "E")
m1 <- rbind(v1,v2)
m1
#returns a matrix when the vectors are the same data type
class(m1)   

m2 <- rbind(v1,v3)
m2
#ALSO RETURNS A MATRIX WHEN THE VECTORS ARE NOT THE SAME DATA TYPE.  THE NUMERIC
#DATA WAS COERCED INTO CHARACTER DATA - WATCH OUT FOR THIS!
class(m2)   

#Combining vectors by columns: cbind()
m1 <- cbind(v1, v2)
m1
class(m1)

m2 <- cbind(v1,v2,v3)
m2
class(m2)

#Be careful when combining named values!  R will use the names from the first
#vector.
v1 <- c(one=1, two=2, three=3)
v2 <- c(four=4, five=5, six=6)
v3 <- cbind(v1,v2)
v3 <- rbind(v1,v2)

#Combining vectors as a matrix: matrix()
v1 <- 1:5
v2 <- 6:10
v3 <- c(TRUE, FALSE, TRUE, TRUE, FALSE)
m1 <- matrix(data = c(v1, v2), ncol = 2)  #each vector is its own column
m2 <- matrix(data = c(v1, v2), nrow = 2)  #each vector is NOT its own row
m3 <- matrix(data = c(v1, v3), ncol =2)   #watch out for coercion!

#Combining vectors as a data frame: data.frame()
v1 <- 1:5
v2 <- 6:10
v3 <- c(TRUE, FALSE, TRUE, TRUE, FALSE)
v4 <- c("A", "B", "C", "D", "E")
df1 <- data.frame(v1,v2, v3)
df1
class(df1)


#Note, data.frame will coerce string into factors and adds row names.
df2 <- data.frame(v1, v4)
#We can see that df2 is a data frame object with an int and factor data types.
str(df2)

#We can preserve v4 as strings by setting stringsAsFactors = FALSE
df3 <- data.frame(v1, v4 ,stringsAsFactors = FALSE)
#df3 has int and chr data types.
str(df3)

#The tibble object is data frame with more desireable default behaviour.  It
#does not coerece inputs or add row names, and it only recycles single value
#inputs.  More info on tibbles can be found through ?tibble.

#Create a tibble from vectors: tibble()
library(tibble)
v1 <- 1:5
v2 <- 6:10
v3 <- c(TRUE, FALSE, TRUE, TRUE, FALSE)
v4 <- c("A", "B", "C", "D", "E")
t1 <- tibble(v1,v2,v3,v4)

#Create a list from vectors: list()
v1 <- 1:5
v2 <- 6:10
v3 <- c(TRUE, FALSE, TRUE, TRUE, FALSE)
v4 <- c("A", "B", "C", "D", "E")

l1 <- list(v1, v2, v3, v4)


#Creating vector sequences

#Simple sequences
v <- c(1:10)
v <- c(20:100)

#Create a sequence of values: seq()
v <- seq(from = 0, to = 20, by = 5)
v <- seq(from = 0, to = 20, length.out = 3)
v <- seq(20)

#Replicate values: the rep()
#replicates elements
v <- rep(1, times = 3)
v <- rep(c(1,3,5), times = 3)
v <- rep(c(1,3,5), each = 2, times = 3)
v <- rep(c(1,3,5), each = 2, times = 3, len = 5)

#The seq and rep are very flexible functions that can accomodate pretty much any
#pattern desired.


#Creating a vector by drawing from a statistical distribution

#Randomly draws from the normal distribution: rnorm()
v <- rnorm(10, mean = 0, sd = 1)

#Draws a random sample from a set of observations: sample()
#NOTE: If replace = FALSE, then the same observation cannot be taken into the sample more than once.
v <- c(1:100)
sample_v <- sample(v, size = 10, replace = FALSE)
sample_v <- sample(v, size = 10, replace = TRUE)


#Vector Operations

v1 <- c(1,2,3)
v2 <- c(2,3,4)
v3 <- c(3,4)
s1 <- 3

#Scalar addition, scalar added to each element of the vector
v1 + s1

#Scalar multiplication, scalar multiplied with each element of the vector
v1 * s1

#Vector multiplication, element i of each vector is multipied together (this is known as vectorization.
v1 * v2

#Vector addition, element i of each vector is added
v1 + v2

#Similar for division
v1 / v2

#The modulus function returns the remainder from the division
v1 %% v2
6 %% 4
4 %% 6

#NOTE: if vectors are of different lengths, the values of the smaller vector are
#recycled.  R will give you a warning message in the console.
v4 <- v1 + v3
v5 <- v1 * v3

#Boolean vectors The values of True/False are converted to 1/0 respectively for
#math operations
v6 <- c(TRUE, TRUE, FALSE)
sum(v6)

v6 * v1
v6 + v1


#Logical Operators
#Logical operators allow us to test and select based on a logical statement.

grades <- c(Lizzie = 100, Tom = 90, Jack = 80, Mary = 70, Susie = 60)

#Does an element have a score greater than 70?
grades>70

#Does an element have a score greater or equal to 70?
grades >=70

#Does an element have a score equal to 70?
grades == 70

#Does an element have a score not equal to 70?
grades != 70

#Does an element have a score that is either 70 or 80?
grades == 70 | grades == 80

#Does an element have a score between 90 and 70 inclusive?
grades >= 70 & grades <= 90


#Vector Subsetting

v <- c(1,2,3)
names(v) <- c("one", "two", "three")

#Get first element of vector
v[1]

#Get last element of vector
v[length(v)]

#Get the last 2 elements of a vector
v[(length(v)-1): length((v))]

#select element by name
v['one']
v["two"]

#You can use logical conditions to subset a vector
v <- c(1:100)
v1 <- v[v>50]
v1 <- v[v==10]

grades <- c(Conan="A", Arthur="B", Doyle="C")

#get grades where the observation name is either Conan or Doyle
grades[names(grades)=="Conan" | names(grades)=="Doyle"]

#find the C grades
grades[grades=="C"]


#Set Functions
#There are 4 base set operations that can be used to compare and select from two sets of observations
v1 <- 1:10
v2 <- 5:15
v3 <- c(3,2,1,4,5,10,9,8,7,6)

#union(), returns the combined set of values
union(v1, v2)

#intersect(), returns the common values
#also see ?%in% for 
intersect(v1, v2)

#setdiff() returns the values of one set that are not found in another set
setdiff(v1, v2)

#setequal(), returns a boolean value whether the two sets are equal
setequal(v1, v2)
setequal(v1, v3)

#is.element(), returns a boolean vector whether the elements of one set are present in another set.
is.element(v1,v2)

#Other useful related functions are all() and any()
#Are all values true?: all()
v <- 1:5
v > 0
all(v > 0)

#Are any values true? any()
v <- 1:5
v > 3
all (v > 3)
any (v > 3)


#Getting Vector Properties

#Test whether an object is a vector: is.vector()
is.vector(v)

#Get the length of a vector: length()
#(Can also be used on lists).
length(v)

#Get the structure of an object: str()
str(v)

#Get summary results for an object: summary() 
#NOTE: This function will return different summary values depending on the type
#of data stored within the R object
summary(v)



# Matricies ---------------------------------------------------------------

#General Notes on Matricies: 

#Matricies can be thought of as a two-dimensional vector.  The data contained
#within the matrix must be of the same type (mode) (e.g. all numeric, all
#factor, etc...).  A matrix is a special case of an Array.  Unlike matricies,
#arrays are able to have more than 2 dimensions.

#Create a matrix: matrix()
m <- matrix(nrow=2, ncol=2)
m2 <- matrix(nrow = 10, ncol =1)
m3 <- matrix(c(1,2,3,4), nrow=2, ncol=2)

#Assign individual values
m[1,1] <- 1
m[1,2] <- 2

#assign vector of values to column 1
m[,1] <- c(3,4)

#assign vector of values to row 2
m[2,] <- c(7,8)

#create matrix by binding vectors together
v1 <- c(1,2,3)
v2 <- c(4,5,6)
m <- rbind(v1,v2)
m <- cbind(v1,v2)

#Extend an existing matrix with cbind or rbind
m3 <- matrix(c(1,2,3,4), nrow=2, ncol=2)
m4 <- matrix(c(5,6,7,8), nrow=2, ncol=2)
m5 <- rbind(m3, m4)
m5
m6 <- cbind(m3, m4)
m6

#Coerce objects to a matrix: as.matrix()
m <- as.matrix(v1)

#Get transpose of matrix
mt <- t(m)

#Get inverse of a matrix
inv.m <- solve(m)
#The solve function can be used to solve systems of linear equations.

#matrix multiplication
m1 <- matrix(nrow=2, ncol = 2)
m1[] <- 1
m2 <- matrix(nrow=2, ncol = 2)
m2[] <- 2
mat.mult <- m1 %*% m2


#Matrix indexing 

#We can index a vector with a single value (e.g. v[1] for element 1). With
#matrices, there are two dimension; therefore, we need to specify the rows and
#columns, respectively.
m3 <- matrix(c(1,2,3,4,5,6), nrow=2, ncol=3)

#Select row 1, column 1
m3[1,1]

#Select row 2, column 1
m3[2,1]

#Select row 1, column 2
m3[1,2]

#select all of row 1
m3[1,]

#select all of column 2
m3[,2]

#select columns 2 and 3 or row 1
m3[1, 2:3]

#The same logical operators (e.g. >, >=, etc.) can be applied to matricies
m3 <- matrix(c(1,2,3,4,5,6), nrow=2, ncol=3)
m3 > 3
m3 > 3 & m3 < 6

#Naming matricies We can name a matrix's columns and rows and then index the
#matrix by using these names
m3 <- matrix(c(1,2,3,4,5,6), nrow=2, ncol=3)
colnames(m3) <- c("a", "b", "c")
m3[,"b"]


#Getting matrix properties

#check that object is a martix: is.matrix()
is.matrix(m)

#get the matrix dimensions
dim(m)

#get matrix structure
str(m)

#get summary information
summary(m)



# Data Frames and Tibbles -------------------------------------------------------------

# General Notes on Data Frames:

#A dataframe is similar to a matrix, however it allows for variables of
#different types of data.

#NOTE: The topic of manipulating data frames is mostly covered in the Data
#Manipulation section.

#Creating data.frames

v1 <- c(90,80,70,30)
v2 <- c("A", "A", "A", "A")
v3 <- c(TRUE, TRUE, TRUE, TRUE)

#Create a dataframe: data.frame()
#Note: The default setting is to treat text data as factors (categorical)
df1 <- data.frame(Perc = v1, Grade = v2, Passed = v3)

#create a dataframe with text as strings
df1 <- data.frame(Perc = v1, Grade = v2, Passed = v3, stringsAsFactors = FALSE)
df1

#Get or set the names of a data frame: names()
names(df1)

# Create a tibble 
#A tibble is considered an improvement to the data frame. 
# Tibbles do not coerce inputs or add row names. There are other desirable
# attributes (see ?tibble()).  While tibbles are an improvement to the data
# frame, they primarily exist in the tidyverse philosophy of R.  Their
# populartity will likely increase over time.

library(tibble)
tb1 <- tibble(Perc = v1, Grade = v2, Passed = v3)
#Note: the console output of a tibble object is a bit more viewer-friendly than
#the standard data frame object.
tb1

#Select the second dataframe variable
#We have three ways of accessing our variable

#Select the second element of the data frame
df1[[2]]

#Select the second column, and every row (same as with a matrix)
df1[,2]

#Select by the column name using the $ operator
df1$Grade

#Select a subdata frame

#Select rows 2 and 3
df1[2:3,]

#Select columns 1 and 3
df1[,c(1,3)]

#Select everything except row 2
df1[-2,]

#Subsetting with logical operators

#Get numbers greater than or equal to 80
high.grade <- df1$Perc[df1$Perc >= 80]

#Assign letter grades
#Note, $Grade must be a chr and not a factor for the below code to work.
df1$Grade[df1$Perc < 50] <- "F"
df1$Grade[df1$Perc >= 70] <- "B"
df1$Grade[df1$Perc >= 80] <- "A"

#Assign Pass/Fail boolean
df1$Passed <- df1$Grade != "F"

#To create a new variable and add it to our df1 object, we can make an
#assignment as though that variable was already part of the data frame and R
#will attach the variable to the end column of the dataframe
df1$Name <- c("Liz", "Lizzie", "Beth", "Betty")

#We can also add new data with the cbind and rbind functions (see the section on
#matricies for an example of this)


#NOTE: most of these operations a the 'old' way of manipulating data.  The dplyr
#package provides a much clearer and more concise way of handling most data
#manipulations.  Please see the section on Data Manipulation for more on
#manipulating data frames.




# Lists -------------------------------------------------------------------

#General Notes on Lists:

#A list is a 'blackbox' object that can be used to store any sort of data, or 
#other objects (include other list).  Lists are a handy way of packaging many
#objects together.

#Create a list: list()
v1 <- c(1,2,3)
v2 <- 1:100
m1 <- matrix(nrow=2, ncol=2)

l <- list(Few.Numbers = v1,
          Lots.a.Numbers = v2,
          Empty.Mat = m1)


#Accessing list elements

#Get the first list element
l$Few.Numbers
l[[1]]

#We can also use single [] to index a list; however, the result is contained in
#another list
l[1]
str(l[1])


#Adding more elements to a list
df1 <- data.frame(x = c(TRUE, FALSE, TRUE))
#get the current number of elements in the list
length(l) #returns 3
#Create and set the 4th element to our data frame df1
l[[4]] <- df1
#Now we can see that we have 4 elements in our list
l
length(l)

#Removing an element from a list
#We can remove the data frame we just added by setting it to NULL
l[[4]] <- NULL
l
#We see that the length of our list is now back to 3.
length(l)

  


# Exploring Data Structure ------------------------------------------------

#General Notes of Exploring Data Structure: 

#It is good practice to use the below functions freqeuntly to check that your
#data objects are as expected. You should be thowing the below functions into
#your console window all the time as you are writing your code.

v1 <- c(1,2,3)
v2 <- c("one", "two", "three")
v3 <- c(TRUE, FALSE, TRUE, FALSE)
v4 <- as.matrix(v3)
v5 <- as.data.frame(v4)

#Get object class: class()
class(v1)
class(v2)
class(v3)
class(v4)
class(v5)

#Get object mode: mode()
mode(v1)
mode(v2)
mode(v3)
mode(v4)
mode(v5)

#Get object summary: summary()
summary(v1)
summary(v2)
summary(v3)
summary(v4)
summary(v5)

#Get object structure: str()
str(v1)
str(v2)
str(v3)
str(v4)
str(v5)

#Listing objects: ls()
ls()

#Removing an object: rm()
rm(v1)

#removing all objects
rm(list=ls(all=TRUE))




# Loops and Control Statements --------------------------------------------

#General Notes on Loops and Control Statements:

#If you need your code to behave differently depending on certain conditions, or
#if you need to develop iterative logic, loops and if statements are what you'll
#use.  A lot of the time, loops and control statements appear in the same
#'block' of code.  It is often convenient and cleaner to wrap these blocks in a
#custom function.  RStudio has a built-in command to help you wth this called
#Extract Function.  The below examples show the basic concepts of loops and
#control statements, a bigger illustation of how loops and control statemetns
#and if statements can come together is provided in the RISK Board Game example
#below.

#for loops: for()
#for loops iterate over a known sequence values.

#Print the values 1 through 10
for(i in 1:10) {
  print(i)
}

#This can also be done on single line
for(i in 1:10) print(i)

#We can iterate through any numeric sequence
x <- c(2,8,100)
for(i in x){
  print(i)
}

#loops can be nested within each other
for(i in 1:3){
  print(paste("i =", i))
  for(j in 1:5) {
    print(paste("j =", j))
  }
}

#While loops: while() 
#while loops will keep iterating while the loop condition is TRUE
i <- 1
while(i <= 10) {
  print(i)
  i <- i + 1
}

#break statments are used to exit a loop.
i <- 1
while(TRUE){
  print(i)
  i <- i + 1
  if (i > 10) break
}

#next statements are used to skip to the next iteration
for(i in 1:10) {
  if(i%%2 !=0){
    next
  }else{
    print(i/2)
  }
}

#conditional statement if: 
#if() The if statement is used when the flow of logic needs to vary depending on
#a condition.

x <- 10
if(x > 5) {
  print("x is greater than 5")
}

x <- 10
if(x>=1 & x <=5){
  print("x is between 1 and 5")
}else{
  print("x is not between 1 and 5")
}

x <- 10
if(x>=1 & x <=5){
  print("x is between 1 and 5")
}else if(x>5 & x<=10){
  print("x is between 5 and 10")
}else{
  print("x is not between 1 and 10")
}


#NOTE: The if statement will exit after the first TRUE condition.  In the below
#example, both conditions are true, but only the block associated with the first
#condition is evaluated.
x <- 10
if(x>1){
  print("x is greater than 1")
}else if(x>5){
  print("x is greater than 5")
}

#Vectorized if statement: ifelse()
x <- c(1,5,10,100)

#Assume we want to double any value greater than or equal to 10. The below if
#statement does not expect a vector argument and will only use the first element
#of the vector; consequently it won't do what we need.
if(x >= 10){
  x * 2
}

#The vectorized ifelse statement will perform the ifelse on each element of the
#x vector, and we get the desired result.
ifelse(x>=10,x*2,x)



# Functions ---------------------------------------------------------------

# General Notes on Functions:

#The principle of functions provides and excellent way to help compartmentalize 
#our code and make it more reusable.  The function works by taking inputs, 
#performing tasks, and returning a result.  The RISK Board Game example gives a
#larger illustration of how functions can be used.

#simple function: firstFunction()
#This function takes no arguments and prints the string "Hello World"
firstFunction <- function(){
  print("Hello World")
}
firstFunction()

#Slightly more useful function.  Calculates the area of a circle.  Takes in radius as input and returns the area.
areaOfCircle <- function(radius) {
  area <- pi * radius^2
  return(area)
}

#Note a couple things with the above example: 1. We created the object area
#within the function, but if we try to call it from the console we get 'Error:
#object 'area' not found'.  2. If we call the function without giving it a value
#for the radius, we get an error.

#The below returns an error
area

#The reason why can't call area, is because it is "out of scope".  The function 
#creates an environment within our environment.  We cannot call variables from 
#the function environment, instead the function must return them to us. 
#However; while we cannot directly access objects created within the function, 
#the function is able to access the objects from our environment.  When creating
#R functions within an R Script, it is highly recommended that everything the
#function needs to perform its task be given as an input argument.

#We get an error when we call areaOfCircle because it has no default value for
#radius.  Maybe it's best to leave as-is so that the user knows the made a
#mistake, but we could give radius a default value (below).

#Give radius a default value of 1
areaOfCircle <- function(radius = 1) {
  area <- pi * radius^2
  return(area)
}

circleParams <- function(radius = 1){
  area <- pi * radius^2
  circumference <- 2 * pi * radius
  result <- list(area = area, circumference = circumference)
  return(result)
}

# Risk Board Game Example --------------------------------------------------

#Construct a function that determines the probable outcome of a risk battle.

#Details: The below is an example of solving a problem by creating simulating
#the situation.  Simulations that involve drawing from probability
#distribtutions are referred to as Monte Carlo simulations.

#Simulation Rules: The RISK battle has an attacker and a defender.  The attacker
#can attack with # of armies - 1.  It requires 1 army to remain in the territory
#from where the attack is being laucned.  The number of dice the attacker gets =
#the number of armies with which it is attacking with a maximum of 3 dice.  The 
#number of defender dice = the number of defenders with a maximum of 2 dice. 
#After the attacker and defender have rolled their dice, the top attacker role 
#is compared with the top defender role, then the second highest roles are 
#compared if necessary.  With each comparrison, the attacker wins if they have 
#the higher role.  The defender wins if they have the higher role, or tie.  For 
#example, attacker has 5 armies, defender has 3.  Attacker's 3 roles are 5, 2, 
#3.  Defender's roels are 3,3.  Defender loses 1 army (5 vs 3) and the Attacker 
#loses 1 army (3 vs 3).  The battles are repeated until either the defender is
#out of armies, or the attacker is down to 1 army.


#This is the master function that will run our simulations and solve our game.
risk.game.solver <- function(num.attackers.init, num.defenders.init, num.simulations){
  
  attackers.remaining.vector <- NULL
  defenders.remaining.vector <- NULL
  attacker.victory.vector <- NULL
  
  for (i in 1:num.simulations){
    
    battle.over <- FALSE
    num.attackers <-num.attackers.init
    num.defenders <- num.defenders.init
    while (battle.over == FALSE) {
      
      if (num.attackers <= 1) {
        
        #simulation over
        battle.over <- TRUE
        attacker.victory <- FALSE
        
      }else if (num.defenders == 0) { 
        
        #simulation over
        battle.over <- TRUE  
        attacker.victory <- TRUE  
        
      }else {
        
        #simulation continues
        num.attacker.dice <- getNumDice(num.attackers, "attacker")
        num.defender.dice <- getNumDice(num.defenders, "defender")
        attacker.roll <- rollDice(num.attacker.dice)
        defender.roll <- rollDice(num.defender.dice)
        battle.result <- getBattleResult(attacker.roll, defender.roll)
        num.attackers <- max(num.attackers - battle.result[1], 0)
        num.defenders <- max(num.defenders - battle.result[2], 0)
        
      }
      
    }
    
    attackers.remaining.vector <- c(attackers.remaining.vector, num.attackers)
    defenders.remaining.vector <- c(defenders.remaining.vector, num.defenders)
    attacker.victory.vector <- c(attacker.victory.vector, attacker.victory)
    
  }
  
  result <- list(attackers.remaining = attackers.remaining.vector,
                 defenders.remaining = defenders.remaining.vector,
                 attacker.victory = attacker.victory.vector,
                 success.rate = sum(attacker.victory.vector)/length(attacker.victory.vector))
  return(result)
}


#return the number of dice for attacker or defender depending on number of armies.
getNumDice <- function(num.armies, player) {
  
  if (player == "attacker") {
    
    num.dice <- num.armies - 1
    num.dice <- min(num.dice, 3)
    
  }else {
    
    num.dice <- min(num.armies,2)
  }
  
  return(num.dice)
}


#returns a dice roll for a given number of dice.
rollDice <- function(num.dice){
  possible.values <- 1:6
  rolls <- sample(possible.values, size = num.dice, replace=TRUE)
  return(rolls)
}


#determines the battle result given the attacker and defender rolls.
getBattleResult <- function(attacker.roll, defender.roll){
  attacker.roll <- sort(attacker.roll, decreasing = TRUE)
  defender.roll <- sort(defender.roll, decreasing = TRUE)
  num.dice.to.compare <- min(length(attacker.roll), length(defender.roll))
  attacker.roll <- attacker.roll[1:num.dice.to.compare]
  defender.roll <- defender.roll[1:num.dice.to.compare]
  dice.win <- attacker.roll > defender.roll
  defender.losses <- sum(dice.win)
  attacker.losses <- length(dice.win) - defender.losses
  result <- c(attacker.losses, defender.losses)
  return(result)
}


#Data Tidying ------------------------------------------------------------ The
#above example of code represents the core lanuage and programing patterns of R.
#The rest of the example code deals with using tidyverse to explore and analyze
#some data.  You'll see that much of the above code is not used in the
#tidyverse.  Tidyverse is a very comprehensive set of tools, but they are not
#perfect, and you will need to know the R fundamentals.  Without the
#fundamentals, R remains a collection of tools rather than a language for
#exploring your ideas.

#Tidying data.  The concept of tidy data was put forward by data scientists from
#R Studio.  Tidy data refers to organizing our information in such a way that
#makes it easy to analyze and visualize.  Furthermore, by keeping our data in a
#consistent structure, the code we develop for anlaysis can be more easily
#re-used.

#There are three rules to tidy data:
#1. Each variable must have its own column.
#2. Each observation must have its own row.
#3. Each value must have its own cell.

#Looking at the above characteristics, the first reaction most people have is
#that nearly all data sets are tidy.  In fact, it is the opposite case.  See the
#slide handouts for data sets that are 'too wide' or 'too narrow'.

#load tidyverse
library(tidyverse)

#load our data sets
commute_data_raw <- read.csv("data/commute_data.csv")
hr_performance_data_raw <- read.csv("data/hr_employees_performance_data.csv")
personal_data_raw <- read.csv("data/personal_data.csv", stringsAsFactors = FALSE)
rnd_performance_data_raw <- read.csv("data/research_and_development_employees_performance_data.csv")
sales_performance_data_raw <- read.csv("data/sales_employees_performance_data.csv")  
  
#examine our data
str(commute_data_raw)
str(personal_data_raw)
str(hr_performance_data_raw)
str(rnd_performance_data_raw)
str(sales_performance_data_raw)

#We see that there is a column called X in each of our data sets.  This appears
#to be a data glitch (this sometimes happens when getting data from Excel when
#the user has some content in a column and then clears the content rather than
#deleteing the column)

#Remove the X columns with the select() function
#Lets also rename our modified data sets so that we keep our raw data untouched.
commutes_data <- commute_data_raw %>%
  select(-X)
  
hr_performance_data <- hr_performance_data_raw %>%
  select(-X)

rnd_performance_data <- rnd_performance_data_raw %>%
  select(-X)

sales_performance_data <- sales_performance_data_raw %>%
  select(-X)


#combine performance data
#we want to be able to identify an employee's department, so we'll make a new variable for this
hr_performance_data <- hr_performance_data %>%
  mutate(Department = "HR")

rnd_performance_data <- rnd_performance_data %>%
  mutate(Department = "Research and Development")

sales_performance_data <- sales_performance_data %>%
  mutate(Department = "Sales")

#Now we can combine our performance data, they all have the same variables
performance_data <- rbind(hr_performance_data,
                     rnd_performance_data,
                     sales_performance_data)

#Department should probably be a category not just text - change it to factor
performance_data <- performance_data %>%
  mutate(Department = as.factor(Department))

#We can see that the commute data and the performance data share the same 
#employee id variable - we can use this to join the data sets together.  The
#dplyr package offers many join functions to help with this.

#left_join performance and commute will give us all the rows from performance,
#right_join will give all the rows from commute, inner_join will give us only
#the rows where there is a match in employee id.  Ideally, all three will return
#the same result.

employee_data <- left_join(performance_data, commutes_data, by = "EmployeeNumber")


#Now lets work on the personal data set... Unlike the other data, personal is 
#not tidy, each varible does not have its own column.  Use tidyr to spread out 
#the data.  Once the data has been spread we see that all the values are chr -
#we need to coerce the data to the proper types.

personal_data <- personal_data_raw %>%
  spread(key = Variable, value = Value) %>%
  mutate(Attrition = as.factor(Attrition),
         Education = as.integer(Education),
         EducationField = as.factor(EducationField),
         Gender = as.factor(Gender),
         Age = as.integer(Age),
         MaritalStatus = as.factor(MaritalStatus),
         RelationshipSatisfaction = as.integer(RelationshipSatisfaction)) %>%
  select(-EmployeeCount)

#We can now tie this in with our other data
employee_data <- inner_join(employee_data, personal_data, by = "EmployeeNumber")

#Lets takes a look at our data set and trim where we can
str(employee_data)

#Firstly, we see that we have dailyrate, hourlyrate, monthlyincome, and monthly
#rate.  Secondly, we also have a lot of integer data which are actually categories

#Check if the various rates are telling us the same thing.
library(corrgram)
rates <- employee_data %>%
  select(DailyRate, HourlyRate, MonthlyRate, MonthlyIncome)
corrgram(rates, upper.panel = panel.conf,lower.panel =  panel.pts)

#These variables are not correlated at all.  We should keep them for the time
#being. Looking at employee standard hours, we see that the variable doesn't
#change - we can get rid of it too.  Same with over18
employee_data <- employee_data %>%
  select(-StandardHours, -Over18)

#We need to convert some data to factors.  
employee_data <- employee_data %>%
  mutate(EnvironmentSatisfaction = as.factor(EnvironmentSatisfaction),
         JobInvolvement = as.factor(JobInvolvement),
         JobLevel = as.factor(JobLevel),
         JobSatisfaction = as.factor(JobSatisfaction),
         PerformanceRating = as.factor(PerformanceRating),
         StockOptionLevel = as.factor(StockOptionLevel),
         WorkLifeBalance = as.factor(WorkLifeBalance),
         Education = as.factor(Education),
         RelationshipSatisfaction = as.factor(RelationshipSatisfaction)
         )

#Now let start looking at our data...
#Lets look at attrition by gender using the group_by function
a <- employee_data %>%
  select(Gender, Attrition) %>%
  group_by(Gender, Attrition) %>%
  summarise(Count = n()) %>%
  spread(key = Attrition, value = Count) %>%
  mutate(PercentAttrition = Yes/(Yes + No))
a


#Lets look at attrition by gender and by department (note we only have to change 2 lines of code!)
a <- employee_data %>%
  select(Gender, Attrition, Department) %>%
  group_by(Department, Gender, Attrition) %>%
  summarise(Count = n()) %>%
  spread(key = Attrition, value = Count) %>%
  mutate(PercentAttrition = Yes/(Yes + No))
a


#Let look at attrition by gender and by department for people over 40
over_forty <- dplyr::filter(employee_data, Age >= 40)
a <- over_forty %>%
  select(Gender, Attrition, Department) %>%
  group_by(Department, Gender, Attrition) %>%
  summarise(Count = n()) %>%
  spread(key = Attrition, value = Count) %>%
  mutate(PercentAttrition = Yes/(Yes + No))
a

#Lets take a look at commutes
a <- employee_data %>%
  select(Attrition, DistanceFromHome) %>%
  group_by(Attrition) %>%
  summarise(AvgDist = mean(DistanceFromHome),
            StdevDist = sd(DistanceFromHome))


#We can see that tidyr and dplyr make us quite the data gymnasts! With Excel,
#the 'how about this?' and the 'could-you-actually?' can mean a lot of work. 
#With these libraries, it can be a matter of one or two lines of code!


#Lets start visualizing our data with ggplot2 ggplot2 stores our graphics object
#as a ggplot object.  ggplot2 offers a layered approach to building our 
#visualzations.  First we specify the data set, then we specify the aesthetic 
#relationships (i.e. how we actually want to see our variables.  do we want 
#attriion on the x-axis?).  The next layer is a geom layer which describes the
#type of graph we're creating.
library(ggplot2)
p1 <- ggplot(data = employee_data, aes(x=Attrition, y=HourlyRate)) +
  geom_boxplot()
p1



#lets also look at department
p1 <- ggplot(data = employee_data, aes(x=Attrition, y=HourlyRate, fill = Department)) +
  geom_boxplot()
p1

#lets show the distribution another way.  facetting allows us to break down a
#graph into multpile graphs by a category.
p1 <- ggplot(data = employee_data, aes(x=HourlyRate, fill = Attrition)) +
  geom_density(alpha = 0.4) +
  facet_wrap(~Department, ncol=1)
p1


p1 <- ggplot(data = employee_data, aes(x=HourlyRate, fill = Attrition)) +
  geom_histogram(alpha = 0.4) +
  facet_wrap(~Department, ncol=1)
p1

#If you'd like different color schemes, you can set your own pallets, or you can
#use some from the ggthemes package.  Be careful that you have enough different
#colors for the number of variables that you wish to plot!

library(ggthemes)

p1 <- ggplot(data = employee_data, aes(x=HourlyRate, fill = Attrition)) +
  geom_histogram(alpha = 0.4) +
  facet_wrap(~Department, ncol=1) +
  scale_fill_fivethirtyeight()
p1


#create a scatterplot of YearsAtCompany vs age
p1 <- ggplot(data = employee_data, aes(x = Age, y = YearsAtCompany, color = Attrition)) +
  geom_point() +
  geom_smooth()
p1


p1 <- ggplot(data = employee_data, aes(x = Age, y = YearsAtCompany )) +
  geom_point(aes(color = Attrition)) +
  geom_smooth()
p1


#lets see how job performance factors in...

#below doesn't work, can't use integers for categories!
p1 <- ggplot(data = employee_data, aes(x = Attrition, fill = PerformanceRating)) +
  geom_bar(position = "dodge")
p1


p1 <- ggplot(data = employee_data, aes(x = Attrition, fill = as.factor(PerformanceRating))) +
  geom_bar(position = "dodge")
p1


#Another good library for creating graphs is ggvis.
library(ggvis)

employee_data %>%
  ggvis(x = ~factor(Education), fill = ~Attrition) %>%
  layer_bars()


employee_data %>%
  ggvis(x = ~Gender, fill = ~Attrition) %>%
  layer_bars()


#There are a lot of variables in our dataset, let's use a decision tree algo to
#help identify some variables that are likely important
library(party)
library(caret)  #needed for the confusion matrix

#First we need to split our data into a training set and a test set:

dataSpliter <- function(employee_data, p = 0.7){
  set.seed(10)
  num_obs <- dim(employee_data)[1]
  draw = sample(1:num_obs, replace = FALSE)
  draw_split <- floor(num_obs * p)
  train = employee_data[draw[1:draw_split], ]
  test = employee_data[draw[(draw_split + 1):num_obs], ]
  result <- list(train = train, test = test)
  return(result)
} 

employee_allsets <- dataSpliter(employee_data, p = 0.7)
employee_trainset <- employee_allsets$train
employee_testset <- employee_allsets$test

train_ctree <- ctree(data = employee_trainset, formula = Attrition ~ BusinessTravel +
                       DailyRate +
                       EnvironmentSatisfaction +
                       JobInvolvement)

#The above tree indicates that the Environment Satisfaction plays the most
#important role in whether an employee stays

#Let's see how our model does to predict the results from our testset
predict_ctree <- predict(train_ctree, employee_testset)

confusionMatrix(predict_ctree, employee_testset$Attrition)
#Hurray! 86% accuracy!, but wait... this is a bit misleading since the vast
#majority of employees will remain.  Looking at the confusion matrix, we
#predicted hardly any of the employees who actually left, only the ones that
#stayed.


#Let's try again with more variables in our model
train_ctree <- ctree(data = employee_trainset, formula = Attrition ~ BusinessTravel +
                       DailyRate +
                       EnvironmentSatisfaction +
                       HourlyRate +
                       JobInvolvement +
                       JobLevel +
                       JobRole +
                       JobSatisfaction +
                       MonthlyIncome +
                       MonthlyRate +
                       NumCompaniesWorked +
                       OverTime +
                       PercentSalaryHike +
                       PerformanceRating +
                       StockOptionLevel +
                       TotalWorkingYears +
                       TrainingTimesLastYear +
                       WorkLifeBalance +
                       YearsAtCompany +
                       YearsInCurrentRole +
                       YearsSinceLastPromotion +
                       YearsWithCurrManager +
                       Department +
                       DistanceFromHome +
                       Education +
                       EducationField +
                       Gender +
                       MaritalStatus +
                       RelationshipSatisfaction +
                       Age
                       )
predict_ctree <- predict(train_ctree, employee_testset)

confusionMatrix(predict_ctree, employee_testset$Attrition)

#We've improved our accuracy, but let's see if we can still do better by using a random forest algo.


employee_data <- employee_data %>%
  mutate(EnvironmentSatisfaction = as.factor(EnvironmentSatisfaction),
         JobInvolvement = as.factor(JobInvolvement),
         JobSatisfaction = as.factor(JobSatisfaction),
         JobLevel = as.factor(JobLevel),
         JobRole = as.factor(JobRole))


library(randomForest)
rand_forest <- randomForest(Attrition ~ ., data = employee_trainset, importance = TRUE)

predict_forest <- predict(rand_forest, employee_testset)
confusionMatrix(predict_forest, employee_testset$Attrition)
importance(rand_forest)

plot(rand_forest)


#Overtime and Job Role appear to be the most important factors.  Let's see if we can visualize this.

pdf("Perc_Attrition_Department.pdf")
p1 <- ggplot(data = employee_data) +
  geom_bar(aes(x = JobRole, fill = Attrition), position="fill") +
  ggtitle("Percentage Attrition by Department") +
  scale_fill_colorblind()
p1
dev.off()


library(plotly)
ggplotly(p1)



p1 <- ggplot(data = employee_data) +
  geom_bar(aes(x = OverTime, fill = Attrition), position="fill") +
  ggtitle("Percentage Attrition by OverTime") +
  scale_fill_colorblind()
p1

p1 <- ggplot(data = employee_data) +
  geom_bar(aes(x = StockOptionLevel, fill = Attrition), position="fill") +
  ggtitle("Percentage Attrition by Stock Option Level") +
  theme(axis.title.y = element_blank()) +
  scale_fill_colorblind()
p1


#Use the random forest model to get a list of employees that are likely to leave
employees_current <- employee_data %>%
  filter(Attrition == "No")

current_prediction <- predict(rand_forest, employees_current)
employees_current$PredictedAttrition <- current_prediction

likely_to_leave_list <- employees_current %>%
  filter(PredictedAttrition == "Yes")


#Use the partition tree model to get another list of employees that are likely to leave
current_prediction_tree <- predict(train_ctree, employees_current)
employees_current$PredictedAttrition2 <- current_prediction_tree

likely_to_leave_list2 <- employees_current %>%
  filter(PredictedAttrition2 == "Yes")


