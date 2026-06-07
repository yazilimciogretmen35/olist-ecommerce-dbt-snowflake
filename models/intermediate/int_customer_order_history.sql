{{ config(
    materialized='view'
) }}

with customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

musteri_bazli_tarihce as (
    select
        c.musteri_id,
        -- Staging katmanındaki Türkçe sütun isimlerini (siparis_tarihi, siparis_durumu) kullanıyoruz
        min(o.siparis_tarihi) as ilk_siparis_tarihi,
        max(o.siparis_tarihi) as son_siparis_tarihi,
        count(o.siparis_id) as toplam_siparis_sayisi,
        count(case when o.siparis_durumu = 'DELIVERED' then o.siparis_id else null end) as teslim_edilen_siparis_sayisi
    from customers c
    left join orders o on c.musteri_id = o.musteri_id
    group by 1
)

select * from musteri_bazli_tarihce
