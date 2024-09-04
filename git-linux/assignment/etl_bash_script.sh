#!/usr/bin/sh

# Get path for files
source /home/diyiola/CDE/git-linux/assignment/variables.env

# Extract csv file and save into folder
wget -O $PATH/raw/data.csv $URL

# Confirm file has been downloaded and saved to raw folder
ls $PATH/raw

# Create a variable for the files
FILE = $PATH/raw/data.csv
TEMP_FILE = $PATH/raw/temp.csv
EDITED_FILE = $PATH/gold/temp.csv


# print the first 5 lines of the file
cat $FILE | head -5

# Parse the file and copy only ncessary columns into temporary file
cat $FILE | cut -d, -f1,5,6,8 > $TEMP_FILE

# Perform transformation by changing a column name
sed '1s/\<Variable_code\>/<variable_code/' $FILE > $TEMP_FILE

# Replace the original file with the modified file
mv $TEMP_FILE $EDITED_FILE








