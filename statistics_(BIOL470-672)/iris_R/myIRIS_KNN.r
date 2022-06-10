
print("hello Greg...welcome to R")
library('ggplot2')
library('class')
library('dplyr') # for resampling
library('caret') # for confusion matrix
# note Sp must be integers when using distance based algorithm like KNN
data = read.table('C:/Users/gabsbi/Desktop/code-examples/R/iris_tab_integer.txt', header = TRUE)
Sp = data$species; # species
SL = data$sepal_length; # sepal length
SW = data$sepal_width; # sepal width
PL = data$petal_length; # petal length
PW = data$petal_width; # petal width
dataframe = data.frame(SL, SW, PL, PW, Sp)
subframe = data.frame(SL, SW, PL, PW)
print (subframe)
rnd <- sample(1:150, 1)
set.seed(rnd)
mysample = sample_n(dataframe, 20, replace=FALSE)
print(mysample)
print(dim(mysample))
print(length(mysample))
# make sure class is a vector matching length of a single data column in training data frame
myspecies = mysample[,5]
print(myspecies)
print(dim(myspecies))
print(length(myspecies))
#sample_subframe = mysample(SL, SW, PL, PW)
#print(sample_subframe)
mypred <- knn(mysample, dataframe, myspecies, k=3, l = 0, prob = FALSE, use.all = TRUE)
#mypred <- predict(mytest, dataframe, probability = FALSE, decision.values = TRUE)
myplot1 <-ggplot(mysample, aes(PL, PW, colour = as.factor(Sp))) + geom_point()
myplot2 <-ggplot(mysample, aes(SL, SW, colour = as.factor(Sp))) + geom_point()                                 
myplot3 <-ggplot(subframe, aes(PL, PW, colour = as.factor(Sp))) + geom_point()
myplot4 <-ggplot(subframe, aes(SL, SW, colour = as.factor(Sp))) + geom_point()                                 
myKNN <- summary(mypred)
print(myKNN)
myplot5 <-ggplot(subframe, aes(PL, PW, colour = mypred)) + geom_point()                                 
myplot6 <-ggplot(subframe, aes(SL, SW, colour = mypred)) + geom_point()                                 
library('grid')
pushViewport(viewport(layout = grid.layout(3, 2)))
print(myplot1, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
print(myplot2, vp = viewport(layout.pos.row = 1, layout.pos.col = 2))
print(myplot3, vp = viewport(layout.pos.row = 2, layout.pos.col = 1))
print(myplot4, vp = viewport(layout.pos.row = 2, layout.pos.col = 2))
print(myplot5, vp = viewport(layout.pos.row = 3, layout.pos.col = 1))
print(myplot6, vp = viewport(layout.pos.row = 3, layout.pos.col = 2))
# confusion matrix
print(as.factor(as.integer(mypred)))
print(as.factor(Sp))
mymatrix <- confusionMatrix(as.factor(as.integer(mypred)), as.factor(Sp))
print(mymatrix)
print("goodbye Greg...leaving R")
#q()