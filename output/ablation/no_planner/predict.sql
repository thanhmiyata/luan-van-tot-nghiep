SELECT count(*) FROM poker_player	poker_player
SELECT Abbreviation FROM airlines WHERE Airline = 'JetBlue Airways'	flight_2
SELECT COUNT(DISTINCT PetType) FROM Pets	pets_1
SELECT AVG(LifeExpectancy) FROM country WHERE Region = 'Central Africa'	world_1
SELECT DISTINCT Template_Type_Code FROM Templates	cre_Doc_Template_Mgt
SELECT COUNT(*) FROM Documents	cre_Doc_Template_Mgt
SELECT SUM(Bonus) FROM evaluation	employee_hire_evaluation
SELECT COUNT(*) AS number_of_flights FROM flights	flight_2
SELECT Continent FROM country WHERE Name = 'Anguilla'	world_1
SELECT Country FROM airlines WHERE Airline = 'JetBlue Airways'	flight_2
SELECT Nationality FROM people GROUP BY Nationality HAVING COUNT(*) >= 2	poker_player
SELECT ID FROM Highschooler WHERE name = 'Kyle'	network_1
SELECT first_name, middle_name, last_name, cell_mobile_number, email_address, ssn, date_first_registered, date_left, other_student_details FROM Students ORDER BY last_name DESC, first_name DESC	student_transcripts_tracking
SELECT T1.Fname, T1.Sex FROM Student AS T1 JOIN Has_Pet AS T2 ON T1.StuID = T2.StuID GROUP BY T1.StuID HAVING COUNT(T2.PetID) > 1	pets_1
SELECT T1.created, T1.state, T1.phone_number FROM VOTES AS T1 JOIN CONTESTANTS AS T2 ON T1.contestant_number = T2.contestant_number WHERE T2.contestant_name = 'Tabatha Gehling'	voter_1
SELECT hand, COUNT(player_id) FROM players GROUP BY hand	wta_1
SELECT T1.Name, COUNT(T2.concert_ID) AS "Number of Concerts" FROM stadium AS T1 JOIN concert AS T2 ON T1.Stadium_ID = T2.Stadium_ID GROUP BY T1.Name	concert_singer
SELECT count(*) FROM concert WHERE Year = 2014 OR Year = 2015	concert_singer
SELECT T1.ContId, T1.Continent, COUNT(T2.CountryId) AS count_countries FROM continents AS T1 JOIN countries AS T2 ON T1.ContId = T2.Continent GROUP BY T1.ContId, T1.Continent	car_1
SELECT City FROM employee WHERE Age < 30 GROUP BY City HAVING COUNT(Employee_ID) > 1	employee_hire_evaluation
SELECT Name, Location, District FROM shop ORDER BY Number_products DESC	employee_hire_evaluation
SELECT T1.series_name FROM TV_Channel AS T1 JOIN Cartoon AS T2 ON T1.id = T2.Channel WHERE T2.Title = 'The Rise of the Blue Beetle!'	tvshow
SELECT Region, Population FROM country WHERE Name = 'Angola'	world_1
SELECT Name, Capacity FROM stadium ORDER BY Average DESC LIMIT 1	concert_singer
SELECT T2.Name FROM poker_player AS T1 JOIN people AS T2 ON T1.People_ID = T2.People_ID ORDER BY T1.Final_Table_Made ASC	poker_player
SELECT T1.Airline FROM airlines AS T1 JOIN flights AS T2 ON T1.uid = T2.Airline GROUP BY T1.uid HAVING COUNT(*) < 200	flight_2
SELECT COUNT(dog_id) FROM Dogs WHERE age < (SELECT AVG(age) FROM Dogs)	dog_kennels
SELECT Record_Company FROM orchestra WHERE Year_of_Founded < 2003 INTERSECT SELECT Record_Company FROM orchestra WHERE Year_of_Founded > 2003	orchestra
SELECT T2.Birth_Date FROM poker_player AS T1 JOIN people AS T2 ON T1.People_ID = T2.People_ID ORDER BY T1.Earnings ASC LIMIT 1	poker_player
SELECT T1.Template_Type_Code FROM Ref_Template_Types AS T1 JOIN Templates AS T2 ON T1.Template_Type_Code = T2.Template_Type_Code GROUP BY T1.Template_Type_Code ORDER BY COUNT(T2.Template_ID) DESC LIMIT 1	cre_Doc_Template_Mgt
SELECT T1.Name FROM people AS T1 LEFT JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID WHERE T2.People_ID IS NULL	poker_player
SELECT T1.student_id FROM Friend AS T1 INTERSECT SELECT T2.liked_id FROM Likes AS T2	network_1
SELECT Name FROM museum WHERE Num_of_Staff > (SELECT MIN(Num_of_Staff) FROM museum WHERE Open_Year > '2010')	museum_visit
SELECT Song_Name FROM singer WHERE Age > (SELECT AVG(Age) FROM singer)	concert_singer
SELECT COUNT(*) FROM flights AS T1 JOIN airports AS T2 ON T1.DestAirport = T2.AirportCode WHERE T2.City = 'Aberdeen' OR T2.City = 'Abilene';	flight_2
SELECT T2.Birth_Date FROM poker_player AS T1 JOIN people AS T2 ON T1.People_ID = T2.People_ID ORDER BY T1.Earnings ASC LIMIT 1	poker_player
SELECT T1.first_name, T1.country_code, T1.birth_date FROM players AS T1 JOIN matches AS T2 ON T1.player_id = T2.winner_id ORDER BY T2.winner_rank_points DESC LIMIT 1	wta_1
SELECT COUNT(*) FROM flights AS T1 JOIN airports AS T2 ON T1.DestAirport = T2.AirportCode WHERE T2.City IN ('Aberdeen', 'Abilene')	flight_2
SELECT DISTINCT T1.Airline FROM airlines AS T1 JOIN flights AS T2 ON T1.uid = T2.Airline WHERE T2.SourceAirport = 'CVO' EXCEPT SELECT DISTINCT T1.Airline FROM airlines AS T1 JOIN flights AS T2 ON T1.uid = T2.Airline WHERE T2.SourceAirport = 'APG'	flight_2
SELECT T1.course_name FROM Courses AS T1 JOIN Student_Enrolment_Courses AS T2 ON T1.course_id = T2.course_id GROUP BY T1.course_id, T1.course_name ORDER BY COUNT(T2.student_course_id) DESC LIMIT 1	student_transcripts_tracking
SELECT T1.Model FROM model_list AS T1 JOIN car_makers AS T2 ON T1.Maker = T2.Id WHERE T2.FullName = 'General Motors' UNION SELECT T3.Model FROM cars_data AS T1 JOIN car_names AS T2 ON T1.Id = T2.MakeId JOIN model_list AS T3 ON T2.Model = T3.Model WHERE T1.Weight > 3500	car_1
SELECT T1.CountryName FROM countries AS T1 JOIN car_makers AS T2 ON T1.CountryId = T2.Country WHERE T1.Continent = 'Europe' GROUP BY T1.CountryId HAVING COUNT(T2.Id) >= 3	car_1
SELECT T1.series_name, T1.Country FROM TV_Channel AS T1 JOIN (SELECT Channel FROM Cartoon WHERE Directed_by = 'Ben Jones' INTERSECT SELECT Channel FROM Cartoon WHERE Directed_by = 'Michael Chang') AS T2 ON T1.id = T2.Channel;	tvshow
SELECT T1.Horsepower, T2.Make FROM cars_data AS T1 JOIN car_names AS T2 ON T1.Id = T2.MakeId WHERE T1.Cylinders = 3 ORDER BY T1.Horsepower DESC LIMIT 1	car_1
SELECT T1.address_id, T1.line_1, T1.line_2 FROM Addresses AS T1 JOIN Students AS T2 ON T1.address_id = T2.current_address_id GROUP BY T1.address_id, T1.line_1, T1.line_2 ORDER BY COUNT(T2.student_id) DESC LIMIT 1	student_transcripts_tracking
SELECT T1.last_name FROM Students AS T1 JOIN Addresses AS T2 ON T1.current_address_id = T2.address_id WHERE T2.state_province_county = 'North Carolina' AND T1.student_id NOT IN (SELECT T3.student_id FROM Student_Enrolment AS T3);	student_transcripts_tracking
SELECT DISTINCT T1.first_name, T1.last_name FROM Professionals AS T1 JOIN Treatments AS T2 ON T1.professional_id = T2.professional_id WHERE T2.cost_of_treatment < (SELECT AVG(T3.cost_of_treatment) FROM Treatments AS T3)	dog_kennels
SELECT T1.Museum_ID, T1.Name FROM museum AS T1 JOIN visit AS T2 ON T1.Museum_ID = T2.Museum_ID GROUP BY T1.Museum_ID, T1.Name ORDER BY COUNT(T2.Museum_ID) DESC LIMIT 1	museum_visit
SELECT DISTINCT T1.Fname FROM Student AS T1 JOIN Has_Pet AS T2 ON T1.StuID = T2.StuID JOIN Pets AS T3 ON T2.PetID = T3.PetID WHERE T3.PetType = 'Dog' AND T1.StuID NOT IN (SELECT T1_sub.StuID FROM Student AS T1_sub JOIN Has_Pet AS T2_sub ON T1_sub.StuID = T2_sub.StuID JOIN Pets AS T3_sub ON T2_sub.PetID = T3_sub.PetID WHERE T3_sub.PetType = 'Cat');	pets_1
SELECT T1.Name FROM city AS T1 JOIN country AS T2 ON T1.CountryCode = T2.Code JOIN countrylanguage AS T3 ON T2.Code = T3.CountryCode WHERE T3.Language = 'English' ORDER BY T1.Population DESC LIMIT 1	world_1
