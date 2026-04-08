{{ config(
    materialized='table',
    tags=['facts', 'opportunity']
) }}

{% set distinct_oppurtunities = generate_distinct_items(ref('exempt_oppurtunities'), 'oppurtunity_id') %}
with opportunity as (
    select * from {{ ref('int_opportunity_with_account_user') }}
    where opportunity_id not in {{ distinct_oppurtunities }}
),

account_key as (
    select account_id, account_key from {{ ref('dim_account') }}
),

user_key as (
    select user_id, user_key from {{ ref('dim_user') }}
),

fct_opportunity_base as (
    select
        {{ dbt_utils.generate_surrogate_key(['opportunity_id']) }} as opportunity_key,
        opportunity_id,
        opp.account_id,
        ak.account_key,
        opp.owner_id,
        uk.user_key as owner_user_key,
        opp.contact_id,
        opp.campaign_id,
        opp.opportunity_name,
        opp.stage_name,
        opp.opportunity_type,
        opp.lead_source,
        opp.amount,
        opp.probability,
        opp.expected_revenue,
        opp.is_closed,
        opp.is_won,
        opp.forecast_category,
        opp.industry,
        opp.annualrevenue as annual_revenue,
        opp.numberofemployees as number_of_employees,
        opp.closedate,
        opp.createddate,
        {{ dbt_date.month_name('opp.createddate', short=true) }} as createdmonth,
        opp.lastmodifieddate,
        current_timestamp as loaddts
    from opportunity opp
    left join account_key ak on opp.account_id = ak.account_id
    left join user_key uk on opp.owner_id = uk.user_id
),

fct_opportunity as (
    select
        *,
        sum(amount) over (partition by account_id order by createddate asc rows between unbounded preceding and current row) as cumulative_amount_per_account
    from fct_opportunity_base
)

select * from fct_opportunity
