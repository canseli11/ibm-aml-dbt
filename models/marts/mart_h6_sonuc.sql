{{ config(materialized='view') }}

SELECT *
FROM {{ source('raw', 'mart_h6_istatistik') }}
