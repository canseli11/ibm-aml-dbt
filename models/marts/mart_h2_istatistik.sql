{{ config(materialized='view') }}

WITH kaynak AS (
    SELECT
        grup_sirasi,
        siklik_grubu,
        hesap_gun_sayisi,
        supheli_hesap_gun,
        hesap_gun_sayisi - supheli_hesap_gun AS normal_hesap_gun
    FROM {{ source('raw', 'mart_h2_siklik_ozet') }}
),

gozlemler AS (
    SELECT
        grup_sirasi,
        'supheli' AS durum,
        supheli_hesap_gun AS gozlenen
    FROM kaynak

    UNION ALL

    SELECT
        grup_sirasi,
        'normal' AS durum,
        normal_hesap_gun AS gozlenen
    FROM kaynak
),

satir_toplamlari AS (
    SELECT
        grup_sirasi,
        SUM(gozlenen) AS satir_toplami
    FROM gozlemler
    GROUP BY grup_sirasi
),

sutun_toplamlari AS (
    SELECT
        durum,
        SUM(gozlenen) AS sutun_toplami
    FROM gozlemler
    GROUP BY durum
),

genel_toplam AS (
    SELECT
        SUM(gozlenen) AS n
    FROM gozlemler
),

beklenen_degerler AS (
    SELECT
        g.grup_sirasi,
        g.durum,
        g.gozlenen,
        t.n,
        SAFE_DIVIDE(
            s.satir_toplami * u.sutun_toplami,
            t.n
        ) AS beklenen
    FROM gozlemler g
    JOIN satir_toplamlari s
        USING (grup_sirasi)
    JOIN sutun_toplamlari u
        USING (durum)
    CROSS JOIN genel_toplam t
),

istatistik AS (
    SELECT
        MAX(n) AS toplam_hesap_gun,
        COUNT(DISTINCT grup_sirasi) - 1
            AS serbestlik_derecesi,
        MIN(beklenen) AS min_beklenen_frekans,
        SUM(
            SAFE_DIVIDE(
                POW(gozlenen - beklenen, 2),
                beklenen
            )
        ) AS ki_kare
    FROM beklenen_degerler
)

SELECT
    'H2' AS hipotez_id,
    'Islem sikligi ve supheli hesap-gun iliskisi' AS hipotez_adi,
    toplam_hesap_gun,
    serbestlik_derecesi,
    ROUND(ki_kare, 4) AS ki_kare,
    ROUND(
        SQRT(
            SAFE_DIVIDE(ki_kare, toplam_hesap_gun)
        ),
        6
    ) AS cramers_v,
    ROUND(min_beklenen_frekans, 2) AS min_beklenen_frekans
FROM istatistik
