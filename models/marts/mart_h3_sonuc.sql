{{ config(materialized='view') }}

SELECT *
FROM {{ source('raw', 'mart_h3_istatistik') }}
