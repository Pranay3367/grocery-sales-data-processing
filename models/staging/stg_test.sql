WITH cleaned_test AS (
    SELECT
        CAST(id AS BIGINT) AS id,
        TO_DATE(date) AS test_date,
        TRIM(store_nbr) AS store_nbr
    FROM {{ source('bronze', 'test') }}
    WHERE id IS NOT NULL
      AND date IS NOT NULL
      AND TRIM(date) <> ''
      AND store_nbr IS NOT NULL
      AND TRIM(store_nbr) <> ''
)

SELECT DISTINCT *
FROM cleaned_test
