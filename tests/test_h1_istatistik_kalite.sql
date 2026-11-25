WITH veri AS (
    SELECT *
    FROM {{ ref('mart_h1_istatistik') }}
),

kontrol AS (
    SELECT
        COUNT(*) AS kayit_sayisi,
        COUNT(DISTINCT para_birimi) AS para_birimi_sayisi,
        COUNTIF(
            para_birimi IS NULL
            OR normal_islem_sayisi <= 0
            OR supheli_islem_sayisi <= 0
            OR normal_medyan_tutar < 0
            OR supheli_medyan_tutar < 0
            OR medyan_orani IS NULL
            OR medyan_orani < 0
            OR p_degeri IS NULL
            OR p_degeri < 0
            OR p_degeri > 1
            OR duzeltilmis_p IS NULL
            OR duzeltilmis_p < 0
            OR duzeltilmis_p > 1
            OR etki_buyuklugu IS NULL
            OR istatistiksel_anlamli IS NULL
        ) AS hatali_kayit
    FROM veri
)

SELECT *
FROM kontrol
WHERE kayit_sayisi != 15
   OR para_birimi_sayisi != 15
   OR hatali_kayit > 0
