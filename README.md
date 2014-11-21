Project Submission for GetAndCleanData
======================================
####The run_analysis.R file can be used to generate a single, tidy data set out of the 'Human Activity Recognition Using Smartphone dataset available from 
##https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
---
The script depends upon the following files to be present in the directory from which it is run:

* test/X_test.txt (contains the test data set)
* train/X_train.txt (contains the training data set)
* test/subject_test.txt (Subject IDs for the test set)
* test/y_test.txt (Activity codes for each of the subjects in the test set)
* train/subject_train.txt (subject IDs for training set)
* train/y_train.txt (Activity codes for each of the subjects in the training set)

The tidy dataset consists of all the mean and std-dev values for each of the activity for each subject, i.e. one subject per row per activity. The mean and std-dev values are extracted from ALL the columns in the train and test sets which have either the word mean() or std in their column names. The grepl function is uesed to generate those column names.
The activities are re-coded from the original set according to the file activity-lables.txt
i.e.
SubjectId ActivityName observation1-mean observation1-std observation2-mean...

Please refer to CodeBook.md for 
