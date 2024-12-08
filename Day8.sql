/*SOLVED*/
with recursive cte_emp_hirarchy as (
	select 
    s.staff_id
    ,s.staff_name
    ,s.manager_id
    ,ARRAY[staff_id] as managers_ids
	from staff as s 
	union all
	-- add more managers
	select 
    s.staff_id
    ,s.staff_name
    ,s.manager_id
    ,eh.managers_ids || s.staff_id as managers_ids -- add manager id to array
  from staff as s
  inner join cte_emp_hirarchy as eh on eh.manager_id = s.staff_id
)
select max(array_length(ceh.managers_ids, 1)) as max_len
from cte_emp_hirarchy as ceh 
where ceh.manager_id is null 
