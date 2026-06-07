select siparis_id,
       toplam_parca_adedi
from {{ref('int_order_financial_matrix')}}
where toplam_parca_adedi<1