
print("hello Greg...welcome to R")

library('ggplot2')
data = read.table('C:/Users/gabsbi/Desktop/code-examples/R/iris_tab.txt', header = TRUE)
Sp = data$species; # species
SL = data$sepal_length; # sepal length
SW = data$sepal_width; # sepal width
PL = data$petal_length; # petal length
PW = data$petal_width; # petal width
dataframe = data.frame(SL, SW, PL, PW, Sp)
print (dataframe)
mytest <-  lm(formula = PL ~ PW + SL + SW, data = dataframe, subset=Sp=="setosa")
Y <- cbind(SL,SW,PL,PW)
print (Y)
myplot <-pairs(Y, col=as.factor(Sp))
myMLR <- summary(mytest)
print(myMLR)
print (myplot)
sink("statsMLR_setosa.txt")
print (myMLR)
sink()
print("goodbye Greg...leaving R")
#q()