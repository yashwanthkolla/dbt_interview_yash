{{ config(
    materialized='Incremental',
    unique_key='campaign_id',
    incremental_strategy = 'insert_overwrite',
    tags=['facts', 'opportunity']
) }}

with campaign_snap as (
    select * from {{ ref('snap_campaign_scd')}}
 {% if is_incremental() %}
  where lastmodifieddate > (select coalesce(max(lastmodifieddate), '1900-01-01') from {{ this }})
  {% endif %}

)
select * from campaign_snap
