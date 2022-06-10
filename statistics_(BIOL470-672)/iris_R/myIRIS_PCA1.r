
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
#dataframe = subset(dataframe, Sp == "virginica")
myPCA <-  prcomp(dataframe, scale = TRUE)
plot(myPCA$x[,1], myPCA$x[,2])
plot(myPCA$x[,2], myPCA$x[,3])
plot(myPCA$x[,3], myPCA$x[,4])
## make a scree plot
myPCA.var <- myPCA$sdev^2
myPCA.var.per <- round(myPCA.var/sum(myPCA.var)*100, 1)
barplot(myPCA.var.per, main="Scree Plot", xlab="Principal Component", ylab="Percent Variation")
loading_scoresPC1 <- myPCA$rotation[,1]
print(loading_scoresPC1)
loading_scoresPC2 <- myPCA$rotation[,2]
print(loading_scoresPC2)
loading_scoresPC3 <- myPCA$rotation[,3]
print(loading_scoresPC3)
loading_scoresPC4 <- myPCA$rotation[,4]
print(loading_scoresPC4)



print("goodbye Greg...leaving R")
#q()