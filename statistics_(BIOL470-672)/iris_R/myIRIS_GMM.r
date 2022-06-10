
print("hello Greg...welcome to R")
library('mixtools')
library('ggplot2')
data = read.table('C:/Users/gabsbi/Desktop/code-examples/R/iris_tab.txt', header = TRUE)
Sp = data$species; # species
SL = data$sepal_length; # sepal length
SW = data$sepal_width; # sepal width
PL = data$petal_length; # petal length
PW = data$petal_width; # petal width
dataframe = data.frame(SL, SW, PL, PW, Sp)
subframe = data.frame(SL, SW, PL, PW)
print (subframe)
SZ = (SL + SW + PL + PW)/4
print (SZ)
#set.seed(30)
fitGMM <- normalmixEM(SZ)
print(fitGMM)
fitGMM_loglik <- fitGMM$loglik
BIC_GMM <- -2*fitGMM_loglik+4*log(150)
print ("BIC for GMM")
print(BIC_GMM)
plot(fitGMM, which = 1)
plot(fitGMM, which = 2)
sink("stats.txt")
print(fitGMM)
print(BICfit)
print ("BIC for GMM")
print(BIC_GMM)
sink()

print("goodbye Greg...leaving R")
#q()