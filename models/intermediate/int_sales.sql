SELECT
    t.transaction_date,
    t.store_nbr,
    s.city,
    s.state,
    s.type AS store_type,
    s.cluster,
    t.transactions
FROM {{ ref('stg_transactions') }} t
LEFT JOIN {{ ref('stg_stores') }} s
    ON t.store_nbr = s.store_nbr
