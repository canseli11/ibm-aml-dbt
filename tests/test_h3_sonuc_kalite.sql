SELECT *
FROM {{ ref('mart_h3_sonuc') }}
WHERE hipotez IS NULL
   OR hipotez != 'H3'
   OR ki_kare IS NULL OR ki_kare < 0
   OR serbestlik_derecesi IS NULL
   OR serbestlik_derecesi <= 0
   OR p_degeri IS NULL OR p_degeri < 0 OR p_degeri > 1
   OR cramers_v IS NULL OR cramers_v < 0 OR cramers_v > 1
   OR risk_orani IS NULL OR risk_orani <= 0
   OR guven_araligi_alt IS NULL OR guven_araligi_alt <= 0
   OR guven_araligi_ust IS NULL
   OR guven_araligi_ust < guven_araligi_alt
   OR risk_orani < guven_araligi_alt
   OR risk_orani > guven_araligi_ust
   OR istatistiksel_anlamli IS NULL

UNION ALL

SELECT *
FROM {{ ref('mart_h3_sonuc') }}
WHERE (SELECT COUNT(*) FROM {{ ref('mart_h3_sonuc') }}) != 1
