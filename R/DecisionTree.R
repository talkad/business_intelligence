

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
  
  # replace value with the suitable bin index
  val2bin <- function(val, min_val, max_val, num_of_bins) {
    
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
    
  update_rows <- function(df, column_name, num_of_bins) {
    min_val <- min(df[column_name])
    max_val <- max(df[column_name])
    
    df[column_name] <- apply(df[column_name], 1, val2bin, min_val=min_val, max_val=max_val, num_of_bins=num_of_bins)
    
    return(df)
  }
    
  
  df <- update_rows(df, "Monthly_Profit", 5)
  df <- update_rows(df, "Loan_Amount", 4)
  df <- update_rows(df, "Spouse_Income", 3)
  
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
filepath <-"C:/Users/tal74/projects/business_intelligence/R/Loan_dataset.csv"
df <- load_dataset(filepath)
data <- preprocessing_pipeline(df)
# C:/Users/tal74/projects/business_intelligence/R/Loan_dataset.csv




# 3 - predict the model 
# predicts<-predict(modelName, newdata=df_test)
# predicts<-predict(modelName, df_test, type = 'class')

# count how many users are classified as qualify to loan
# table_mat <- table(df_test$qualify, predicts)
# table_mat

# calc acc of the predict
# accuracy_Test <- sum(diag(table_mat)) / sum(table_mat)
# print(paste('Accuracy for test', accuracy_Test))

# convert defaults from "Yes" and "No" to 1's and 0's (if nesessery)
# test$default <- ifelse(df_test$default=="Yes", 1, 0)
# Confusion Matrix
# CM<-confusionMatrix(predicts, reference=testing$Species)

# minsplit
# control <- rpart.control(minsplit = 4,minbucket = round(5 / 3),maxdepth = 3,cp = 0)
# tune_fit <- rpart(survived~., data = data_train, method = 'class', control = control)
# accuracy_tune(tune_fit)

# plot(density(iris$Sepal.Length))
# plot(iris$Sepal.Length, iris$Sepal.Width)
# pairs(iris)



# show the tree
# library(party)
# iris_ctree<-ctree(Species~.,data=training)
# plot(iris_ctree)

# 
# table(iris$Species, results$cluster)
# plot(iris$Petal.Length, iris$Petal.Width, col=results$cluster)
# plot(iris$Petal.Length, iris$Petal.Width, col=iris$Species)
