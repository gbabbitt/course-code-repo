
print("hello Greg...welcome to R")
library('mda') # for mixed model discriminants - need R>v3.5
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
mytest <-  mda(Sp~SL+SW+PL+PW, mysample) # mixed model discriminant analysis (using GMM)
mypred <- predict(mytest, subframe, prior = mytest$prior, method = "predictive")
print(mytest)
print(mypred)
myplot1 <-ggplot(mysample, aes(PL, PW, colour = Sp)) + geom_point()
myplot2 <-ggplot(mysample, aes(SL, SW, colour = Sp)) + geom_point()                                 
myplot3 <-ggplot(subframe, aes(PL, PW, colour = Sp)) + geom_point()
myplot4 <-ggplot(subframe, aes(SL, SW, colour = Sp)) + geom_point()                                 
myMDA <- summary(mytest)
print(myMDA)
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
print(as.factor(mypred))
print(as.factor(Sp))
mymatrix <- confusionMatrix(as.factor(mypred), as.factor(Sp))
print(mymatrix)
#LD plot
myMDplot <- plot(mytest)
print(myMDplot)

print("goodbye Greg...leaving R")
#q()