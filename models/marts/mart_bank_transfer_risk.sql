
{{ config(materialized='view') }}

SELECT
    CASE
        WHEN is_same_bank THEN 'Banka Ici'
        ELSE 'Bankalar Arasi'
    END AS transfer_turu,

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

    COUNT(DISTINCT from_account_key)
        AS benzersiz_gonderen_hesap,

    COUNT(DISTINCT to_account_key)
        AS benzersiz_alici_hesap

FROM {{ ref('int_transactions_clean') }}

GROUP BY transfer_turu
