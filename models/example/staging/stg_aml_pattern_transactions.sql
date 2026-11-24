
{{ config(materialized='view') }}

SELECT
    SAFE_CAST(attempt_id AS INT64) AS attempt_id,
    TRIM(pattern_name) AS pattern_name,

    SAFE.PARSE_TIMESTAMP(
        '%Y/%m/%d %H:%M',
        timestamp
    ) AS islem_zamani,

    TRIM(from_bank) AS gonderen_banka,
    TRIM(from_account) AS gonderen_hesap,

    TRIM(to_bank) AS alici_banka,
    TRIM(to_account) AS alici_hesap,

    SAFE_CAST(amount_paid AS NUMERIC) AS gonderilen_tutar,
    TRIM(payment_currency) AS gonderilen_para_birimi,

    SAFE_CAST(amount_received AS NUMERIC) AS alinan_tutar,
    TRIM(receiving_currency) AS alinan_para_birimi,

    TRIM(payment_format) AS odeme_yontemi,
    SAFE_CAST(is_laundering AS INT64) AS supheli_etiket,

    CASE
        WHEN TRIM(from_bank) = TRIM(to_bank)
            THEN 'Ayni Banka'
        ELSE 'Farkli Banka'
    END AS transfer_turu

FROM {{ source('raw', 'raw_aml_pattern_transactions') }}
