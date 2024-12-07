/*NOT ACCEPTED*/
with cte_exp as (
	-- experience by skills
	select e.primary_skill
		,max(e.years_experience) as max_years
		,min(e.years_experience) as min_years
	from workshop_elves as e
	group by e.primary_skill
)
,cte_info as (
	select old.*
		,new.elf_id as new_id, new.elf_name as new_name, new.primary_skill as new_skill, new.years_experience as new_years	
		,row_number() over (partition by old.primary_skill order by old.elf_id, new.elf_id) as rn
	from workshop_elves as old
	inner join cte_exp as c on c.primary_skill = old.primary_skill
		and c.max_years = old.years_experience
	inner join workshop_elves as new on new.primary_skill = old.primary_skill
		and new.elf_id <> old.elf_id
		and new.years_experience < old.years_experience
	inner join cte_exp as c1 on c1.primary_skill = new.primary_skill
		and c1.min_years = new.years_experience
	order by old.primary_skill 
)
select c.elf_id
	,c.new_id
	,c.primary_skill as shared_skill
from cte_info as c
where c.rn = 1
limit 3
