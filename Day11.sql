/*SOLVED*/
/*
Show the 3-season moving average per field per season per year

Write a single SQL query using window functions that will reveal these vital patterns. Your analysis will help ensure that every child who wishes for a Christmas tree will have one for years to come.

Order them by three_season_moving_avg descending to make it easier to find the largest figure.

Seasons are ordered as follows:

Spring THEN 1
Summer THEN 2
Fall THEN 3
Winter THEN 4
Find the row with the most three_season_moving_avg
*/
with cte_data as (
	select t.harvest_year
		,t.field_name
		,t.trees_harvested
		,case 
			when t.season = 'Spring' then 1
			when t.season = 'Summer' then 2
			when t.season = 'Fall' then 3
			when t.season = 'Winter' then 4
		end as season_id
	from treeharvests t 
)
,cte_avg_harvest as (
	select t.*
		,avg(t.trees_harvested) over (partition by t.harvest_year, t.field_name order by t.season_id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as avg_harvest
	from cte_data t 
)
select round(ah.avg_harvest, 2)
from cte_avg_harvest as ah
order by avg_harvest desc
limit 1
