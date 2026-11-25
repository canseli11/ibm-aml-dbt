{{ config(materialized='view') }}

SELECT *
FROM {{ source('raw', 'mart_h4_istatistik') }}
