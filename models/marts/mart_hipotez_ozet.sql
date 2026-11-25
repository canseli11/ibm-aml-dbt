{{ config(materialized='view') }}

WITH h1 AS (
    SELECT
        'H1' AS hipotez_id,
        'Islem tutari' AS analiz_konusu,
        'Para birimi' AS analiz_birimi,
        COUNT(*) AS sonuc_sayisi,
        COUNT(*) = COUNTIF(istatistiksel_anlamli)
            AS istatistiksel_anlamli,
        CAST(NULL AS FLOAT64) AS ki_kare,
        CAST(NULL AS FLOAT64) AS cramers_v,
        CAST(NULL AS FLOAT64) AS p_degeri,
        'Para birimi bazinda medyan ve etki analizi'
            AS aciklama
    FROM {{ ref('mart_h1_istatistik') }}
),

h2 AS (
    SELECT
        'H2' AS hipotez_id,
        'Islem sikligi' AS analiz_konusu,
        'Hesap-gun' AS analiz_birimi,
        1 AS sonuc_sayisi,
        CAST(NULL AS BOOL) AS istatistiksel_anlamli,
        CAST(ki_kare AS FLOAT64) AS ki_kare,
        CAST(cramers_v AS FLOAT64) AS cramers_v,
        CAST(NULL AS FLOAT64) AS p_degeri,
        'Ki-kare ve Cramers V; p-degeri ayri hesaplandi'
            AS aciklama
    FROM {{ ref('mart_h2_istatistik') }}
),

h3 AS (
    SELECT
        'H3' AS hipotez_id,
        'Bankalar arasi transfer' AS analiz_konusu,
        'Islem' AS analiz_birimi,
        1 AS sonuc_sayisi,
        istatistiksel_anlamli,
        ki_kare,
        cramers_v,
        p_degeri,
        'Transfer turu ve supheli islem iliskisi'
            AS aciklama
    FROM {{ ref('mart_h3_sonuc') }}
),

h4 AS (
    SELECT
        'H4' AS hipotez_id,
        'Odeme yontemi' AS analiz_konusu,
        'Islem' AS analiz_birimi,
        1 AS sonuc_sayisi,
        istatistiksel_anlamli,
        ki_kare,
        cramers_v,
        p_degeri,
        'Odeme yontemi ve supheli islem iliskisi'
            AS aciklama
    FROM {{ ref('mart_h4_sonuc') }}
),

h5 AS (
    SELECT
        'H5' AS hipotez_id,
        'Alici cesitliligi' AS analiz_konusu,
        'Islem' AS analiz_birimi,
        1 AS sonuc_sayisi,
        istatistiksel_anlamli,
        ki_kare,
        cramers_v,
        p_degeri,
        'Alici cesitliligi; surekli artis desteklenmedi'
            AS aciklama
    FROM {{ ref('mart_h5_sonuc') }}
),

h6 AS (
    SELECT
        'H6' AS hipotez_id,
        'Kurulus cesitliligi' AS analiz_konusu,
        'Regresyon katsayisi' AS analiz_birimi,
        COUNT(*) AS sonuc_sayisi,
        CAST(NULL AS BOOL) AS istatistiksel_anlamli,
        CAST(NULL AS FLOAT64) AS ki_kare,
        CAST(NULL AS FLOAT64) AS cramers_v,
        CAST(NULL AS FLOAT64) AS p_degeri,
        'Regresyon; yuksek coklu baglanti tespit edildi'
            AS aciklama
    FROM {{ ref('mart_h6_sonuc') }}
)

SELECT * FROM h1
UNION ALL
SELECT * FROM h2
UNION ALL
SELECT * FROM h3
UNION ALL
SELECT * FROM h4
UNION ALL
SELECT * FROM h5
UNION ALL
SELECT * FROM h6
