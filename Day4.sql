with cte_info as (
	select tp.toy_id 
		,tp.toy_name as toy_name 
		,tp.previous_tags
		,tp.new_tags
		,ARRAY(
	    	SELECT UNNEST(tp.previous_tags) EXCEPT SELECT UNNEST(tp.new_tags)
		) AS removed_tags
	  	,ARRAY(
		    SELECT UNNEST(tp.previous_tags) INTERSECT SELECT UNNEST(tp.new_tags)
		) AS unchanged_tags
		,ARRAY(
	    	SELECT UNNEST(tp.new_tags) EXCEPT SELECT UNNEST(tp.previous_tags)
	  	) AS added_tags
	from toy_production tp 
)
select c.toy_id
	,array_length(c.added_tags, 1) as added_tags_length
	,array_length(c.unchanged_tags, 1) as unchanged_tags_length
	,array_length(c.removed_tags, 1) as removed_tags_length
from cte_info as c
order by coalesce(array_length(c.added_tags, 1), 0) desc 
limit 1
