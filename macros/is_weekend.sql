{% macro is_weekend(tarih_sutunu) %}
    -- Snowflake'te DAYOFWEEK fonksiyonu Cumartesi için 6, Pazar için 0 veya 7 döndürür.
    -- Bu makro, verilen tarihin hafta sonu olup olmadığını otomatik kontrol eder.
    case 
        when extract(dayofweek from {{ tarih_sutunu }}) in (6, 0) then true
        else false
    end
{% endmacro %}
