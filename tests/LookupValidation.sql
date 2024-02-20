
{% set isocodes = dbt_utils.get_column_values(table=ref('Countrycode'),column='ISO')%}

{% set comma = joiner(",")%}

select * from {{ref('stg_customers')}} where ISO not in ({% for isocode in isocodes %}{{comma()}}'{{isocode}}'{% endfor %})