  {{ config(
      materialized='incremental' 
  ) }}

{%- set var_table_name = "T_DDS_PARTY_" ~ var('party_source_system_id') ~ "_STANDARDIZE" %}



select * from
{{ ref(var_table_name) }}

