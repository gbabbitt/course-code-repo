
print("hello Greg...welcome to R")

library('ggplot2')

data = read.table('C:/Users/gabsbi/Desktop/code-examples/R/iris_tab.txt', header = TRUE)
Sp = data$species; # species
SL = data$sepal_length; # sepal length
SW = data$sepal_width; # sepal width
PL = data$petal_length; # petal length
PW = data$petal_width; # petal width
dataframe = data.frame(SL, SW, PL, PW)
print (dataframe)
myPCA <-  princomp(dataframe, cor=TRUE)
mytest <- summary(myPCA) # print variance accounted for 
myload <- loadings(myPCA) # pc loadings 
myscores <- myPCA$scores # the principal components
plot(myPCA,type="lines") # scree plot 
biplot(myPCA)
print(mytest)
print(myload)
print(myscores)
#print(myplot1)
print("goodbye Greg...leaving R")
#q()