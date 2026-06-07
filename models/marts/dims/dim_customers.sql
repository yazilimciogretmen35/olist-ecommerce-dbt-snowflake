with customers as (
    -- Staging katmanındaki temiz müşteri temel verileri
    select * from {{ ref('stg_customers') }}
),

musteri_tarihce as (
    -- Az önce başarıyla mühürlediğimiz intermediate tarihçe tablosu
    select * from {{ ref('int_customer_order_history') }}
)

select
    c.musteri_id,
    c.benzersiz_musteri_id,
    c.posta_kodu_on_eki,
    c.sehir,
    c.eyalet,
    
    -- Ara katmandan gelen zamansal metrikleri boyuta yediriyoruz
    t.ilk_siparis_tarihi,
    t.son_siparis_tarihi,
    nvl(t.toplam_siparis_sayisi, 0) as toplam_siparis_sayisi,
    nvl(t.teslim_edilen_siparis_sayisi, 0) as teslim_edilen_siparis_sayisi,
    
    -- BI (Raporlama) araçlarında analistlerin bayılacağı dinamik müşteri segmentasyonu
    case
        when t.toplam_siparis_sayisi is null or t.toplam_siparis_sayisi = 0 then '01. Hiç Alışveriş Yapmadı'
        when t.toplam_siparis_sayisi = 1 then '02. Tek Seferlik Müşteri'
        when t.toplam_siparis_sayisi between 2 and 4 then '03. Düzenli Müşteri'
        else '04. Sadık / VIP Müşteri'
    end as musteri_segmenti
from customers c
left join musteri_tarihce t on c.musteri_id = t.musteri_id
