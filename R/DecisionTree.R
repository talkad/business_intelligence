

# 1.1. loading the data
load_dataset <- function(filepath) {
  data = read.csv(filepath)
  df = data.frame(data)

  # print columns types
  print(lapply(df, class))
  
  #replace empty string with NA
  df[df==""]<-NA
  
  # drop irrelevant columns
  df = subset(df, select = -c(Request_Number) )

  return(df)
}


check.integer <- function(N){
  !grepl("[^[:digit:]]", format(N,  digits = 20, scientific = FALSE))
}


# 1.2. missing values
impute <- function(df) {
  
  # impute numerical values
  numeric_imputer <- function(df, column_name, val) {
    df[column_name][indx<-which(is.na(df[column_name]), arr.ind=TRUE)] <- val
    
    return(df)
  }
  
  means<-colMeans(subset(df, select=c(Loan_Amount, Payment_Terms)),na.rm=TRUE)
  df <- numeric_imputer(df, "Loan_Amount", means[1])
  df <- numeric_imputer(df, "Payment_Terms", means[2])

  
  # impute categorical values
  categorical_imputer <- function(df, column_name) {
    df[column_name][indx<-which(is.na(df[column_name]), arr.ind=TRUE)] <- tail(names(sort(table(df[column_name]))), 1)

    return(df)
  }
  
  df <- categorical_imputer(df, "Employees")
  df <- categorical_imputer(df, "Credit_History")
  df <- categorical_imputer(df, "Export_Abroad")
  df <- categorical_imputer(df, "Gender")
  df <- categorical_imputer(df, "Married")
  
  return(df)
}


# 1.3. numerical features discretization
discretizator <- function(df) {
  
  # replace value with the suitable bin index - width discretization
  val2bin_width <- function(val, min_val, max_val, num_of_bins) {
    
    width <- (max_val - min_val) / num_of_bins
    bin <- (val - min_val) / width

    # include upper bound
    if(bin>0 && bin%%1==0) {
      as.integer(bin - 1)
    }
    else {
      as.integer(bin)
    }

  }
  
  # replace value with the suitable bin index - depth discretization
  val2bin_depth <- function(val, sorted_col, num_of_bins) {
    
    # sorted_col <- sort(col)
    sample_in_bin <- as.integer(length(sorted_col) / num_of_bins)
    
    for(idx in 1:num_of_bins) {
      if(val <= sorted_col[idx*sample_in_bin])
        return(idx - 1)
    }
    
    return(num_of_bins - 1)
  }
    
  update_rows <- function(df, column_name, num_of_bins, type) {

    
    if(type == "depth") {# depth
      col <- sort(unlist(as.list(df[column_name])))
      
      df[column_name] <- apply(df[column_name], 1, val2bin_depth, sorted_col=col, num_of_bins=num_of_bins)
    }
    else { # width
      min_val <- min(df[column_name])
      max_val <- max(df[column_name])
      
      df[column_name] <- apply(df[column_name], 1, val2bin_width, min_val=min_val, max_val=max_val, num_of_bins=num_of_bins)
      
    }
    
    return(df)
  }
    
  
  df <- update_rows(df, "Monthly_Profit", 4, "depth")
  df <- update_rows(df, "Loan_Amount", 5, "width")
  df <- update_rows(df, "Spouse_Income", 3, "depth")
  
  return(df)
}


# 1.4. randomly splitting dataset 
train_test_split <- function(df) {
  sample_size <- floor(0.7*nrow(df))
  set.seed(777)
  
  train_idx = sample(seq_len(nrow(df)),size = sample_size)
  train <- df[train_idx,]
  test <- df[-train_idx,]

  return(list("train" = train, "test" = test))
}

# preprocess - impute and discretization training and testing test without 
preprocessing_pipeline <- function(df) {
  
  data = train_test_split(df)

  train <- impute(data$train)
  #row.names(data$train) <- NULL
  train <- discretizator(train)
  
  test <- impute(data$test)
  #row.names(data$test) <- NULL
  test <- discretizator(test)
  
  return(list("train" = train, "test" = test))
}


# filepath <- readline(prompt="Enter File Path: ")
#filepath <-"C:/Users/tal74/projects/business_intelligence/R/Loan_dataset.csv"
filepath <- "C:/Users/שקד/Documents/business_intelligence/R/Loan_dataset.csv"
df <- load_dataset(filepath)
data <- preprocessing_pipeline(df)
# C:/Users/tal74/projects/business_intelligence/R/Loan_dataset.csv

# 2 - buiding the model
# 2.1 using rpart to build the decision tree

# creating the training and testing data set
trainData <- data$train
testData <- data$test
library(rpart)
output.tree1 <- rpart(Request_Approved~., data=trainData,parms=list(split="information"), minsplit=35, cp = 0.005)
#output.tree2 <- rpart(Request_Approved~Employees + Monthly_Profit + Credit_History + Customers + Export_Abroad + Loan_Amount + Payment_Terms + Gender + Education + Spouse_Income,data=trainData,parms=list(split="gini"), minsplit=6)
# print(output.tree)

library(rpart.plot)

library(RColorBrewer)

library(rattle)

plot(output.tree1)

text(output.tree1,pretty=0)

summary(output.tree1)

fancyRpartPlot(output.tree1, type=2)

# 3 - predict the model 
predicts<-predict(output.tree1, newdata=testData, type = 'class')


# count how many users are classified as qualify to loan
table_mat <- table(testData$Request_Approved, predicts)
table_mat

# calc acc of the predict
accuracy_Test <- sum(diag(table_mat)) / sum(table_mat)
acc_num <- sprintf("%.3f", accuracy_Test)
print(paste('Accuracy for test is ', as.numeric(acc_num)*100, '%'))


#Confusion Matrix - categorize the predictions against the actual values
library(caret)
Churn <- as.factor(testData$Request_Approved)
CM<-confusionMatrix(data=predicts, reference=Churn)
CM




# show the tree
library(party)
# convert defaults from "Yes" and "No" to 1's and 0's (if necessary)
testData$Request_Approved<-ifelse(testData$Request_Approved=="Y", 1 , 0)
testData$Married<-ifelse(testData$Married=="Yes", 1 , 0)
testData$Education<-ifelse(testData$Education=="Graduate", 1 , 0)
testData$Gender<-ifelse(testData$Gender=="Male", 1 , 0)
testData$Export_Abroad<-ifelse(testData$Export_Abroad=="Yes", 1 , 0)
testData$Employees<-ifelse(testData$Employees=="0", 0, ifelse(testData$Employees=="1" ,1, ifelse(testData$Employees=="2" ,2, 3)))
testData$Credit_History<-ifelse(testData$Credit_History=="1", 1 , 0)
testData$Customers<-ifelse(testData$Customers=="Small", 0, ifelse(testData$Customers=="Medium" ,1, 2))

trainDataCheck <- trainData
trainDataCheck$Request_Approved<-ifelse(trainDataCheck$Request_Approved=="Y", 1 , 0)
trainDataCheck$Married<-ifelse(trainDataCheck$Married=="Yes", 1 , 0)
trainDataCheck$Education<-ifelse(trainDataCheck$Education=="Graduate", 1 , 0)
trainDataCheck$Gender<-ifelse(trainDataCheck$Gender=="Male", 1 , 0)
trainDataCheck$Export_Abroad<-ifelse(trainDataCheck$Export_Abroad=="Yes", 1 , 0)
trainDataCheck$Employees<-ifelse(trainDataCheck$Employees=="0", 0, ifelse(trainDataCheck$Employees=="1" ,1, ifelse(trainDataCheck$Employees=="2" ,2, 3)))
trainDataCheck$Credit_History<-ifelse(trainDataCheck$Credit_History=="1", 1 , 0)
trainDataCheck$Customers<-ifelse(trainDataCheck$Customers=="Small", 0, ifelse(trainDataCheck$Customers=="Medium" ,1, 2))

# conditional inference tree - classify by some params
airct <- ctree(Request_Approved~., data = trainDataCheck)
airct
plot(airct)
# MSE - mean squared error - measure how far predicted values are from observed values in a regression analysis
mean((trainDataCheck$Request_Approved - predict(airct))^2)
# ratio of the individuals to the entire population
plot(density(testData$Request_Approved))
#  the correlation between every param
pairs(trainDataCheck, col = "red",pch = 18, main = "the correlation between every param")

