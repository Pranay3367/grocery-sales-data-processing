WITH cleaned_stores AS (
    SELECT
        TRIM(store_nbr) AS store_nbr,
        CASE
            WHEN TRIM(store_nbr) = '27' THEN 'Daule'
            WHEN TRIM(store_nbr) = '40' THEN 'Machala'
            ELSE TRIM(city)
        END AS city,
        CASE
            WHEN TRIM(store_nbr) = '27' THEN 'Guayas'
            WHEN TRIM(store_nbr) = '40' THEN 'El Oro'
            ELSE TRIM(state)
        END AS state,
        TRIM(type) AS type,
        TRIM(cluster) AS cluster
    FROM {{ source('bronze', 'stores') }}
    WHERE store_nbr IS NOT NULL
      AND TRIM(store_nbr) <> ''
      AND type IS NOT NULL
      AND TRIM(type) <> ''
      AND cluster IS NOT NULL
      AND TRIM(cluster) <> ''
      AND NOT (
          TRIM(store_nbr) = '20'
          AND TRIM(cluster) = '99'
      )
)

SELECT DISTINCT *
FROM cleaned_stores
