with order_items as(
    select * from {{source('olist_kaynaklari','RAW_OLIST_ORDER_ITEMS')}}

)


select
    -- Benzersiz anahtarları ve ilişkisel ID'leri temizliyoruz
    trim(order_id)::varchar as siparis_id,
    trim(product_id)::varchar as urun_id,
    trim(seller_id)::varchar as satici_id,
    
    -- Sipariş içi satır numarasını integer yapıyoruz (Örn: Sepetteki 1. veya 2. ürün)
    order_item_id::int as siparis_satir_no,
    
    -- Lojistik limiti için zaman damgası
    shipping_limit_date::timestamp as son_sevk_zamani,
    
    -- Finansal metrikleri float/numeric olarak mühürlüyoruz
    price::float as urun_fiyati,
    freight_value::float as kargo_ucreti,
    
    -- Analizlerde kolaylık için toplam kalem maliyetini şimdiden üretiyoruz
    round((price + freight_value), 2)::float as toplam_kalem_maliyeti
from order_items
where order_id is not null
