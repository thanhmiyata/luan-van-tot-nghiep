select count(distinct state) from AREA_CODE_STATE	voter_1
select contestant_number, contestant_name from CONTESTANTS order by contestant_name desc	voter_1
select vote_id, phone_number, state from VOTES	voter_1
select min(area_code), max(area_code) from AREA_CODE_STATE	voter_1
select max(created) from VOTES where state = "CA"	voter_1
select contestant_name from CONTESTANTS where contestant_name != "Jessie Alloway"	voter_1
select distinct state, created from VOTES	voter_1
select c.contestant_number, c.contestant_name from CONTESTANTS c join VOTES v on c.contestant_number = v.contestant_number group by c.contestant_number, c.contestant_name having count(v.vote_id) >= 2	voter_1
select c.contestant_number, c.contestant_name from CONTESTANTS c join VOTES v on c.contestant_number = v.contestant_number group by c.contestant_number, c.contestant_name order by count(*) asc limit 1	voter_1
select count(*) from VOTES where state = "NY" or state = "CA"	voter_1
select count(*) from CONTESTANTS c where not EXISTS ( select 1 from VOTES v where v.contestant_number = c.contestant_number )	voter_1
select acs.area_code from AREA_CODE_STATE acs join VOTES v on acs.state = v.state group by acs.area_code order by count(distinct v.phone_number) desc limit 1	voter_1
select VOTES.created, VOTES.state, VOTES.phone_number from VOTES join CONTESTANTS on VOTES.contestant_number = CONTESTANTS.contestant_number where CONTESTANTS.contestant_name = "Tabatha Gehling"	voter_1
select distinct acs.area_code from AREA_CODE_STATE acs where acs.area_code in ( select CAST(SUBSTR(v1.phone_number, 1, 3)) from VOTES v1 join CONTESTANTS c1 on v1.contestant_number = c1.contestant_number where c1.contestant_name = "Tabatha Gehling" and v1.state = acs.state ) and acs.area_code in ( select CAST(SUBSTR(v2.phone_number, 1, 3)) from VOTES v2 join CONTESTANTS c2 on v2.contestant_number = c2.contestant_number where c2.contestant_name = "Kelly Clauss" and v2.state = acs.state )	voter_1
select contestant_name from CONTESTANTS where contestant_name like "%Al%"	voter_1
