select
    (sum(cases) = 25097375) as assert
from {{ref('f_covid_cases')}}
HAVING assert NOT IN(1)
