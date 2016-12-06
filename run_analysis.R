## Set working directory

## Download data
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "GACD_proj.zip")

## Extract zipped data
if(!file.exists("UCI HAR Dataset")) {
unzip("GACD_proj.zip") }

## Load reshape2
install.packages("reshape2")
library(reshape2)

## Extracts only the measurements on the mean and standard deviation for each measurement.

## Read datasets
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

## Clean column names
feature_filter <- grep(".*[Mm]ean.*|.*[Ss]td.*", features[,2])
feature_names <- as.character(features[feature_filter,2])
feature_names <- gsub("\\()", "", feature_names)
feature_names <- gsub("-mean", "Mean", feature_names)
feature_names <- gsub("-std", "StDev", feature_names)
feature_names <- gsub("gravity", "Gravity", feature_names)

## Load test data
test_x <- read.table("UCI HAR Dataset/test/X_test.txt")[feature_filter]
test_y <- read.table("UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(subject_test, test_y, test_x)

## Load train data
train_x <- read.table("UCI HAR Dataset/train/X_train.txt")[feature_filter]
train_y <- read.table("UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(subject_train, train_y, train_x)

## Merges the training and the test sets to create one data set.
alldata <- rbind(test, train)

## Appropriately labels the data set with descriptive variable names.
colnames(alldata) <- c("subject", "activities", feature_names)

## Uses descriptive activity names to name the activities in the data set
alldata$activities <- factor(alldata$activities, levels = activity_labels[,1], labels = activity_labels[,2])

## Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
alldata_melt <- melt(alldata, id = c("subject", "activities"))
alldata_mean <- dcast(alldata_melt, subject + activities ~ variable, mean)

## Save txt fileto work directory
write.table(alldata_mean, "mean.txt", row.name = FALSE)
