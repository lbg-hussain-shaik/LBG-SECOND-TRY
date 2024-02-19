

  create or replace view `playpen-b3556a`.`test_01`.`tp1`
  OPTIONS()
  as with source as (

    select * from `playpen-b3556a`.`test_01`.`raw_customers`

),

renamed as (

    select
        id as customer_id,
        first_name,
        last_name,
        'sysdate' as datecolumn

    from source

)

select * from renamed;

