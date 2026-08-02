SELECT COUNT(*) FROM visitor WHERE Age < 30
SELECT Name FROM visitor WHERE Level_of_membership > 4 ORDER BY Level_of_membership DESC
SELECT AVG(Age) AS average_age FROM visitor WHERE Level_of_membership <= 4
SELECT Name, Level_of_membership FROM visitor WHERE Level_of_membership > 4 ORDER BY Age DESC
SELECT Museum_ID, Name FROM museum ORDER BY Num_of_Staff DESC LIMIT 1
SELECT AVG(Num_of_Staff) FROM museum WHERE Open_Year < 2009
SELECT Open_Year, Num_of_Staff FROM museum WHERE Name = 'Plaza Museum'
SELECT Name FROM museum WHERE Num_of_Staff > (SELECT MIN(Num_of_Staff) FROM museum WHERE Open_Year > 2010)
SELECT visitor.ID, visitor.Name, visitor.Age FROM visitor JOIN visit ON visitor.ID = visit.visitor_ID GROUP BY visit.visitor_ID, visitor.ID, visitor.Name, visitor.Age HAVING COUNT(*) > 1
SELECT visitor.ID, visitor.Name, visitor.Level_of_membership FROM visitor JOIN visit ON visitor.ID = visit.visitor_ID GROUP BY visitor.ID, visitor.Name, visitor.Level_of_membership ORDER BY SUM(visit.Total_spent) DESC LIMIT 1
SELECT museum.Museum_ID, museum.Name FROM museum JOIN visit ON museum.Museum_ID = visit.Museum_ID GROUP BY museum.Museum_ID, museum.Name ORDER BY COUNT(*) DESC LIMIT 1
SELECT Name FROM museum WHERE NOT Museum_ID IN (SELECT Museum_ID FROM visit)
SELECT visitor.Name, visitor.Age FROM visit JOIN visitor ON visit.visitor_ID = visitor.ID ORDER BY visit.Num_of_Ticket DESC LIMIT 1
SELECT AVG(Num_of_Ticket) AS average_num_of_ticket, MAX(Num_of_Ticket) AS maximum_num_of_ticket FROM visit
SELECT SUM(visit.Total_spent) AS SUM_Total_spent FROM visit JOIN visitor ON visit.visitor_ID = visitor.ID WHERE visitor.Level_of_membership = 1
SELECT DISTINCT visitor.Name FROM visitor INNER JOIN visit ON visitor.ID = visit.visitor_ID INNER JOIN museum ON visit.Museum_ID = museum.Museum_ID WHERE museum.Open_Year < 2009 INTERSECT SELECT DISTINCT visitor.Name FROM visitor INNER JOIN visit ON visitor.ID = visit.visitor_ID INNER JOIN museum ON visit.Museum_ID = museum.Museum_ID WHERE museum.Open_Year > 2011
SELECT COUNT(visitor.ID) FROM visitor WHERE NOT visitor.ID IN (SELECT DISTINCT visit.visitor_ID FROM visit JOIN museum ON visit.Museum_ID = museum.Museum_ID WHERE museum.Open_Year > 2010)
SELECT COUNT(*) FROM museum WHERE Open_Year > 2013 OR Open_Year < 2008
