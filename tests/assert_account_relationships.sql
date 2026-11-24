
WITH islem_hesaplari AS (

    SELECT
        SAFE_CAST(gonderen_banka AS INT64) AS banka_id,
        TRIM(gonderen_hesap) AS hesap_numarasi
    FROM {{ ref('stg_transactions') }}

    UNION DISTINCT

    SELECT
        SAFE_CAST(alici_banka AS INT64) AS banka_id,
        TRIM(alici_hesap) AS hesap_numarasi
    FROM {{ ref('stg_transactions') }}

)

SELECT
    i.banka_id,
    i.hesap_numarasi

FROM islem_hesaplari AS i

WHERE NOT EXISTS (
    SELECT 1
    FROM {{ ref('stg_accounts') }} AS a
    WHERE a.banka_id = i.banka_id
      AND a.hesap_numarasi = i.hesap_numarasi
)
