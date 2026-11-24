
WITH kontrol AS (
    SELECT
        COUNT(*) AS toplam,
        COUNTIF(
            gonderen_kurulus_id IS NULL
            OR alici_kurulus_id IS NULL
        ) AS eslesmeyen
    FROM {{ ref('int_transactions_entities') }}
),

kaynak AS (
    SELECT COUNT(*) AS ham_toplam
    FROM {{ ref('stg_transactions') }}
)

SELECT
    kontrol.toplam,
    kaynak.ham_toplam,
    kontrol.eslesmeyen
FROM kontrol
CROSS JOIN kaynak
WHERE kontrol.toplam != kaynak.ham_toplam
   OR kontrol.eslesmeyen > 0
