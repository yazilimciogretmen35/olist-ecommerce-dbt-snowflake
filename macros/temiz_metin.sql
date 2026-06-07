{% macro temiz_metin(sutun_adi) %}
    -- Giriş parametresi olarak verilen sütunun boşluklarını siler ve tamamen büyük harfe çevirir
    upper(trim({{ sutun_adi }}))
{% endmacro %}
