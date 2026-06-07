select 
      kargoya_verilme_suresi,
      gerceklesen_teslimat_suresi_gun
from {{ref('fct_shipping_performance')}}
where kargoya_verilme_suresi<0 or gerceklesen_teslimat_suresi_gun<0