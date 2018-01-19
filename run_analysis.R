#Required library
library(dplyr)
#file is already dowanloaded and extracted into a folder named "UCI HAR Dataset" on the working directory 


# Read the train data
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
Sub_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Read the test data
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
Sub_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Read the data description
variable_names <- read.table("UCI HAR Dataset/features.txt")

# Read the activity labels
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

# Merges the training and the test datasets
X_total <- rbind(X_train, X_test)
Y_total <- rbind(Y_train, Y_test)
Sub_total <- rbind(Sub_train, Sub_test)

# Extracts only the measurements on the mean and standard deviation for each measurement
selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]
X_total <- X_total[,selected_var[,1]]

# Uses descriptive activity names to name the activities in the data set
colnames(Y_total) <- "activity"
Y_total$activitylabel <- factor(Y_total$activity, labels = as.character(activity_labels[,2]))
activitylabel <- Y_total[,-1]

# Appropriately labels the data set with descriptive variable names.
colnames(X_total) <- variable_names[selected_var[,1],2]

# Tidy data set
colnames(Sub_total) <- "subject"
total <- cbind(X_total, activitylabel, Sub_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))

# Wrtite the dataset into a file
write.table(total_mean, file = "UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)
