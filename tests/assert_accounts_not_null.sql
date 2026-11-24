
SELECT
    banka_id,
    hesap_numarasi,
    kurulus_id
FROM {{ ref('stg_accounts') }}
WHERE banka_id IS NULL
   OR hesap_numarasi IS NULL
   OR TRIM(hesap_numarasi) = ''
   OR kurulus_id IS NULL
   OR TRIM(kurulus_id) = ''
