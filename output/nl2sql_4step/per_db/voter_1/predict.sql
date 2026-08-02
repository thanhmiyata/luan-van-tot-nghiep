select count(distinct state) from AREA_CODE_STATE	voter_1
select contestant_number, contestant_name from CONTESTANTS order by contestant_name desc	voter_1
select vote_id, phone_number, state from VOTES	voter_1
select max(area_code), min(area_code) from AREA_CODE_STATE	voter_1
select max(created) from VOTES where state = "CA"	voter_1
select contestant_name from CONTESTANTS where contestant_name <> "Jessie Alloway"	voter_1
select distinct state, created from VOTES	voter_1
select CONTESTANTS.contestant_number, CONTESTANTS.contestant_name from CONTESTANTS join VOTES on CONTESTANTS.contestant_number = VOTES.contestant_number group by CONTESTANTS.contestant_number, CONTESTANTS.contestant_name having count(*) >= 2	voter_1
select c.contestant_number, c.contestant_name from CONTESTANTS as c join VOTES as v on c.contestant_number = v.contestant_number group by c.contestant_number, c.contestant_name order by count(*) asc limit 1	voter_1
select count(vote_id) from VOTES where state in ("NY", "CA")	voter_1
select count(*) from CONTESTANTS left join VOTES on CONTESTANTS.contestant_number = VOTES.contestant_number where VOTES.contestant_number is null	voter_1
select area_code from AREA_CODE_STATE join VOTES on AREA_CODE_STATE.state = VOTES.state group by area_code order by count(*) desc limit 1	voter_1
select VOTES.created, VOTES.state, VOTES.phone_number from VOTES join CONTESTANTS on VOTES.contestant_number = CONTESTANTS.contestant_number where CONTESTANTS.contestant_name = "Tabatha Gehling"	voter_1
select area_code from AREA_CODE_STATE join VOTES on AREA_CODE_STATE.state = VOTES.state join CONTESTANTS on VOTES.contestant_number = CONTESTANTS.contestant_number where CONTESTANTS.contestant_name = "Tabatha Gehling" intersect select area_code from AREA_CODE_STATE join VOTES on AREA_CODE_STATE.state = VOTES.state join CONTESTANTS on VOTES.contestant_number = CONTESTANTS.contestant_number where CONTESTANTS.contestant_name = "Kelly Clauss"	voter_1
select contestant_name from CONTESTANTS where contestant_name like "%Al%"	voter_1
