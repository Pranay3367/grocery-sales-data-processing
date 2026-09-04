SELECT
    t.id,
    t.sales_date,
    t.store_nbr,
    t.family,
    t.sales,
    t.onpromotion,
    s.city,
    s.state,
    s.type,
    s.cluster
FROM {{ ref('int_train_sales') }} t
INNER JOIN {{ ref('stg_stores') }} s
    ON t.store_nbr = s.store_nbr
