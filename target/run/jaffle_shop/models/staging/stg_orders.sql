
  
    

    create or replace table `playpen-b3556a`.`test_01`.`stg_orders`
      
    
    

    OPTIONS()
    as (
      with source as (
    select * from `playpen-b3556a`.`test_01`.`raw_orders`

),

renamed as (

    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status

    from source

)

select * from renamed
    );
  