#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Create variables for source and destination
#$SOURCE_DIR="/"

# Create a folder json and csv folder if it doesn't exist
echo -e "Create a folder for json and csv files if it doesn't exists."
mkdir -p json_and_csv/

# Move all json and csv scripts to the json_and_csv folder
mv -r ./*.json ./json_and_csv/
echo "All json and csv files have been moved to json_and_csv/."