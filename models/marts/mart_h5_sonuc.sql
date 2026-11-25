{{ config(materialized='view') }}

SELECT *
FROM {{ source('raw', 'mart_h5_istatistik') }}
