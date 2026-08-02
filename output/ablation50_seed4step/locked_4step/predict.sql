SELECT COUNT(*) FROM poker_player
SELECT Abbreviation FROM airlines WHERE Airline = 'JetBlue Airways'
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT AVG(LifeExpectancy) FROM country WHERE Region = 'Central Africa'
SELECT DISTINCT Template_Type_Code FROM Ref_Template_Types
SELECT COUNT(*) AS COUNT_Documents FROM Documents
SELECT SUM(Bonus) FROM evaluation
SELECT COUNT(*) AS number_of_flights FROM flights
SELECT Continent FROM country WHERE Name = 'Anguilla'
SELECT Country FROM airlines WHERE Airline = 'JetBlue Airways'
SELECT Nationality FROM people GROUP BY Nationality HAVING COUNT(*) >= 2
SELECT ID FROM Highschooler WHERE name = 'Kyle'
SELECT student_id, current_address_id, permanent_address_id, first_name, middle_name, last_name, cell_mobile_number, email_address, ssn, date_first_registered, date_left, other_student_details FROM Students ORDER BY last_name DESC
SELECT Student.Fname, Student.Sex FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID GROUP BY Student.StuID, Student.Fname, Student.Sex HAVING COUNT(*) > 1
SELECT VOTES.created, VOTES.state, VOTES.phone_number FROM VOTES JOIN CONTESTANTS ON VOTES.contestant_number = CONTESTANTS.contestant_number WHERE CONTESTANTS.contestant_name = 'Tabatha Gehling'
SELECT hand, COUNT(player_id) FROM players GROUP BY hand
SELECT T1.Name, COUNT(T2.concert_ID) AS "Number of Concerts" FROM stadium AS T1 JOIN concert AS T2 ON T1.Stadium_ID = T2.Stadium_ID GROUP BY T1.Name
SELECT COUNT(*) AS num_concerts FROM concert WHERE Year IN ('2014', '2015')
SELECT continents.ContId, continents.Continent, COUNT(*) FROM continents JOIN countries ON countries.Continent = continents.ContId GROUP BY continents.ContId, continents.Continent
SELECT City FROM employee WHERE Age < 30 GROUP BY City HAVING COUNT(*) > 1
SELECT Name, Location, District FROM shop ORDER BY Number_products DESC
SELECT Cartoon.Channel, TV_Channel.series_name FROM Cartoon JOIN TV_Channel ON Cartoon.Channel = TV_Channel.id WHERE Cartoon.Title = 'The Rise of the Blue Beetle!'
SELECT Region, Population FROM country WHERE Name = 'Angola'
SELECT Name, Capacity FROM stadium ORDER BY Average DESC LIMIT 1
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID ORDER BY T2.Final_Table_Made ASC
SELECT a.Airline FROM airlines AS a JOIN flights AS f ON a.Airline = f.Airline GROUP BY a.Airline HAVING COUNT(*) < 200
SELECT COUNT(*) AS count FROM Dogs WHERE age < (SELECT AVG(age) FROM Dogs)
SELECT Record_Company FROM orchestra WHERE Year_of_Founded < 2003 INTERSECT SELECT Record_Company FROM orchestra WHERE Year_of_Founded > 2003
SELECT people.Birth_Date FROM poker_player JOIN people ON poker_player.People_ID = people.People_ID ORDER BY poker_player.Earnings ASC LIMIT 1
SELECT Template_Type_Code FROM Templates GROUP BY Template_Type_Code ORDER BY COUNT(*) DESC LIMIT 1
SELECT T1.Name FROM people AS T1 LEFT JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID WHERE T2.People_ID IS NULL
SELECT Highschooler.ID FROM Highschooler WHERE Highschooler.ID IN (SELECT student_id FROM Friend) AND Highschooler.ID IN (SELECT liked_id FROM Likes)
SELECT Name FROM museum WHERE Num_of_Staff > (SELECT MIN(Num_of_Staff) FROM museum WHERE Open_Year > 2010)
SELECT Song_Name FROM singer WHERE Age > (SELECT AVG(Age) FROM singer)
SELECT COUNT(*) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City = 'Aberdeen ' OR airports.City = 'Abilene '
SELECT T1.Birth_Date FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID ORDER BY T2.Earnings ASC LIMIT 1
SELECT T1.first_name, T1.country_code, T1.birth_date FROM players AS T1 JOIN matches AS T2 ON T1.player_id = T2.winner_id ORDER BY T2.winner_rank_points DESC LIMIT 1
SELECT COUNT(*) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City = 'Aberdeen ' OR airports.City = 'Abilene '
SELECT T1.Airline FROM airlines AS T1 JOIN flights AS T2 ON T1.Airline = T2.Airline WHERE T2.SourceAirport = 'CVO' EXCEPT SELECT T1.Airline FROM airlines AS T1 JOIN flights AS T2 ON T1.Airline = T2.Airline WHERE T2.SourceAirport = 'APG'
SELECT T1.course_name FROM Courses AS T1 JOIN Student_Enrolment_Courses AS T2 ON T1.course_id = T2.course_id GROUP BY T1.course_name ORDER BY COUNT(T2.student_course_id) DESC LIMIT 1
SELECT DISTINCT T1.Model FROM model_list AS T1 JOIN car_makers AS T2 ON T1.Maker = T2.Id LEFT JOIN car_names AS T3 ON T3.Model = T1.Model LEFT JOIN cars_data AS T4 ON T3.MakeId = T4.Id WHERE T2.FullName = 'General Motors' OR T4.Weight > 3500
SELECT countries.CountryName FROM countries JOIN continents ON countries.Continent = continents.ContId JOIN car_makers ON car_makers.Country = countries.CountryId WHERE continents.Continent = 'europe' GROUP BY countries.CountryName HAVING COUNT(*) >= 3
SELECT T1.series_name, T1.Country FROM TV_Channel AS T1 JOIN Cartoon AS T2 ON T1.id = T2.Channel WHERE T2.Directed_by IN ('Ben Jones', 'Michael Chang') GROUP BY T1.id, T1.series_name, T1.Country HAVING COUNT(DISTINCT T2.Directed_by) = 2
SELECT T2.Horsepower, T1.Make FROM car_names AS T1 JOIN cars_data AS T2 ON T1.MakeId = T2.Id WHERE T2.Cylinders = 3 ORDER BY T2.Horsepower DESC LIMIT 1
SELECT T1.address_id, T1.line_1, T1.line_2 FROM Addresses AS T1 JOIN Students AS T2 ON T1.address_id = T2.current_address_id GROUP BY T1.address_id, T1.line_1, T1.line_2 ORDER BY COUNT(T2.student_id) DESC LIMIT 1
SELECT Students.last_name FROM Students WHERE Students.current_address_id IN (SELECT address_id FROM Addresses WHERE state_province_county = 'North Carolina') AND Students.student_id NOT IN (SELECT student_id FROM Student_Enrolment)
SELECT DISTINCT T1.first_name, T1.last_name FROM Professionals AS T1 JOIN Treatments AS T2 ON T1.professional_id = T2.professional_id WHERE T2.cost_of_treatment < (SELECT AVG(cost_of_treatment) FROM Treatments)
SELECT museum.Museum_ID, museum.Name FROM museum JOIN visit ON museum.Museum_ID = visit.Museum_ID GROUP BY museum.Museum_ID, museum.Name ORDER BY SUM(visit.Num_of_Ticket) DESC LIMIT 1
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'dog')) AND StuID NOT IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat'))
SELECT city.Name FROM city JOIN countrylanguage ON city.CountryCode = countrylanguage.CountryCode WHERE countrylanguage.Language = 'English' ORDER BY city.Population DESC LIMIT 1
