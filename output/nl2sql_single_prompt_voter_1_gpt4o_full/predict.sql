select count(distinct state) from AREA_CODE_STATE	voter_1
select contestant_number, contestant_name from CONTESTANTS order by contestant_name desc	voter_1
select vote_id, phone_number, state from VOTES	voter_1
select max(area_code), min(area_code) from AREA_CODE_STATE	voter_1
select max(DATE(created)) from VOTES where state = "CA"	voter_1
select contestant_name from CONTESTANTS where contestant_name != "Jessie Alloway"	voter_1
select distinct state, created from VOTES	voter_1
select c.contestant_number, c.contestant_name from CONTESTANTS c where c.contestant_number in ( select v.contestant_number from VOTES v group by v.contestant_number having count(v.vote_id) >= 2 )	voter_1
select c.contestant_number, c.contestant_name from CONTESTANTS c join VOTES v on c.contestant_number = v.contestant_number group by c.contestant_number, c.contestant_name order by count(v.vote_id) asc limit 1	voter_1
select count(*) from VOTES where state in ("NY", "CA")	voter_1
select count(*) from CONTESTANTS where contestant_number not in (select distinct contestant_number from VOTES)	voter_1
select SUBSTR(phone_number, 1, 3), count(*) from VOTES group by area_code order by vote_count desc limit 1	voter_1
select VOTES.created, VOTES.state, VOTES.phone_number from VOTES join CONTESTANTS on VOTES.contestant_number = CONTESTANTS.contestant_number where CONTESTANTS.contestant_name = "Tabatha Gehling"	voter_1
select distinct acs.area_code from AREA_CODE_STATE acs join VOTES v1 on acs.state = v1.state join VOTES v2 on acs.state = v2.state join CONTESTANTS c1 on v1.contestant_number = c1.contestant_number join CONTESTANTS c2 on v2.contestant_number = c2.contestant_number where c1.contestant_name = "Tabatha Gehling" and c2.contestant_name = "Kelly Clauss" and v1.phone_number = v2.phone_number	voter_1
select contestant_name from CONTESTANTS where contestant_name like "%Al%"	voter_1
