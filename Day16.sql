/*SOLVED
In which timezone has Santa spent the most time?

Assume that each timestamp is when Santa entered the timezone.

Ignore the last timestamp when Santa is in Lapland.
*/
with cte_area_time as (
	select a.place_name
		,min(sl.timestamp) as t1
		,max(sl.timestamp) as t2
	from areas_2 as a
	inner join sleigh_locations_2 as sl on ST_DWithin(sl.coordinate::geography, a.polygon::geography, 0)
	group by a.place_name
)
select c.place_name
	,EXTRACT(EPOCH FROM (t2 - t1)) / 3600 AS difference_in_hours
from cte_area_time as c
order by 2 desc
limit 1
