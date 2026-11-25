WITH veri AS (
    SELECT *
    FROM {{ ref('mart_hipotez_ozet') }}
),

kontrol AS (
    SELECT
        COUNT(*) AS kayit_sayisi,
        COUNT(DISTINCT hipotez_id) AS tekil_hipotez,
        COUNTIF(
            hipotez_id IS NULL
            OR hipotez_id NOT IN ('H1','H2','H3','H4','H5','H6')
            OR analiz_konusu IS NULL
            OR analiz_birimi IS NULL
            OR sonuc_sayisi IS NULL
            OR sonuc_sayisi <= 0
            OR (ki_kare IS NOT NULL AND ki_kare < 0)
            OR (cramers_v IS NOT NULL AND
                (cramers_v < 0 OR cramers_v > 1))
            OR (p_degeri IS NOT NULL AND
                (p_degeri < 0 OR p_degeri > 1))
        ) AS hatali_kayit
    FROM veri
)

SELECT *
FROM kontrol
WHERE kayit_sayisi != 6
   OR tekil_hipotez != 6
   OR hatali_kayit > 0
