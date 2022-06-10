print("hello Greg...welcome to R")
library('MASS')
library('mixtools')
library('ggplot2')
data = read.table('C:/Users/gabsbi/Desktop/code-examples/R/iris_tab_big.txt', header = TRUE)
Sp = data$species; # species
SL = data$sepal_length; # sepal length
SW = data$sepal_width; # sepal width
PL = data$petal_length; # petal length
PW = data$petal_width; # petal width
dataframe = data.frame(SL, SW, PL, PW, Sp)
subframe = data.frame(SL, SW, PL, PW)
print (subframe)
SZ = (SL + SW + PL + PW)/4 # petal and sepal size
#SZ = (SL + SW)/2 # sepal size
#SZ = (PL + PW) # petal size
print (SZ)
#set.seed(30)
fitNORM <- fitdistr(SZ, densfun="normal")
print(fitNORM)
fitLNORM <- fitdistr(SZ, densfun="log-normal")
print(fitLNORM)
fitEXP <- fitdistr(SZ, densfun="exponential")
print(fitEXP)
fitGMM <- normalmixEM(SZ, k=2) # for GMM with 2 density functions (default)
print(fitGMM)
fitGMM_loglik <- fitGMM$loglik
BIC_GMM <- -2*fitGMM_loglik+4*log(500000) # 4 parameters and large sample size
BICfit <- BIC(fitNORM,fitLNORM,fitEXP)
print(BICfit)
#print(fit4_loglik)
print ("BIC for GMM")
print(BIC_GMM)
myplot1 <-ggplot(dataframe, aes(x=SZ)) + geom_histogram(aes(y=..density..)) + geom_density() + stat_function(fun=dnorm, color="red", args=list(mean = fitNORM$estimate[1], sd = fitNORM$estimate[2])) 
myplot2 <-ggplot(dataframe, aes(x=SZ)) + geom_histogram(aes(y=..density..)) + geom_density() + stat_function(fun=dlnorm, color="red", args=list(meanlog = fitLNORM$estimate[1], sdlog = fitLNORM$estimate[2])) 
myplot3 <-ggplot(dataframe, aes(x=SZ)) + geom_histogram(aes(y=..density..)) + geom_density() + stat_function(fun=dexp, color="red", args=list(rate = fitEXP$estimate[1])) 

# for GMM two density functions
myplot4 <-ggplot(dataframe, aes(x=SZ)) + geom_histogram(aes(y=2*(..density..))) + geom_density(aes(y=2*(..density..))) + 
   stat_function(fun=dnorm, color="red", args=list(mean = fitGMM$mu[1], sd = fitGMM$sigma[1])) + 
   stat_function(fun=dnorm, color="red", args=list(mean = fitGMM$mu[2], sd = fitGMM$sigma[2])) 

# for GMM with three density functions
#myplot4 <-ggplot(dataframe, aes(x=SZ)) + geom_histogram(aes(y=3*(..density..))) + geom_density(aes(y=3*(..density..))) + geom_histogram(aes(y=3*(..density..))) +
#   stat_function(fun=dnorm, color="red", args=list(mean = fitGMM$mu[1], sd = fitGMM$sigma[1])) +
#   stat_function(fun=dnorm, color="red", args=list(mean = fitGMM$mu[2], sd = fitGMM$sigma[2])) +
#   stat_function(fun=dnorm, color="red", args=list(mean = fitGMM$mu[3], sd = fitGMM$sigma[3]))

library('grid')
pushViewport(viewport(layout = grid.layout(2, 2)))
print(myplot1, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
print(myplot2, vp = viewport(layout.pos.row = 1, layout.pos.col = 2))
print(myplot3, vp = viewport(layout.pos.row = 2, layout.pos.col = 1))
print(myplot4, vp = viewport(layout.pos.row = 2, layout.pos.col = 2))
sink("stats.txt")
print(fitGMM)
print(BICfit)
print ("BIC for GMM")
print(BIC_GMM)
sink()

print("goodbye Greg...leaving R")
#q()