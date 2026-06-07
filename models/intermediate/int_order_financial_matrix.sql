with order_items as (
    -- Staging katmanındaki temiz sipariş detaylarını referans alıyoruz
    select * from {{ ref('stg_order_items') }}
),

siparis_bazli_ozet as (
    select
        siparis_id,
        -- Siparişteki toplam farklı ürün (kalem) sayısı
        count(distinct urun_id) as toplam_benzersiz_urun_sayisi,
        -- Siparişteki toplam satılan toplam parça adedi
        sum(siparis_satir_no) as toplam_parca_adedi,
        -- Net ürün cirosu
        round(sum(urun_fiyati), 2) as toplam_urun_cirosu,
        -- Toplam kargo (navlun) maliyeti
        round(sum(kargo_ucreti), 2) as toplam_kargo_maliyeti,
        -- Şirketin kasasına giren brüt toplam (Ciro + Kargo)
        round(sum(toplam_kalem_maliyeti), 2) as brut_siparis_tutari
    from order_items
    group by 1
)

select * from siparis_bazli_ozet
