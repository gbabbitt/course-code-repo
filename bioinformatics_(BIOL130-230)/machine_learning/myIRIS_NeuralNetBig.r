####  NOTE: this neural net trains on 10000 random flowers and deploys 
####  classifications on 500000 flowers  (uses multiple CPU core)
print("hello Greg...welcome to R")
library('tictoc')
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
myspecies = mysample[5:5]
print(myspecies)

# set up parallel processing and run several neural nets on available cores
tic("time elapsed")
library(doParallel)
numCores <- detectCores()
print("number of available cores")
print(numCores)
#numCoresUsed = 18  # for use on the server
#numCoresUsed = 36  # for use on the server
numCoresUsed = numCores # for use on your laptop
print("number of cores used")
print(numCoresUsed)
cl <- makeCluster(numCoresUsed)
registerDoParallel(cl)

# train neural network classifier on large amount of data on multiple cores
print("running training on multiple cores")
set.seed(1)
myNN <- train(Sp~SL+SW+PL+PW,
              data = mysample,
              #method = "rf", # random forest
              method = "nnet", # neural network
              maxit = 1000,
              linout = FALSE,
              allowParallel = TRUE)
stopCluster(cl)
print(myNN)
print(plot(myNN))
registerDoSEQ()

print("running predictions (single core)")
mypred <- predict(myNN, subframe, rep = 1, all.units = FALSE)
print("predictions completed")

# print stylized neural net
library('NeuralNetTools')
myStyleNN <- plotnet(myNN)
print(myStyleNN)

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
print(mypred)
print(Sp)
mymatrix <- confusionMatrix(as.factor(mypred), as.factor(Sp))
print(mymatrix)
toc() # print time elapsed
print("goodbye Greg...leaving R")
#q()