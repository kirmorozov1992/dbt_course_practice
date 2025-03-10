{{
  config(
    materialized = 'incremental',
    incremental_strategy = 'merge',
    unique_key = ['flight_id'],
    )
}}

select
      flight_id,
      flight_no,
      scheduled_departure,
      scheduled_arrival,
      departure_airport,
      arrival_airport,
      status,
      aircraft_code,
      actual_departure,
      actual_arrival
from 
    {{ source('demo_src', 'flights') }}
{% if is_incremental() %}
  where
      (select max(scheduled_departure) from {{ source('demo_src', 'flights') }}) - scheduled_departure <= '100 day'::interval
{% endif %}
    