SELECT count(*) FROM area_code_state	voter_1
SELECT contestant_number ,  contestant_name FROM contestants ORDER BY contestant_name DESC	voter_1
SELECT vote_id ,  phone_number ,  state FROM votes	voter_1
SELECT max(area_code) ,  min(area_code) FROM area_code_state	voter_1
SELECT max(created) FROM votes WHERE state  =  'CA'	voter_1
SELECT contestant_name FROM contestants WHERE contestant_name != 'Jessie Alloway'	voter_1
SELECT DISTINCT state ,  created FROM votes	voter_1
SELECT T1.contestant_number , T1.contestant_name FROM contestants AS T1 JOIN votes AS T2 ON T1.contestant_number  =  T2.contestant_number GROUP BY T1.contestant_number HAVING count(*)  >=  2	voter_1
SELECT T1.contestant_number , T1.contestant_name FROM contestants AS T1 JOIN votes AS T2 ON T1.contestant_number  =  T2.contestant_number GROUP BY T1.contestant_number ORDER BY count(*) ASC LIMIT 1	voter_1
SELECT count(*) FROM votes WHERE state  =  'NY' OR state  =  'CA'	voter_1
SELECT count(*) FROM contestants WHERE contestant_number NOT IN ( SELECT contestant_number FROM votes )	voter_1
SELECT T1.area_code FROM area_code_state AS T1 JOIN votes AS T2 ON T1.state  =  T2.state GROUP BY T1.area_code ORDER BY count(*) DESC LIMIT 1	voter_1
SELECT T2.created ,  T2.state ,  T2.phone_number FROM contestants AS T1 JOIN votes AS T2 ON T1.contestant_number  =  T2.contestant_number WHERE T1.contestant_name  =  'Tabatha Gehling'	voter_1
SELECT T3.area_code FROM contestants AS T1 JOIN votes AS T2 ON T1.contestant_number  =  T2.contestant_number JOIN area_code_state AS T3 ON T2.state  =  T3.state WHERE T1.contestant_name  =  'Tabatha Gehling' INTERSECT SELECT T3.area_code FROM contestants AS T1 JOIN votes AS T2 ON T1.contestant_number  =  T2.contestant_number JOIN area_code_state AS T3 ON T2.state  =  T3.state WHERE T1.contestant_name  =  'Kelly Clauss'	voter_1
select contestant_name from contestants where contestant_name like "%al%"	voter_1
