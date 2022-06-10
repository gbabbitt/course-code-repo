print("hello, welcome to R")

library('ggplot2')
library('reshape2')
# NOTE: install libraries with 'install.packages('PackageName') on the R console


# NOTE: In Win full path is not needed if data file is in same folder as code script
# NOTE: In Linux, full path is always needed
# NOTE: full path in Win is C:/Users/username/Desktop/folder/filename
# NOTE: full path in Linux/Mac is /home/username/Desktop/folder/filename
data<-read.table("C:/Users/gabsbi/Desktop/code-examples/iris_R/iris_tab.txt",header=TRUE)
sepal_length=data$sepal_length
sepal_width=data$sepal_width
petal_length=data$petal_length
petal_width=data$petal_width
species=data$species

iris.data<-data.frame(
  sepal_length,
  sepal_width,
  petal_length,
  petal_width,
  species
)

print(iris.data)
print(summary(iris.data))

#extract two columns and create new data frame
new.iris <- data.frame(
    species,
    sepal_length
)
  
print(new.iris)

#scatter plot colored by species
plot1<-ggplot(iris.data, aes(x=petal_width, y=petal_length, shape=species, color=species)) +
  geom_point() 
print(plot1)

plot2<-ggplot(iris.data, aes(x=sepal_width, y=sepal_length, shape=species, color=species)) +
  geom_point()
print(plot2)

#calculate means by species
PLmean<- tapply(petal_length,species,mean) 
PWmean<- tapply(petal_width,species,mean) 
SLmean<- tapply(sepal_length,species,mean) 
SWmean<- tapply(sepal_width,species,mean) 

iris.means<-data.frame(
    PLmean,
    PWmean,
    SLmean,
    SWmean)

print(iris.means)

# conduct ANOVA on petal length
petal_length.anova = oneway.test(petal_length~species) 
petal_width.anova = oneway.test(petal_width~species)
sepal_length.anova = oneway.test(sepal_length~species) 
sepal_width.anova = oneway.test(sepal_width~species)
print(sepal_length.anova)
print(sepal_width.anova)
print(petal_length.anova)
print(petal_width.anova)

# print means, ANOVA test, and summary to external file
sink(file = 'C:/Users/gabsbi/Desktop/meansIRIS.txt')
print(iris.means)
print(summary(iris.means))
print(sepal_length.anova)
print(sepal_width.anova)
print(petal_length.anova)
print(petal_width.anova)
sink() 

iris.melt<-melt(iris.data,id.vars="species")
print(iris.melt)

plot3<- ggplot(iris.melt, aes(fill=species, y=value, x=variable)) + 
  geom_bar(position="dodge", stat="identity")
print(plot3)

plot4<- ggplot(iris.melt, aes(fill=species, y=value, x=variable)) + 
  geom_bar(position="dodge", stat="identity") +
  labs(x ='myX', y = 'myY', title = "Sir Ronald's garden bars") +
  theme(panel.background = element_rect(fill = "gray50"), plot.background = element_rect(fill = "gray80"))
print(plot4)

# put plots on single PDF page
library(grid)
pushViewport(viewport(layout = grid.layout(2, 2)))
print(plot1, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
print(plot2, vp = viewport(layout.pos.row = 1, layout.pos.col = 2))
print(plot3, vp = viewport(layout.pos.row = 2, layout.pos.col = 1))
print(plot4, vp = viewport(layout.pos.row = 2, layout.pos.col = 2))
