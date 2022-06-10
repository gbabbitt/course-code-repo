####  NOTE: this neural net trains on 50,000 color images 
####  deploys classifications on 10,000 images  (uses single GPU)

## TO ACTIVATE CUDA USE: 
# install.packages("keras")
# install.packages("tensorflow")
# library('tensorflow')
# library('keras')
# install_keras(tensorflow = "gpu")
## TO MONITOR GPU DURING RUN: in Linux terminal 'nvidia-smi -l 3'

print("hello Greg...welcome to R")
library('tictoc')
library('keras') # for deep learning on GPU
library('tensorflow')
library('ggplot2')
library('dplyr') # for resampling
library('caret') # for confusion matrix
library('tidyr') # for preprocessing images

# load CIFAR10 image dataset from keras
cifar <- dataset_cifar10() # 60,000 high resolution color images of 10 classes
c(train_images, train_labels) %<-% cifar$train
c(test_images, test_labels) %<-% cifar$test

class_names <- c('airplane', 'automobile', 'bird', 'cat', 'deer',
                 'dog', 'frog', 'horse', 'ship', 'truck')  # class names for plotting
# check data
print("number training images and labels")
print(dim(train_images))
print(dim(train_labels))
print("print some labels")
print(train_labels[1:20])
print("number testing images and labels")
print(dim(test_images))
print(dim(test_labels))

# scale pixels from range (0 to 255) to range (0 to 1)
#train_images <- train_images / 255
#test_images <- test_images / 255

# display first 25 images from data set and check format
index <- 1:30

par(mfcol = c(5,6), mar = rep(1, 4), oma = rep(0.2, 4))
cifar$train$x[index,,,] %>% 
  purrr::array_tree(1) %>%
  purrr::set_names(class_names[cifar$train$y[index] + 1]) %>% 
  purrr::map(as.raster, max = 255) %>%
  purrr::iwalk(~{plot(.x); title(.y)})

# build deep net model
tic("time elapsed")
model <- keras_model_sequential() %>% 
  layer_conv_2d(filters = 32, kernel_size = c(3,3), activation = "relu", 
                input_shape = c(32,32,3)) %>% 
  layer_max_pooling_2d(pool_size = c(2,2)) %>% 
  layer_conv_2d(filters = 64, kernel_size = c(3,3), activation = "relu") %>% 
  layer_max_pooling_2d(pool_size = c(2,2)) %>% 
  layer_conv_2d(filters = 64, kernel_size = c(3,3), activation = "relu")

summary(model)

## add some dense layers
model %>% 
  layer_flatten() %>% 
  layer_dense(units = 64, activation = "relu") %>% 
  layer_dense(units = 10, activation = "softmax")

summary(model)


# compile and train the model
model %>% compile(
  optimizer = "adam",
  loss = "sparse_categorical_crossentropy",
  metrics = "accuracy"
)


# evaluate 
history <- model %>% 
  fit(
    x = cifar$train$x, y = cifar$train$y,
    epochs = 50,
    validation_data = unname(cifar$test),
    verbose = 2
  )


plot(history)

# get class predictions
class_pred <- model %>% predict_classes(test_images)
# confusion matrix
mymatrix <- confusionMatrix(as.factor(class_pred), as.factor(test_labels))
print(mymatrix)
print(pre_image)
print(post_image)
toc() # print time elapsed
print("goodbye Greg...leaving R")
#q()