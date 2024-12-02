/*
SOLVED
Combine info from 2 tables, but why the 1st table consists only of trash symbols?
We can use only 'letters_b'
*/
with cte_l as (
	select 
		case 
      -- regexp for valid symbols
			when CHR(la.value) ~ '^[A-Za-z !(),\-.:;?""'']+$' then CHR(la.value)
			else ''
		end as l
	from letters_a as la
	union all
	select 
		case 
      -- regexp for valid symbols
			when CHR(lb.value) ~ '^[A-Za-z !(),\-.:;?""'']+$' then CHR(lb.value)
			else ''
		end as l
	from letters_b as lb	
)
select 
  -- aggregate everything to the string
	string_agg(l.l , '')
from cte_l as l
where l.l <> ''
