select count(*) from conductor	orchestra
select count(*) from conductor	orchestra
select Name from conductor order by Age asc	orchestra
select Name from conductor order by Age asc	orchestra
select Name from conductor where Nationality <> "USA"	orchestra
select Name from conductor where Nationality <> "USA"	orchestra
select Record_Company, Year_of_Founded from orchestra order by Year_of_Founded desc	orchestra
select Record_Company from orchestra order by Year_of_Founded desc	orchestra
select avg(Attendance) from show	orchestra
select avg(Attendance) from show	orchestra
select max(Share), min(Share) from performance where Type <> "Live final"	orchestra
select max(Share), min(Share) from performance where Type <> "Live final"	orchestra
select count(distinct Nationality) from conductor	orchestra
select count(distinct Nationality) from conductor	orchestra
select Name, Year_of_Work from conductor order by Year_of_Work desc	orchestra
select Name from conductor order by Year_of_Work desc	orchestra
select Name from conductor order by Year_of_Work desc limit 1	orchestra
select Name from conductor order by Year_of_Work desc limit 1	orchestra
select conductor.Name, orchestra.Orchestra from conductor join orchestra on conductor.Conductor_ID = orchestra.Conductor_ID	orchestra
select T1.Name, T2.Orchestra from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID	orchestra
select Name from conductor where Conductor_ID in (select Conductor_ID from orchestra group by Conductor_ID having count(distinct Orchestra_ID) > 1)	orchestra
select Name from conductor where Conductor_ID in (select Conductor_ID from orchestra group by Conductor_ID having count(distinct Orchestra_ID) > 1)	orchestra
select T1.Name from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID group by T1.Conductor_ID order by count(T2.Orchestra_ID) desc limit 1	orchestra
select Name from conductor where Conductor_ID = (select Conductor_ID from orchestra group by Conductor_ID order by count(Orchestra_ID) desc limit 1)	orchestra
select conductor.Name from conductor join orchestra on conductor.Conductor_ID = orchestra.Conductor_ID where orchestra.Year_of_Founded > 2008	orchestra
select Name from conductor join orchestra on conductor.Conductor_ID = orchestra.Conductor_ID where Year_of_Founded > 2008	orchestra
select Record_Company, count(distinct Orchestra) from orchestra group by Record_Company	orchestra
select Record_Company, count(Orchestra_ID) from orchestra group by Record_Company	orchestra
select Major_Record_Format, count(*) from orchestra group by Major_Record_Format order by count(*) asc	orchestra
select Major_Record_Format, count(*) from orchestra group by Major_Record_Format order by frequency desc	orchestra
select Record_Company from orchestra group by Record_Company order by count(Orchestra_ID) desc limit 1	orchestra
select Record_Company from orchestra group by Record_Company order by count(*) desc limit 1	orchestra
select Orchestra from orchestra where Orchestra_ID not in (select Orchestra_ID from performance)	orchestra
select Orchestra from orchestra where Orchestra_ID not in (select Orchestra_ID from performance)	orchestra
select Record_Company from orchestra where Year_of_Founded < 2003 intersect select Record_Company from orchestra where Year_of_Founded > 2003	orchestra
select Record_Company from orchestra where Year_of_Founded < 2003 intersect select Record_Company from orchestra where Year_of_Founded > 2003	orchestra
select count(*) from orchestra where Major_Record_Format = "CD" or Major_Record_Format = "DVD"	orchestra
select count(*) from orchestra where Major_Record_Format = "CD" or Major_Record_Format = "DVD"	orchestra
select Year_of_Founded from orchestra where Orchestra_ID in (select Orchestra_ID from performance group by Orchestra_ID having count(*) > 1)	orchestra
select Year_of_Founded from orchestra where Orchestra_ID in (select Orchestra_ID from performance group by Orchestra_ID having count(*) > 1)	orchestra
