SELECT
    id AS sales_id,
    sales_date,
    store_nbr,
    family,
    sales,
    onpromotion,
    city,
    state,
    type AS store_type,
    cluster,
    oil_price,
    holiday_type,
    holiday_locale,
    holiday_locale_name,
    holiday_description,
    holiday_transferred
FROM {{ ref('int_sales_complete') }}
