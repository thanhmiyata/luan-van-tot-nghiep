select count(*) from visitor where Age < 30	museum_visit
select Name from visitor where Level_of_membership > 4 order by Level_of_membership desc	museum_visit
select avg(Age) from visitor where Level_of_membership <= 4	museum_visit
select Name, Level_of_membership from visitor where Level_of_membership > 4 order by Age desc	museum_visit
select Museum_ID, Name from museum order by Num_of_Staff desc limit 1	museum_visit
select avg(Num_of_Staff) from museum where Open_Year < 2009	museum_visit
select Open_Year, Num_of_Staff from museum where Name = "Plaza Museum"	museum_visit
select Name from museum where Num_of_Staff > (select min(Num_of_Staff) from museum where Open_Year > 2010)	museum_visit
SELECT t1.id ,  t1.name ,  t1.age FROM visitor AS t1 JOIN visit AS t2 ON t1.id  =  t2.visitor_id GROUP BY t1.id HAVING count(*)  >  1	museum_visit
select T1.ID, T1.Name, T1.Level_of_membership from visitor as T1 join visit as T2 on T1.ID = T2.visitor_ID group by T1.ID order by sum(T2.Total_spent) desc limit 1	museum_visit
SELECT t2.Museum_ID ,  t1.name FROM museum AS t1 JOIN visit AS t2 ON t1.Museum_ID  =  t2.Museum_ID GROUP BY t2.Museum_ID ORDER BY count(*) DESC LIMIT 1	museum_visit
select museum.Name from museum left join visit on museum.Museum_ID = visit.Museum_ID where visit.Museum_ID is null	museum_visit
select visitor.Name, visitor.Age from visitor join visit on visitor.ID = visit.visitor_ID order by visit.Num_of_Ticket desc limit 1	museum_visit
select avg(Num_of_Ticket), max(Num_of_Ticket) from visit	museum_visit
select sum(visit.Total_spent) from visit join visitor on visit.visitor_ID = visitor.ID where visitor.Level_of_membership = 1	museum_visit
select visitor.Name from museum join visit on visit.Museum_ID = museum.Museum_ID join visitor on visit.visitor_ID = visitor.ID where museum.Open_Year < 2009 intersect select visitor.Name from museum join visit on visit.Museum_ID = museum.Museum_ID join visitor on visit.visitor_ID = visitor.ID where museum.Open_Year > 2011	museum_visit
select count(*) from (select distinct T1.visitor_ID from visit as T1 join museum as T2 on T1.Museum_ID = T2.Museum_ID where T2.Open_Year <= 2010 except select distinct T1.visitor_ID from visit as T1 join museum as T2 on T1.Museum_ID = T2.Museum_ID where T2.Open_Year > 2010)	museum_visit
select count(*) from museum where Open_Year > 2013 or Open_Year < 2008	museum_visit
