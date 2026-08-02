SELECT count(*) FROM area_code_state	voter_1
select contestant_number, contestant_name from CONTESTANTS order by contestant_name desc	voter_1
select vote_id, phone_number, state from VOTES	voter_1
select max(area_code), min(area_code) from AREA_CODE_STATE	voter_1
SELECT max(created) FROM votes WHERE state  =  'CA'	voter_1
SELECT contestant_name FROM contestants WHERE contestant_name != 'Jessie Alloway'	voter_1
select distinct state, created from VOTES	voter_1
select T1.contestant_number, T1.contestant_name from CONTESTANTS as T1 join VOTES as T2 on T2.contestant_number = T1.contestant_number group by T1.contestant_number having count(*) >= 2	voter_1
SELECT T1.contestant_number , T1.contestant_name FROM contestants AS T1 JOIN votes AS T2 ON T1.contestant_number  =  T2.contestant_number GROUP BY T1.contestant_number ORDER BY count(*) ASC LIMIT 1	voter_1
SELECT count(*) FROM votes WHERE state  =  'NY' OR state  =  'CA'	voter_1
select count(*) from CONTESTANTS where contestant_number not in (select contestant_number from VOTES)	voter_1
select T1.area_code from AREA_CODE_STATE as T1 join VOTES as T2 on T1.state = T2.state group by T1.area_code order by count(*) desc limit 1	voter_1
SELECT T2.created ,  T2.state ,  T2.phone_number FROM contestants AS T1 JOIN votes AS T2 ON T1.contestant_number  =  T2.contestant_number WHERE T1.contestant_name  =  'Tabatha Gehling'	voter_1
select distinct A.area_code from VOTES V join CONTESTANTS C on V.contestant_number = C.contestant_number join AREA_CODE_STATE A on V.state = A.state where C.contestant_name = "Tabatha Gehling" intersect select distinct A.area_code from VOTES V join CONTESTANTS C on V.contestant_number = C.contestant_number join AREA_CODE_STATE A on V.state = A.state where C.contestant_name = "Kelly Clauss"	voter_1
select contestant_name from CONTESTANTS where contestant_name like "%Al%"	voter_1
