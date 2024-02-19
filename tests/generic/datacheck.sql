{% test datecheck (model, column_name) %}
    {% set c_name = column_name %}
    {% set mod_name = model %}

select count(1) as CNT from {{ mod_name }} where safe_cast ( {{c_name}} as date) is null

{% endtest %}
