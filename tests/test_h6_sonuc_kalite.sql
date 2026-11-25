WITH kontrol AS (
    SELECT
        COUNT(*) AS n,
        COUNTIF(
            hipotez IS NULL OR hipotez != 'H6'
            OR model IS NULL OR degisken IS NULL
            OR katsayi IS NULL
            OR odds_ratio IS NULL OR odds_ratio <= 0
            OR guven_alt IS NULL OR guven_alt <= 0
            OR guven_ust IS NULL OR guven_ust < guven_alt
            OR odds_ratio < guven_alt OR odds_ratio > guven_ust
            OR p_degeri IS NULL OR p_degeri < 0 OR p_degeri > 1
        ) AS hatali,
        COUNT(DISTINCT TO_JSON_STRING(
            STRUCT(model, degisken)
        )) AS benzersiz
    FROM {{ ref('mart_h6_sonuc') }}
)
SELECT *
FROM kontrol
WHERE n != 7 OR hatali > 0 OR benzersiz != n
