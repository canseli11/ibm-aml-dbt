
SELECT
    supheli_etiket
FROM {{ ref('stg_transactions') }}
WHERE supheli_etiket IS NULL
   OR supheli_etiket NOT IN (0, 1)
