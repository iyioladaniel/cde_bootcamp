#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define paths
ORG_FILE="raw"
TRANS_FILE="Transformed"
EDITED_FILE="Gold"

# Define URL and file name
URL="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"
FILE_NAME="2023_year_finance.csv"

# Define the function to check if a file exists
check_file_exists() {
    local directory="$1"
    local filename="$2"

    # Check if the file exists in the directory
    if [[ -f "$directory/$filename" ]]; then
        echo -e "File '$filename' exists in the directory '$directory'.\n"
        return 0
    else
        echo -e "File '$filename' does not exist in the directory '$directory'.\n"
        return 1
    fi
}

# Create directories if they don't exist
echo -e "Creating directories if they don't exist...\n"
mkdir -p "$ORG_FILE" "$TRANS_FILE" "$EDITED_FILE"
echo "Directories created.\n=======================================================\n"

# Extract CSV file and save it into the folder
echo "Downloading CSV file from $URL..."
wget -O "$ORG_FILE/$FILE_NAME" "$URL" && echo "Download successful." || { echo "Download failed: Unable to retrieve $URL."; exit 1; }

# Check if wget was successful
echo -e "\nChecking if file is present in the raw folder...\n"
check_file_exists "$ORG_FILE" "$FILE_NAME"

# Print the first line of the file
echo -e "\n=======================================================\nPrinting the first line of the downloaded file:"
head -1 "$ORG_FILE/$FILE_NAME"

# Perform transformation by changing a column name from Variable_code to variable_code
echo -e "\nPerforming transformation by changing 'Variable_code' to 'variable_code'...\n=======================================================\n"
sed '1s/Variable_code/variable_code/' "$ORG_FILE/$FILE_NAME" > "$TRANS_FILE/temp_$FILE_NAME"

# Extract columns 1 (year), 5 (Value), 6 (Units), 8 (variable_code) from the transformed file
echo -e "Extracting columns 1 (year), 5 (Value), 6 (Units), 8 (variable_code)...\n=======================================================\n"
cut -d, -f1,5,6,8 "$TRANS_FILE/temp_$FILE_NAME" > "$TRANS_FILE/$FILE_NAME"

# Remove the temporary file
echo -e "Removing temporary file...\n"
rm "$TRANS_FILE/temp_$FILE_NAME"

# Print the first line of the transformed file to confirm transformation
echo -e "\nPrinting the first line of the transformed file:"
head -1 "$TRANS_FILE/$FILE_NAME"
echo -e "\n"

# Check if the file has been loaded into the Transformed folder
echo -e "Checking if file is present in the transformed folder...\n=======================================================\n"
check_file_exists "$TRANS_FILE" "$FILE_NAME"

# Move the transformed file to the Gold directory
echo -e "Moving the file to the Gold directory...\n"
cp "$TRANS_FILE/$FILE_NAME" "$EDITED_FILE/$FILE_NAME"

# Check if the file has been loaded into the Gold folder
echo -e "Checking if file is present in the Gold folder...\n\n"
check_file_exists "$EDITED_FILE" "$FILE_NAME"

echo -e "\n=======================================================\nETL process completed successfully.\n=======================================================\n"
