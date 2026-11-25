{{ config(materialized='table') }}

WITH gonderen_islemler AS (
    SELECT
        gonderen_kurulus_id AS entity_id,
        COUNT(*) AS toplam_islem,
        COUNTIF(supheli_etiket = 1) AS supheli_islem
    FROM {{ ref('int_transactions_entities') }}
    WHERE gonderen_kurulus_id IS NOT NULL
    GROUP BY gonderen_kurulus_id
)

SELECT
    entity_id,
    toplam_islem,
    supheli_islem,
    IF(supheli_islem > 0, 1, 0) AS supheli_kurulus
FROM gonderen_islemler
