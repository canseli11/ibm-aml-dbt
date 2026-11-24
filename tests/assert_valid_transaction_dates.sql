
SELECT
    islem_zamani
FROM {{ ref('stg_transactions') }}
WHERE islem_zamani IS NULL
   OR DATE(islem_zamani) < DATE '2000-01-01'
   OR DATE(islem_zamani) > CURRENT_DATE()
