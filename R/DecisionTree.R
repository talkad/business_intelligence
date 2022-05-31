

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
  df1 <- impute(df)
  df1 <- discretizator(df1)
  write.csv(df1,"C:/Users/tal74/projects/business_intelligence/R/check.csv", row.names = FALSE)
  
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


