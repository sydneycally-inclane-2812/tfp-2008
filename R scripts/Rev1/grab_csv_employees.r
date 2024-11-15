if (!requireNamespace("haven", quietly = TRUE)) {
  install.packages("haven")
}
if (!requireNamespace("readstata13", quietly = TRUE)) {
  install.packages("readstata13")
}
library(haven)
library(readstata13)

# defining the address
years <- list(2007, 2009, 2011, 2013, 2015)
for (year in years) {
  addr <- paste0("Files/Original/SME Employee ", year, "_clean.dta")

  # Check if file exists
  if (!file.exists(addr)) {
    print(paste("File not found:", addr))
    next  # Skip to the next iteration
  }

  # Try to read the data file
  tryCatch({
    data <- read.dta13(addr)

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
    output_data_csv_path <- paste0("Files/CSV files/employees/data_", year, ".csv")  # Replace with your desired output path for data
    write.csv(data, output_data_csv_path, row.names = FALSE, fileEncoding = "UTF-8", na = "")
    print(paste("Data has been saved to", output_data_csv_path))

    # Save the metadata to a CSV file
    output_metadata_csv_path <- paste0("Files/CSV files/employees/metadata_", year, ".csv")  # Replace with your desired output path for metadata
    write.csv(metadata_df, output_metadata_csv_path, row.names = FALSE, fileEncoding = "UTF-8", na = "")
    print(paste("Metadata has been saved to", output_metadata_csv_path))
  }, error = function(e) {
    print(paste("Error reading file:", addr, ":", e$message))
  })
}

year <- 2009
addr <- paste0("Files/Original/SME Employee ", year, "_clean.dta")
data <- read.dta13(addr, generate.factors = TRUE)
attributes(data[[1]])
attributes(data)$label

metadata_list <- lapply(data, function(x) {
  attr(x, "label")  # Get the variable label
})

metadata_df <- data.frame(
  Variable = names(data),
  Label = sapply(metadata_list, function(x) ifelse(is.null(x), NA, x)),  # Handle missing labels
  stringsAsFactors = FALSE
)

metadata_df

for (col in names(data)) {
  attr(data[[col]], "label") <- paste("Label for", col)
}

met_list <- lapply(data, function(x) {
  attr(x, "label")
})
met_list
