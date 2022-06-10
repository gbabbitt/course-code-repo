
library(np) # non parametric library
data(iris)
attach(iris)
print(iris)
m <- npreg(Petal.Length~Petal.Width)

plot(m,plot.errors.method="asymptotic",
     plot.errors.style="band",
     ylim=c(0,8))

points(Petal.Width,Petal.Length)