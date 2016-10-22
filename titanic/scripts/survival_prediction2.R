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

#Imputing missing data

#Embarked
full.dataset[full.dataset$Embarked == "","Embarked"] <- "S" #distribution mode

#Fare
full.dataset[is.na(full.dataset$Fare),"Fare"] <- median(full.dataset$Fare, na.rm = T)

#Age
full.dataset[is.na(full.dataset$Age),"Age"] <- median(full.dataset$Age, na.rm = T)

#Adding input variables

