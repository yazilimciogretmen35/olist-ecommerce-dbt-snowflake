with orders as (
    -- Ana kılavuz olarak temiz sipariş başlıklarını çekiyoruz
    select * from {{ ref('stg_orders') }}
),

finansal_matris as (
    -- İlk yazdığımız ara katman (Ciro, adet ve kargo maliyetleri)
    select * from {{ ref('int_order_financial_matrix') }}
),

odeme_matris as (
    -- İkinci yazdığımız ara katman (Ödeme kanalları, kart/kupon tutarları, taksit)
    select * from {{ ref('int_order_payments_summary') }}
)

select
    -- 1. Yabancı Anahtarlar (Foreign Keys - Dim tablolarına bağlanacak köprüler)
    o.siparis_id,
    o.musteri_id, -- dim_musteriler tablosuna bağlanacak anahtar
    
    -- Zamansal Analiz Köprüleri
    o.siparis_tarihi,
    o.musteriye_teslim_tarihi,
    
    -- 2. Sipariş Durum Bilgisi
    o.siparis_durumu,
    
    -- 3. Finansal Metrikler (Sayısal Göstergeler / KPI)
    nvl(f.toplam_benzersiz_urun_sayisi, 0) as toplam_benzersiz_urun_sayisi,
    nvl(f.toplam_parca_adedi, 0) as toplam_parca_adedi,
    nvl(f.toplam_urun_cirosu, 0) as net_urun_cirosu,
    nvl(f.toplam_kargo_maliyeti, 0) as toplam_kargo_maliyeti,
    nvl(f.brut_siparis_tutari, 0) as brut_siparis_tutari,
    
    -- 4. Ödeme ve Taksit Metrikleri (İkinci ara katmandan gelenler)
    nvl(p.toplam_odeme_adimi, 0) as toplam_odeme_adimi,
    nvl(p.maksimum_taksit_sayisi, 0) as maksimum_taksit_sayisi,
    nvl(p.kredi_karti_odeme_tutari, 0) as kredi_karti_odeme_tutari,
    nvl(p.kupon_odeme_tutari, 0) as kupon_odeme_tutari,
    nvl(p.toplam_odenen_tutar, 0) as toplam_odenen_tutar
from orders o
left join finansal_matris f on o.siparis_id = f.siparis_id
left join odeme_matris p on o.siparis_id = p.siparis_id
