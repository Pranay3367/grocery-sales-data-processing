WITH cleaned_train AS (
    SELECT
        CAST(id AS BIGINT) AS id,
        TO_DATE(date) AS sales_date,
        TRIM(store_nbr) AS store_nbr,
        TRIM(family) AS family,
        CAST(CAST(sales AS DOUBLE) AS DECIMAL(18,2)) AS sales,
        CAST(CAST(onpromotion AS DOUBLE) AS INT) AS onpromotion
    FROM {{ source('bronze', 'train') }}
    WHERE id IS NOT NULL
      AND date IS NOT NULL
      AND TRIM(date) <> ''
      AND store_nbr IS NOT NULL
      AND TRIM(store_nbr) <> ''
      AND family IS NOT NULL
      AND TRIM(family) <> ''
      AND sales IS NOT NULL
      AND onpromotion IS NOT NULL
)

SELECT DISTINCT *
FROM cleaned_train
