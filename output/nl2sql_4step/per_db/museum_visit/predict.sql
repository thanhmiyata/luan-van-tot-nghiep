select count(*) from visitor where Age < 30	museum_visit
select Name from visitor where Level_of_membership > 4 order by Level_of_membership desc	museum_visit
select avg(Age) from visitor where Level_of_membership <= 4	museum_visit
select Name, Level_of_membership from visitor where Level_of_membership > 4 order by Age desc	museum_visit
select Museum_ID, Name from museum order by Num_of_Staff desc limit 1	museum_visit
select avg(Num_of_Staff) from museum where Open_Year < 2009	museum_visit
select Open_Year, Num_of_Staff from museum where Name = "Plaza Museum"	museum_visit
select Name from museum where Num_of_Staff > (select min(Num_of_Staff) from museum where Open_Year > 2010)	museum_visit
select visitor.ID, visitor.Name, visitor.Age from visitor join visit on visitor.ID = visit.visitor_ID group by visit.visitor_ID, visitor.ID, visitor.Name, visitor.Age having count(*) > 1	museum_visit
select visitor.ID, visitor.Name, visitor.Level_of_membership from visitor join visit on visitor.ID = visit.visitor_ID group by visitor.ID, visitor.Name, visitor.Level_of_membership order by sum(visit.Total_spent) desc limit 1	museum_visit
select museum.Museum_ID, museum.Name from museum join visit on museum.Museum_ID = visit.Museum_ID group by museum.Museum_ID, museum.Name order by sum(visit.Num_of_Ticket) desc limit 1	museum_visit
select Name from museum where Museum_ID not in (select Museum_ID from visit)	museum_visit
select visitor.Name, visitor.Age from visit join visitor on visit.visitor_ID = visitor.ID order by visit.Num_of_Ticket desc limit 1	museum_visit
select avg(Num_of_Ticket), max(Num_of_Ticket) from visit	museum_visit
select sum(visit.Total_spent) from visit join visitor on visit.visitor_ID = visitor.ID where visitor.Level_of_membership = 1	museum_visit
select T1.Name from visitor as T1 join visit as T2 on T1.ID = T2.visitor_ID join museum as T3 on T2.Museum_ID = T3.Museum_ID where T3.Open_Year < 2009 intersect select T1.Name from visitor as T1 join visit as T2 on T1.ID = T2.visitor_ID join museum as T3 on T2.Museum_ID = T3.Museum_ID where T3.Open_Year > 2011	museum_visit
select count(visitor.ID) from visitor where visitor.ID not in (select distinct visit.visitor_ID from visit join museum on visit.Museum_ID = museum.Museum_ID where museum.Open_Year > 2010)	museum_visit
select count(*) from museum where Open_Year > 2013 or Open_Year < 2008	museum_visit
