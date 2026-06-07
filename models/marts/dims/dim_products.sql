{{ config(
    materialized='table'
) }}

with snapshot_products as (
    -- Staging yerine doğrudan dbt'nin tuttuğu tarihçeli snapshot tablosunu çağırıyoruz!
    select * from {{ ref('sns_products') }}
),

clean_products as (
    select
        product_id as urun_id,
        nvl(product_category_name, 'BILINMEYEN_KATEGORI') as urun_kategori_adi,
        nvl(product_weight_g, 0) as urun_agirlik_gram,
        nvl(product_length_cm, 0) as urun_uzunluk_cm,
        nvl(product_height_cm, 0) as urun_yukseklik_cm,
        nvl(product_width_cm, 0) as urun_genislik_cm,
        
        -- Tarihsel izleme sütunlarını boyut tablosuna kazandırıyoruz
        dbt_valid_from as gecerlilik_baslangic_tarihi,
        dbt_valid_to as gecerlilik_bitis_tarihi,
        
        -- Bu satırın şu an en güncel veri olup olmadığını gösteren filtre!
        case 
            when dbt_valid_to is null then true 
            else false 
        end as en_guncel_kayit_mi
    from snapshot_products
)

select
    urun_id,
    urun_kategori_adi,
    urun_agirlik_gram,
    urun_uzunluk_cm,
    urun_yukseklik_cm,
    urun_genislik_cm,
    gecerlilik_baslangic_tarihi,
    gecerlilik_bitis_tarihi,
    en_guncel_kayit_mi,
    -- Lojistik desi hesabı
    round((urun_uzunluk_cm * urun_yukseklik_cm * urun_genislik_cm) / 3000, 2) as urun_desisi
from clean_products
where en_guncel_kayit_mi = true
