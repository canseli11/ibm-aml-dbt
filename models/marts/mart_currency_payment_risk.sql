
{{ config(materialized='view') }}

SELECT
    payment_currency,
    payment_format,

    COUNT(*) AS toplam_islem,

    COUNTIF(is_laundering = 1) AS supheli_islem,

    COUNTIF(is_laundering = 0) AS normal_islem,

    ROUND(
        100 * SAFE_DIVIDE(
            COUNTIF(is_laundering = 1),
            COUNT(*)
        ),
        4
    ) AS supheli_oran_yuzde,

    ROUND(AVG(amount_paid), 2) AS ortalama_islem_tutari,

    ROUND(
        AVG(IF(is_laundering = 1, amount_paid, NULL)),
        2
    ) AS ortalama_supheli_tutar,

    SUM(amount_paid) AS toplam_tutar

FROM {{ ref('int_transactions_clean') }}

GROUP BY
    payment_currency,
    payment_format
