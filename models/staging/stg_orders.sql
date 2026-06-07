with orders as (
    select * from {{ source('olist_kaynaklari', 'RAW_OLIST_ORDERS') }}
)

select
    trim(order_id)::varchar as siparis_id,
    trim(customer_id)::varchar as musteri_id,
    

    upper(trim(order_status)) as siparis_durumu,
    
    order_purchase_timestamp::timestamp as siparis_olusturma_zamani,
    order_approved_at::timestamp as siparis_onay_zamani,
    order_delivered_carrier_date::timestamp as kargoya_verilme_zamani,
    order_delivered_customer_date::timestamp as musteriye_teslim_zamani,
    order_estimated_delivery_date::timestamp as tahmini_teslim_zamani,
    
    order_purchase_timestamp::date as siparis_tarihi,
    order_delivered_customer_date::date as musteriye_teslim_tarihi
from orders
where order_id is not null
