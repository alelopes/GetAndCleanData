
#setwd("C:\\Users\\Alexandre\\Documents\\Data Analysis\\UCI HAR Dataset")
##first setwd to the folder of the UCI HAR Dataset
##So, the first part of the code opens the files and bind by row the test and train data sets

testElements <- read.table(".\\test\\X_test.txt")
trainElements <- read.table(".\\train\\X_train.txt")

#gets all the elements
totalElements <- rbind(testElements,trainElements)

##later, the code opens the features file and get just the mean and std features names and filter the totalElements to get just the mean and std elements.
features <- read.table("features.txt")
features <- features[,2]
justMeanStdFeatures <- grep("mean|std",features)

totalElements<-totalElements[,justMeanStdFeatures]

#greps the mean OR std of the feature names, and chang the totalElements column name.
colnames(totalElements)<-justMeanStdFeatures <- grep("mean|std",features, value=TRUE)


##Now the code do a similar process for the activity variable and subject variable:

labels <- read.table("activity_labels.txt")

testactivity <- read.table(".\\test\\y_test.txt")
trainactivity <- read.table(".\\train\\y_train.txt")
allactivity<-rbind(testactivity,trainactivity)
colnames(allactivity)<-"Activity"



testSubject <- read.table(".\\test\\subject_test.txt")
trainSubject <- read.table(".\\train\\subject_train.txt")
allSubject<-rbind(testSubject ,trainSubject )
colnames(allSubject)<-"Subject"




elementsAndActivity<-cbind(totalElements ,allactivity,allSubject)

# function to transform from 1, 2, 3, 4, 5 and 6 to representative names.
transformToString <- function(x){
	if (x==1){
		return ("WALKING")
	}else if(x==2){
		return ("WALKING_UPSTAIRS")
	}else if(x==3){
		return ("WALKING_DOWNSTAIRS")
	}else if(x==4){
	  return ("SITTING")
	}else if(x==5){
		return ("STANDING")
	}else{
		return ("LAYING")
	}
}

## Now, the code changes the names to more representative names and 
## here comes the tricky part: the use of aggregate function. This will 
## aggregate the data by Subjects and Activities and apply mean to the 
## result aggregated values. The dataframe is shown and the code stores 
## the data in a txt file

elementsAndActivity$Activity<-sapply(elementsAndActivity$Activity,transformToString)

names(elementsAndActivity)<-gsub("^t", "time", names(elementsAndActivity))
names(elementsAndActivity)<-gsub("^f", "frequency", names(elementsAndActivity))
names(elementsAndActivity)<-gsub("Mag", "Magnitude", names(elementsAndActivity))
names(elementsAndActivity)<-gsub("Acc", "Accelerometer", names(elementsAndActivity))
names(elementsAndActivity)<-gsub("Gyro", "Gyroscope", names(elementsAndActivity))

aggdata<-aggregate(.~ Activity + Subject , data = elementsAndActivity,FUN=mean)

View(aggdata)

write.table(aggdata,file="tidyData.txt",name=FALSE)
