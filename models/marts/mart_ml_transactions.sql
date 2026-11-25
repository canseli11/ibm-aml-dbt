{{ config(
    materialized='table',
    partition_by={
        'field': 'tx_date',
        'data_type': 'date'
    },
    cluster_by=['veri_grubu', 'payment_format']
) }}

WITH kaynak AS (
    SELECT
        tx_ts,
        tx_date,
        tx_hour,
        from_bank,
        from_acc,
        to_bank,
        to_acc,
        amount_paid,
        payment_currency,
        payment_format,
        is_same_bank,
        is_cross_currency,
        is_laundering
    FROM {{ ref('int_transactions_clean') }}
),

ozellikler AS (
    SELECT
        *,
        EXTRACT(DAYOFWEEK FROM tx_date) AS haftanin_gunu,
        LN(1 + GREATEST(amount_paid, 0)) AS log_tutar,

        CASE
            WHEN tx_date BETWEEN DATE '2022-09-01'
                             AND DATE '2022-09-10'
                THEN 'TRAIN'
            WHEN tx_date BETWEEN DATE '2022-09-11'
                             AND DATE '2022-09-13'
                THEN 'VALIDATION'
            WHEN tx_date BETWEEN DATE '2022-09-14'
                             AND DATE '2022-09-16'
                THEN 'TEST'
            WHEN tx_date BETWEEN DATE '2022-09-17'
                             AND DATE '2022-09-28'
                THEN 'OOD_TEST'
            ELSE 'DIGER'
        END AS veri_grubu
    FROM kaynak
)

SELECT *
FROM ozellikler
