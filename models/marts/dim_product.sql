SELECT DISTINCT
    family AS product_family
FROM {{ ref('int_train_sales') }}
WHERE family IS NOT NULL
