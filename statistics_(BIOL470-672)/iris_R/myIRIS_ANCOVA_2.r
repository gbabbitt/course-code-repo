
print("hello Greg...welcome to R")

library('ggplot2')
data = read.table('C:/Users/gabsbi/Desktop/code-examples/R/iris_size_tab.txt', header = TRUE)
Sp = data$species; # species
SL = data$sepal_length; # sepal length
SW = data$sepal_width; # sepal width
PL = data$petal_length; # petal length
PW = data$petal_width; # petal width
SZ = data$avg_size; # flower size
dataframe = data.frame(SL, SW, PL, PW, Sp, SZ)
print (dataframe)
mytest <-  aov(formula = PL ~ SL*Sp, data = dataframe)
Y <- cbind(SL,SW,PL,PW)
print (Y)
myplot <-pairs(Y, col=as.factor(Sp))
myANCOVA <- summary(mytest)
print(myANCOVA)
print (myplot)
sink("statsANCOVA2.txt")
print (myANCOVA)
print("goodbye Greg...leaving R")
#q()