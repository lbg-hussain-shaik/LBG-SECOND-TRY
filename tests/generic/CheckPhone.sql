{% test test_is_tdn(model, column_name) %}

with validation as (
  select
    {{ column_name }} as tdn_field
  from {{ model }}
),

validation_errors as (
  
)

select count(*)
from validation_errors

{% endtest %}