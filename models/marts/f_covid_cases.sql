{{
    config (
        materialized='incremental',
        engine = 'MergeTree()',
        order_by='report_date'
    )
}}

with cases as (
    select
        date_rep, cases, deaths, geo_id
    from {{ref('stg_covid_cases')}}
),
country_codes as (
        select country, alpha_2code from {{source('dbgen', 'ref_country_codes')}}
),
collected as (
    select
        cases.cases,
        cases.deaths,
        cases.date_rep as report_date,
        country_codes.country as country
    from cases
    join country_codes on cases.geo_id = country_codes.alpha_2code
)

select collected.cases, collected.country, collected.report_date, collected.deaths
from collected
{%if is_incremental()%}
   where collected.report_date > (select max(report_date) from {{this}})
{%endif%}
