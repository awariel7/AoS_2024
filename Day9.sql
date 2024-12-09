/*SOLVED*/
with cte_speed as (
	select ts.reindeer_id
		,ts.exercise_name
		,avg(ts.speed_record) as average_speed 
	from training_sessions ts 
	group by ts.reindeer_id
		,ts.exercise_name
)
,cte_max_speed as (
	select r.reindeer_name 
		,round(s.average_speed, 2) as max_speed
		,row_number() over (partition by s.reindeer_id order by s.average_speed desc) as rn
	from cte_speed as s
	inner join reindeers r on r.reindeer_id = s.reindeer_id 
	where r.reindeer_name != 'Rudolph'
)
select m.reindeer_name, m.max_speed
from cte_max_speed as m
where rn = 1
order by m.max_speed desc
limit 3
