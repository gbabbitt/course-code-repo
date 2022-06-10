####  NOTE: this SVM trains on 10000 random flowers and deploys 
####  classifications on 500000 flowers(uses GPU/multiple CPU)
print("hello Greg...welcome to R")
library('tictoc')
library('liquidSVM') # for SVM on multiple CPU or GPU
library('ggplot2')
library('dplyr') # for resampling
library('caret') # for confusion matrix
data = read.table('C:/Users/gabsbi/Desktop/code-examples/R/iris_tab_big.txt', header = TRUE)
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
mysample = sample_n(dataframe, 10000, replace=FALSE)
print(mysample)
### run support vector machine
tic("time elapsed")
mytest <- svm(Sp~SL+SW+PL+PW, mysample, threads=8, display=1, gpus=0, do.select=TRUE, predict.prob=FALSE)
mypred <- predict(mytest, subframe, probability = FALSE, decision.values = TRUE)

### WARNING - this scatterplot function commented out runs very slow
#print("running plotting functions - (very slow)")
#myplot1 <-ggplot(mysample, aes(PL, PW, colour = Sp)) + geom_point()
#myplot2 <-ggplot(mysample, aes(SL, SW, colour = Sp)) + geom_point()                                 
#myplot3 <-ggplot(subframe, aes(PL, PW, colour = Sp)) + geom_point()
#myplot4 <-ggplot(subframe, aes(SL, SW, colour = Sp)) + geom_point()                                 
#myplot5 <-ggplot(subframe, aes(PL, PW, colour = mypred)) + geom_point()                                 
#myplot6 <-ggplot(subframe, aes(SL, SW, colour = mypred)) + geom_point()                                 
#library('grid')
#pushViewport(viewport(layout = grid.layout(3, 2)))
#print(myplot1, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
#print(myplot2, vp = viewport(layout.pos.row = 1, layout.pos.col = 2))
#print(myplot3, vp = viewport(layout.pos.row = 2, layout.pos.col = 1))
#print(myplot4, vp = viewport(layout.pos.row = 2, layout.pos.col = 2))
#print(myplot5, vp = viewport(layout.pos.row = 3, layout.pos.col = 1))
#print(myplot6, vp = viewport(layout.pos.row = 3, layout.pos.col = 2))

# confusion matrix
print(as.factor(mypred))
print(as.factor(Sp))
mymatrix <- confusionMatrix(as.factor(mypred), as.factor(Sp))
print(mymatrix)
toc() # print time elapsed
print("goodbye Greg...leaving R")
#q()