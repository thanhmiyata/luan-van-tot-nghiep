SELECT COUNT(*) FROM poker_player
SELECT Abbreviation FROM airlines WHERE Airline = 'JetBlue Airways'
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT AVG(LifeExpectancy) FROM country WHERE Region = 'Central Africa'
SELECT COUNT(DISTINCT Template_Type_Code) FROM Ref_Template_Types
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
SELECT stadium.Name, COUNT(concert.concert_ID) AS "Number of Concerts" FROM stadium JOIN concert ON stadium.Stadium_ID = concert.Stadium_ID GROUP BY stadium.Name
SELECT COUNT(*) AS num_concerts FROM concert WHERE Year IN ('2014', '2015')
SELECT continents.ContId, continents.Continent, COUNT(*) FROM continents JOIN countries ON countries.Continent = continents.ContId GROUP BY continents.ContId, continents.Continent
SELECT City FROM employee WHERE Age < 30 GROUP BY City HAVING COUNT(*) > 1
SELECT Name, Location, District, Number_products FROM shop ORDER BY Number_products DESC
SELECT Cartoon.Channel, TV_Channel.series_name FROM Cartoon JOIN TV_Channel ON Cartoon.Channel = TV_Channel.id WHERE Cartoon.Title = 'The Rise of the Blue Beetle!'
SELECT Region, Population FROM country WHERE Name = 'Angola'
SELECT Name, Capacity FROM stadium ORDER BY Average DESC LIMIT 1
SELECT Name FROM people JOIN poker_player ON people.People_ID = poker_player.People_ID ORDER BY Final_Table_Made ASC
SELECT airlines.Airline FROM airlines JOIN flights ON airlines.Airline = flights.Airline GROUP BY airlines.Airline HAVING COUNT(flights.FlightNo) < 200
SELECT COUNT(*) AS count FROM Dogs WHERE age < (SELECT AVG(age) FROM Dogs)
SELECT Record_Company FROM orchestra WHERE Year_of_Founded < 2003 INTERSECT SELECT Record_Company FROM orchestra WHERE Year_of_Founded > 2003
SELECT people.Birth_Date FROM poker_player JOIN people ON poker_player.People_ID = people.People_ID ORDER BY poker_player.Earnings ASC LIMIT 1
SELECT Template_Type_Code FROM Templates GROUP BY Template_Type_Code ORDER BY COUNT(Template_ID) DESC LIMIT 1
SELECT Name FROM people WHERE NOT People_ID IN (SELECT People_ID FROM poker_player)
SELECT Highschooler.ID FROM Highschooler WHERE Highschooler.ID IN (SELECT student_id FROM Friend) AND Highschooler.ID IN (SELECT liked_id FROM Likes)
SELECT Name FROM museum WHERE Num_of_Staff > (SELECT MIN(Num_of_Staff) FROM museum WHERE Open_Year > 2010)
SELECT Song_Name FROM singer WHERE Age > (SELECT AVG(Age) FROM singer)
SELECT COUNT(*) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City = 'Aberdeen' OR airports.City = 'Abilene'
SELECT Birth_Date FROM people JOIN poker_player ON people.People_ID = poker_player.People_ID ORDER BY Earnings ASC LIMIT 1
SELECT p.first_name, p.country_code, p.birth_date FROM players AS p JOIN matches AS m ON p.player_id = m.winner_id ORDER BY m.winner_rank_points DESC LIMIT 1
SELECT COUNT(*) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City = 'Aberdeen' OR airports.City = 'Abilene'
SELECT a.Airline FROM airlines AS a WHERE a.Airline IN (SELECT Airline FROM flights WHERE SourceAirport = 'CVO') AND NOT a.Airline IN (SELECT Airline FROM flights WHERE SourceAirport = 'APG')
SELECT Courses.course_name FROM Courses JOIN Student_Enrolment_Courses ON Courses.course_id = Student_Enrolment_Courses.course_id GROUP BY Courses.course_name ORDER BY COUNT(*) DESC LIMIT 1
SELECT DISTINCT model_list.Model FROM model_list JOIN car_makers ON model_list.Maker = car_makers.Id JOIN car_names ON car_names.Model = model_list.Model JOIN cars_data ON car_names.MakeId = cars_data.Id WHERE car_makers.FullName = 'General Motors' OR cars_data.Weight > 3500
SELECT countries.CountryName FROM countries JOIN continents ON countries.Continent = continents.ContId JOIN car_makers ON car_makers.Country = countries.CountryId WHERE continents.Continent = 'europe' GROUP BY countries.CountryName HAVING COUNT(car_makers.Id) >= 3
SELECT TV_Channel.series_name, TV_Channel.Country FROM TV_Channel JOIN Cartoon ON TV_Channel.id = Cartoon.Channel WHERE Cartoon.Directed_by = 'Ben Jones' OR Cartoon.Directed_by = 'Michael Chang'
SELECT MAX(cars_data.Horsepower), car_names.Make FROM cars_data JOIN car_names ON cars_data.Id = car_names.MakeId WHERE cars_data.Cylinders = 3
SELECT A.address_id, A.line_1, A.line_2 FROM Addresses AS A JOIN Students AS S ON A.address_id = S.current_address_id GROUP BY A.address_id, A.line_1, A.line_2 ORDER BY COUNT(*) DESC LIMIT 1
SELECT Students.last_name FROM Students WHERE Students.current_address_id IN (SELECT address_id FROM Addresses WHERE state_province_county = 'NorthCarolina') AND NOT Students.student_id IN (SELECT student_id FROM Student_Enrolment)
SELECT Professionals.first_name, Professionals.last_name FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id WHERE Treatments.cost_of_treatment < (SELECT AVG(cost_of_treatment) FROM Treatments)
SELECT museum.Museum_ID, museum.Name FROM museum JOIN visit ON museum.Museum_ID = visit.Museum_ID GROUP BY museum.Museum_ID, museum.Name ORDER BY SUM(visit.Num_of_Ticket) DESC LIMIT 1
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'dog') EXCEPT SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat'))
SELECT city.Name FROM city JOIN countrylanguage ON city.CountryCode = countrylanguage.CountryCode WHERE countrylanguage.Language = 'English' ORDER BY city.Population DESC LIMIT 1
