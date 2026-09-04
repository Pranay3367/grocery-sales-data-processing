WITH cleaned_transactions AS (
    SELECT
        TO_DATE(date) AS transaction_date,
        TRIM(store_nbr) AS store_nbr,
        CAST(CAST(transactions AS DOUBLE) AS INT) AS transactions
    FROM {{ source('bronze', 'transactions') }}
    WHERE date IS NOT NULL
      AND TRIM(date) <> ''
      AND store_nbr IS NOT NULL
      AND TRIM(store_nbr) <> ''
      AND transactions IS NOT NULL
      AND NOT (
          TO_DATE(date) = '2013-01-02'
          AND TRIM(store_nbr) = '1'
          AND CAST(CAST(transactions AS DOUBLE) AS INT) = 2611
      )
)

SELECT DISTINCT *
FROM cleaned_transactions
