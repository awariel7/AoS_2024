-- SOLVED
with cte_avg_price as (
	select avg(g.price) as a_price
	from gifts g
)
select 
  c."name" as child_name
  ,g.*
	,p.a_price
from gifts g 
cross join cte_avg_price as p
inner join children_d6 as c on c.child_id = g.child_id 
	and g.price > p.a_price
order by g.price asc
limit 1
