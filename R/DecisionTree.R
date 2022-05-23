

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



# filepath <- readline(prompt="Enter File Path: ")
filepath <-"C:/Users/tal74/projects/business_intelligence/R/Loan_dataset.csv"
df <- load_dataset(filepath)
df <- impute(df)
# C:/Users/tal74/projects/business_intelligence/R/Loan_dataset.csv


