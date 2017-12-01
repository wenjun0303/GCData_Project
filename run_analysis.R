#################################Pre-requisite#####################################
## Download zip file and save it to "project" folder under working directory
if(!file.exists("project")){dir.create("project")}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="./project/dataset.zip",method="curl")
## Unzip the file
zipfile <- "./project/dataset.zip"
unzip(zipfile,exdir="./project")    
## Check files                     
list.files("./project")
# [1] "dataset.zip"     "UCI HAR Dataset"                        
list.files("./project/UCI HAR Dataset")
# [1] "activity_labels.txt" "features_info.txt"   "features.txt"        "README.txt"          "test"                "train"              
list.files("./project/UCI HAR Dataset/test")
# [1] "Inertial Signals" "subject_test.txt" "X_test.txt"       "y_test.txt"      
list.files("./project/UCI HAR Dataset/train")
# [1] "Inertial Signals"  "subject_train.txt" "X_train.txt"       "y_train.txt"      
#########################Merges the training and test sets to create one data set###########################   
## Use subject_test.txt, X_test.txt and y_test.txt to create test data set
testSub <- read.table("./project/UCI HAR Dataset/test/subject_test.txt",stringsAsFactors=F)
test <- read.table("./project/UCI HAR Dataset/test/X_test.txt",stringsAsFactors=F)
testAct <- read.table("./project/UCI HAR Dataset/test/y_test.txt",stringsAsFactors=F)
## Use subject_train.txt, X_train.txt and y_train.txt to create test data set
trainSub <- read.table("./project/UCI HAR Dataset/train/subject_train.txt",stringsAsFactors=F)
trainAct <- read.table("./project/UCI HAR Dataset/train/y_train.txt",stringsAsFactors=F)
train <- read.table("./project/UCI HAR Dataset/train/X_train.txt",stringsAsFactors=F)
## Assign variable names to variables in test and train
features <- read.table("./project/UCI HAR Dataset/features.txt",stringsAsFactors=F)
colnames(testSub) <- "Subject"
colnames(testAct) <- "ActivityIndex"
colnames(test) <- features[,2]
colnames(trainSub) <- "Subject"
colnames(trainAct) <- "ActivityIndex"
colnames(train) <- features[,2]
## create test and train data sets and combine them
testData <- cbind(testSub,testAct,test)
trainData <- cbind(trainSub,trainAct,train)
allData <- rbind(testData,trainData)
######################Extracts only the measurements on the mean and standard deviation for each measurement#######################
useCol <- grepl("Subject|ActivityIndex|mean|std",colnames(allData))&!grepl("meanFreq",colnames(allData))
useData <- allData[,useCol]
######################Uses descripative activity names to name the activities in the data set#####################
activities <- read.table("./project/UCI HAR Dataset/activity_labels.txt",stringsAsFactors=F)
colnames(activities) <- c("ActivityIndex","ActivityDescription")
myData <- merge(useData,activities,by="ActivityIndex")
ncol(myData)
# [1] 69
## Adjust variable orders
install.packages("dplyr")
library("dplyr")
myData <- select(myData,2,1,69,3:68)
install.packages("plyr")
library("plyr")
## Adjust observation orders
myData <- arrange(myData,Subject,ActivityIndex)
#########################Appropriately labels the data set with descripative variable names########################
cols <- colnames(myData)[4:69]
cols <- gsub("-mean()-","Mean",cols,fixed=T)
cols <- gsub("-mean()","Mean",cols,fixed=T)
cols <- gsub("-std()-","Std",cols,fixed=T)
cols <- gsub("-std()","Std",cols,fixed=T)
colnames(myData)[4:69] <- cols
########################From the data set in step4, creates a second, independent tidy data set with the average of each variable for each activity and each subject##############################
group_by(myData,Subject,ActivityDescription) %>% summarise_all(funs(mean)) %>%
write.table("./project/tidy.txt")
