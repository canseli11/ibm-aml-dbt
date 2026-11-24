
{{ config(materialized='view') }}

SELECT
    t.*,

    g.kurulus_id AS gonderen_kurulus_id,
    g.kurulus_adi AS gonderen_kurulus_adi,

    a.kurulus_id AS alici_kurulus_id,
    a.kurulus_adi AS alici_kurulus_adi

FROM {{ ref('stg_transactions') }} AS t

LEFT JOIN {{ ref('stg_accounts') }} AS g
    ON SAFE_CAST(t.gonderen_banka AS INT64) = g.banka_id
    AND TRIM(t.gonderen_hesap) = g.hesap_numarasi

LEFT JOIN {{ ref('stg_accounts') }} AS a
    ON SAFE_CAST(t.alici_banka AS INT64) = a.banka_id
    AND TRIM(t.alici_hesap) = a.hesap_numarasi
