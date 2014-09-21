GettingAndCleaningData
======================

This repository is for the course project of the Getting and Cleaning data course. 

Raw data for this project can be found from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip . For this project data set from X_train.txt / X_test.txt was used. In addition to this features.txt was used to label the columns, subject_train.txt / subject_test.txt were used to add test subject and activity_labels.txt was used to give content to activies.

This script assumes that UCI HAR Dataset must be extracted to the same working directory. This scripts consists from six parts. First part determines the locations from files needed. Second part merges train and test data sets, labels and subjects. For this new combined data it adds column texts. Third part filters unwanted columns out and adds subject columns. Fourth part converts labels numbers to texts. Fifth part converts column names to more readable form. The final sixth part tidies the data and writes it to output.txt