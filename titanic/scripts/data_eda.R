#Importing libs
library(dplyr)
library(randomForest)
library(ggplot2)

#Reading data
train <- read.csv("../input/train.csv")
test <- read.csv("../input/test.csv")

test.survived <- test
test.survived$Survived <- -1

full.dataset <- rbind(train,test.survived)

#Looking into data
str(full.dataset)

summary(full.dataset)