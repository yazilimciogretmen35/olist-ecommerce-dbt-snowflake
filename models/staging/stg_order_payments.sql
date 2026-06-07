with order_payments as(
    select * from {{source('olist_kaynaklari','RAW_OLIST_ORDER_PAYMENTS')}}
)


select
    -- İlişkisel anahtarı temizliyoruz
    trim(order_id)::varchar as siparis_id,
    
    -- Ödeme sırasını ve taksit sayısını integer yapıyoruz
    payment_sequential::int as odeme_sirasi,
    payment_installments::int as taksit_sayisi,
    
    -- Ödeme tipini standartlaştırıyoruz (Örn: CREDIT_CARD, VOUCHER)
    upper(trim(payment_type)) as odeme_tipi,
    
    -- Finansal değeri mühürlüyoruz
    payment_value::float as odeme_tutari
from order_payments
where order_id is not null
