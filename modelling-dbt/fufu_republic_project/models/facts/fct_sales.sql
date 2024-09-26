{{ config(materialized='table') }}

SELECT sales_id, customer_id, branch_id, product_id, 
    quantity, payment_method, dining_option, rating, 
    sales_date
FROM {{ ref('stg_sales') }}