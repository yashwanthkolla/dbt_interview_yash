{{ config(
    materialized='table',
    tags=['dimensions', 'user']
) }}

with user as (
    select * from {{ ref('stg_salesforce__user') }}
),
user_role as (
    select * from {{ ref('stg_salesforce__user_role')}}
),

dim_user as (
    select
        {{ dbt_utils.generate_surrogate_key(['us.user_id']) }} as user_key,
        us.user_id,
        us.userroleid as user_role_id,
        us.username,
        us.firstname,
        us.lastname,
        concat(us.firstname, '', us.lastname) as user_full_name,
        us.email,
        us.title,
        us.department,
        us.phone,
        us.mobilephone,
        us.usertype as user_type,
        case 
            when us.isactive = true then 'Active'
            else 'Inactive'
        end as user_status,
        ur.name as user_role_name,
        us.createddate as user_created_date,
        us.lastlogindate as user_last_login_date,
        us.lastmodifieddate as user_last_modified_date,
        current_timestamp as loaddts
    from user us
    left join user_role ur on us.userroleid = ur.user_role_id
)

select * from dim_user