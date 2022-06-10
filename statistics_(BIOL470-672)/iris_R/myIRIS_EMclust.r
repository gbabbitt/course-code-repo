
#  see this tutorial on mclust
#  https://cran.r-project.org/web/packages/mclust/vignettes/mclust.html

print("hello Greg...welcome to R")
library('mclust')
library('ggplot2')
data = read.table('C:/Users/gabsbi/Desktop/code-examples/R/iris_tab.txt', header = TRUE)
Sp = data$species; # species
SL = data$sepal_length; # sepal length
SW = data$sepal_width; # sepal width
PL = data$petal_length; # petal length  
PW = data$petal_width; # petal width
dataframe = data.frame(SL, SW, PL, PW, Sp)
print (dataframe)
subframe = data.frame(SL, SW, PL, PW)
set.seed(2)
# find best candidate model
myBIC <- mclustBIC(subframe)
# use best model  NOTE: for iris data G = 3 species
#myModel <- Mclust(subframe, G = 1:9, x = myBIC) # use best cluster break
myModel <- Mclust(subframe, G = 3, x = myBIC) # define number of clusters manually
print(summary(myModel, parameters = TRUE))
# my grid plot in ggplot2
myplot1 <-ggplot(data, aes(PL, PW, color = Sp)) + geom_point()
myplot3 <-ggplot(data, aes(SL, SW, color = Sp)) + geom_point()                                 
myKMEANS <- summary(myModel)
print(myKMEANS)
myModel$cluster <- as.factor(myModel$cluster)
myplot2 <-ggplot(data, aes(PL, PW, color = myModel$classification)) + geom_point()                                 
myplot4 <-ggplot(data, aes(SL, SW, color = myModel$classification)) + geom_point()                                 
library('grid')
pushViewport(viewport(layout = grid.layout(2, 2)))
print(myplot1, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
print(myplot2, vp = viewport(layout.pos.row = 1, layout.pos.col = 2))
print(myplot3, vp = viewport(layout.pos.row = 2, layout.pos.col = 1))
print(myplot4, vp = viewport(layout.pos.row = 2, layout.pos.col = 2))
# plot BIC fit and model overlay on data
print(plot(myBIC))
print(plot(myModel, what = "uncertainty"))
print(plot(myModel, what="classification"))
print(plot(myModel, what="density"))
print("goodbye Greg...leaving R")
#q()