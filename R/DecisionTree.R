

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
  means<-colMeans(subset(df, select=c(Loan_Amount, Payment_Terms)),na.rm=TRUE)
  df$Loan_Amount[indx<-which(is.na(df$Loan_Amount), arr.ind=TRUE)] <- means[1]
  df$Payment_Terms[indx<-which(is.na(df$Payment_Terms), arr.ind=TRUE)] <- means[2]
  
  # impute categorical values
  df$Employees[indx<-which(is.na(df$Employees), arr.ind=TRUE)] <- tail(names(sort(table(df$Employees))), 1)
  df$Credit_History[indx<-which(is.na(df$Credit_History), arr.ind=TRUE)] <- tail(names(sort(table(df$Credit_History))), 1)
  df$Export_Abroad[indx<-which(is.na(df$Export_Abroad), arr.ind=TRUE)] <- tail(names(sort(table(df$Export_Abroad))), 1)
  df$Gender[indx<-which(is.na(df$Gender), arr.ind=TRUE)] <- tail(names(sort(table(df$Gender))), 1)
  df$Married[indx<-which(is.na(df$Married), arr.ind=TRUE)] <- tail(names(sort(table(df$Married))), 1)
  
  return(df)
}



# filepath <- readline(prompt="Enter File Path: ")
filepath <-"C:/Users/tal74/projects/business_intelligence/R/Loan_dataset.csv"
df <- load_dataset(filepath)
df <- impute(df)
# C:/Users/tal74/projects/business_intelligence/R/Loan_dataset.csv


