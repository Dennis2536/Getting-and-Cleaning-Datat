Library(dplyr)
library(data.table)

#Data gathering and importing of dataset

dir.create("Data")
setwd("Data")

features <- read.table("features.txt", col.names = c("no","features"))
activity <- read.table("activity_labels.txt", col.names = c("label", "activity"))

subject_test <- read.table("test/subject_test.txt", col.names = "subject")
x_test <- read.table("test/X_test.txt", col.names = features$features)
y_test <- read.table("test/Y_test.txt", col.names = "label")
y_test_label <- left_join(y_test, activity, by = "label")

subject_train <- read.table("train/subject_train.txt", col.names = "subject")
x_train <- read.table("train/X_train.txt", col.names = features$features)
y_train <- read.table("train/Y_train.txt", col.names = "label")
y_train_label <- left_join(y_train, activity, by = "label")

#Cleaning of Test and Train dataset

tidy_test <- cbind(subject_test, y_test_label, x_test)
tidy_test <- select(tidy_test, -label)
tidy_train <- cbind(subject_train, y_train_label, x_train)
tidy_train <- select(tidy_train, -label)

#Emerging cleaned dataset
tidy_set <- rbind(tidy_test, tidy_train)

#Mean and standard deviation
tidy_mean_std <- select(tidy_set, contains("mean"), contains("std"))

#Average
tidy_mean_std$subject <- as.factor(tidy_set$subject)
tidy_mean_std$activity <- as.factor(tidy_set$activity)

average <- tidy_mean_std %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

write.table(average, "tidy_set.txt", quote = FALSE, row.names = FALSE)


