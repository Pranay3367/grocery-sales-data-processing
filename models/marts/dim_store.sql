SELECT DISTINCT
    store_nbr,
    city,
    state,
    type AS store_type,
    cluster
FROM {{ ref('stg_stores') }}
WHERE store_nbr IS NOT NULL
