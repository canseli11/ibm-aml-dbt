
WITH kontrol AS (
    SELECT
        SUM(toplam_islem) AS toplam_islem,
        SUM(supheli_islem) AS toplam_supheli,
        COUNT(*) AS donem_sayisi
    FROM {{ ref('mart_period_risk_comparison') }}
),

kaynak AS (
    SELECT
        COUNT(*) AS toplam_islem,
        COUNTIF(is_laundering = 1) AS toplam_supheli
    FROM {{ ref('int_transactions_clean') }}
)

SELECT
    kontrol.*,
    kaynak.toplam_islem AS kaynak_islem,
    kaynak.toplam_supheli AS kaynak_supheli
FROM kontrol
CROSS JOIN kaynak
WHERE kontrol.toplam_islem != kaynak.toplam_islem
   OR kontrol.toplam_supheli != kaynak.toplam_supheli
   OR kontrol.donem_sayisi != 2
