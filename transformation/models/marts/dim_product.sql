{{ config(
    materialized='table',
    tags=['dimensions', 'product']
) }}

with product as (
    select * from {{ ref('stg_salesforce__product_2') }}
),

dim_product as (
    select
        {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_key,
        product_id,
        name as product_name,
        productcode as product_code,
        family as product_family,
        type as product_type,
        description,
        case 
            when isactive = true then 'Active'
            else 'Inactive'
        end as product_status,
        createddate as product_created_date,
        lastmodifieddate as product_last_modified_date,
        current_timestamp as loaddts
    from product
)

select * from dim_product