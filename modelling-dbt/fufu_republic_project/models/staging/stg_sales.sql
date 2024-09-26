{{ config(materialized='view') }}

SELECT sales_id, customer_id, branch_id, product_id, 
    quantity, payment_method, dining_option, rating, 
    sales_date
FROM {{ source('fufu_republic_dev', 'sales') }}