#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Load environment variables from .env file
source dbaccess.env

# Check if CSV files exist
for file in "$DATA_FILES"/*.csv; do
    if [ ! -f "$file" ]; then
        echo "File $file does not exist. Please check the path."
        exit 1
    fi
done

# Function to load CSV files into PostgreSQL tables
load_csv_files() {
    echo "Loading CSV files into $DB_NAME database..."
    for csv_file in "$DATA_FILES"/* .csv; do
        table_name=$(basename "$csv_file" .csv)  # Get table name from the CSV file name
        echo "Loading $csv_file into $table_name table..."
        
        sudo -u postgres psql -d "$DB_NAME" -c "\COPY $table_name FROM '$csv_file' WITH (FORMAT csv, HEADER true);"
    done
}

# Main script execution
load_csv_files 

echo "CSV data load completed successfully."
