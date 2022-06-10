
print("hello Greg...welcome to R")

library('ggplot2')

data = read.table('C:/Users/gabsbi/Desktop/code-examples/R/GoodTeachSurvey_tab.txt', header = TRUE)
expectation = data$Expect; 
entertain = data$Entertain; 
communicate = data$Comm; 
expertise = data$Expert; 
motivate = data$Motivate; 
caring = data$Caring; 
charisma = data$Charisma; 
passion = data$Passion; 
friendly = data$Friendly; 
dataframe = data.frame(expectation, entertain, communicate, expertise, motivate, caring, charisma, passion, friendly)
print (dataframe)
myFA <-  factanal(dataframe, 4, rotation="varimax")
print(myFA, digits=2, cutoff=.3, sort=TRUE)
# plot factor 1 by factor 2 
load <- myFA$loadings[,1:2] 
plot(load,type="n") # set up plot 
text(load,labels=names(dataframe),cex=.7) # add variable names
print("goodbye Greg...leaving R")
#q()