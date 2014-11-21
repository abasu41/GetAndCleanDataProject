library (data.table)
# open the train and test datasets and combine them into one dataset
# Check for file first
if ( ! file.exists('test/X_test.txt') ) {
  stop('X_test : Test Set File not found')
}
if ( ! file.exists('train/X_train.txt') ) {
  stop('X_train : Training Set: File not found')
}
# Read the first file
df_test <- read.table('test/X_test.txt')
# add the subject to the test frame
test_subjects <- read.table('test/subject_test.txt')
df_test<-cbind(df_test, test_subjects[,1])
# rename the last column to something better
colnames(df_test)[length(colnames(df_test))] <- 'SubjectId' 
# add activities
test_activities <- read.table('test/y_test.txt')
df_test<-cbind(df_test, test_activities[,1])
# rename the last column to something better
colnames(df_test)[length(colnames(df_test))] <- 'ActivityId' 


# Now we do the same for the training set
df_train <- read.table('train/X_train.txt')
train_subjects <- read.table('train/subject_train.txt')
df_train<-cbind(df_train, train_subjects[,1])
colnames(df_train)[length(colnames(df_train))] <- 'SubjectId' 
train_activities <- read.table('train/y_train.txt')
df_train<-cbind(df_train, train_activities[,1])
colnames(df_train)[length(colnames(df_train))] <- 'ActivityId'

# create a new frame called combined
combined <- rbind(df_test, df_train)
# remove the original tables
rm(df_test)
rm(df_train)
# Read the features into a table for easy access
feats <- read.table('features.txt', col.names=c('idx', 'feature'))
# create a list of columns of interest by removing everything that does not have
# mean or std in it
feats <- feats[grepl('*mean*|*std*', feats$feature),]
# Create a new frame with just the subject Id and activty id
newFrame <- data.table(subject=combined[,'SubjectId'])
newFrame <- cbind(newFrame, activity=combined[,'ActivityId'])
# Get only columns that match this feature table by looping thru the feats list
for ( i in 1:dim(feats)[1] ) {
  newFrame<-cbind(newFrame, combined[, feats[i,1]])
  setnames(newFrame, length(names(newFrame)), as.character(feats[i, 2]))
}
# change the activities to meaningful names by reading from the activties table
#1 WALKING
#2 WALKING_UPSTAIRS
#3 WALKING_DOWNSTAIRS
#4 SITTING
#5 STANDING
#6 LAYING
newFrame$activity[newFrame$activity==1] <- "WALKING"
newFrame$activity[newFrame$activity==2] <- "WALKING_UPSTAIRS"
newFrame$activity[newFrame$activity==3] <- "WALKING_DOWNSTAIRS"
newFrame$activity[newFrame$activity==4] <- "SITTING"
newFrame$activity[newFrame$activity==5] <- "STANDING"
newFrame$activity[newFrame$activity==6] <- "LAYING"
act_names <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING",
               "STANDING", "LAYING")
# Create a new tidy dataset by summarizing each subject for each activity
# SubjectId Activity          fBodyBody... 
#   1       WALKING           -9323 -392 3239
#   1       WALKING_UPSTAIRS  -0.3932 -3923 -3
#   1       WALKING_DOWNSTAIRS -0.2393 -0.323 ...
tidySet <- data.frame()
# clean up the column names, remove () and -
cols <- colnames(newFrame)
cols <- gsub("()", "", cols, fixed=TRUE)
cols <- gsub("-", ".", cols, fixed=TRUE)

setnames(newFrame, 3:length(cols), cols[3:length(cols)])

# average for each subject by activity
for ( i in 1:30 ) {
  for (j in act_names) {
    
    df <- data.frame(newFrame[activity==j & subject==i])
    # calculate the mean of each column
    m <- aggregate(df[3:dim(df)[2]], df[1:2], function(x) mean(x,na.rm=T))
    tidySet<-rbind(tidySet, m)
  }
}
# write out the tidy set
write.table(tidySet, "TidySet.txt", row.names=FALSE)




