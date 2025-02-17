{{
  config(
        materialized = 'table'
    )
}}

select
    ticket_no,
    tf.flight_id,
    fare_conditions,
    amount,
    case
        when boarding_no is null
            then false
        else true
    end as boarding_pass_exists,
    boarding_no,
    seat_no,
    (select current_date) as load_date
from
    {{ ref('stg_flights__ticket_flights') }} tf
left join
    {{ ref('stg_flights__boarding_passes') }}
using
    (ticket_no)
