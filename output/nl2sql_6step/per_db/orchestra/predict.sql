select count(*) from conductor	orchestra
select count(*) from conductor	orchestra
select Name from conductor order by Age asc	orchestra
select Name from conductor order by Age asc	orchestra
SELECT Name FROM conductor WHERE Nationality != 'USA'	orchestra
SELECT Name FROM conductor WHERE Nationality != 'USA'	orchestra
select Record_Company from orchestra order by Year_of_Founded desc	orchestra
select Record_Company from orchestra order by Year_of_Founded desc	orchestra
select avg(Attendance) from show	orchestra
select avg(Attendance) from show	orchestra
SELECT max(SHARE) ,  min(SHARE) FROM performance WHERE TYPE != "Live final"	orchestra
SELECT max(SHARE) ,  min(SHARE) FROM performance WHERE TYPE != "Live final"	orchestra
select count(distinct Nationality) from conductor	orchestra
select count(distinct Nationality) from conductor	orchestra
select Name from conductor order by Year_of_Work desc	orchestra
select Name from conductor order by Year_of_Work desc	orchestra
select Name from conductor order by Year_of_Work desc limit 1	orchestra
select Name from conductor order by Year_of_Work desc limit 1	orchestra
select T1.Name, T2.Orchestra from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID	orchestra
select T1.Name, T2.Orchestra from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID	orchestra
SELECT T1.Name FROM conductor AS T1 JOIN orchestra AS T2 ON T1.Conductor_ID  =  T2.Conductor_ID GROUP BY T2.Conductor_ID HAVING COUNT(*)  >  1	orchestra
select T1.Name from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID group by T1.Conductor_ID having count(*) > 1	orchestra
select c.Name from conductor as c join orchestra as o on c.Conductor_ID = o.Conductor_ID group by c.Name order by count(*) desc limit 1	orchestra
select conductor.Name from conductor join orchestra on conductor.Conductor_ID = orchestra.Conductor_ID group by conductor.Conductor_ID order by count(*) desc limit 1	orchestra
select T1.Name from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID where T2.Year_of_Founded > 2008	orchestra
select conductor.Name from conductor join orchestra on conductor.Conductor_ID = orchestra.Conductor_ID where orchestra.Year_of_Founded > 2008	orchestra
select Record_Company, count(*) from orchestra group by Record_Company	orchestra
SELECT Record_Company ,  COUNT(*) FROM orchestra GROUP BY Record_Company	orchestra
select Major_Record_Format from orchestra group by Major_Record_Format order by count(*) asc	orchestra
select Major_Record_Format, count(*) from orchestra group by Major_Record_Format order by frequency desc	orchestra
select Record_Company from orchestra group by Record_Company order by count(*) desc limit 1	orchestra
select Record_Company from orchestra group by Record_Company order by count(*) desc limit 1	orchestra
select orchestra.Orchestra from orchestra left join performance on orchestra.Orchestra_ID = performance.Orchestra_ID where performance.Orchestra_ID is null	orchestra
select o.Orchestra from orchestra as o left join performance as p on o.Orchestra_ID = p.Orchestra_ID where p.Performance_ID is null	orchestra
select Record_Company from orchestra where Year_of_Founded < 2003 intersect select Record_Company from orchestra where Year_of_Founded > 2003	orchestra
select Record_Company from orchestra where Year_of_Founded < 2003 intersect select Record_Company from orchestra where Year_of_Founded > 2003	orchestra
SELECT COUNT(*) FROM orchestra WHERE Major_Record_Format  =  "CD" OR Major_Record_Format  =  "DVD"	orchestra
SELECT COUNT(*) FROM orchestra WHERE Major_Record_Format  =  "CD" OR Major_Record_Format  =  "DVD"	orchestra
select distinct T1.Year_of_Founded from orchestra as T1 join (select Orchestra_ID from performance group by Orchestra_ID having count(Performance_ID) > 1) on T1.Orchestra_ID = T2.Orchestra_ID	orchestra
select distinct T1.Year_of_Founded from orchestra as T1 join (select Orchestra_ID from performance group by Orchestra_ID having count(*) > 1) on T1.Orchestra_ID = T2.Orchestra_ID	orchestra
