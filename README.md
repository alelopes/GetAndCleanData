# Synopsis

This code works to do the following steps of code:

1)Merges the training and the test sets to create one data set.

2)Extracts only the measurements on the mean and standard deviation for each measurement.

3)Uses descriptive activity names to name the activities in the data set

4)Appropriately labels the data set with descriptive variable names.

5)From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The data could be downloaded from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


The idea of the code is to first open the data

So, the first part of the code opens the files and bind by row the test and train data sets 
```
testElements <- read.table(".\\test\\X_test.txt")
trainElements <- read.table(".\\train\\X_train.txt")

totalElements <- rbind(testElements,trainElements)

```

later, the code opens the features file and get just the mean and std features names and filter the totalElements to get just the mean and std elements.

```
features <- read.table("features.txt")
features <- features[,2]
justMeanStdFeatures <- grep("mean|std",features)
totalElements<-totalElements[,justMeanStdFeatures]
colnames(totalElements)<-justMeanStdFeatures <- grep("mean|std",features, value=TRUE)


```
Now the code do a similar process for the activity variable and subject variable:
```

labels <- read.table("activity_labels.txt")

testactivity <- read.table(".\\test\\y_test.txt")
trainactivity <- read.table(".\\train\\y_train.txt")
allactivity<-rbind(testactivity,trainactivity)
colnames(allactivity)<-"Activity"

testSubject <- read.table(".\\test\\subject_test.txt")
trainSubject <- read.table(".\\train\\subject_train.txt")
allSubject<-rbind(testSubject ,trainSubject )
colnames(allSubject)<-"Subject"
```

The code finally bind the data, subject and activity into one dataset, applies a function called transformToString to transform the activity that had numbers to string representation.

```
elementsAndActivity<-cbind(totalElements ,allactivity,allSubject)

transformToString <- function(x){
	if (x==1){
		return ("WALKING")
	}else if(x==2){
		return ("WALKING_UPSTAIRS")
	}else if(x==3){
		return ("WALKING_DOWNSTAIRS SITTING")
	}else if(x==4){
		return ("STANDING")
	}else{
		return ("LAYING")
	}
}


elementsAndActivity$Activity<-sapply(elementsAndActivity$Activity,transformToString)

```
Now, the code changes the names to more representative names and here comes the tricky part: the use of aggregate function. This will aggregate the data by Subjects and Activities and apply mean to the result aggregated values. The dataframe is shown and the code stores the data in a csv file

```

names(elementsAndActivity)<-gsub("^t", "time", names(elementsAndActivity))
names(elementsAndActivity)<-gsub("^f", "frequency", names(elementsAndActivity))
names(elementsAndActivity)<-gsub("Mag", "Magnitude", names(elementsAndActivity))
names(elementsAndActivity)<-gsub("Acc", "Accelerometer", names(elementsAndActivity))
names(elementsAndActivity)<-gsub("Gyro", "Gyroscope", names(elementsAndActivity))

aggdata<-aggregate(.~ Activity + Subject , data = elementsAndActivity,FUN=mean)

View(aggdata)

write.csv(aggdata,file="tidyData.csv")
```


