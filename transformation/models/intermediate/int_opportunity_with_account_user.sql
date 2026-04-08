{{ config(
    materialized='table',
    tags=['opportunity']
) }}

with opportunity as (
    select * from {{ ref('stg_salesforce__opportunity') }}
),

account as (
    select * from {{ ref('stg_salesforce__account') }}
),

user as (
    select * from {{ ref('stg_salesforce__user') }}
),

enriched as (
    select
        opp.opportunity_id,
        opp.accountid as account_id,
        opp.ownerid as owner_id,
        opp.contactid as contact_id,
        opp.campaignid as campaign_id,
        opp.name as opportunity_name,
        opp.description,
        opp.stagename as stage_name,
        opp.amount,
        opp.probability,
        opp.expectedrevenue as expected_revenue,
        opp.closedate,
        opp.type as opportunity_type,
        opp.leadsource as lead_source,
        opp.isclosed as is_closed,
        opp.iswon as is_won,
        opp.forecastcategoryname as forecast_category,
        acc.name as account_name,
        acc.industry,
        acc.annualrevenue,
        acc.numberofemployees,
        own.username as owner_username,
        own.firstname as owner_first_name,
        own.lastname as owner_last_name,
        opp.createddate,
        opp.lastmodifieddate
    from opportunity opp
    left join account acc on opp.accountid = acc.account_id
    left join user own on opp.ownerid = own.user_id
)

select * from enriched
