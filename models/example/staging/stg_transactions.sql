
{{ config(materialized='view') }}

SELECT
    SAFE.PARSE_TIMESTAMP(
        '%Y/%m/%d %H:%M',
        timestamp
    ) AS islem_zamani,

    from_bank AS gonderen_banka,
    from_account AS gonderen_hesap,

    to_bank AS alici_banka,
    to_account AS alici_hesap,

    amount_paid AS gonderilen_tutar,
    payment_currency AS gonderilen_para_birimi,

    amount_received AS alinan_tutar,
    receiving_currency AS alinan_para_birimi,

    payment_format AS odeme_yontemi,
    is_laundering AS supheli_etiket,

    CASE
        WHEN from_bank = to_bank
            THEN 'Ayni Banka'
        ELSE 'Farkli Banka'
    END AS transfer_turu

FROM {{ source('raw', 'raw_transactions') }}
