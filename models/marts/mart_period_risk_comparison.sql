
{{ config(materialized='view') }}

SELECT
    CASE
        WHEN islem_tarihi < DATE '2022-09-17'
            THEN 'Normal Donem'
        ELSE 'Anormal Donem'
    END AS donem,

    MIN(islem_tarihi) AS baslangic_tarihi,
    MAX(islem_tarihi) AS bitis_tarihi,

    COUNT(*) AS gun_sayisi,

    SUM(toplam_islem) AS toplam_islem,
    SUM(supheli_islem) AS supheli_islem,

    ROUND(
        100 * SAFE_DIVIDE(
            SUM(supheli_islem),
            SUM(toplam_islem)
        ),
        4
    ) AS supheli_oran_yuzde,

    ROUND(
        AVG(toplam_islem),
        2
    ) AS ortalama_gunluk_islem

FROM {{ ref('mart_daily_aml_risk') }}

GROUP BY donem
