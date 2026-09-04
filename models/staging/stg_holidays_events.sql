WITH cleaned_holidays AS (
    SELECT
        TO_DATE(date) AS date,
        TRIM(type) AS type,
        TRIM(locale) AS locale,
        TRIM(locale_name) AS locale_name,
        CASE
            WHEN description IS NULL
              OR TRIM(description) = ''
            THEN 'Not Provided'
            ELSE TRIM(description)
        END AS description,
        CAST(transferred AS BOOLEAN) AS transferred
    FROM {{ source('bronze', 'holidays_events') }}
    WHERE date IS NOT NULL
      AND TRIM(date) <> ''
      AND type IS NOT NULL
      AND TRIM(type) <> ''
      AND locale IS NOT NULL
      AND TRIM(locale) <> ''
      AND locale_name IS NOT NULL
      AND TRIM(locale_name) <> ''
)

SELECT DISTINCT *
FROM cleaned_holidays
