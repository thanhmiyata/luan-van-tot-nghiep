select count(state) from AREA_CODE_STATE	voter_1
select contestant_number, contestant_name from CONTESTANTS order by contestant_name desc	voter_1
select vote_id, phone_number, state from VOTES	voter_1
select max(area_code), min(area_code) from AREA_CODE_STATE	voter_1
select max(created) from VOTES where state = "CA"	voter_1
select contestant_name from CONTESTANTS where contestant_name != "Jessie Alloway"	voter_1
select distinct state, created from VOTES	voter_1
select T1.contestant_number, T1.contestant_name from CONTESTANTS as T1 join VOTES as T2 on T1.contestant_number = T2.contestant_number group by T1.contestant_number having count(T2.vote_id) >= 2	voter_1
select T1.contestant_number, T1.contestant_name from CONTESTANTS as T1 join VOTES as T2 on T1.contestant_number = T2.contestant_number group by T1.contestant_number order by count(T2.vote_id) asc limit 1	voter_1
select count(*) from VOTES where state = "NY" or state = "CA"	voter_1
select count(*) from CONTESTANTS except select T1.contestant_number from CONTESTANTS as T1 join VOTES as T2 on T1.contestant_number = T2.contestant_number	voter_1
select T1.area_code from AREA_CODE_STATE as T1 join VOTES as T2 on T1.state = T2.state group by T1.area_code order by count(T2.vote_id) desc limit 1	voter_1
select T1.created, T1.state, T1.phone_number from VOTES as T1 inner join CONTESTANTS as T2 on T1.contestant_number = T2.contestant_number where T2.contestant_name = "Tabatha Gehling"	voter_1
select distinct T3.area_code from VOTES as T1 inner join CONTESTANTS as T2 on T1.contestant_number = T2.contestant_number inner join AREA_CODE_STATE as T3 on T1.state = T3.state where T2.contestant_name = "Tabatha Gehling" intersect select distinct T3.area_code from VOTES as T1 inner join CONTESTANTS as T2 on T1.contestant_number = T2.contestant_number inner join AREA_CODE_STATE as T3 on T1.state = T3.state where T2.contestant_name = "Kelly Clauss"	voter_1
select contestant_name from CONTESTANTS where contestant_name like "%Al%"	voter_1
