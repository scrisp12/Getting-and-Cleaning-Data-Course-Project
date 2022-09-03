library(data.table)
library(dplyr)
setwd("C:/Users/Stephen/Documents/Johns Hopkins - Data Science Files/3. Data Cleaning/Getting-and-Cleaning-Data-Course-Project")

###########################################################################################
##### Grab all files from train folder and compile into one DF ############################
###########################################################################################

trainFiles <- list.files("./UCI HAR Dataset/train", pattern="*.txt", full.names=TRUE, recursive = TRUE)
trainData <- data.frame()
   for (file in trainFiles) {
        i <- fread(file)
       trainData <- rbind(trainData,i, fill=TRUE)
   }


###########################################################################################
##### Grab all files from test folder and compile into one DF ############################
###########################################################################################

testFiles <- list.files("./UCI HAR Dataset/test", pattern="*.txt", full.names=TRUE, recursive = TRUE)
testData <- data.frame()
for (file in testFiles) {
  i <- fread(file)
  testData <- rbind(testData,i,fill=TRUE)
}


###########################################################################################
##### Combine both DF's, pull names from features file and apply to all columns ###########
###########################################################################################

data <- rbind(testData,trainData)

names <- fread("./UCI HAR Dataset/features.txt")
names <- as.character(transpose(names)[2,])
colnames(data) <- names


###########################################################################################
##### Find all columns w/ mean or std dev in name, keep just those columns ################
###########################################################################################

data1 <- data %>% dplyr::select(contains("mean"))
data2 <- data %>% dplyr::select(contains("std"))
data <- cbind(data1,data2)


###########################################################################################
##### Create separate dataset with just activity name and average #########################
###########################################################################################

means <- data.frame(colMeans(data, na.rm = TRUE))
colnames(means) <- c("mean")

###########################################################################################
##### Output the 2 datasets as text files #################################################
###########################################################################################

write.csv(data, file = "by activity.csv")
write.csv(means, file = "means.csv")
