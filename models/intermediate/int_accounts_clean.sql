
{{ config(materialized='view') }}

SELECT
    CONCAT(
        CAST(banka_id AS STRING),
        '|',
        hesap_numarasi
    ) AS account_key,

    banka_id AS bank_id,
    banka_adi AS bank_name,
    hesap_numarasi AS account_number,

    kurulus_id AS entity_id,
    kurulus_adi AS entity_name,

    REGEXP_REPLACE(
        kurulus_adi,
        r'\s*#\d+$',
        ''
    ) AS entity_type

FROM {{ ref('stg_accounts') }}
