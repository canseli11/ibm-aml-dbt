{% set h2 = ref('mart_h2_istatistik') %}

WITH kontrol AS (
    SELECT
        COUNT(*) AS kayit_sayisi,
        COUNTIF(
            hipotez_id IS NULL
            OR hipotez_id != 'H2'
            OR toplam_hesap_gun IS NULL
            OR toplam_hesap_gun <= 0
            OR ki_kare IS NULL
            OR ki_kare < 0
            OR serbestlik_derecesi != 5
            OR cramers_v IS NULL
            OR cramers_v < 0
            OR cramers_v > 1
            OR min_beklenen_frekans IS NULL
            OR min_beklenen_frekans <= 0
        ) AS hatali_kayit
    FROM {{ h2 }}
)

SELECT *
FROM kontrol
WHERE kayit_sayisi != 1
   OR hatali_kayit > 0
