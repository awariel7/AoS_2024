/*SOLVED*/
/*
Find the toy with the second highest percentile of requests. Submit the name of the toy and the percentile value.

If there are multiple values, choose the first occurrence.

Order by percentile descending, then gift name ascending.
*/
select g.gift_name
	,round(percent_rank() over (order by count(gr.request_id))::numeric, 2) as perc
from gifts g 
inner join gift_requests gr on gr.gift_id = g.gift_id
group by g.gift_name
order by perc desc, g.gift_name asc
