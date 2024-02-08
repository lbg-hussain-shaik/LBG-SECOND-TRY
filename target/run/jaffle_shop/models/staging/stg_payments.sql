

  create or replace view `playpen-b3556a`.`test_01`.`stg_payments`
  OPTIONS()
  as with source as (
    select * from `playpen-b3556a`.`test_01`.`raw_payments`

),

renamed as (

    select
        id as payment_id,
        order_id,
        payment_method,

        -- `amount` is currently stored in cents, so we convert it to dollars
        amount / 100 as amount

    from source

)

select * from renamed;
