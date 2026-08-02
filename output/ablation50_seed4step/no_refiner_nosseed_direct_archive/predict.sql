SELECT COUNT(*) FROM poker_player
SELECT Abbreviation FROM airlines WHERE Airline = 'JetBlue Airways'
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT AVG(LifeExpectancy) FROM country WHERE Region = 'Central Africa'
SELECT DISTINCT Ref_Template_Types.Template_Type_Code FROM Ref_Template_Types JOIN Templates ON Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code
SELECT COUNT(*) FROM Documents
SELECT SUM(Bonus) FROM evaluation
SELECT COUNT(*) FROM flights
SELECT Continent FROM country WHERE Name = 'Anguilla'
SELECT Country FROM airlines WHERE Airline = 'JetBlue Airways'
SELECT Nationality FROM people GROUP BY Nationality HAVING COUNT(*) >= 2
SELECT ID FROM Highschooler WHERE name = 'Kyle'
SELECT student_id, current_address_id, permanent_address_id, first_name, middle_name, last_name, cell_mobile_number, email_address, ssn, date_first_registered, date_left, other_student_details FROM Students ORDER BY last_name DESC
SELECT Student.Fname, Student.Sex FROM Student WHERE Student.StuID IN (SELECT Has_Pet.StuID FROM Has_Pet GROUP BY Has_Pet.StuID HAVING COUNT(*) > 1)
SELECT VOTES.created, VOTES.state, VOTES.phone_number FROM VOTES JOIN CONTESTANTS ON VOTES.contestant_number = CONTESTANTS.contestant_number WHERE CONTESTANTS.contestant_name = 'Tabatha Gehling'
SELECT hand, COUNT(*) FROM players GROUP BY hand
SELECT stadium."Name", COUNT(*) FROM concert INNER JOIN stadium ON concert."Stadium_ID" = stadium."Stadium_ID" GROUP BY stadium."Name"
SELECT COUNT(*) FROM concert WHERE Year IN (2014, 2015)
SELECT continents.ContId, continents.Continent, COUNT(countries.CountryId) FROM continents JOIN countries ON continents.ContId = countries.Continent GROUP BY continents.ContId, continents.Continent
SELECT City FROM employee WHERE Age < 30 GROUP BY City HAVING COUNT(*) > 1
SELECT Name, Location, District, Number_products FROM shop ORDER BY Number_products DESC
SELECT Cartoon.Channel, TV_Channel.series_name FROM TV_Channel INNER JOIN Cartoon ON TV_Channel.id = Cartoon.Channel WHERE Cartoon.Title = 'The Rise of the Blue Beetle!'
SELECT "Region", "Population" FROM "country" WHERE "Name" = 'Angola'
SELECT Name, Capacity FROM stadium ORDER BY Average DESC LIMIT 1
SELECT people.Name FROM poker_player INNER JOIN people ON poker_player.People_ID = people.People_ID GROUP BY people.Name ORDER BY COUNT(poker_player.Final_Table_Made) ASC
SELECT airlines."Airline" FROM airlines JOIN flights ON airlines."Airline" = flights."Airline" GROUP BY airlines."Airline" HAVING COUNT(flights."FlightNo") < 200
SELECT COUNT(*) FROM Dogs WHERE age < (SELECT AVG(age) FROM Dogs)
SELECT Record_Company FROM orchestra WHERE Year_of_Founded < 2003 UNION SELECT Record_Company FROM orchestra WHERE Year_of_Founded > 2003
SELECT people.Birth_Date FROM poker_player INNER JOIN people ON poker_player.People_ID = people.People_ID ORDER BY poker_player.Earnings ASC LIMIT 1
SELECT Template_Type_Code FROM Templates GROUP BY Template_Type_Code ORDER BY COUNT(*) DESC LIMIT 1
SELECT Name FROM people WHERE NOT People_ID IN (SELECT People_ID FROM poker_player)
SELECT DISTINCT Highschooler.ID FROM Highschooler WHERE Highschooler.ID IN (SELECT Friend.student_id FROM Friend) AND Highschooler.ID IN (SELECT Likes.student_id FROM Likes)
SELECT Name FROM museum WHERE Num_of_Staff > (SELECT MIN(Num_of_Staff) FROM museum WHERE Open_Year > 2010)
SELECT Song_Name FROM singer WHERE Age > (SELECT AVG(Age) FROM singer)
SELECT COUNT(*) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City IN ('Aberdeen', 'Abilene')
SELECT p."Birth_Date" FROM "people" AS p JOIN "poker_player" AS pp ON p."People_ID" = pp."People_ID" ORDER BY pp."Earnings" LIMIT 1
SELECT players.first_name, players.country_code, players.birth_date FROM players JOIN matches ON matches.winner_id = players.player_id GROUP BY players.first_name, players.country_code, players.birth_date ORDER BY SUM(matches.winner_rank_points) DESC LIMIT 1
SELECT COUNT(*) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City IN ('Aberdeen', 'Abilene')
SELECT DISTINCT airlines.Airline FROM airlines INNER JOIN flights ON airlines.Airline = flights.Airline WHERE flights.SourceAirport = 'CVO' AND NOT airlines.Airline IN (SELECT flights.Airline FROM flights WHERE flights.SourceAirport = 'APG')
SELECT Courses.course_name FROM Courses JOIN Student_Enrolment_Courses ON Courses.course_id = Student_Enrolment_Courses.course_id GROUP BY Student_Enrolment_Courses.course_id ORDER BY COUNT(Student_Enrolment_Courses.course_id) DESC LIMIT 1
SELECT DISTINCT m."Model" FROM "model_list" AS m JOIN "car_makers" AS cm ON m."Maker" = cm."Id" WHERE cm."FullName" = 'General Motors' OR m."Model" IN (SELECT cn."Model" FROM "car_names" AS cn JOIN "cars_data" AS cd ON cn."MakeId" = cd."Id" WHERE cd."Weight" > 3500)
SELECT countries.CountryName FROM countries INNER JOIN continents ON countries.Continent = continents.ContId INNER JOIN car_makers ON car_makers.Country = countries.CountryId WHERE continents.Continent = 'europe' GROUP BY countries.CountryName HAVING COUNT(car_makers.Id) >= 3
SELECT TV_Channel.series_name, TV_Channel.Country FROM TV_Channel WHERE TV_Channel.id IN (SELECT Channel FROM Cartoon WHERE Directed_by = 'Ben Jones') AND TV_Channel.id IN (SELECT Channel FROM Cartoon WHERE Directed_by = 'Michael Chang')
SELECT MAX(cars_data.Horsepower), car_names.Make FROM cars_data JOIN car_names ON cars_data.Id = car_names.MakeId WHERE cars_data.Cylinders = 3 GROUP BY car_names.Make
SELECT A.address_id, A.line_1, A.line_2 FROM Addresses AS A JOIN Students AS S ON A.address_id = S.current_address_id GROUP BY A.address_id, A.line_1, A.line_2 ORDER BY COUNT(*) DESC LIMIT 1
SELECT Students.last_name FROM Students INNER JOIN Addresses ON Students.current_address_id = Addresses.address_id WHERE Addresses.state_province_county = 'NorthCarolina' AND NOT Students.student_id IN (SELECT student_id FROM Student_Enrolment)
SELECT Professionals.first_name, Professionals.last_name FROM Treatments JOIN Professionals ON Treatments.professional_id = Professionals.professional_id WHERE Treatments.cost_of_treatment < (SELECT AVG(cost_of_treatment) FROM Treatments)
SELECT museum."Museum_ID", museum."Name" FROM museum JOIN visit ON museum."Museum_ID" = visit."Museum_ID" GROUP BY museum."Museum_ID" ORDER BY COUNT(*) DESC LIMIT 1
SELECT DISTINCT Student.Fname FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'dog' AND NOT EXISTS(SELECT 1 FROM Has_Pet AS HP2 JOIN Pets AS P2 ON HP2.PetID = P2.PetID WHERE HP2.StuID = Student.StuID AND P2.PetType = 'cat')
SELECT city."Name" FROM city JOIN countrylanguage ON city."CountryCode" = countrylanguage."CountryCode" WHERE countrylanguage."Language" = 'English' ORDER BY city."Population" DESC LIMIT 1
