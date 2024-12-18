/*SOLVED*/
with cte_time as (
	select w.*
		,((CURRENT_DATE || ' ' || w.business_start_time)::timestamp at time zone w.timezone) at time zone 'UTC' as start_tz_utc
		, ((CURRENT_DATE || ' ' || w.business_end_time)::timestamp at time zone w.timezone) at time zone 'UTC' as end_tz_utc
	from Workshops as w 
)
select max(c.start_tz_utc) as max_start
from cte_time as c
