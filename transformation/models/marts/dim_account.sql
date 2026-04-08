{{ config(
    materialized='table',
    tags=['dimensions', 'account']
) }}

with account as (
    select * from {{ ref('stg_salesforce__account') }}
),

account_user as (
    select * from {{ ref('stg_salesforce__user') }}
),

dim_account as (
    select
        {{ dbt_utils.generate_surrogate_key(['a.account_id']) }} as account_key,
        a.account_id,
        a.name as account_name,
        a.type as account_type,
        a.industry,
        a.annualrevenue,
        a.numberofemployees,
        a.phone,
        a.website,
        a.rating,
        a.ownership,
        a.billingcity,
        a.billingstate,
        a.billingcountry,
        au.username as account_owner_username,
        concat(au.firstname, '', au.lastname) as account_owner_name,
        case 
            when a.isdeleted = true then 'Deleted'
            else 'Active'
        end as account_status,
        a.createddate as account_created_date,
        a.lastmodifieddate as account_last_modified_date,
        current_timestamp as loaddts
    from account a
    left join account_user au on a.ownerid = au.user_id
)

select * from dim_account
