{% snapshot sns_products %}

{{
    config(
      target_database='db_olist',
      target_schema='schema_olist',
      strategy='check',
      unique_key='product_id',
      check_cols=['product_category_name', 'product_weight_g']
    )
}}

select * from {{ source('olist_kaynaklari', 'RAW_OLIST_PRODUCTS') }}

{% endsnapshot %}
