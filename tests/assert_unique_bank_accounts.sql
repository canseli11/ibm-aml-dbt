
SELECT
    banka_id,
    hesap_numarasi,
    COUNT(*) AS tekrar_sayisi
FROM {{ ref('stg_accounts') }}
GROUP BY
    banka_id,
    hesap_numarasi
HAVING COUNT(*) > 1
