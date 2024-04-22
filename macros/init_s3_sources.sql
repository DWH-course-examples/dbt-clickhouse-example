{% macro init_s3_sources() -%}

    {% set sources = [
        'DROP TABLE IF EXISTS src_covid_cases'
        , 'CREATE TABLE IF NOT EXISTS src_covid_cases
        (
			date_rep String,
			day UInt32,
			month UInt32,
			year UInt32,
			cases UInt32,
			deaths UInt32,
			geo_id String
		)
        ENGINE = S3(\'https://storage.yandexcloud.net/ch-data-course/covid_cases/raw_covid__cases.csv\', \'CSVWithNames\')
        '
        , 'DROP TABLE IF EXISTS src_covid_vaccines'
        , 'CREATE TABLE src_covid_vaccines
        (
            year_week_iso String,
			reporting_country String,
			num_doses_recv UInt32,
			num_doses_exported UInt32,
			first_dose UInt32,
			first_dose_refused UInt32,
			second_dose UInt32,
			unknown_dose UInt32,
			target_group String,
			vaccine String
        )
        ENGINE = S3(\'https://storage.yandexcloud.net/ch-data-course/covid_cases/raw_covid__vaccines.csv\', \'CSVWithNames\')
        '
        , 'DROP TABLE IF EXISTS ref_country_codes'
        , 'CREATE TABLE ref_country_codes
        (
			country String,
			alpha_2code String,
			alpha_3code String,
			numeric_code UInt32,
			latitude_avg Decimal(15,3),
			longitude_avg Decimal(15,3)
        )
        ENGINE = S3(\'https://storage.yandexcloud.net/ch-data-course/covid_cases/reference/ref__country_codes.csv\', \'CSVWithNames\')
        '
        , 'DROP TABLE IF EXISTS ref_populations'
        , 'CREATE TABLE ref_populations
        (
			country_code String,
			population UInt32
        )
        ENGINE = S3(\'https://storage.yandexcloud.net/otus-dwh/tpch-dbgen-1g/ref__populations.csv\', \'CSVWithNames\')
        '
    ] %}

    {% for src in sources %}
        {% set statement = run_query(src) %}
    {% endfor %}

{{ print('Initialized source tables – Covid Cases (S3)') }}

{%- endmacro %}
