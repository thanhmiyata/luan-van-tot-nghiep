select count(*) from conductor	orchestra
select count(*) from conductor	orchestra
select Name from conductor order by Age asc	orchestra
select Name from conductor order by Age	orchestra
select Name from conductor where Nationality != "USA"	orchestra
select Name from conductor where Nationality != "USA"	orchestra
select Record_Company from orchestra order by Year_of_Founded desc	orchestra
select Record_Company from orchestra order by Year_of_Founded desc	orchestra
select avg(Attendance) from show	orchestra
select avg(Attendance) from show	orchestra
select max(Share), min(Share) from performance where Type != "Live final"	orchestra
select max(Share), min(Share) from performance where Type != "Live final"	orchestra
select count(distinct Nationality) from conductor	orchestra
select count(distinct Nationality) from conductor	orchestra
select Name from conductor order by Year_of_Work desc	orchestra
select Name from conductor order by Year_of_Work desc	orchestra
select Name from conductor order by Year_of_Work desc limit 1	orchestra
select Name from conductor order by Year_of_Work desc limit 1	orchestra
select T1.Name, T2.Orchestra from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID	orchestra
select T1.Name, T2.Orchestra from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID	orchestra
select T1.Name from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID group by T1.Conductor_ID having count(T2.Orchestra_ID) > 1	orchestra
select T1.Name from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID group by T1.Conductor_ID having count(T2.Orchestra_ID) > 1	orchestra
select T1.Name from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID group by T1.Conductor_ID order by count(T2.Orchestra_ID) desc limit 1	orchestra
select T1.Name from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID group by T1.Conductor_ID order by count(T2.Orchestra_ID) desc limit 1	orchestra
select T1.Name from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID where T2.Year_of_Founded > 2008	orchestra
select T1.Name from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID where T2.Year_of_Founded > 2008	orchestra
select Record_Company, count(Orchestra_ID) from orchestra group by Record_Company	orchestra
select Record_Company, count(Orchestra_ID) from orchestra group by Record_Company	orchestra
select Major_Record_Format from orchestra group by Major_Record_Format order by count(Major_Record_Format) asc	orchestra
select Major_Record_Format from orchestra group by Major_Record_Format order by count(*) desc	orchestra
select Record_Company from orchestra group by Record_Company order by count(Orchestra_ID) desc limit 1	orchestra
select Record_Company from orchestra group by Record_Company order by count(Orchestra_ID) desc limit 1	orchestra
select Orchestra from orchestra except select T1.Orchestra from orchestra as T1 join performance as T2 on T1.Orchestra_ID = T2.Orchestra_ID	orchestra
select Orchestra from orchestra except select T1.Orchestra from orchestra as T1 join performance as T2 on T1.Orchestra_ID = T2.Orchestra_ID	orchestra
select Record_Company from orchestra where Year_of_Founded < 2003 intersect select Record_Company from orchestra where Year_of_Founded > 2003	orchestra
select Record_Company from orchestra where Year_of_Founded < 2003 intersect select Record_Company from orchestra where Year_of_Founded > 2003	orchestra
select count(*) from orchestra where Major_Record_Format = "CD" or Major_Record_Format = "DVD"	orchestra
select count(*) from orchestra where Major_Record_Format = "CD" or Major_Record_Format = "DVD"	orchestra
select T1.Year_of_Founded from orchestra as T1 join performance as T2 on T1.Orchestra_ID = T2.Orchestra_ID group by T1.Orchestra_ID having count(T2.Performance_ID) > 1	orchestra
select T1.Year_of_Founded from orchestra as T1 join performance as T2 on T1.Orchestra_ID = T2.Orchestra_ID group by T1.Orchestra_ID having count(T2.Performance_ID) > 1	orchestra
