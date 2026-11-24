
{{ config(materialized='view') }}

SELECT
    SAFE_CAST(attempt_id AS INT64) AS attempt_id,
    TRIM(pattern_name) AS pattern_name,
    SAFE_CAST(transaction_count AS INT64) AS transaction_count

FROM {{ source('raw', 'raw_aml_attempts') }}

