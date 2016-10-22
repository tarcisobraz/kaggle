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
full.dataset[is.na(full.dataset$Fare),"Fare"] <- median(full.dataset$Fare, na.rm = T) #distribution mode

#Age
full.dataset[is.na(full.dataset$Age),"Age"] <- median(full.dataset$Age, na.rm = T) #distribution mode

#Split datasets again
train.fixed <- full.dataset[1:891,]
test.fixed <- full.dataset[892:1309,] %>% select(-Survived)

#Training model
form <- formula(factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked)

rf.model <- randomForest(form, data=train.fixed)

plot(rf.model, ylim=c(0,0.36))
legend('topright', colnames(rf.model$err.rate), col=1:3, fill=1:3)

imp <- importance(rf.model)
featureImportance <- data.frame(Feature=row.names(imp), Importance=imp[,1])

p <- ggplot(featureImportance, aes(x=reorder(Feature, Importance), y=Importance)) +
  geom_bar(stat="identity", fill="#53cfff") +
  coord_flip() + 
  theme_light(base_size=20) +
  xlab("") +
  ylab("Importance") + 
  ggtitle("Random Forest Feature Importance\n") +
  theme(plot.title=element_text(size=18))

#Predicting values
test.fixed$Survived <- predict(rf.model, test.fixed)

write.csv(select(test.fixed, PassengerId, Survived), "prediction_out.csv", row.names=F)
