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

# Create the user and assign a password
echo -e "\nChecking if the user exists ortherwise create a user....\n"
USER_EXISTS=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='$DB_USER'")
if [ "$USER_EXISTS" = "1" ]; then
    echo "User $DB_USER already exists."
else
    echo "Creating user $DB_USER..."
    sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASS';"
fi

# Grant privileges to the user on the database
echo "Granting privileges to user $DB_USER on database $DB_NAME..."
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"


# Create tables in the database using the provided SQL queries
echo "Creating tables in the $DB_NAME database..."

sudo -u postgres psql -d "$DB_NAME" -c "
CREATE TABLE region (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);
CREATE TABLE sales_reps (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    region_id INT,
    FOREIGN KEY (region_id) REFERENCES region(id) ON DELETE SET NULL
);
CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    website VARCHAR(255),
    lat DECIMAL(10, 7),
    long DECIMAL(10, 7),
    primary_poc VARCHAR(255),
    sales_rep_id INT,
    FOREIGN KEY (sales_rep_id) REFERENCES sales_reps(id) ON DELETE SET NULL
);
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    account_id INT NOT NULL,
    occurred_at TIMESTAMP NOT NULL,
    standard_qty INT DEFAULT 0,
    gloss_qty INT DEFAULT 0,
    poster_qty INT DEFAULT 0,
    total INT,
    standard_amt_usd DECIMAL(10, 2),
    gloss_amt_usd DECIMAL(10, 2),
    poster_amt_usd DECIMAL(10, 2),
    total_amt_usd DECIMAL(10, 2),
    FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
);
CREATE TABLE web_events (
    id SERIAL PRIMARY KEY,
    account_id INT NOT NULL,
    occurred_at TIMESTAMP NOT NULL,
    channel VARCHAR(255),
    FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
);
"

echo "PostgreSQL setup completed successfully."