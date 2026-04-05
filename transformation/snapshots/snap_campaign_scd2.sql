{% snapshot snap_campaign_scd %}

  {{
    config(
      target_schema='snapshots',
      database='dbt',
      unique_key='campaign_id',
      strategy='timestamp',
      updated_at='lastmodifieddate',
      tags=['scd_type_2', 'campaign']
    )
  }}

  select
    campaign_id,
    name as campaign_name,
    type as campaign_type,
    status,
    startdate,
    enddate,
    expectedrevenue,
    budgetedcost,
    actualcost,
    ownerid,
    createddate as campaign_created_date,
    createdbyid,
    isactive,
    isdeleted,
    lastmodifieddate
  from {{ ref('stg_salesforce__campaign') }}

{% endsnapshot %}
