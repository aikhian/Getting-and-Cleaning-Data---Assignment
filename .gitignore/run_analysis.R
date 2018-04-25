Getting and Cleaning Data - Assignment

# Values of Variable Activity consist of data from "Y_train.txt" and "Y_test.txt"
# values of Variable Subject consist of data from "subject_train.txt" and subject_test.txt"
# Values of Variables Features consist of data from "X_train.txt" and "X_test.txt"
# Names of Variables Features come from "features.txt"
# levels of Variable Activity come from "activity_labels.txt"

getwd()
setwd("C:/Users/leona/OneDrive/Desktop/Data Analytics/Courera/Course 3 - Getting and Cleaning Data/Assignment/UCI HAR Dataset")
install.packages("plyr")
install.packages("data.table")
library(plyr)
library(data.table)
options(max.print = 999999)

# Part 1 - Merges the training and test sets to create one data set.

# Reading the Subject files and combining test and train data through concatenate by rows
subTrain <- read.table('./train/subject_train.txt', header = FALSE)
subTest <- read.table('./test/subject_test.txt', header = FALSE)
subData <- rbind(subTrain, subTest)

# Reading the Features files and combining test and train data through concatenate by rows
xTrain <- read.table('./train/x_train.txt', header = FALSE)
xTest <- read.table('./test/x_test.txt', header = FALSE)
xData <- rbind(xTrain, xTest)

# Reading the Activity files and combining test and train data through concatenate by rows
yTrain <- read.table('./train/y_train.txt', header = FALSE)
yTest <- read.table('./test/y_test.txt', header = FALSE)
yData <- rbind(yTrain, yTest)

dim(xData)
dim(yData)
dim(subData)
str(xData)
str(yData)
str(subData)

names(subData) <- c("Subject")
names(yData) <- c("Activity")
featureName <- read.table('./features.txt', header = FALSE)
names(xData) <- featureName$V2

dataCombine <- cbind(yData, subData)
allData <- cbind(dataCombine, xData)
str(allData)
head(allData, 10)

# Part 2 - Extracts only the measurements on the mean and standard deviations for each measurement.

subxData <- featureName$V2[grep("mean\\(\\)|std\\(\\)", featureName$V2)] 
subxData
str(allData)
head(allData, 10)


# Part 3 - Uses the descriptive activity names to name the activities in the data set.

activityLabels <- read.table('./activity_labels.txt', header = FALSE)
activityLabels <- as.character(activityLabels[,2])
allData$Activity <- activityLabels[allData$Activity]
head(allData$Activity, 30)

# Part 4 - Appropriately labels the data set with descriptive variable names.

names(allData) <- gsub("Acc", "Accelerometer", names(allData))
names(allData) <- gsub("BodyBody", "Body", names(allData))
names(allData) <- gsub("Gyro", "Gyroscope", names(allData))
names(allData) <- gsub("Mag", "Magnitude", names(allData))
names(allData) <- gsub("^f", "Frequency", names(allData))
names(allData) <- gsub("^t", "Time", names(allData))
names(allData) <- gsub("std()", "SD", names(allData))
names(allData) <- gsub("mean()", "MEAN", names(allData))
names(allData)
dim(allData)

# Part 5 - From the data set in step 4, create a second, independent tidy data set with the
# average of each variable for each activity and each subject.

tidyData <- aggregate(. ~ Subject + Activity, allData, mean)
tidytData <- tidyData[order(tidyData$Subject, tidyData$Activity),]
write.table(tidyData, file = "Tidy_Data.txt", row.name = FALSE)
head(tidyData[order(tidyData$Activity)][,c(1:4),],10) 
