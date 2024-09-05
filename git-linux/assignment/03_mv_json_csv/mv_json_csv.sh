#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Create variables for source and destination
FOLDER="json_and_csv"

# Create a folder json and csv folder if it doesn't exist
echo -e "\n\nCreating a folder for json and csv files if it doesn't exists..."
mkdir -p $FOLDER/

# Move all json and csv scripts to the json_and_csv folder
echo -e "\n\nMoving all json & csv files to the $FOLDER...\n=======================================================\n"
find ./ -type f \( -name "*.json" -o -name "*.csv" \) -exec mv {} ./$FOLDER/ \;

echo -e "\nAll json and csv files have been moved to json_and_csv\n."