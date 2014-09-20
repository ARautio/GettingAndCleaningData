# 0. Read filenames ----------------------------------------------------------------

# -------- Information location -------- 
location <- "UCI HAR Dataset/"

# Content: Links the class labels with their activity name.
activity_labels <-  read.table(paste(location,"activity_labels.txt",sep=""))

# Content: List of all features.
features <-   read.table(paste(location,"features.txt",sep=""))

# -------- Test data location --------
test_location <- paste(location,"test/",sep="")
test_data_location <- paste(test_location,"Inertial Signals/",sep="")

# Content:  Test set
X_test <- paste(test_location,"X_test.txt",sep="")

# Content:  Test labels
Y_test <- paste(test_location,"Y_test.txt",sep="")

# Content:  Each row identifies the subject who performed the activity for 
#           each window sample. Its range is from 1 to 30. 
subject_test <- paste(test_location,"subject_test.txt",sep="")

# -------- Train data location --------
train_location <- paste(location,"train/",sep="")
train_data_location <- paste(train_location,"Inertial Signals/",sep="")

# Content:  Each row identifies the subject who performed the activity for 
#           each window sample. Its range is from 1 to 30. 
subject_train <-  paste(train_location,"subject_train.txt",sep="")

# Content:  Train set
X_train <-  paste(train_location,"X_train.txt",sep="")

# Content:  Train labels
Y_train <-  paste(train_location,"Y_train.txt",sep="")

# 1. Merge content ----------------------------------------------------------------

# Content: Set
Y <- rbind(read.table(Y_test), read.table(Y_train))

# Content: Labels
X <- rbind(read.table(X_test), read.table(X_train))

# Content:  Each row identifies the subject who performed the activity for 
#           each window sample. Its range is from 1 to 30. 
subject <- rbind(read.table(subject_test), read.table(subject_train))


# Add titles
names(X) <- features[,2]

# 2. Extracts only the measurements on the mean and standard deviation --------------------- 
X <- X[,grepl("mean\\(|std",names(X))]

# Add Subject to the dataset
names(subject) <- "Subject"
X$Subject <- as.factor(unlist(subject))

# 3. Uses descriptive activity names to name the activities in the data set ---------------
names(Y) <- "ID"
names(activity_labels) <- c("ID","Activity")
activity <- merge(Y,activity_labels,by="ID")
X$Activity <- as.factor(unlist(activity$Activity))

# 4. Appropriately labels the data set with descriptive variable names.   ---------------
names(X) <- gsub("tBody","Time.Domain.Body",names(X))
names(X) <- gsub("tGravity","Time.Domain.Gravity",names(X))
names(X) <- gsub("fBody","Frequency.Domain.Body",names(X))
names(X) <- gsub("fGravity","Frequency.Domain.Gravity",names(X))
names(X) <- gsub("Acc",".Acceleration",names(X))
names(X) <- gsub("Gyro",".Gyroscope",names(X))
names(X) <- gsub("Jerk",".Jerk",names(X))
names(X) <- gsub("Mag",".Magnitude",names(X))
names(X) <- gsub("-mean\\(\\)",".Mean",names(X))
names(X) <- gsub("-std\\(\\)",".Standard.Deviation",names(X))
names(X) <- gsub("-",".",names(X))

# 5. Create data set with the avg of each var for each activity and each subject. -----
is.installed <- function(mypkg){
  is.element(mypkg, installed.packages()[,1])
}
if(!is.installed("dplyr"))
{
  install.packages("dplyr")
}
require("dplyr")

X_tbl <- tbl_df(X)
grouped <- group_by(X,Activity,Subject)
X_tidy <-summarise_each(grouped,funs(mean))

# Write to table
write.table(X_tidy,file="output.txt",row.name=FALSE)
