
SELECT
    islem_zamani,
    gonderilen_tutar,
    alinan_tutar
FROM {{ ref('stg_transactions') }}
WHERE gonderilen_tutar IS NULL
   OR alinan_tutar IS NULL
   OR gonderilen_tutar <= 0
   OR alinan_tutar <= 0
