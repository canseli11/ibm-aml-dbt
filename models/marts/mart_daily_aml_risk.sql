
{{ config(materialized='view') }}

SELECT
    tx_date AS islem_tarihi,

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

    COUNTIF(
        is_laundering = 1
        AND NOT is_same_bank
    ) AS supheli_bankalar_arasi,

    COUNTIF(
        is_laundering = 1
        AND is_same_bank
    ) AS supheli_banka_ici

FROM {{ ref('int_transactions_clean') }}

GROUP BY tx_date
