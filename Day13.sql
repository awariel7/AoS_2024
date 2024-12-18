/*SOLVED
Create a list of all the domains that exist in the contacts list emails.

Submit the domain names with the most emails.
*/
with cte_total_mail as (
	select c.id 
		,c."name" 
		,unnest(c.email_addresses) as e_mail
	from contact_list as c
)
select substring(cm.e_mail from position('@' in cm.e_mail) + 1 ) as dmn
	,count(cm.ID) as c
from cte_total_mail as cm
group by substring(cm.e_mail from position('@' in cm.e_mail) + 1)
order by 2 desc
limit 1
