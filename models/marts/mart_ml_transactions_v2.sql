{{ config(
    materialized='table',
    partition_by={
        'field': 'tx_date',
        'data_type': 'date'
    },
    cluster_by=['veri_grubu', 'payment_format']
) }}

WITH gecmis AS (
    SELECT
        t.*,

        COUNT(*) OVER (
            PARTITION BY from_bank, from_acc
            ORDER BY UNIX_MICROS(tx_ts)
            RANGE BETWEEN UNBOUNDED PRECEDING
                      AND 1 PRECEDING
        ) AS prior_count_raw,

        COUNT(*) OVER (
            PARTITION BY from_bank, from_acc
            ORDER BY UNIX_MICROS(tx_ts)
            RANGE BETWEEN 86400000000 PRECEDING
                      AND 1 PRECEDING
        ) AS prev_24h_raw,

        COUNT(*) OVER (
            PARTITION BY from_bank, from_acc
            ORDER BY UNIX_MICROS(tx_ts)
            RANGE BETWEEN 604800000000 PRECEDING
                      AND 1 PRECEDING
        ) AS prev_7d_raw,

        AVG(amount_paid) OVER (
            PARTITION BY
                from_bank, from_acc, payment_currency
            ORDER BY UNIX_MICROS(tx_ts)
            RANGE BETWEEN UNBOUNDED PRECEDING
                      AND 1 PRECEDING
        ) AS prior_avg_raw,

        MAX(UNIX_MICROS(tx_ts)) OVER (
            PARTITION BY from_bank, from_acc
            ORDER BY UNIX_MICROS(tx_ts)
            RANGE BETWEEN UNBOUNDED PRECEDING
                      AND 1 PRECEDING
        ) AS last_tx_micros

    FROM {{ ref('mart_ml_transactions') }} t
),

ozellikler AS (
    SELECT
        * EXCEPT (
            prior_count_raw,
            prev_24h_raw,
            prev_7d_raw,
            prior_avg_raw,
            last_tx_micros
        ),

        CASE
            WHEN from_bank IS NULL OR from_acc IS NULL
            THEN NULL
            ELSE prior_count_raw
        END AS sender_prior_count,

        CASE
            WHEN from_bank IS NULL OR from_acc IS NULL
            THEN NULL
            ELSE prev_24h_raw
        END AS sender_prev_24h_count,

        CASE
            WHEN from_bank IS NULL OR from_acc IS NULL
            THEN NULL
            ELSE prev_7d_raw
        END AS sender_prev_7d_count,

        CASE
            WHEN from_bank IS NULL OR from_acc IS NULL
            THEN NULL
            ELSE prior_avg_raw
        END AS sender_prior_avg_amount,

        CASE
            WHEN last_tx_micros IS NULL
              OR from_bank IS NULL
              OR from_acc IS NULL
            THEN NULL
            ELSE
                (UNIX_MICROS(tx_ts) - last_tx_micros)
                / 3600000000.0
        END AS sender_hours_since_last_tx,

        CASE
            WHEN from_bank IS NULL OR from_acc IS NULL
            THEN NULL
            ELSE SAFE_DIVIDE(
                amount_paid,
                NULLIF(prior_avg_raw, 0)
            )
        END AS sender_amount_to_prior_avg

    FROM gecmis
)

SELECT *
FROM ozellikler
