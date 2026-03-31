SELECT COUNT(DISTINCT Poker_Player_ID) FROM poker_player;	poker_player
SELECT Abbreviation FROM airlines WHERE Airline = 'JetBlue Airways';	flight_2
SELECT COUNT(DISTINCT PetType) FROM Pets;	pets_1
SELECT AVG(LifeExpectancy) FROM country WHERE Region = 'Central Africa';	world_1
SELECT DISTINCT Template_Type_Code FROM Templates;	cre_Doc_Template_Mgt
SELECT COUNT(DISTINCT Document_ID) FROM Documents;	cre_Doc_Template_Mgt
SELECT SUM(Bonus) FROM evaluation;	employee_hire_evaluation
SELECT COUNT(*) FROM flights;	flight_2
SELECT Continent FROM country WHERE Name = 'Anguilla';	world_1
SELECT Country FROM airlines WHERE Airline = 'JetBlue Airways';	flight_2
SELECT Nationality FROM people GROUP BY Nationality HAVING COUNT(DISTINCT People_ID) >= 2;	poker_player
SELECT ID FROM Highschooler WHERE name = 'Kyle';	network_1
SELECT first_name, middle_name, last_name, cell_mobile_number, email_address, ssn, date_first_registered, date_left, other_student_details FROM Students ORDER BY last_name DESC;	student_transcripts_tracking
SELECT Student.Fname, Student.Sex FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID GROUP BY Student.StuID, Student.Fname, Student.Sex HAVING COUNT(DISTINCT Has_Pet.PetID) > 1;	pets_1
SELECT T1.created, T1.state, T1.phone_number FROM VOTES AS T1 JOIN CONTESTANTS AS T2 ON T1.contestant_number = T2.contestant_number WHERE T2.contestant_name = 'Tabatha Gehling';	voter_1
SELECT hand, COUNT(DISTINCT player_id) AS count_players FROM players GROUP BY hand;	wta_1
SELECT stadium.Name, COUNT(DISTINCT concert.concert_ID) AS count_concerts FROM stadium JOIN concert ON stadium.Stadium_ID = concert.Stadium_ID GROUP BY stadium.Name;	concert_singer
SELECT COUNT(DISTINCT concert_ID) FROM concert WHERE Year = 2014 OR Year = 2015;	concert_singer
SELECT T1.ContId, T1.Continent, COUNT(DISTINCT T2.CountryId) FROM continents AS T1 LEFT JOIN countries AS T2 ON T1.ContId = T2.Continent GROUP BY T1.ContId, T1.Continent;	car_1
SELECT City FROM employee WHERE Age < 30 GROUP BY City HAVING COUNT(DISTINCT Employee_ID) > 1;	employee_hire_evaluation
SELECT Name, Location, District FROM shop ORDER BY Number_products DESC;	employee_hire_evaluation
SELECT T1.series_name FROM TV_Channel AS T1 JOIN Cartoon AS T2 ON T2.Channel = T1.id WHERE T2.Title = 'The Rise of the Blue Beetle!';	tvshow
SELECT Region, Population FROM country WHERE Name = 'Angola';	world_1
SELECT Name, Capacity FROM stadium ORDER BY Average DESC LIMIT 1;	concert_singer
SELECT T1.Name FROM poker_player AS T2 JOIN people AS T1 ON T2.People_ID = T1.People_ID ORDER BY T2.Final_Table_Made ASC;	poker_player
SELECT T1.Airline FROM airlines AS T1 JOIN flights AS T2 ON T1.uid = T2.Airline GROUP BY T1.Airline HAVING COUNT(DISTINCT T2.FlightNo) < 200;	flight_2
SELECT COUNT(DISTINCT dog_id) AS count_dogs FROM Dogs WHERE age < (SELECT AVG(age) FROM Dogs);	dog_kennels
SELECT Record_Company FROM orchestra WHERE Year_of_Founded < 2003 INTERSECT SELECT Record_Company FROM orchestra WHERE Year_of_Founded > 2003;	orchestra
SELECT people.Birth_Date FROM poker_player JOIN people ON poker_player.People_ID = people.People_ID ORDER BY poker_player.Earnings ASC LIMIT 1;	poker_player
SELECT T1.Template_Type_Code FROM Ref_Template_Types AS T1 JOIN Templates AS T2 ON T1.Template_Type_Code = T2.Template_Type_Code GROUP BY T1.Template_Type_Code ORDER BY COUNT(DISTINCT T2.Template_ID) DESC LIMIT 1;	cre_Doc_Template_Mgt
SELECT Name FROM people WHERE People_ID NOT IN (SELECT People_ID FROM poker_player);	poker_player
SELECT DISTINCT Highschooler.ID FROM Highschooler JOIN Friend ON Highschooler.ID = Friend.student_id JOIN Likes ON Highschooler.ID = Likes.liked_id;	network_1
SELECT Name FROM museum WHERE Num_of_Staff > (SELECT MIN(Num_of_Staff) FROM museum WHERE Open_Year > '2010');	museum_visit
SELECT Song_Name FROM singer WHERE Age > (SELECT AVG(Age) FROM singer);	concert_singer
SELECT COUNT(*) AS "Number of Flights" FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City IN ('Aberdeen', 'Abilene');	flight_2
SELECT Birth_Date FROM people WHERE People_ID = (SELECT People_ID FROM poker_player ORDER BY Earnings LIMIT 1);	poker_player
SELECT p.first_name, p.country_code, p.birth_date FROM players AS p JOIN matches AS m ON p.player_id = m.winner_id WHERE m.winner_rank_points = (SELECT MAX(winner_rank_points) FROM matches);	wta_1
SELECT COUNT(DISTINCT flights.FlightNo) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City = 'Aberdeen' OR airports.City = 'Abilene';	flight_2
SELECT DISTINCT T1.Airline FROM airlines AS T1 JOIN flights AS T2 ON T1.uid = T2.Airline WHERE T2.SourceAirport = 'CVO' EXCEPT SELECT T1.Airline FROM airlines AS T1 JOIN flights AS T2 ON T1.uid = T2.Airline WHERE T2.SourceAirport = 'APG';	flight_2
SELECT T1.course_name FROM Courses AS T1 JOIN Student_Enrolment_Courses AS T2 ON T1.course_id = T2.course_id GROUP BY T1.course_id, T1.course_name ORDER BY COUNT(T2.student_course_id) DESC LIMIT 1;	student_transcripts_tracking
SELECT DISTINCT T1.Model FROM model_list AS T1 JOIN car_makers AS T2 ON T1.Maker = T2.Id JOIN car_names AS T3 ON T1.Id = T3.ModelId JOIN cars_data AS T4 ON T3.ModelId = T4.Id WHERE T2.FullName = 'General Motors' OR T4.Weight > 3500;	car_1
SELECT countries.CountryName FROM countries JOIN continents ON countries.Continent = continents.ContId JOIN car_makers ON countries.CountryName = car_makers.Country WHERE continents.Continent = 'Europe' GROUP BY countries.CountryName HAVING COUNT(DISTINCT car_makers.Id) >= 3;	car_1
SELECT TV_Channel.series_name, TV_Channel.Country FROM TV_Channel JOIN Cartoon ON TV_Channel.id = Cartoon.Channel WHERE Cartoon.Directed_by IN ('Ben Jones', 'Michael Chang') GROUP BY TV_Channel.series_name, TV_Channel.Country HAVING COUNT(DISTINCT Cartoon.Directed_by) = 2;	tvshow
SELECT MAX(T1.Horsepower), T2.Make FROM cars_data AS T1 JOIN car_names AS T2 ON T1.Id = T2.MakeId WHERE T1.Cylinders = 3 GROUP BY T2.Make;	car_1
SELECT a.address_id, a.line_1, a.line_2 FROM Addresses a JOIN Students s ON a.address_id = s.current_address_id GROUP BY a.address_id, a.line_1, a.line_2 ORDER BY COUNT(DISTINCT s.student_id) DESC LIMIT 1;	student_transcripts_tracking
SELECT last_name FROM Students WHERE current_address_id IN (SELECT address_id FROM Addresses WHERE state_province_county = 'North Carolina') AND student_id NOT IN (SELECT student_id FROM Student_Enrolment);	student_transcripts_tracking
SELECT Professionals.first_name, Professionals.last_name FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id WHERE Treatments.cost_of_treatment < (SELECT AVG(cost_of_treatment) FROM Treatments);	dog_kennels
SELECT m.Museum_ID, m.Name FROM museum m JOIN visit v ON m.Museum_ID = v.Museum_ID GROUP BY m.Museum_ID, m.Name ORDER BY COUNT(v.Museum_ID) DESC LIMIT 1;	museum_visit
SELECT Fname FROM Student WHERE StuID IN (SELECT T1.StuID FROM Has_Pet AS T1 JOIN Pets AS T2 ON T1.PetID = T2.PetID WHERE T2.PetType = 'Dog') AND StuID NOT IN (SELECT T1.StuID FROM Has_Pet AS T1 JOIN Pets AS T2 ON T1.PetID = T2.PetID WHERE T2.PetType = 'Cat');	pets_1
SELECT T1.Name FROM city AS T1 JOIN country AS T2 ON T1.CountryCode = T2.Code JOIN countrylanguage AS T3 ON T2.Code = T3.CountryCode WHERE T3.Language = 'English' ORDER BY T1.Population DESC LIMIT 1;	world_1
