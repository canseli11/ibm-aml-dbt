
{{ config(materialized='view') }}

SELECT
    SAFE_CAST(`Bank ID` AS INT64) AS banka_id,
    TRIM(`Bank Name`) AS banka_adi,
    TRIM(`Account Number`) AS hesap_numarasi,
    TRIM(`Entity ID`) AS kurulus_id,
    TRIM(`Entity Name`) AS kurulus_adi

FROM {{ source('raw', 'raw_accounts') }}
