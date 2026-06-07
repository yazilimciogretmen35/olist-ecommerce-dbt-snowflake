{% macro temizle_ve_turkcelestir(sutun_adi) %}
    -- 1. Önce veriyi tamamen büyük harfe çevirip sağ-sol boşluklarını temizliyoruz
    -- 2. Snowflake TRANSLATE ile Portekizce/İngilizce karakter karmaşasını standartlaştırıyoruz
    upper(
        trim(
            translate(
                {{ sutun_adi }}, 
                'áéíóúâêîôûãõçñ', 
                'AEIOUAEIOUAOCN'
            )
        )
    )
{% endmacro %}
