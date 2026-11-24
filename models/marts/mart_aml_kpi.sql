
{{ config(materialized='view') }}

SELECT
    COUNT(*) AS toplam_islem,

    COUNTIF(is_laundering = 1) AS supheli_islem,

    COUNTIF(is_laundering = 0) AS normal_islem,

    ROUND(
        100 * SAFE_DIVIDE(
            COUNTIF(is_laundering = 1),
            COUNT(*)
        ),
        4
    ) AS supheli_islem_orani_yuzde,

    COUNT(DISTINCT from_account_key)
        AS gonderen_hesap_sayisi,

    COUNT(DISTINCT to_account_key)
        AS alici_hesap_sayisi,

    SUM(amount_paid) AS toplam_gonderilen_tutar

FROM {{ ref('int_transactions_clean') }}
