
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
subframe = data.frame(SL, SW, PL, PW)
set.seed(2)
mytest <-  kmeans(subframe, 3, nstart = 3)
myplot1 <-ggplot(data, aes(PL, PW, color = Sp)) + geom_point()
myplot3 <-ggplot(data, aes(SL, SW, color = Sp)) + geom_point()                                 
myKMEANS <- summary(mytest)
print(myKMEANS)
mytest$cluster <- as.factor(mytest$cluster)
myplot2 <-ggplot(data, aes(PL, PW, color = mytest$cluster)) + geom_point()                                 
myplot4 <-ggplot(data, aes(SL, SW, color = mytest$cluster)) + geom_point()                                 
library('grid')
pushViewport(viewport(layout = grid.layout(2, 2)))
print(myplot1, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
print(myplot2, vp = viewport(layout.pos.row = 1, layout.pos.col = 2))
print(myplot3, vp = viewport(layout.pos.row = 2, layout.pos.col = 1))
print(myplot4, vp = viewport(layout.pos.row = 2, layout.pos.col = 2))
print("goodbye Greg...leaving R")
#q()