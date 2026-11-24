
{{ config(materialized='view') }}

SELECT
    p.*,
    a.transaction_count AS senaryo_islem_sayisi

FROM {{ ref('stg_aml_pattern_transactions') }} AS p

LEFT JOIN {{ ref('stg_aml_attempts') }} AS a
    ON p.attempt_id = a.attempt_id
    AND p.pattern_name = a.pattern_name
