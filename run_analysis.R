#Pls README.MD before running this script

# setting path to the main data folder

d.path<-"./UCI HAR Dataset"
#e.g for absolute path to be set 
# d.path<-"H:\\UCI HAR Dataset"

# Checking exsitance of critical folders and files in the folder spesified for #further processiing

files<-grep("^test$|^train$|^activity_labels.txt$|^features.txt$",list.files(d.path))
            
if (length(files)==4){ # number of files expected is 4 for further processing
  
  ColHead_file<-"features.txt"                   # main column headers file
  activity_file<-"activity_labels.txt"           # activity lable file
  test_measure_file<-"test\\X_test.txt"          # file of measurments in test
  train_measure_file<-"train\\X_train.txt"       # file of measurments in train
  test_actv_idsFile<-"test\\y_test.txt"          # file of Activity ids in test
  train_actv_idsFile<-"train\\y_train.txt"       # file of Activity ids in trin
  test_sub_idsFile<-"test\\subject_test.txt"     # file of subject ids in test
  train_sub_idsFile<-"train\\subject_train.txt"  # file of subject ids in test
 
### Reading files and assigning column headers with relevent names  
  #Reading features (columns headers for measurements)
  df.features<-read.table(paste(d.path,ColHead_file,sep="\\"))
  #naming column headers of the above data frame as id and col_name
  names(df.features)<-c("id", "col_name")
  
  #Reading measurements of test  
  df.test_measure<-read.table(paste(d.path,test_measure_file,sep="\\"))
  #naming column headers of the above data frame from df created with features file
  names(df.test_measure)<-df.features$col_name
 
  #Reading measurements of train
  df.train_measure<-read.table(paste(d.path,train_measure_file,sep="\\"))
  #naming column headers of the above data frame from df created with features file
  names(df.train_measure)<-df.features$col_name
  
  #Reading activity ids of test from activity ids(Y_test) file
  df.test_act_ids<-read.table(paste(d.path,test_actv_idsFile,sep="\\"))
  #naming column headers of the above data frame as activity_id
  names(df.test_act_ids)<-"activity_id"
  
  #Reading activity ids of train from activity ids(Y_train) file
  df.train_act_ids<-read.table(paste(d.path,train_actv_idsFile,sep="\\"))
  #naming column headers of the above data frame as activity_id
  names(df.train_act_ids)<-"activity_id"
  
  #Reading subject ids of test from subject_test file
  df.test_sub_ids<-read.table(paste(d.path,test_sub_idsFile,sep="\\"))
  #naming column headers of the above data frame as subject_id
  names(df.test_sub_ids)<-"subject_id"

  #Reading subject ids of train from subject_train file  
  df.train_sub_ids<-read.table(paste(d.path,train_sub_idsFile,sep="\\"))
  #naming column headers of the above data frame as subject_id
  names(df.train_sub_ids)<-"subject_id"

#### End of file reading 

# loading data.table llibrary from data.table R base package
#library(data.table)
suppressWarnings(require(data.table)) # require will load only package specified previosly loaded

# Clipping all id files for test. the result will be a data table
dt.test_ids<- as.data.table(cbind(df.test_act_ids,df.test_sub_ids))

#Adding a variable called system with a value of 'test' , read README for further details
dt.test_ids$system<-'Test'

# Clipping  id files and relevent measures for test.the result will be a data table
dt.test_full<- as.data.table(cbind(dt.test_ids,df.test_measure))

# Clipping all id files for train. the result will be a data table
dt.train_ids<- as.data.table(cbind(df.train_act_ids,df.train_sub_ids))
#Adding a variable called system with a value of 'Train' , read README for further details
dt.train_ids$system<-'Train'
# Clipping all id files for train. the result will be a data table
dt.train_full<- as.data.table(cbind( dt.train_ids, df.train_measure))

# ques no 1 , merging test and train to create full data set

dt.full_set<-rbind(dt.test_full,dt.train_full)
#######End of Ques 1 ###############################

#ques no 2, extracting mean and standard deviation measurements with other relevant variables(activity_id,subject_id,system ) only to a charcter vector
selected_col<-grep("^activity_id$|^subject_id$|^system$|mean|std",names(dt.full_set),value=T)

#ques no 2
dt.selected_set<-dt.full_set[,selected_col, with=FALSE]

#######End of Ques 2 ###############################

#creating a descriptive activity data set with 2 coulmns id and labels. The id  will refer the activity ids in the full data set

#Reading activity labels along with relevent ids 
df.activity<-read.table(paste(d.path,activity_file,sep="\\"))

#naming column headers of the above data frame as id and acitivity_label 
names(df.activity)<-c("id", "activity_label")

#creating data table that hold activity labels for each activity id in the full data set
df.activ_nm<-as.data.frame(df.activity$activity_label[dt.selected_set$activity_id])
#naming column header of the above data table  as activity_label
names(df.activ_nm)<-"activity_label"
# Qus 3 new data set with descriptive activity lables. the first column will be activity lable
dt.new_fullset<-cbind(df.activ_nm ,dt.selected_set)

#######End of Ques 3 ###############################

#  reading descriptive column names from desc_features.txt
dt.desc_features<- read.table("desc_features.txt", header = FALSE)
#naming column headers of the above data frame as feature_name and desc_feature_name
names(dt.desc_features)<-c("feature_name", "desc_feature_name")

# Qua 4 Assigning column names of the new data set from desriptive variable names
colnames(dt.new_fullset)<-dt.desc_features$desc_feature_name
#######End of Ques 4 ###############################

#Creating character Vector holding  mean and std column names only

dt.mean_std<-dt.new_fullset[,5:ncol(dt.new_fullset)]

#creatiing list to take group 
 group_by_list<-list(dt.new_fullset$"Label of the Activity", dt.new_fullset$"Id of the subject who performed the activity")

# qus 5  average of each variable for each activity and each subject
dt.avg.actsubj <-aggregate(dt.mean_std, by= group_by_list, FUN=mean, na.rm=TRUE)

#naming group by coulmns a
colnames(dt.avg.actsubj)[1] <- "Label of the Activity"
colnames(dt.avg.actsubj)[2] <- "Id of the subject who performed the activity"
#naming rest of the variables as avarage of orginal coumn

colnames(dt.avg.actsubj)[3:ncol(dt.avg.actsubj)]<-paste("Average ", names(dt.mean_std))

dt.avg.actsubj
##### end of question 5################# 

}else { message('Data folder does not have required folders or files, Pls check README.MD ......')}
