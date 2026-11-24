
WITH kaynak AS (
    SELECT COUNT(*) AS toplam
    FROM {{ ref('stg_aml_pattern_transactions') }}
),

birlesmis AS (
    SELECT
        COUNT(*) AS toplam,
        COUNTIF(senaryo_islem_sayisi IS NULL) AS eslesmeyen
    FROM {{ ref('int_patterns_linked') }}
)

SELECT
    kaynak.toplam AS kaynak_islem,
    birlesmis.toplam AS birlesmis_islem,
    birlesmis.eslesmeyen
FROM kaynak
CROSS JOIN birlesmis
WHERE kaynak.toplam != birlesmis.toplam
   OR birlesmis.eslesmeyen > 0
