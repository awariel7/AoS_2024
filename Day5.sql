/*
SOLVED
--Possible Solution n 1
select c.production_date
	,c.toys_produced
	,cc.toys_produced as previous_day_production
	-- prev - current
	,c.toys_produced - cc.toys_produced as production_change
	-- production_change/prev
	,round(((c.toys_produced - cc.toys_produced)/cc.toys_produced::numeric) * 100, 2) as production_change_percentage
from toy_production_d5 as c
inner join toy_production_d5 as cc on c.production_date - cc.production_date = 1 
order by round(((c.toys_produced - cc.toys_produced)/cc.toys_produced::numeric) * 100, 2) desc 
limit 1
*/
--Possible Solution n 2
with cte_c as (
	select c.production_date
		,c.toys_produced
		,coalesce(lag(c.toys_produced) over (order by c.production_date), 0) as previous_day_production
	from toy_production_d5 as c
)
select c.production_date
	,c.toys_produced
	,c.previous_day_production
	,c.toys_produced - c.previous_day_production as production_change
	,case 
		when c.previous_day_production = 0 then 0
		else ((c.toys_produced - c.previous_day_production)/ c.previous_day_production::numeric) * 100
	end as production_change_percentage
from cte_c as c 
order by case 
			when c.previous_day_production = 0 then 0
			else ((c.toys_produced - c.previous_day_production)/ c.previous_day_production::numeric) * 100
		end desc
limit 1

