---
title: "Getting and cleaning data course project"
output: 
  html_document:
    keep_md: true
---


### Data source

Data for the project is available [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

### Instructions to create a tidy data set

0. Obtain data set 

```r
# set working directory
setwd("~/Documents/Coursera/R/3gettingcleaning")
# Download zip file and save it to "project" folder under working directory
if(!file.exists("project")){dir.create("project")}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="./project/dataset.zip",method="curl")
# Unzip the file
zipfile <- "./project/dataset.zip"
unzip(zipfile,exdir="./project")    
# Check files                     
list.files("./project")
```

```
## [1] "dataset.zip"     "project_cache"   "project.Rmd"     "UCI HAR Dataset"
```

```r
list.files("./project/UCI HAR Dataset")
```

```
## [1] "activity_labels.txt" "features_info.txt"   "features.txt"       
## [4] "README.txt"          "test"                "train"
```

```r
list.files("./project/UCI HAR Dataset/test")
```

```
## [1] "Inertial Signals" "subject_test.txt" "X_test.txt"      
## [4] "y_test.txt"
```

```r
list.files("./project/UCI HAR Dataset/train")
```

```
## [1] "Inertial Signals"  "subject_train.txt" "X_train.txt"      
## [4] "y_train.txt"
```
1. Merges the training and the test sets to create one data set.

```r
# Re-set working directory
setwd("~/Documents/Coursera/R/3gettingcleaning/project")
# Use subject_test.txt, X_test.txt and y_test.txt to create test data set
testSub <- read.table("./UCI HAR Dataset/test/subject_test.txt",stringsAsFactors=F)
test <- read.table("./UCI HAR Dataset/test/X_test.txt",stringsAsFactors=F)
testAct <- read.table("./UCI HAR Dataset/test/y_test.txt",stringsAsFactors=F)
# Use subject_train.txt, X_train.txt and y_train.txt to create test data set
trainSub <- read.table("./UCI HAR Dataset/train/subject_train.txt",stringsAsFactors=F)
train <- read.table("./UCI HAR Dataset/train/X_train.txt",stringsAsFactors=F)
trainAct <- read.table("./UCI HAR Dataset/train/y_train.txt",stringsAsFactors=F)
# Assign variable names to variables in test and train
features <- read.table("./UCI HAR Dataset/features.txt",stringsAsFactors=F)
colnames(testSub) <- "Subject"
colnames(testAct) <- "ActivityIndex"
colnames(test) <- features[,2]
colnames(trainSub) <- "Subject"
colnames(trainAct) <- "ActivityIndex"
colnames(train) <- features[,2]
# create test and train data sets and combine them
testData <- cbind(testSub,testAct,test)
trainData <- cbind(trainSub,trainAct,train)
allData <- rbind(testData,trainData)
```
2. Extracts only the measurements on the mean and standard deviation for each measurement.

```r
useCol <- grepl("Subject|ActivityIndex|mean|std",colnames(allData))&!grepl("meanFreq",colnames(allData))
useData <- allData[,useCol]
```
3. Uses descriptive activity names to name the activities in the data set

```r
activities <- read.table("./UCI HAR Dataset/activity_labels.txt",stringsAsFactors=F)
colnames(activities) <- c("ActivityIndex","ActivityDescription")
myData <- merge(useData,activities,by="ActivityIndex")
ncol(myData)
```

```
## [1] 69
```

```r
# Adjust variable orders
install.packages("dplyr")
```

```
## 
## The downloaded binary packages are in
## 	/var/folders/h9/8hjlqx357_b5g7m6j3djpfkr0000gp/T//Rtmp7KTZEh/downloaded_packages
```

```r
library("dplyr")
myData <- select(myData,2,1,69,3:68)
install.packages("plyr")
```

```
## 
## The downloaded binary packages are in
## 	/var/folders/h9/8hjlqx357_b5g7m6j3djpfkr0000gp/T//Rtmp7KTZEh/downloaded_packages
```

```r
library("plyr")
# Adjust observation orders
myData <- arrange(myData,Subject,ActivityIndex)
# Check myData
myData[1:6,1:10]
```

```
##   Subject ActivityIndex ActivityDescription tBodyAcc-mean()-X
## 1       1             1             WALKING         0.3083054
## 2       1             1             WALKING         0.3274654
## 3       1             1             WALKING         0.3036349
## 4       1             1             WALKING         0.2399583
## 5       1             1             WALKING         0.2897275
## 6       1             1             WALKING         0.2966810
##   tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X tBodyAcc-std()-Y
## 1       -0.01988284       -0.16044667       -0.4390001      0.003312783
## 2       -0.03566696       -0.18182373       -0.3672203      0.034414774
## 3       -0.01465677       -0.04261383       -0.2153093      0.120917310
## 4       -0.00971072       -0.12197022       -0.3707841     -0.072025636
## 5        0.01534272       -0.11667518       -0.3687999     -0.083343414
## 6       -0.04271512       -0.10477623       -0.2307267      0.209557810
##   tBodyAcc-std()-Z tGravityAcc-mean()-X
## 1       -0.2085377            0.9507442
## 2       -0.1940234            0.9499126
## 3       -0.2186594            0.9425752
## 4       -0.3016738            0.9518559
## 5       -0.2633467            0.9526893
## 6       -0.2629006            0.9305479
```
4. Appropriately labels the data set with descriptive variable names.

```r
cols <- colnames(myData)[4:69]
cols <- gsub("-mean()-","Mean",cols,fixed=T)
cols <- gsub("-mean()","Mean",cols,fixed=T)
cols <- gsub("-std()-","Std",cols,fixed=T)
cols <- gsub("-std()","Std",cols,fixed=T)
colnames(myData)[4:69] <- cols
# Check myData
myData[1:6,1:10]
```

```
##   Subject ActivityIndex ActivityDescription tBodyAccMeanX tBodyAccMeanY
## 1       1             1             WALKING     0.3083054   -0.01988284
## 2       1             1             WALKING     0.3274654   -0.03566696
## 3       1             1             WALKING     0.3036349   -0.01465677
## 4       1             1             WALKING     0.2399583   -0.00971072
## 5       1             1             WALKING     0.2897275    0.01534272
## 6       1             1             WALKING     0.2966810   -0.04271512
##   tBodyAccMeanZ tBodyAccStdX tBodyAccStdY tBodyAccStdZ tGravityAccMeanX
## 1   -0.16044667   -0.4390001  0.003312783   -0.2085377        0.9507442
## 2   -0.18182373   -0.3672203  0.034414774   -0.1940234        0.9499126
## 3   -0.04261383   -0.2153093  0.120917310   -0.2186594        0.9425752
## 4   -0.12197022   -0.3707841 -0.072025636   -0.3016738        0.9518559
## 5   -0.11667518   -0.3687999 -0.083343414   -0.2633467        0.9526893
## 6   -0.10477623   -0.2307267  0.209557810   -0.2629006        0.9305479
```
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

```r
group_by(myData,Subject,ActivityDescription) %>% summarise_all(funs(mean)) %>%
write.table("./tidy.txt")
```
