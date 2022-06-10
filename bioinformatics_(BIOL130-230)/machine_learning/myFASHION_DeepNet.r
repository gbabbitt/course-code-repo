####  NOTE: this neural net trains on 10,000 images, each 28x28 pixels 
####  deploys classifications on 600000 images  (uses single GPU)

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

# load fashion_MNIST image dataset from keras
fashion_mnist <- dataset_fashion_mnist() # 70,000 low resolution grayscale images of clothing
c(train_images, train_labels) %<-% fashion_mnist$train
c(test_images, test_labels) %<-% fashion_mnist$test
class_names = c('T-shirt/top',
                'Trouser',
                'Pullover',
                'Dress',
                'Coat', 
                'Sandal',
                'Shirt',
                'Sneaker',
                'Bag',
                'Ankle boot')  # class names for plotting
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
train_images <- train_images / 255
test_images <- test_images / 255

# display first 25 images from data set and check format
par(mfcol=c(5,5))
par(mar=c(0, 0, 1.5, 0), xaxs='i', yaxs='i')
for (i in 1:25) { 
  img <- train_images[i, , ]
  img <- t(apply(img, 2, rev)) 
  pre_image <-image(1:28, 1:28, img, col = gray((0:255)/255), xaxt = 'n', yaxt = 'n',
        main = paste(class_names[train_labels[i] + 1]))
}

# build deep net model
tic("time elapsed")
model <- keras_model_sequential()
model %>%
  layer_flatten(input_shape = c(28, 28)) %>%
  layer_dense(units = 256, activation = 'relu') %>%
  layer_dense(units = 256, activation = 'relu') %>%
  layer_dense(units = 20, activation = 'softmax')

# compile the model
model %>% compile(
  optimizer = 'adam', 
  loss = 'sparse_categorical_crossentropy',
  metrics = c('accuracy')
)

# train model and summarize it 
model %>% fit(train_images, train_labels, epochs = 50, verbose = 2)
print(model)

# make probabilistic predictions
predictions <- model %>% predict(test_images)
print(predictions[1, ]) # print first prediction
print(which.max(predictions[1, ])) # print which of 10 classes wins
# get class predictions
class_pred <- model %>% predict_classes(test_images)
print(class_pred[1:20]) # print first 20 predictions

# plot some classifications
par(mfcol=c(5,5))
par(mar=c(0, 0, 1.5, 0), xaxs='i', yaxs='i')
for (i in 1:25) { 
  img <- test_images[i, , ]
  img <- t(apply(img, 2, rev)) 
  # subtract 1 as labels go from 0 to 9
  predicted_label <- which.max(predictions[i, ]) - 1
  true_label <- test_labels[i]
  if (predicted_label == true_label) {
    color <- '#008800' # green font
  } else {
    color <- '#bb0000' # red font
  }
  post_image <- image(1:28, 1:28, img, col = gray((0:255)/255), xaxt = 'n', yaxt = 'n',
        main = paste0(class_names[predicted_label + 1], " (",
                      class_names[true_label + 1], ")"),
        col.main = color)
}

# confusion matrix
mymatrix <- confusionMatrix(as.factor(class_pred), as.factor(test_labels))
print(mymatrix)
print(pre_image)
print(post_image)
toc() # print time elapsed
print("goodbye Greg...leaving R")
#q()