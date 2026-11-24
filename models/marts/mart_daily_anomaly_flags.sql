
{{ config(materialized='view') }}

WITH daily AS (
    SELECT *
    FROM {{ ref('mart_daily_aml_risk') }}
),

metrics AS (
    SELECT
        *,
        LAG(toplam_islem) OVER (
            ORDER BY islem_tarihi
        ) AS onceki_gun_islem
    FROM daily
)

SELECT
    *,

    ROUND(
        100 * SAFE_DIVIDE(
            toplam_islem - onceki_gun_islem,
            onceki_gun_islem
        ),
        2
    ) AS gunluk_hacim_degisim_yuzde,

    CASE
        WHEN onceki_gun_islem IS NOT NULL
          AND toplam_islem < onceki_gun_islem * 0.1
        THEN TRUE
        ELSE FALSE
    END AS ani_hacim_dususu,

    CASE
        WHEN supheli_oran_yuzde > 5
        THEN TRUE
        ELSE FALSE
    END AS yuksek_supheli_oran,

    CASE
        WHEN onceki_gun_islem IS NOT NULL
         AND toplam_islem < onceki_gun_islem * 0.1
         AND supheli_oran_yuzde > 5
        THEN TRUE
        ELSE FALSE
    END AS kritik_anomali

FROM metrics
