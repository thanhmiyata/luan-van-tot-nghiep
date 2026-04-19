select count(*) from visitor where Age < 30	museum_visit
select Name from visitor where Level_of_membership > 4 order by Level_of_membership desc	museum_visit
select avg(Age) from visitor where Level_of_membership <= 4	museum_visit
select Name , Level_of_membership from visitor where Level_of_membership > 4 order by Age desc	museum_visit
select Museum_ID, Name from museum order by Num_of_Staff desc limit 1	museum_visit
select avg(Num_of_Staff) from museum where Open_Year < "2009"	museum_visit
select Open_Year, Num_of_Staff from museum where Name = "Plaza Museum"	museum_visit
select Name from museum where Num_of_Staff > (select min(Num_of_Staff) from museum where Open_Year > "2010")	museum_visit
select T1.ID, T1.Name, T1.Age from visitor as T1 where T1.ID in ( select T2.visitor_ID from visit as T2 group by T2.visitor_ID, T2.Museum_ID having count(*) > 1 )	museum_visit
select T1.ID, T1.Name, T1.Level_of_membership from visitor as T1 inner join visit as T2 on T1.ID = T2.visitor_ID group by T1.ID having sum(T2.Total_spent) = ( select max(TotalSpent) from ( select sum(Total_spent) from visit group by visitor_ID ) )	museum_visit
select T1.Museum_ID, T1.Name from museum as T1 join visit as T2 on T1.Museum_ID = T2.Museum_ID group by T1.Museum_ID order by count(T2.Museum_ID) desc limit 1	museum_visit
select Name from museum except select T1.Name from museum as T1 join visit as T2 on T1.Museum_ID = T2.Museum_ID	museum_visit
select T1.Name, T1.Age from visitor as T1 inner join visit as T2 on T1.ID = T2.visitor_ID order by T2.Num_of_Ticket desc limit 1	museum_visit
select avg(Num_of_Ticket), max(Num_of_Ticket) from visit	museum_visit
select sum(T1.Total_spent) from visit as T1 inner join visitor as T2 on T1.visitor_ID = T2.ID where T2.Level_of_membership = 1	museum_visit
select T3.Name from visitor as T3 where T3.ID in ( select T1.visitor_ID from visit as T1 inner join museum as T2 on T1.Museum_ID = T2.Museum_ID where T2.Open_Year < "2009" intersect select T1.visitor_ID from visit as T1 inner join museum as T2 on T1.Museum_ID = T2.Museum_ID where T2.Open_Year > "2011" )	museum_visit
select count(ID) from visitor where ID not in ( select T1.visitor_ID from visit as T1 join museum as T2 on T1.Museum_ID = T2.Museum_ID where T2.Open_Year > "2010" )	museum_visit
select count(*) from museum where Open_Year > "2013" or Open_Year < "2008"	museum_visit
