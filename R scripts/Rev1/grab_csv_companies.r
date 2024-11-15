if (!requireNamespace("haven", quietly = TRUE)) {
  install.packages("haven")
}
if (!requireNamespace("readstata13", quietly = TRUE)) {
  install.packages("readstata13")
}
library(haven)
library(readstata13)
library(data.table)


# defining the address
years <- list(2005, 2007, 2009, 2011, 2013, 2015)
for (year in years) {
  file_path <- paste0("Files/Original/So lieu DN ", year, "_Final_clean.dta")
  
  # Check if file exists
  if (!file.exists(file_path)) {
    print(paste("File not found:", file_path))
    next  # Skip to the next iteration
  }
  
  # Try to read the data file
  tryCatch({
    if (year == 2013) {
      data <- read.dta13(file_path)
    } else {
      data <- read_dta(file_path)
    }
    
    # Extract and display metadata
    metadata_list <- lapply(data, function(x) {
      attr(x, "label")  # Get the variable label
    })
    
    # Create a data frame for metadata
    metadata_df <- data.frame(
      Variable = names(data),
      Label = sapply(metadata_list, function(x) ifelse(is.null(x), NA, x)),  # Handle missing labels
      stringsAsFactors = FALSE
    )
    
    # Optionally, save the data to a CSV file
    output_data_csv_path <- paste0("Files/CSV files/companies/data_", year, ".csv")  # Replace with your desired output path for data
    write.csv(data, output_data_csv_path, row.names = FALSE, fileEncoding = "UTF-8", na = "")
    print(paste("Data has been saved to", output_data_csv_path))
    
    # Save the metadata to a CSV file
    output_metadata_csv_path <- paste0("Files/CSV files/companies/metadata_", year, ".csv")  # Replace with your desired output path for metadata
    write.csv(metadata_df, output_metadata_csv_path, row.names = FALSE, fileEncoding = "UTF-8", na = "")
    print(paste("Metadata has been saved to", output_metadata_csv_path))
  }, error = function(e) {
    print(paste("Error reading file:", file_path, ":", e$message))
  })
}