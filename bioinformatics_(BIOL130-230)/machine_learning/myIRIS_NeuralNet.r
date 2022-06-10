####  NOTE: this neural net trains on 50 random flowers and deploys 
####  classifications on 150 flowers  (uses single CPU core)
print("hello Greg...welcome to R")
library('neuralnet')
library('ggplot2')
library('dplyr') # for resampling
library('caret') # for confusion matrix
data = read.table('C:/Users/gabsbi/Desktop/code-examples/R/iris_tab.txt', header = TRUE)
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
mysample = sample_n(dataframe, 50, replace=FALSE)
print(mysample)
myspecies = mysample[5:5]
print(myspecies)

# run neural network classifier
mytest <- neuralnet(Sp~SL+SW+PL+PW, mysample, hidden = 3, linear.output = FALSE)
print(mytest)
print(plot(mytest))
mypred <- predict(mytest, subframe, rep = 1, all.units = FALSE)
print(round(mypred))
library(data.table)
print(max.col(mypred)) # return column with maximum value
myplot1 <-ggplot(mysample, aes(PL, PW, colour = Sp)) + geom_point()
myplot2 <-ggplot(mysample, aes(SL, SW, colour = Sp)) + geom_point()                                 
myplot3 <-ggplot(subframe, aes(PL, PW, colour = Sp)) + geom_point()
myplot4 <-ggplot(subframe, aes(SL, SW, colour = Sp)) + geom_point()                                 
myplot5 <-ggplot(subframe, aes(PL, PW, colour = max.col(mypred))) + geom_point()                                 
myplot6 <-ggplot(subframe, aes(SL, SW, colour = max.col(mypred))) + geom_point()                                 
library('grid')
pushViewport(viewport(layout = grid.layout(3, 2)))
print(myplot1, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
print(myplot2, vp = viewport(layout.pos.row = 1, layout.pos.col = 2))
print(myplot3, vp = viewport(layout.pos.row = 2, layout.pos.col = 1))
print(myplot4, vp = viewport(layout.pos.row = 2, layout.pos.col = 2))
print(myplot5, vp = viewport(layout.pos.row = 3, layout.pos.col = 1))
print(myplot6, vp = viewport(layout.pos.row = 3, layout.pos.col = 2))

# confusion matrix
print(max.col(mypred))
Sp_factor <- as.factor(Sp)
print(as.integer(Sp_factor))
Sp_integer <- as.integer(Sp_factor)
mymatrix <- confusionMatrix(as.factor(max.col(mypred)), as.factor(Sp_integer))
print(mymatrix)
print(plot(mytest))
print("goodbye Greg...leaving R")
#q()