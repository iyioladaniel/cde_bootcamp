---

# Fufu Republic dbt Project

## Overview
This dbt project models data for **Fufu Republic**, a restaurant chain with multiple branches. The project transforms raw data into analytical models using dbt and follows a dimensional model approach, organizing data for easy reporting and analysis on sales, customer orders, and branch performance.

The project is structured around 5 key steps as outlined in the assignment.

## Assignment Steps

### Step 1: Develop a Dimensional Model
A dimensional model has been designed based on the sales data for Fufu Republic. This model organizes the data into **fact** and **dimension** tables to allow for effective analysis of customer orders, branch performance, and product sales.

### Step 2: Prototype Using Seed Data
Since real data is not yet available, **synthetic data** was generated using the Python **Faker library**. The generated synthetic data is stored as CSV files and serves as seeds for the dbt project.

The following seed files were created:
- `branches.csv`
- `customers.csv`
- `menu.csv`
- `products.csv`
- `sales.csv`
- `staff.csv`

These seed files populate the source data for the dbt models.

### Step 3: Implement dbt Models
Several dbt models were implemented to transform the raw data into structured tables for analysis. This step is broken down into four key sub-tasks:

#### Sources
- Source models were created for the raw data tables, with freshness tests defined to ensure that data is up to date. The source models are configured in `staging_sources.yml`.

#### Staging Models
- **Six staging models** were created for the raw data:
  - `stg_branches.sql`
  - `stg_customers.sql`
  - `stg_menu.sql`
  - `stg_products.sql`
  - `stg_sales.sql`
  - `stg_staff.sql`
- These staging models perform light transformations, such as renaming columns and formatting data, to prepare the raw data for further transformation.

#### Intermediate Models (Optional)
- No intermediate models were required in this phase, but they can be added if needed to refine the data before it is fed into the final models.

#### Dimensional Models
- The final dimension and fact models were built, with the **fact table (`fct_sales`)** as the central table to track sales transactions across customers, branches, and products.

### Step 4: Add Tests and Documentation
Generic and custom tests were added to ensure data quality:
- **Unique** and **not_null** tests were applied to critical fields like `sales_id`, `branch_id`, `product_id`, and `customer_id` in the fact table (`fct_sales`).
- Tests are defined in `schema.yml`.

Documentation was added for each model to explain its purpose and the transformations applied.

### Step 5: Automate User Access Requests

Currently, the user **Joseph** manually requests access to new tables/models after each dbt execution. To automate this, a solution is implemented using **dbt macros** and **post-hooks**.

#### Solution:
We created a dbt macro that automatically grants Joseph access to new tables/models after each dbt run:

```sql
{% macro grant_access_to_user(user, schema) %}
{% set grant_statement %}
  GRANT SELECT ON ALL TABLES IN SCHEMA {{ schema }} TO USER {{ user }};
{% endset %}

{% do run_query(grant_statement) %}
{% endmacro %}
```

This macro ensures that after each dbt execution, Joseph is automatically granted **SELECT** permissions on all tables in the schema.

#### Using the Macro in `dbt_project.yml`:
We added a **post-hook** to the `dbt_project.yml` file to ensure that this macro is executed after each run:

```yaml
models:
  fufu_republic_project:
    +post-hook: "{{ grant_access_to_user('joseph', target.schema) }}"
```

#### Why This Works:
This solution automates the access grant process, removing the need for Joseph to manually request access after each model run. Every time a dbt run completes, Joseph is automatically given the necessary permissions to view the newly created tables, ensuring smooth and efficient collaboration.

## Project Structure

The project contains the following key directories and files:

```
.
├── models/
│   ├── facts/                    # Fact tables (sales transactions)
│   ├── staging/                  # Staging models for raw data transformation
│   └── schema.yml                # Tests for models (e.g., uniqueness, not_null)
├── seeds/                        # Seed data (CSV files) for initial database setup
├── macros/                       # Custom macros for transformations (e.g., access grant)
└── dbt_project.yml               # Main configuration file for the dbt project
```

## Running the Project

To run the project, follow these steps:

1. **Install dbt**: Ensure you have dbt installed in your environment.
   ```bash
   pip install dbt-core
   ```

2. **Set Up dbt Profile**:
   - Ensure your **Snowflake** connection details are correctly set in the `profiles.yml` file.

3. **Seed Data**: Load the seed data from CSV files into your database.
   ```bash
   dbt seed
   ```

4. **Build Models**: Build and run the models.
   ```bash
   dbt build
   ```

5. **Run Tests**: Validate the data models by running tests.
   ```bash
   dbt test
   ```

## Project Objectives

This dbt project aims to:

- **Centralize Sales Data**: Organize sales and transaction data from multiple branches into a structured format.
- **Ensure Data Quality**: Use dbt’s testing framework to ensure data consistency and integrity across the models.
- **Automate Access**: Ensure Joseph can access new tables automatically after every dbt run.

## Conclusion

This project lays the foundation for data-driven decision-making at **Fufu Republic** by transforming raw operational data into structured models that are ready for analysis. It also automates user access requests, streamlining collaboration within the team.

---

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
