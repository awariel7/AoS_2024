/*CREATE EXTENSION IF NOT EXISTS postgis;
SELECT PostGIS_Version();
*/

/*SOLVED
Using the list of areas you need to find which city the last sleigh_location is located in.
Submit the city name only.
*/

select a.place_name
from areas as a
inner join sleigh_locations as sl on ST_DWithin(sl.coordinate::geography, a.polygon::geography, 0);
