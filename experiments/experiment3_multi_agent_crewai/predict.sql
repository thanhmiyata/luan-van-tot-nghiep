SELECT name FROM station WHERE lat < 37.5;	bike_1
SELECT date, mean_temperature_f, mean_humidity FROM weather ORDER BY max_gust_speed_mph DESC LIMIT 3;	bike_1
SELECT T1.id, T1.name FROM station AS T1 JOIN status AS T2 ON T1.id = T2.station_id WHERE T2.bikes_available > 12;	bike_1
SELECT cloud_cover FROM weather WHERE zip_code = 94107 GROUP BY cloud_cover ORDER BY COUNT(*) DESC LIMIT 3;	bike_1
SELECT T1.name, T1.id FROM station AS T1 JOIN trip AS T2 ON T1.id = T2.start_station_id WHERE strftime('%m', T2.start_date) = '08' GROUP BY T2.start_station_id ORDER BY count(*) DESC LIMIT 1;	bike_1
SELECT name FROM station WHERE city = 'Palo Alto' EXCEPT SELECT end_station_name FROM trip;	bike_1
SELECT date FROM weather WHERE max_temperature_f > 85;	bike_1
SELECT start_station_name, end_station_name FROM trip ORDER BY id ASC LIMIT 3;	bike_1
SELECT count(*) FROM station WHERE city = 'Mountain View';	bike_1
SELECT date, zip_code FROM weather WHERE max_temperature_f = 80;	bike_1
SELECT count(*) FROM trip AS T1 JOIN station AS T2 ON T1.start_station_name = T2.name JOIN station AS T3 ON T1.end_station_name = T3.name WHERE T2.city = 'Mountain View' AND T3.city = 'Palo Alto';	bike_1
SELECT count(*) FROM weather WHERE mean_humidity > 50 AND mean_visibility_miles > 8;	bike_1
SELECT T1.id FROM station AS T1 JOIN status AS T2 ON T1.id = T2.station_id WHERE T1.city = 'San Francisco' GROUP BY T1.id HAVING avg(T2.bikes_available) > 10;	bike_1
SELECT avg(T2.bikes_available) FROM station AS T1 JOIN status AS T2 ON T1.id = T2.station_id WHERE T1.city != 'Palo Alto';	bike_1
SELECT T1.installation_date FROM station AS T1 JOIN trip AS T2 ON T1.id = T2.end_station_id;	bike_1
SELECT date FROM weather WHERE mean_sea_level_pressure_inches BETWEEN 30.3 AND 31;	bike_1
SELECT id FROM trip ORDER BY duration ASC LIMIT 1;	bike_1
SELECT zip_code FROM weather GROUP BY zip_code HAVING avg(mean_visibility_miles) < 10;	bike_1
SELECT COUNT(*) FROM weather WHERE mean_humidity > 50 AND mean_visibility_miles > 8;	bike_1
SELECT count(DISTINCT city) FROM station;	bike_1
SELECT zip_code FROM weather EXCEPT SELECT zip_code FROM weather WHERE max_dew_point_f >= 70;	bike_1
SELECT count(*) FROM trip WHERE end_station_name != 'San Francisco';	bike_1
SELECT id FROM trip WHERE start_station_id = (SELECT id FROM station ORDER BY dock_count DESC LIMIT 1);	bike_1
SELECT sum(duration), max(duration) FROM trip WHERE bike_id = 636;	bike_1
SELECT date, zip_code FROM weather WHERE min_dew_point_f < (SELECT min(min_dew_point_f) FROM weather WHERE zip_code = 94107);	bike_1
SELECT t.id FROM trip AS t JOIN station AS s ON t.start_station_id = s.id WHERE s.id = (SELECT id FROM station ORDER BY dock_count DESC LIMIT 1);	bike_1
SELECT id FROM trip ORDER BY duration ASC LIMIT 1;	bike_1
SELECT avg(mean_temperature_f), zip_code FROM weather WHERE date LIKE '%August%' GROUP BY zip_code;	bike_1
SELECT name, lat, city FROM station ORDER BY lat ASC LIMIT 1;	bike_1
SELECT count(*) FROM station WHERE city = 'Mountain View';	bike_1
SELECT city FROM station GROUP BY city ORDER BY MAX(lat) DESC;	bike_1
SELECT date, max_temperature_f - min_temperature_f AS temperature_range FROM weather WHERE max_temperature_f - min_temperature_f = (SELECT MIN(max_temperature_f - min_temperature_f) FROM weather);	bike_1
SELECT avg(T1.bikes_available) FROM status AS T1 JOIN station AS T2 ON T1.station_id = T2.id WHERE T2.city != 'Palo Alto';	bike_1
SELECT date, zip_code FROM weather WHERE min_dew_point_f < (SELECT min(min_dew_point_f) FROM weather WHERE zip_code = 94107);	bike_1
SELECT name, lat, city FROM station ORDER BY lat ASC LIMIT 1;	bike_1
SELECT zip_code, date FROM weather WHERE max_temperature_f >= 80;	bike_1
SELECT DISTINCT T1.name FROM station AS T1 JOIN status AS T2 ON T1.id = T2.station_id WHERE T2.bikes_available = 7;	bike_1
