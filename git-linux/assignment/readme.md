# CoreDataEngineers Assignment README

## Project Overview
As a newly hired Data Engineer at **CoreDataEngineers**, I have been tasked with managing the company’s data infrastructure and version control. This project involves building a series of **Bash scripts** that automate various **ETL (Extract, Transform, Load)** processes, manage CSV and JSON file movement, and handle PostgreSQL database operations.

### Objectives:
1. Build a Bash script to automate an **ETL process**.
2. Schedule the ETL script using **cron** to run daily.
3. Write a Bash script to move all **CSV and JSON** files to a specified folder.
4. Set up a PostgreSQL database and write SQL queries to answer analytical questions.
5. Ensure the use of **environment variables** and detailed documentation within the scripts.

---

## 1. Bash ETL Script

### Process:
The script performs a simple ETL process:
- **Extract**: Download a CSV file from a URL and save it to a `raw` folder.
- **Transform**: Rename the column `Variable_code` to `variable_code` and select specific columns (`year`, `Value`, `Units`, `variable_code`). The transformed data is saved in a file named `2023_year_finance.csv` in the `Transformed` folder.
- **Load**: The transformed data is moved to a `Gold` folder, completing the ETL process.

### Directory Structure:
```bash
01_bash_etl/
├── Gold/
├── Transformed/
├── etl.env
├── etl_bash_script.sh
└── raw/
```

- **`etl_bash_script.sh`**: Main Bash script handling the ETL process.
- **`etl.env`**: Contains environment variables, such as the URL of the CSV file.

### Cron Job:
- The ETL script is scheduled to run daily at **12:00 AM** using a **cron job**.
- **`cron_script.sh`** is the Bash script used to schedule the job.

---

## 2. Moving CSV and JSON Files

### Process:
A Bash script is created to move all **CSV** and **JSON** files from any folder to a target folder named `json_and_csv`. The script can handle one or multiple files.

### Directory Structure:
```bash
03_mv_json_csv/
├── json_and_csv/
└── mv_json_csv.sh
```

- **`mv_json_csv.sh`**: Bash script that identifies and moves the CSV and JSON files into the `json_and_csv` folder.

---

## 3. PostgreSQL Database Setup

### Database Initialization:
The **PostgreSQL** database (`posey_db`) is created using the `psql_init.sh` script. This script checks for PostgreSQL installation, creates the database, and sets up the necessary tables using **SQL** scripts.

### Data Loading:
A separate script, **`psql_load.sh`**, loads CSV files into their respective tables (`accounts`, `orders`, `region`, `sales_reps`, `web_events`) in the PostgreSQL database.

### Directory Structure:
```bash
04_parch_and_posey/
├── create_tables.sql
├── datafiles/
├── dbaccess.env
├── psql_init.sh
├── psql_load.sh
└── queries.sql
```

- **`psql_init.sh`**: Script to initialize the database and create tables.
- **`psql_load.sh`**: Script to load CSV data into the PostgreSQL database.
- **`queries.sql`**: Contains SQL queries to answer analytical questions.

---

## 4. SQL Queries

### Analytical Queries:

1. **Find a list of order IDs where either gloss_qty or poster_qty is greater than 4000.**

2. **Return a list of orders where standard_qty is zero and either gloss_qty or poster_qty is over 1000.**

3. **Find all company names that start with 'C' or 'W' where the primary contact contains 'ana' or 'Ana' but not 'eana'.**

4. **Provide a table showing regions for each sales rep along with associated accounts.**
   - All queries are located in ![queries.sql](./04_parch_and_posey/queries.sql).

---

## 5. GitHub and Version Control

The project was uploaded to GitHub following best practices:
- Separate folders for **Bash scripts** and **SQL scripts**.
- Files were pushed via a **pull request** to avoid directly pushing to the master branch.

---

## 6. Architectural Diagram

Below is a visual representation of the ETL pipeline described in **01_bash_etl**. The diagram outlines how the data flows through the **Extract**, **Transform**, and **Load** stages.

![ETL Process Diagram](./etl_process_diagram.png)

---

## Conclusion

This project demonstrates how to automate ETL processes using **Bash scripting**, schedule tasks using **cron jobs**, and work with **PostgreSQL databases**. The scripts are organized into separate folders for easy management and integration into a version control system. The README provides a clear understanding of the process and implementation.

--- 

