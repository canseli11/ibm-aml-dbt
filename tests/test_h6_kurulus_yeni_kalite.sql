WITH veri AS (
    SELECT *
    FROM {{ ref('mart_h6_kurulus_yeni') }}
),

kontrol AS (
    SELECT
        COUNT(*) AS kayit_sayisi,
        COUNT(DISTINCT entity_id) AS tekil_kurulus,
        COUNTIF(
            entity_id IS NULL
            OR banka_sayisi IS NULL
            OR hesap_sayisi IS NULL
            OR toplam_islem IS NULL
            OR supheli_islem IS NULL
            OR supheli_kurulus IS NULL
            OR banka_sayisi < 1
            OR hesap_sayisi < 1
            OR toplam_islem < 1
            OR supheli_islem < 0
            OR supheli_islem > toplam_islem
            OR supheli_kurulus NOT IN (0, 1)
            OR supheli_kurulus != IF(supheli_islem > 0, 1, 0)
        ) AS hatali_kayit
    FROM veri
)

SELECT *
FROM kontrol
WHERE kayit_sayisi != tekil_kurulus
   OR hatali_kayit > 0
