
{{ config(materialized='view') }}

SELECT
    islem_zamani AS tx_ts,
    DATE(islem_zamani) AS tx_date,
    EXTRACT(HOUR FROM islem_zamani) AS tx_hour,

    gonderen_banka AS from_bank,
    gonderen_hesap AS from_acc,

    CONCAT(
        gonderen_banka, '|', gonderen_hesap
    ) AS from_account_key,

    alici_banka AS to_bank,
    alici_hesap AS to_acc,

    CONCAT(
        alici_banka, '|', alici_hesap
    ) AS to_account_key,

    gonderilen_tutar AS amount_paid,
    alinan_tutar AS amount_received,

    gonderilen_para_birimi AS payment_currency,
    alinan_para_birimi AS receiving_currency,

    odeme_yontemi AS payment_format,
    supheli_etiket AS is_laundering,

    supheli_etiket = 1 AS is_suspicious,

    gonderen_banka = alici_banka AS is_same_bank,

    (
        gonderen_banka = alici_banka
        AND gonderen_hesap = alici_hesap
    ) AS is_self_transfer,

    gonderilen_para_birimi !=
        alinan_para_birimi AS is_cross_currency,

    COALESCE(
        gonderilen_tutar > 0
        AND alinan_tutar > 0,
        FALSE
    ) AS is_valid_amount

FROM {{ ref('stg_transactions') }}
