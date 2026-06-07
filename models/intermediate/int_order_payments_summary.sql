{{ config(
    materialized='view'
) }}

with order_payments as (
    -- Staging katmanındaki temiz ödeme verilerini referans alıyoruz
    select * from {{ ref('stg_order_payments') }}
),

siparis_odeme_ozet as (
    select
        siparis_id,
        -- Siparişin kaç farklı ödeme adımı veya yöntemiyle ödendiği
        count(odeme_sirasi) as toplam_odeme_adimi,
        -- Müşterinin bu siparişte çıktığı maksimum taksit sayısı
        max(taksit_sayisi) as maksimum_taksit_sayisi,
        -- Kredi kartı ile ödenen toplam tutar
        round(sum(case when odeme_tipi = 'CREDIT_CARD' then odeme_tutari else 0 end), 2) as kredi_karti_odeme_tutari,
        -- Kupon / Hediye çeki ile ödenen toplam tutar
        round(sum(case when odeme_tipi = 'VOUCHER' then odeme_tutari else 0 end), 2) as kupon_odeme_tutari,
        -- Sipariş için yapılan toplam ödeme tutarı (Brüt)
        round(sum(odeme_tutari), 2) as toplam_odenen_tutar
    from order_payments
    group by 1
)

select * from siparis_odeme_ozet
