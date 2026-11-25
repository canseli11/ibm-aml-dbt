WITH kontrol AS (
    SELECT
        COUNT(*) AS n,
        COUNTIF(
            hipotez IS NULL OR hipotez != 'H5'
            OR ki_kare IS NULL OR ki_kare < 0
            OR serbestlik_derecesi IS NULL
            OR serbestlik_derecesi <= 0
            OR p_degeri IS NULL OR p_degeri < 0 OR p_degeri > 1
            OR cramers_v IS NULL OR cramers_v < 0 OR cramers_v > 1
            OR istatistiksel_anlamli IS NULL
            OR surekli_artis_desteklendi IS NULL
        ) AS hatali
    FROM {{ ref('mart_h5_sonuc') }}
)
SELECT * FROM kontrol WHERE n != 1 OR hatali > 0
