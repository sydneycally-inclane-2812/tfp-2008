library(haven)
library(readstata13)
library(dplyr)
library(data.table)
library(foreign)
years <- list(2005, 2007, 2009, 2011, 2013, 2015)


dat <- read_dta("Files/Original/So lieu DN 2013_Final_clean.dta")
haven::read_dta("Files/Original/So lieu DN 2013_Final_clean.dta")
readstata13::read.dta13("Files/Original/So lieu DN 2013_Final_clean.dta")


# Install if needed
if (!requireNamespace("foreign", quietly = TRUE)) {
  install.packages("foreign")
}
library(foreign)

# Function to check Stata file version
check_stata_version <- function(file_path) {
  # Get file info
  file_info <- file.info(file_path)
  print(paste("File size:", file_info$size, "bytes"))
  
  # Try haven first
  tryCatch({
    haven::read_dta(file_path)
    print("File can be read with haven - likely Stata version 13 or earlier")
  }, error = function(e) {
    print("haven cannot read this file")
  })
  
  # Try readstata13
  tryCatch({
    readstata13::read.dta13(file_path)
    print("File can be read with readstata13 - likely Stata version 13+")
  }, error = function(e) {
    print("readstata13 cannot read this file")
  })
}

# Check your file
check_stata_version("Files/Original/So lieu DN 2013_Final_clean.dta")

met <- lapply(dat, function(x) {
  attr(x, "label")
})
met_df <- data.frame(
  Variable = names(dat),
  Label = sapply(met, function(x) ifelse(is.null(x), NA, x)),
  stringsAsFactors = FALSE
)

dat <- as.data.table(dat)
met_df <- as.data.table(met_df)


# Basic structure and summary
str(dat)
summary(dat)

str(met_df)
summary(met_df)
# Checking for null values
na_counts <- sapply(dat, function(x) sum(is.na(x)))
print(na_counts)

# Using dplyr to summarize null values
dat %>%
  summarise_all(~ sum(is.na(.))) %>%
  gather(key = "variable", value = "na_count") %>%
  arrange(desc(na_count)) %>%
  print()

# Using skimr for a comprehensive summary
skim(dat)

write.csv(dat, "Files/CSV files/companies/data_2005.csv", row.names = FALSE, fileEncoding = "UTF-8", na = "")