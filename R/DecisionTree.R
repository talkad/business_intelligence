

load_dataset <<- function(filepath) {
  data = read.csv(filepath)
  df = data.frame(data)
  return(df)
}



filepath <- readline(prompt="Enter File Path: ")
load_dataset(filepath)
# C:/Users/tal74/projects/business_intelligence/R/Loan_dataset.csv


