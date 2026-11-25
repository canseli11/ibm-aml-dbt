{{ config(materialized='view') }}

SELECT
    'H1' AS hipotez_id,
    'Islem tutari ve supheli islem iliskisi' AS hipotez_adi,
    para_birimi,
    islem_sayisi_0 AS normal_islem_sayisi,
    islem_sayisi_1 AS supheli_islem_sayisi,
    medyan_tutar_0 AS normal_medyan_tutar,
    medyan_tutar_1 AS supheli_medyan_tutar,
    medyan_orani,
    supheli_orani_yuzde,
    normal_ornek,
    supheli_ornek,
    p_degeri,
    duzeltilmis_p,
    etki_buyuklugu,
    istatistiksel_anlamli
FROM {{ source('raw', 'mart_h1_tutar_analizi') }}
