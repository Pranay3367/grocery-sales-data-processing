WITH holiday_clean AS (
    SELECT
        date,
        CONCAT_WS(
            ' | ',
            SORT_ARRAY(COLLECT_SET(TRIM(type)))
        ) AS holiday_type,
        CONCAT_WS(
            ' | ',
            SORT_ARRAY(COLLECT_SET(TRIM(locale)))
        ) AS holiday_locale,
        CONCAT_WS(
            ' | ',
            SORT_ARRAY(COLLECT_SET(TRIM(locale_name)))
        ) AS holiday_locale_name,
        CONCAT_WS(
            ' | ',
            SORT_ARRAY(COLLECT_SET(TRIM(description)))
        ) AS holiday_description,
        MAX(
            CASE
                WHEN transferred = TRUE THEN TRUE
                ELSE FALSE
            END
        ) AS holiday_transferred
    FROM {{ ref('stg_holidays_events') }}
    GROUP BY date
)

SELECT
    s.id,
    s.sales_date,
    s.store_nbr,
    s.family,
    s.sales,
    s.onpromotion,
    s.city,
    s.state,
    s.type,
    s.cluster,
    s.oil_price,
    COALESCE(h.holiday_type, 'No Holiday') AS holiday_type,
    COALESCE(h.holiday_locale, 'No Holiday') AS holiday_locale,
    COALESCE(h.holiday_locale_name, 'No Holiday') AS holiday_locale_name,
    COALESCE(h.holiday_description, 'No Holiday') AS holiday_description,
    COALESCE(h.holiday_transferred, FALSE) AS holiday_transferred
FROM {{ ref('int_sales_oil') }} s
LEFT JOIN holiday_clean h
    ON s.sales_date = h.date
