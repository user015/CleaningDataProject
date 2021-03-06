
# read the variable names from the features.txt file
library(dplyr)
 file="features.txt"
 titles=read.delim(file,header=FALSE,sep=" ")[2]
 title_str=as.vector(titles[,1])
 remlist=list();
 # read files from the test folder
 file="test/X_test.txt"
 testdata_x=read.table(file,header=FALSE,sep="")
 file="test/y_test.txt"
 testdata_activities=read.table(file,header=FALSE,sep="")
 file="test/subject_test.txt"
 testdata_subject=read.table(file,header=FALSE,sep="")
 #read files from the train folder
 file="train/X_train.txt"
 traindata_x=read.table(file,header=FALSE,sep="")
 file="train/y_train.txt"
 traindata_activities=read.table(file,header=FALSE,sep="")
 file="train/subject_train.txt"
 traindata_subject=read.table(file,header=FALSE,sep="")
 file="activity_labels.txt"
 activity_labels=read.table(file,header=FALSE,sep="")
 
 # row bind test data to train data.
 vardata=rbind(traindata_x,testdata_x)
 activity=rbind(traindata_activities, testdata_activities)
 subjects=rbind(traindata_subject,testdata_subject)
 # convert activity to factor
 activity_num=as.integer(activity[,1])
 activity=cut(activity_num,labels=activity_labels[,2],breaks=6)
 activity=as.data.frame(activity)
 # set the activity and subject header
 names(activity)="Activity"
 names(subjects)="Subjects"
 
 # add variable names to the columns, the names from the features.txt
 names(vardata)=title_str
 
 # now only include the columns which contain mean and std.
 sortted_data=vardata[,grepl("mean",names(vardata))|grepl("std",names(vardata))]

 #now add the subjects and activities data.
sortted_data=cbind(sortted_data,activity)

tidy_data=cbind(sortted_data,subjects)
# tidy data is generated by grouping by Activity, Subjects and take mean of all remaining columns.
d=tidy_data%>%group_by(Activity,Subjects)%>%summarise_each(funs(mean))
 
#Export data for read in later.
write.table(d,"DataExport.txt",row.names=FALSE)
 