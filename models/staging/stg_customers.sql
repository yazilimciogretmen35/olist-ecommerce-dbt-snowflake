with customers as(
    select * from {{source('olist_kaynaklari','RAW_OLIST_CUSTOMERS')}}
)

select
    -- ID alanlarını metin (varchar) olarak koruyor ve temizliyoruz
    trim(customer_id)::varchar as musteri_id,
    trim(customer_unique_id)::varchar as benzersiz_musteri_id,
    
    -- Sayısal alanları açıkça int yapıyoruz
    customer_zip_code_prefix::int as posta_kodu_on_eki,
    
    -- Metinsel alanları standartlaştırıyoruz
    upper(trim(customer_city)) as sehir,
    upper(trim(customer_state)) as eyalet
from customers
where customer_id is not null