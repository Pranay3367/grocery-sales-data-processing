WITH sales_with_oil AS (
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
        o.oil_price
    FROM {{ ref('int_sales_enriched') }} s
    LEFT JOIN {{ ref('stg_oil') }} o
        ON s.sales_date = o.date
),

filled_oil AS (
    SELECT
        *,
        LAST_VALUE(oil_price, TRUE) OVER (
            ORDER BY sales_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS previous_oil_price,
        FIRST_VALUE(oil_price, TRUE) OVER (
            ORDER BY sales_date DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS next_oil_price
    FROM sales_with_oil
)

SELECT
    id,
    sales_date,
    store_nbr,
    family,
    sales,
    onpromotion,
    city,
    state,
    type,
    cluster,
    COALESCE(previous_oil_price, next_oil_price) AS oil_price
FROM filled_oil
