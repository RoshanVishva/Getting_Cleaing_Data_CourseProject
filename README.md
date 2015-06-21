# Getting Cleaning Data CourseProject
==================================================================
Averages of Human Activity Recognition Using Smartphones Dataset
==================================================================
The run_analysis.R is to create tidy data set obtained from a data set based on the sensor signals (accelerometer and gyroscope) from an  experiments that have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist.
More details of the original data set that was used by  run_analysis.R can be found from the following URL
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
Special note
I made full afford to code this assignment using R base operation only rather than using any packages including any of other packages like dplyr. However at some point I have used data.table package to convert all my data frames to data tables (data.table) due to the facts
<br>(1) memory efficiency (2) much faster as they were written in  (3) much faster in sub setting, grouping ect..</br>
<br><b>The following assumptions been made</b><br>
<br>(1)The relevant folders test,train with data set and other files activity_labels, features are in the folder ‘UCI HAR Dataset’ and ‘UCI HAR Dataset’ is in the working directory

If these files are not available pls download from the following link , unzip and move the  UCI HAR Dataset folder with it’s content to the working directory

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


(2)desc_features.txt is available in the working directory . This is the descriptive variable names of each variable available in the fetures.txt created manually. The descriptive variable names added manually but the following code been used to extract variables names to a file called outfile.

write.table(names(dt.new_fullset),file="outfile.txt",sep="\t",  row.names = FALSE,
col.names = FALSE)

<br>(1)	Y_test/Y_train consist of activity ids which reference activities in activity_labels and subject_test /subject_train consist of the ids that identifies the subject who performed the activity
<br>(2)	Order of the Columns(variables) in the X_test and X_train are same as column names(variable names) appears in the features file
<br>(3)	activity_lables file consist of id and activity label names. The id is id of the activity in which the experiment was performed as specified in   Y_test/Y_train
</br>
<br>Some convection for naming and methods I followed
<br>Naming
<br>(1)	All data frame start with df_(prefix with df)
<br>(2)	All data tables start with dt_(prefix with df)
<br>Methods
<br>As a practice I have assigned variable names for all data frames, data tables created for subsequent reference. 
Column names of all data fames loaded from different files have been manually assigned</br>
<br>Flow of the script
<br><b>Step 1 (Question 1)</b>
<br>Column bind(cbind) been used for clipping data sets Y_test, subject_test, X_test and  Y_train, subject_train, X_train, Then row bind(rbind) been used to clip these 2 sets(test and training)
<br>I have added new variable called system which hold value ‘test ‘ and ‘train’ to indicate the system for which data belong to. This will give option to analyse data test and train level as well.
<br>The final full data from test and training consist of activity_id from (Y_test/Y_train)  subject_id (subject_test/subject_train) and system ( literal values as Test and Train)  and rest (X_test/X_train) 
<br>Data set -- dt.full_set
<br>This assign the column names for these data sets as the subsequent steps required filtering of  columns
<br><b>Step 2 ((Question 2)</b>
<br>Created a subset of column names that holds mean and std (standard deviation column) only. And this vector was used to filter the variables required (data set dt.selected_set). Purposefully ‘Mean’ columns did not take into account as they deal with angles.
<br><b>Step 3(question 3)</b>
<br>Created a data frame that hold activity label for each activity id in the data set created in previous set and clipped it to the data set created in the previous step.
<br><b>Step 4(question 4)</b>
<br>Created a txt file desc_features.txt to hold descriptive variable names of each variable available in the fetures.txt. The descriptive variable names added manually but the following code was used to extract variables names to a file called outfile.
<br>write.table(names(dt.new_fullset),file="outfile.txt",sep="\t",  row.names = FALSE,
col.names = FALSE)
<br>then the new desc_features.txt used to create a data frame (dt.desc_features columns feature_name, desc_feature_name ) with descriptive names and assign the descriptive name to column header of the data set created in the previous step
<br><b>Step 5(question 5)</b>
Created a data set taking only the columns start from   column number 5 to rest in to account so that data set consist of all measurements (mean/std). (dt.mean_std)
<br>Took the average  of these mean and standard deviation columns using aggregate function grouping by activity label and subject id. The column heading of group columns (level) were assigned with “Label of the Activity" and  "Id of the subject who performed the activity" and all other column headers (average measurers) were named appending  ‘Average of – to the existing descriptive measurement name
So the column names of the derived data set will be
"Label of the Activity" ,“Id of the subject who performed the activity" , …..

<br>The following code was executed to produce the final output in the file called Avg_actv_subj.txt

write.table(dt.avg.actsubj,file="Avg_actv_subj.txt",sep="\t",  row.names = FALSE,col.names = TRUE)
