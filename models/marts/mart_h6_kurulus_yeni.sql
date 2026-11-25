{{ config(materialized='table') }}

WITH hesap_ozet AS (
    SELECT
        entity_id,
        COUNT(DISTINCT bank_id) AS banka_sayisi,
        COUNT(DISTINCT account_key) AS hesap_sayisi
    FROM {{ ref('int_accounts_clean') }}
    WHERE entity_id IS NOT NULL
    GROUP BY entity_id
),

gonderen_ozet AS (
    SELECT
        entity_id,
        toplam_islem,
        supheli_islem,
        supheli_kurulus
    FROM {{ ref('mart_h6_gonderen_kurulus') }}
)

SELECT
    g.entity_id,
    h.banka_sayisi,
    h.hesap_sayisi,
    g.toplam_islem,
    g.supheli_islem,
    g.supheli_kurulus
FROM gonderen_ozet g
LEFT JOIN hesap_ozet h
    ON g.entity_id = h.entity_id
