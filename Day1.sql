/*
SOLVED
Create a report showing what gifts children want, with difficulty ratings and categorization.
The primary wish will be the first choice
The secondary wish will be the second choice
You can presume the favorite color is the first color in the wish list
Gift complexity can be mapped from the toy difficulty to make. Assume the following:
    Simple Gift = 1
    Moderate Gift = 2
    Complex Gift >= 3
We assign the workshop based on the primary wish's toy category. Assume the following:
  outdoor = Outside Workshop
  educational = Learning Workshop
  all other types = General Workshop
Order the list by name in ascending order.
Your answer should return only 5 rows
In the inputs below provide one row per input in the format, with no spaces and comma separation
*/
-- Get last wishlist for every kid (not in the task?)
-- Use child_id for partition, cause we have kids with the same name? like Abbey
with cte_kids_wl as (
	select c.child_id
		,wl.list_id
		,c."name"
		,wl.wishes ->> 'first_choice' as primary_wish
		,wl.wishes ->> 'second_choice' as backup_wish
		--primary colour
		,(wl.wishes -> 'colors') ->> 0 as favorite_color
		,json_array_length(wl.wishes -> 'colors') as color_count
		,wl.wishes
		,wl.submitted_date
		,rank() over (partition by c.child_id order by wl.submitted_date desc) as rn
	from wish_lists wl
	inner join children c on c.child_id  = wl.child_id 
)
select 
	c."name"
	,c.primary_wish
	,c.backup_wish
	,c.favorite_color
	,c.color_count
	,case 
		when tc.difficulty_to_make = 1 then 'Simple Gift'
		when tc.difficulty_to_make = 2 then 'Moderate Gift'
		else 'Complex Gift'
	end as gift_complexity
	,case 
		when tc.category = 'outdoor' then 'Outside Workshop'
		when tc.category = 'educational' then 'Learning Workshop'
		else 'General Workshop'
	end as workshop_assignment
	--,c.wishes
from cte_kids_wl as c
inner join toy_catalogue tc on tc.toy_name = c.primary_wish
--where c.rn = 1
order by c."name" asc
limit 5
