SELECT DISTINCT
    sales_date AS date,
    YEAR(sales_date) AS year,
    MONTH(sales_date) AS month,
    DAY(sales_date) AS day,
    DAYOFWEEK(sales_date) AS day_of_week
FROM {{ ref('int_sales_complete') }}
WHERE sales_date IS NOT NULL
