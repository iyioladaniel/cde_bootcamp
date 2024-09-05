#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Load environment variables from .env file
source ./dbaccess.env

# Function to install PostgreSQL if it doesn't exist
if ! command -v psql > /dev/null; then
    echo "PostgreSQL is not installed. Installing PostgreSQL..."
    sudo apt update
    sudo apt install -y postgresql postgresql-contrib
else
    echo "PostgreSQL is already installed."
fi

# Function to start PostgreSQL service
echo "Starting PostgreSQL service..."
sudo systemctl start postgresql

# Check if the database exists; if not, create it
DB_EXISTS=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'")

if [ "$DB_EXISTS" = "1" ]; then
    echo "Database $DB_NAME already exists."
else
    echo "Creating the $DB_NAME database..."
    sudo -u postgres psql -c "CREATE DATABASE $DB_NAME"
fi

# Function to create the Posey database
#echo "Creating the $DB_NAME database..."
#sudo -u postgres psql -c "CREATE DATABASE IF $DB_NAME;"


# Function to create tables in the database using the provided SQL queries
echo "Creating tables in the $DB_NAME database..."
cd /tmp
sudo -u postgres psql -d "$DB_NAME" -f "/home/diyiola/CDE/git-linux/assignment/parch_and_posey/create_tables.sql"

# Function to create a new PostgreSQL user
echo "Creating PostgreSQL user..."
sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASS';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"

echo "PostgreSQL setup completed successfully."