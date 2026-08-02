select count(*) from poker_player
select Abbreviation from airlines where Airline = "JetBlue Airways"
select count(distinct PetType) from Pets
select avg(LifeExpectancy) from country where Region = "Central Africa"
select distinct Template_Type_Code from Ref_Template_Types
select count(*) from Documents
select sum(Bonus) from evaluation
select count(*) from flights
select Continent from country where Name = "Anguilla"
select Country from airlines where Airline = "JetBlue Airways"
select Nationality from people group by Nationality having count(*) >= 2
select ID from Highschooler where name = "Kyle"
SELECT student_id, current_address_id, permanent_address_id, first_name, middle_name, last_name, cell_mobile_number, email_address, ssn, date_first_registered, date_left, other_student_details FROM Students ORDER BY last_name DESC
SELECT T1.fname ,  T1.sex FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid GROUP BY T1.stuid HAVING count(*)  >  1
SELECT T2.created ,  T2.state ,  T2.phone_number FROM contestants AS T1 JOIN votes AS T2 ON T1.contestant_number  =  T2.contestant_number WHERE T1.contestant_name  =  'Tabatha Gehling'
select hand, count(*) from players group by hand
select stadium.Name, count(concert.concert_ID) from stadium inner join concert on stadium.Stadium_ID = concert.Stadium_ID group by stadium.Name
SELECT count(*) FROM concert WHERE YEAR  =  2014 OR YEAR  =  2015
select continents.ContId, continents.Continent, count(*) from continents inner join countries on countries.Continent = continents.ContId group by continents.ContId, continents.Continent
select City from employee where Age < 30 group by City having count(*) > 1
select Name, Location, District from shop order by Number_products desc
select T1.series_name from TV_Channel as T1 join Cartoon as T2 on T1.id = T2.Channel where T2.Title = "The Rise of the Blue Beetle!"
select Region, Population from country where Name = "Angola"
select Name, Capacity from stadium order by Average desc limit 1
select people.Name from poker_player join people on poker_player.People_ID = people.People_ID order by poker_player.Final_Table_Made asc
select T1.Airline from airlines as T1 join flights as T2 on T1.Airline = T2.Airline group by T1.Airline having count(*) < 200
select count(*) from Dogs where age < (select avg(age) from Dogs)
select Record_Company from orchestra where Year_of_Founded < 2003 intersect select Record_Company from orchestra where Year_of_Founded > 2003
select people.Birth_Date from poker_player join people on poker_player.People_ID = people.People_ID order by poker_player.Earnings asc limit 1
select Templates.Template_Type_Code from Templates group by Templates.Template_Type_Code order by count(*) desc limit 1
select people.Name from people left join poker_player on people.People_ID = poker_player.People_ID where poker_player.People_ID is null
select student_id from Friend intersect select liked_id from Likes
select Name from museum where Num_of_Staff > (select min(Num_of_Staff) from museum where Open_Year > 2010)
select Song_Name from singer where Age > (select avg(Age) from singer)
SELECT count(*) FROM Flights AS T1 JOIN Airports AS T2 ON T1.DestAirport  =  T2.AirportCode WHERE T2.city  =  "Aberdeen" OR T2.city  =  "Abilene"
select people.Birth_Date from poker_player join people on poker_player.People_ID = people.People_ID order by poker_player.Earnings asc limit 1
select T1.first_name, T1.country_code, T1.birth_date from players as T1 join matches as T2 on T2.winner_id = T1.player_id order by T2.winner_rank_points desc limit 1
SELECT count(*) FROM Flights AS T1 JOIN Airports AS T2 ON T1.DestAirport  =  T2.AirportCode WHERE T2.city  =  "Aberdeen" OR T2.city  =  "Abilene"
select T1.Airline from airlines as T1 join (select distinct Airline from flights where SourceAirport = "CVO" except select distinct Airline from flights where SourceAirport = "APG") on T1.Airline = T2.Airline
SELECT Courses.course_name FROM Courses JOIN Student_Enrolment_Courses ON Courses.course_id = Student_Enrolment_Courses.course_id GROUP BY Student_Enrolment_Courses.course_id ORDER BY COUNT(*) DESC LIMIT 1
SELECT DISTINCT model_list.Model FROM model_list JOIN car_makers ON model_list.Maker = car_makers.Id JOIN car_names ON car_names.Model = model_list.Model JOIN cars_data ON cars_data.Id = car_names.MakeId WHERE car_makers.FullName = 'General Motors' OR cars_data.Weight > 3500
select countries.CountryName from countries join continents on countries.Continent = continents.ContId join car_makers on car_makers.Country = countries.CountryId where continents.Continent = "europe" group by countries.CountryName having count(car_makers.Country) >= 3
select T1.series_name, T1.Country from TV_Channel as T1 join Cartoon as T2 on T1.id = T2.Channel where T2.Directed_by = "Ben Jones" intersect select T1.series_name, T1.Country from TV_Channel as T1 join Cartoon as T2 on T1.id = T2.Channel where T2.Directed_by = "Michael Chang"
select max(cars_data.Horsepower), car_names.Make from cars_data join car_names on cars_data.Id = car_names.MakeId where cars_data.Cylinders = 3
SELECT T1.address_id ,  T1.line_1 ,  T1.line_2 FROM Addresses AS T1 JOIN Students AS T2 ON T1.address_id  =  T2.current_address_id GROUP BY T1.address_id ORDER BY count(*) DESC LIMIT 1
SELECT Students.last_name FROM Students WHERE Students.current_address_id IN (SELECT address_id FROM Addresses WHERE state_province_county = 'North Carolina') AND NOT Students.student_id IN (SELECT student_id FROM Student_Enrolment)
SELECT Professionals.first_name, Professionals.last_name FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id WHERE Treatments.cost_of_treatment < (SELECT AVG(cost_of_treatment) FROM Treatments)
SELECT t2.Museum_ID ,  t1.name FROM museum AS t1 JOIN visit AS t2 ON t1.Museum_ID  =  t2.Museum_ID GROUP BY t2.Museum_ID ORDER BY count(*) DESC LIMIT 1
SELECT DISTINCT S.Fname FROM Student AS S JOIN Has_Pet AS HP ON S.StuID = HP.StuID JOIN Pets AS P ON HP.PetID = P.PetID WHERE P.PetType = 'dog' AND NOT S.StuID IN (SELECT HP2.StuID FROM Has_Pet AS HP2 JOIN Pets AS P2 ON HP2.PetID = P2.PetID WHERE P2.PetType = 'cat')
SELECT city.Name FROM city JOIN countrylanguage ON city.CountryCode = countrylanguage.CountryCode WHERE countrylanguage.Language = 'English' ORDER BY city.Population DESC LIMIT 1
