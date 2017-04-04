##Get Data
pathIn <- file.path("C:/Users/Jorge/Documents/data/UCI HAR Dataset", "UCI HAR Dataset")
list.files(pathIn, recursive=TRUE)

## Read Files
SubjectTrain <- read.table("C:/Users/Jorge/Documents/data/UCI HAR Dataset/subject_train.txt")
SubjectTest <- read.table("C:/Users/Jorge/Documents/data/UCI HAR Dataset/subject_test.txt")
XTrain <- read.table("C:/Users/Jorge/Documents/data/UCI HAR Dataset/X_train.txt")
XTest <- read.table("C:/Users/Jorge/Documents/data/UCI HAR Dataset/X_test.txt")
YTrain <- read.table("C:/Users/Jorge/Documents/data/UCI HAR Dataset/y_train.txt")
YTest <- read.table("C:/Users/Jorge/Documents/data/UCI HAR Dataset/y_test.txt")
Features <- read.table("C:/Users/Jorge/Documents/data/UCI HAR Dataset/features.txt")

## Arrange Data

colnames(XTrain) <- t(Features[2])
colnames(XTest) <- t(Features[2])

## Merge Data

XTrain$activities <- YTrain[, 1]
XTrain$participants <- SubjectTrain[, 1]
XTest$activities <- YTest[, 1]
XTest$participants <- SubjectTest[, 1]

## 1.Merges the training and the test sets to create one data set.

OneDataSet <- rbind(XTrain, XTest)
duplicated(colnames(OneDataSet))
OneDataSet <- OneDataSet[, !duplicated(colnames(OneDataSet))]

## 2.Extracts only the measurements on the mean and standard deviation for each measurement.

Mean <- grep("mean()", names(OneDataSet), value = FALSE, fixed = TRUE)
InstrumentMean <- OneDataSet[Mean]
STD <- grep("std()", names(OneDataSet), value = FALSE)
InstrumentSTD <- OneDataSet[STD]

## 3.Uses descriptive activity names to name the activities in the data set

OneDataSet$activities <- as.character(OneDataSet$activities)
OneDataSet$activities[OneDataSet$activities == 1] <- "Walking"
OneDataSet$activities[OneDataSet$activities == 2] <- "Walking Upstairs"
OneDataSet$activities[OneDataSet$activities == 3] <- "Walking Downstairs"
OneDataSet$activities[OneDataSet$activities == 4] <- "Sitting"
OneDataSet$activities[OneDataSet$activities == 5] <- "Standing"
OneDataSet$activities[OneDataSet$activities == 6] <- "Laying"
OneDataSet$activities <- as.factor(OneDataSet$activities)

## 4. Appropriately labels the data set with descriptive variable names. 

names(OneDataSet)
names(OneDataSet) <- gsub("Acc", "Accelerator", names(OneDataSet))
names(OneDataSet) <- gsub("Mag", "Magnitude", names(OneDataSet))
names(OneDataSet) <- gsub("Gyro", "Gyroscope", names(OneDataSet))
names(OneDataSet) <- gsub("^t", "time", names(OneDataSet))
names(OneDataSet) <- gsub("^f", "frequency", names(OneDataSet))


## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

OneDataSetTable <- data.table(OneDataSet)
TidyData <- OneDataSetTable[, lapply(.SD, mean), by = 'participants,activities']
write.table(TidyData, file = "Tidy.txt", row.names = FALSE)



