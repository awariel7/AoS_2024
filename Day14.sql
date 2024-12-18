/*SOLVED
Mrs. Claus needs to find the receipt for Santa's green suit that was dry cleaned.

She needs to know when it was dropped off, so submit the drop off date.

Order by the latest drop off date
*/
with cte_total_res as (
	select c.record_id
		,c.record_date
		,jsonb_array_elements(c.cleaning_receipts) as receipt
	from SantaRecords as c
)
select c.record_id
	,c.record_date
	,c.receipt ->> 'color' as costume_color
	,c.receipt ->> 'drop_off' as drop_off_date
from cte_total_res as c
where c.receipt ->> 'color' = 'green'
	and c.receipt ->> 'garment' = 'suit'
order by 4 desc
limit 1
