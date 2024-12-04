-- Get info for 3 different types of XML files
with cte_menus as (
	SELECT cm.*
	    ,(xpath('/polar_celebration/event_administration/participant_metrics/attendance_details/headcount/total_present/text()', cm.menu_data))[1]::text as guests_count1
		,(xpath('/christmas_feast/organizational_details/attendance_record/total_guests/text()', cm.menu_data))[1]::text as guests_count2
		,(xpath('/northpole_database/annual_celebration/event_metadata/dinner_details/guest_registry/total_count/text()', cm.menu_data))[1]::text as guests_count3
	FROM christmas_menus cm
)
-- Filter menus for guests amount over 78 persons
,cte_filtered_menus as (
	select cm.id
		,cm.menu_data
		,coalesce(cm.guests_count1, cm.guests_count2, cm.guests_count3) as Guests
	from cte_menus cm  
	-- comparison will be correct for strings
	where coalesce(cm.guests_count1, cm.guests_count2, cm.guests_count3) > '78'
)
-- Get and Unnest food_item arrays
,cte_food as (
	select fm.*
		,unnest(xpath('/christmas_feast/organizational_details/menu_registry/course_details/dish_entry/food_item_id/text()', fm.menu_data)::TEXT[]) AS f_food_item_id
		,unnest(xpath('/northpole_database/annual_celebration/event_metadata/menu_items/food_category/food_category/dish/food_item_id/text()', fm.menu_data)::TEXT[]) AS f_food_item_id2
	from cte_filtered_menus as fm
)
-- Calculate the most popular food_item
select coalesce(f.f_food_item_id, f.f_food_item_id2) as food_item_id
	,count(coalesce(f.f_food_item_id, f.f_food_item_id2)) as food_item_id_count
from cte_food as f
group by coalesce(f.f_food_item_id, f.f_food_item_id2)
order by food_item_id_count desc
limit 1
