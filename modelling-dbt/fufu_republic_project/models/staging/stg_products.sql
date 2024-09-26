{{ config(materialized='view') }}

SELECT * FROM {{ source('fufu_republic_dev', 'products') }}