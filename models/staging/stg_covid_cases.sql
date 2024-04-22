{{
    config (
        engine = 'MergeTree()',
        order_by='date_rep'
    )
}}

select
    toDate(parseDateTimeBestEffort(date_rep)) as date_rep,
    toInt32(cases) as cases,
    toInt32(deaths) as deaths,
    geo_id
from {{source('dbgen', 'src_covid_cases')}}
