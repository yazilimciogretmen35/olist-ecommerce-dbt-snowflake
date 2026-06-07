with products as(
    select * from {{source('olist_kaynaklari','RAW_OLIST_PRODUCTS')}}
)

select
    -- ID alanını metin (varchar) olarak koruyor ve temizliyoruz
    trim(product_id)::varchar as urun_id,
    
    -- macroyu kullanıyoruz
   {{ temizle_ve_turkcelestir('product_category_name') }} as urun_kategori_adi,
    
    -- Sayısal özellikleri açıkça integer yapıyoruz (Null gelme ihtimaline karşı nvl ile 0 yapabiliriz)
    nvl(product_name_lenght, 0)::int as urun_adi_karakter_uzunlugu,
    nvl(product_description_lenght, 0)::int as urun_aciklama_karakter_uzunlugu,
    nvl(product_photos_qty, 0)::int as urun_foto_adedi,
    
    -- Lojistik analizlerinde (fct_kargo) kullanılacak ağırlık ve boyut metrikleri
    nvl(product_weight_g, 0)::int as urun_agirlik_gram,
    nvl(product_length_cm, 0)::int as urun_uzunluk_cm,
    nvl(product_height_cm, 0)::int as urun_yukseklik_cm,
    nvl(product_width_cm, 0)::int as urun_genislik_cm
from products
where product_id is not null
