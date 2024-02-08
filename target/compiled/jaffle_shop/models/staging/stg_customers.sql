with source as (
    select * from `playpen-b3556a`.`test_01`.`raw_customers`

),

renamed as (

    select
        id as customer_id,
        first_name,
        last_name

    from source

)

select * from renamed