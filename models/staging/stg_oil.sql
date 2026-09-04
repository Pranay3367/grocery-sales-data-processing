WITH cleaned_oil AS (
    SELECT
        TO_DATE(date) AS date,
        CAST(dcoilwtico AS DECIMAL(10,2)) AS oil_price
    FROM {{ source('bronze', 'oil') }}
    WHERE date IS NOT NULL
      AND TRIM(date) <> ''
      AND dcoilwtico IS NOT NULL
),

deduplicated_oil AS (
    SELECT
        date,
        oil_price,
        ROW_NUMBER() OVER (
            PARTITION BY date
            ORDER BY oil_price
        ) AS rn
    FROM cleaned_oil
)

SELECT
    date,
    oil_price
FROM deduplicated_oil
WHERE rn = 1
