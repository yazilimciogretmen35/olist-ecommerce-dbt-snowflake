{{ config(
    materialized='table'
) }}

with tablo as (
    select * from {{ ref('stg_orders') }}
),

tablo2 as (
    select 
        siparis_id,
        musteri_id,
        siparis_olusturma_zamani,
        -- Makromuz sütunu başarıyla üretiyor:
        {{ is_weekend('siparis_olusturma_zamani') }} as siparis_hafta_sonu_mu,
        datediff(day, siparis_olusturma_zamani, kargoya_verilme_zamani) as kargoya_verilme_suresi,
        datediff(day, siparis_olusturma_zamani, musteriye_teslim_zamani) as gerceklesen_teslimat_suresi_gun,
        datediff(day, tahmini_teslim_zamani, musteriye_teslim_zamani) as tahmini_teslimat_sapma_gun
    from tablo
)

select 
    siparis_id,
    musteri_id,
    -- HATA BURADAYDI: Sütunu nihai select bloğuna ekledik!
    siparis_hafta_sonu_mu, 
    kargoya_verilme_suresi,
    gerceklesen_teslimat_suresi_gun,
    tahmini_teslimat_sapma_gun,
    case
        when tahmini_teslimat_sapma_gun > 0 then 'Gecikme Yaşandı'
        when tahmini_teslimat_sapma_gun = 0 then 'Tam Zamanında Teslim Edildi'
        when tahmini_teslimat_sapma_gun < 0 then 'Erken Teslim Edildi'
        else 'Veri Eksik / Teslim Edilmedi' 
    end as gecikme_durumu
from tablo2
