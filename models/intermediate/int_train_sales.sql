SELECT
    t.id,
    t.sales_date,
    t.store_nbr,
    t.family,
    t.sales,
    t.onpromotion
FROM {{ ref('stg_train') }} t
