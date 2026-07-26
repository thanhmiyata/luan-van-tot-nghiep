SELECT Pets.PetType , Pets.weight FROM Pets ORDER BY Pets.birthyear desc LIMIT 1	s000_pets_1_5
SELECT Student.LName FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Pets.PetID = Has_Pet.PetID WHERE Pets.pet_age = 3 and Pets.is_cat = "T"	s001_pets_1_4
SELECT teacher.first_name , teacher.last_name , course.Course FROM course_arrange JOIN course ON course_arrange.Course_ID = course.Course_ID JOIN teacher ON course_arrange.Teacher_ID = teacher.Teacher_ID	s002_course_teach_5
SELECT teacher.first_name , teacher.last_name , count(*) FROM course_arrange JOIN teacher ON course_arrange.Teacher_ID = teacher.Teacher_ID GROUP BY teacher.first_name , teacher.last_name	s003_course_teach_1
SELECT visitor.Name , visitor.Level_of_membership FROM visitor WHERE visitor.Level_of_membership > 4 ORDER BY visitor.birthyear asc	s004_museum_visit_1
SELECT count(DISTINCT matches.winner_name) FROM matches WHERE matches.tourney_name = "WTA Championships" and matches.is_winner_right_handed = "F"	s005_wta_1_0
SELECT Transcripts.transcript_date , Transcripts.transcript_time , Transcript_Contents.transcript_id FROM Transcript_Contents JOIN Transcripts ON Transcript_Contents.transcript_id = Transcripts.transcript_id GROUP BY Transcript_Contents.transcript_id ORDER BY count(*) asc LIMIT 1	s006_student_transcripts_tracking_0
SELECT DISTINCT Student_Enrolment.semester_id FROM Degree_Programs JOIN Student_Enrolment ON Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id WHERE Degree_Programs.is_master = "T" INTERSECT SELECT DISTINCT Student_Enrolment.semester_id FROM Degree_Programs JOIN Student_Enrolment ON Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id WHERE Degree_Programs.is_bachelor = "T"	s007_student_transcripts_tracking_0
SELECT TV_Channel.Country FROM TV_Channel JOIN Cartoon ON TV_Channel.id = Cartoon.Channel WHERE Cartoon.writer_firstname = "Todd" and Cartoon.writer_lastname = "Casey"	s008_tvshow_0
SELECT TV_Channel.id FROM TV_Channel EXCEPT SELECT Cartoon.Channel FROM Cartoon WHERE Cartoon.director_firstname = "Ben" and Cartoon.director_lastname = "Jones"	s009_tvshow_5
SELECT TV_Channel.id FROM TV_Channel EXCEPT SELECT Cartoon.Channel FROM Cartoon WHERE Cartoon.director_firstname = "Ben" and Cartoon.director_lastname = "Jones"	s010_tvshow_5
SELECT people.first_name , people.last_name FROM people JOIN poker_player ON people.People_ID = poker_player.People_ID	s011_poker_player_0
SELECT people.first_name , people.last_name , people.Birth_Date FROM people ORDER BY people.first_name , people.last_name asc	s012_poker_player_0
SELECT DISTINCT VOTES.state , VOTES.created_date , VOTES.created_time FROM VOTES	s013_voter_1_7
SELECT conductor.first_name , conductor.last_name FROM conductor WHERE conductor.Nationality != "USA"	s014_orchestra_3
SELECT conductor.first_name , conductor.last_name FROM conductor WHERE conductor.Nationality != "USA"	s015_orchestra_3
SELECT conductor.Name FROM conductor ORDER BY conductor.year_start_to_work asc LIMIT 1	s016_orchestra_1
SELECT conductor.first_name , conductor.last_name FROM conductor JOIN orchestra ON conductor.Conductor_ID = orchestra.Conductor_ID WHERE orchestra.Year_of_Founded > 2008	s017_orchestra_3
SELECT singer.first_name , singer.last_name FROM singer JOIN song ON singer.Singer_ID = song.Singer_ID GROUP BY singer.first_name , singer.last_name HAVING count(*) > 1	s018_singer_0
SELECT singer.first_name , singer.last_name FROM singer WHERE singer.Singer_ID NOT in (SELECT song.Singer_ID FROM song)	s019_singer_0
SELECT max(Pets.wt) , Pets.PetType FROM Pets GROUP BY Pets.PetType	s020_pets_1_1
SELECT car_names.Model FROM car_names JOIN cars_data ON car_names.MakeId = cars_data.Id WHERE cars_data.wt < (SELECT avg(cars_data.wt) FROM cars_data)	s021_car_1_0
SELECT model_list.Maker , model_list.mdl FROM model_list	s022_car_1_1
SELECT car_names.mdl FROM car_names JOIN cars_data ON car_names.MakeId = cars_data.Id ORDER BY cars_data.MPG desc LIMIT 1	s023_car_1_3
SELECT airports.City , airports.cntry FROM airports WHERE airports.apt_name = "Alton"	s024_flight_2_4
SELECT count(*) FROM flights JOIN airports ON flights.srcapt = airports.AirportCode WHERE airports.City = "Aberdeen"	s025_flight_2_4
SELECT airports.apt_name FROM airports WHERE airports.apt_code NOT in (SELECT flights.srcapt FROM flights UNION SELECT flights.destapt FROM flights)	s026_flight_2_0
SELECT count(DISTINCT shop.loc) FROM shop	s027_employee_hire_evaluation_0
SELECT count(DISTINCT Documents.tpl_id) FROM Documents	s028_cre_Doc_Template_Mgt_2
SELECT Templates.Template_ID FROM Templates EXCEPT SELECT Documents.tpl_id FROM Documents	s029_cre_Doc_Template_Mgt_1
SELECT teacher.Name FROM course_arrange JOIN teacher ON course_arrange.tchr_id = teacher.Teacher_ID GROUP BY teacher.Name HAVING count(*) >= 2	s030_course_teach_4
SELECT visitor.Name FROM visitor WHERE visitor.lvl_mem > 4 ORDER BY visitor.lvl_mem desc	s031_museum_visit_2
SELECT players.first_name , players.country_code , players.dob FROM players JOIN matches ON players.player_id = matches.winner_id ORDER BY matches.winner_rank_points desc LIMIT 1	s032_wta_1_3
SELECT Addresses.adr_id , Addresses.line_1 , Addresses.line_2 FROM Addresses JOIN Students ON Addresses.adr_id = Students.ca_id GROUP BY Addresses.adr_id ORDER BY count(*) desc LIMIT 1	s033_student_transcripts_tracking_0
SELECT Cartoon.Title , Cartoon.dir FROM Cartoon ORDER BY Cartoon.Original_air_date asc	s034_tvshow_0
SELECT TV_series.ep FROM TV_series ORDER BY TV_series.rtg asc	s035_tvshow_0
SELECT country.Region FROM country JOIN city ON country.Code = city.cntry_code WHERE city.Name = "Kabul"	s036_world_1_4
SELECT country.Name FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.Language = "english" and countrylanguage.ofcl = "t" UNION SELECT country.Name FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.Language = "dutch" and countrylanguage.ofcl = "t"	s037_world_1_1
SELECT country.Name FROM country ORDER BY country.popn asc LIMIT 3	s038_world_1_0
SELECT orchestra.record_co FROM orchestra ORDER BY orchestra.Year_of_Founded desc	s039_orchestra_0
SELECT count(*) FROM concert WHERE concert.Stadium_ID = (SELECT stadium.Stadium_ID FROM stadium ORDER BY stadium.max_carrying_number desc LIMIT 1)	s040_concert_singer_1
SELECT Student.Fname , Student.gender FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID GROUP BY Student.StuID HAVING count(*) > 1	s041_pets_1_1
SELECT count(*) FROM cars_data WHERE cars_data.engine > 150	s042_car_1_2
SELECT max(cars_data.speed_up) , cars_data.cylinder_number FROM cars_data GROUP BY cars_data.cylinder_number	s043_car_1_0
SELECT car_names.mode FROM car_names GROUP BY car_names.mode ORDER BY count(*) desc LIMIT 1	s044_car_1_0
SELECT count(*) FROM flights WHERE flights.flight_from = "APG"	s045_flight_2_0
SELECT airlines.Airline FROM airlines JOIN flights ON airlines.uid = flights.air_way GROUP BY airlines.Airline ORDER BY count(*) desc LIMIT 1	s046_flight_2_2
SELECT DISTINCT Templates.template_kind_codification FROM Templates	s047_cre_Doc_Template_Mgt_3
SELECT Templates.template_kind_codification FROM Templates EXCEPT SELECT Templates.template_kind_codification FROM Templates JOIN Documents ON Templates.Template_ID = Documents.Template_ID	s048_cre_Doc_Template_Mgt_2
SELECT Ref_Template_Types.category_code , Ref_Template_Types.description FROM Ref_Template_Types	s049_cre_Doc_Template_Mgt_0
SELECT players.country_code , players.given_name FROM players JOIN matches ON players.player_id = matches.winner_id WHERE matches.tourney_name = "WTA Championships" INTERSECT SELECT players.country_code , players.given_name FROM players JOIN matches ON players.player_id = matches.winner_id WHERE matches.tourney_name = "Australian Open"	s050_wta_1_1
SELECT count(*) , players.nation_code FROM players GROUP BY players.nation_code	s051_wta_1_4
SELECT count(DISTINCT country.mainland) FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.official_language = "Chinese"	s052_world_1_0
SELECT country.Name FROM country WHERE country.Continent = "Africa" and country.how_many_people < (SELECT max(country.how_many_people) FROM country WHERE country.Continent = "Asia")	s053_world_1_3
SELECT count(*) , city.District FROM city WHERE city.total_citizens > (SELECT avg(city.total_citizens) FROM city) GROUP BY city.District	s054_world_1_3
SELECT count(*) FROM country WHERE country.mainland = "Asia"	s055_world_1_4
SELECT Treatments.time_of_therapeutics , Professionals.forename FROM Treatments JOIN Professionals ON Treatments.professional_id = Professionals.professional_id	s056_dog_kennels_0
SELECT Owners.forename , Owners.last_name , Dogs.size_code FROM Owners JOIN Dogs ON Owners.owner_id = Dogs.owner_id	s057_dog_kennels_4
SELECT singer.Name FROM singer WHERE singer.born_date = 1948 or singer.born_date = 1949	s058_singer_4
SELECT singer.nationality , count(*) FROM singer GROUP BY singer.nationality	s059_singer_0
select count(*) from concert where stadium_id = (select stadium_id from stadium order by capacity desc limit 1)	s060_concert_singer
SELECT T1.model FROM CAR_NAMES AS T1 JOIN CARS_DATA AS T2 ON T1.MakeId = T2.Id WHERE T2.Weight < (SELECT avg(Weight) FROM CARS_DATA)	s061_car_1
SELECT T2.horsepower , T1.Make FROM CAR_NAMES AS T1 JOIN CARS_DATA AS T2 ON T1.MakeId = T2.Id WHERE T2.cylinders = 3 ORDER BY T2.horsepower DESC LIMIT 1	s062_car_1
SELECT T1.Model FROM CAR_NAMES AS T1 JOIN CARS_DATA AS T2 ON T1.MakeId = T2.Id ORDER BY T2.mpg DESC LIMIT 1	s063_car_1
SELECT COUNT(*) FROM CARS_DATA WHERE Accelerate > ( SELECT Accelerate FROM CARS_DATA ORDER BY Horsepower DESC LIMIT 1 )	s064_car_1
SELECT t2.visitor_id , t1.name , t1.Level_of_membership FROM visitor AS t1 JOIN visit AS t2 ON t1.id = t2.visitor_id GROUP BY t2.visitor_id ORDER BY sum(t2.Total_spent) DESC LIMIT 1	s065_museum_visit
SELECT first_name , country_code FROM players ORDER BY birth_date LIMIT 1	s066_wta_1
SELECT winner_name FROM matches WHERE tourney_name = 'Australian Open' ORDER BY winner_rank_points DESC LIMIT 1	s067_wta_1
SELECT winner_name , loser_name FROM matches ORDER BY minutes DESC LIMIT 1	s068_wta_1
SELECT first_name , middle_name , last_name FROM Students ORDER BY date_first_registered ASC LIMIT 1	s069_student_transcripts_tracking
SELECT first_name , middle_name , last_name FROM Students ORDER BY date_first_registered ASC LIMIT 1	s070_student_transcripts_tracking
select production_code , channel from cartoon order by original_air_date desc limit 1	s071_tvshow
SELECT Money_Rank FROM poker_player ORDER BY Earnings DESC LIMIT 1	s072_poker_player
SELECT T1.Birth_Date FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID ORDER BY T2.Earnings ASC LIMIT 1	s073_poker_player
SELECT T2.Money_Rank FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID ORDER BY T1.Height DESC LIMIT 1	s074_poker_player
SELECT Name , Population , LifeExpectancy FROM country WHERE Continent = "Asia" ORDER BY SurfaceArea DESC LIMIT 1	s075_world_1
SELECT Name , Population , LifeExpectancy FROM country WHERE Continent = "Asia" ORDER BY SurfaceArea DESC LIMIT 1	s076_world_1
SELECT Name , SurfaceArea , IndepYear FROM country ORDER BY Population LIMIT 1	s077_world_1
SELECT Name , population , HeadOfState FROM country ORDER BY SurfaceArea DESC LIMIT 1	s078_world_1
SELECT T1.owner_id , T1.zip_code FROM Owners AS T1 JOIN Dogs AS T2 ON T1.owner_id = T2.owner_id JOIN Treatments AS T3 ON T2.dog_id = T3.dog_id GROUP BY T1.owner_id ORDER BY sum(T3.cost_of_treatment) DESC LIMIT 1	s079_dog_kennels
SELECT name , country , age FROM singer ORDER BY age DESC	s080_concert_singer
SELECT name FROM stadium EXCEPT SELECT T2.name FROM concert AS T1 JOIN stadium AS T2 ON T1.stadium_id = T2.stadium_id WHERE T1.year = 2014	s081_concert_singer
SELECT T2.name , T2.location FROM concert AS T1 JOIN stadium AS T2 ON T1.stadium_id = T2.stadium_id WHERE T1.Year = 2014 INTERSECT SELECT T2.name , T2.location FROM concert AS T1 JOIN stadium AS T2 ON T1.stadium_id = T2.stadium_id WHERE T1.Year = 2015	s082_concert_singer
SELECT Airline , Abbreviation FROM AIRLINES WHERE Country = "USA"	s083_flight_2
SELECT AirportName FROM AIRPORTS WHERE City = "Aberdeen"	s084_flight_2
SELECT count(*) , t2.name FROM hiring AS t1 JOIN shop AS t2 ON t1.shop_id = t2.shop_id GROUP BY t2.name	s085_employee_hire_evaluation
SELECT T3.Name , T2.Course FROM course_arrange AS T1 JOIN course AS T2 ON T1.Course_ID = T2.Course_ID JOIN teacher AS T3 ON T1.Teacher_ID = T3.Teacher_ID	s086_course_teach
SELECT avg(loser_age) , avg(winner_age) FROM matches	s087_wta_1
SELECT T1.degree_summary_name FROM Degree_Programs AS T1 JOIN Student_Enrolment AS T2 ON T1.degree_program_id = T2.degree_program_id GROUP BY T1.degree_summary_name ORDER BY count(*) DESC LIMIT 1	s088_student_transcripts_tracking
SELECT semester_name FROM Semesters WHERE semester_id NOT IN( SELECT semester_id FROM Student_Enrolment )	s089_student_transcripts_tracking
SELECT DISTINCT T1.course_name FROM Courses AS T1 JOIN Student_Enrolment_Courses AS T2 ON T1.course_id = T2.course_id	s090_student_transcripts_tracking
SELECT first_name , middle_name , last_name FROM Students ORDER BY date_left ASC LIMIT 1	s091_student_transcripts_tracking
SELECT T1.series_name , T1.country FROM TV_Channel AS T1 JOIN cartoon AS T2 ON T1.id = T2.Channel WHERE T2.directed_by = 'Michael Chang' INTERSECT SELECT T1.series_name , T1.country FROM TV_Channel AS T1 JOIN cartoon AS T2 ON T1.id = T2.Channel WHERE T2.directed_by = 'Ben Jones'	s092_tvshow
SELECT T1.series_name , T1.country FROM TV_Channel AS T1 JOIN cartoon AS T2 ON T1.id = T2.Channel WHERE T2.directed_by = 'Michael Chang' INTERSECT SELECT T1.series_name , T1.country FROM TV_Channel AS T1 JOIN cartoon AS T2 ON T1.id = T2.Channel WHERE T2.directed_by = 'Ben Jones'	s093_tvshow
SELECT Name FROM people WHERE People_ID NOT IN (SELECT People_ID FROM poker_player)	s094_poker_player
select contestant_name from contestants where contestant_name like "%al%"	s095_voter_1
SELECT Name FROM country ORDER BY Population ASC LIMIT 3	s096_world_1
SELECT Name FROM conductor ORDER BY Year_of_Work DESC	s097_orchestra
SELECT name FROM Highschooler EXCEPT SELECT T2.name FROM Friend AS T1 JOIN Highschooler AS T2 ON T1.student_id = T2.id	s098_network_1
SELECT date_arrived , date_departed FROM Dogs	s099_dog_kennels
SELECT DISTINCT T2.Model FROM CAR_NAMES AS T1 JOIN MODEL_LIST AS T2 ON T1.Model = T2.Model JOIN CAR_MAKERS AS T3 ON T2.Maker = T3.Id JOIN CARS_DATA AS T4 ON T1.MakeId = T4.Id WHERE T3.FullName = 'General Motors' OR T4.weight > 3500	s100_car_1
select distinct year from cars_data where weight between 3000 and 4000	s101_car_1
SELECT FlightNo FROM FLIGHTS WHERE SourceAirport = "APG"	s102_flight_2
SELECT T1.template_type_code FROM Templates AS T1 JOIN Documents AS T2 ON T1.template_id = T2.template_id WHERE T2.document_name = "Data base"	s103_cre_Doc_Template_Mgt
SELECT template_type_code FROM Templates EXCEPT SELECT template_type_code FROM Templates AS T1 JOIN Documents AS T2 ON T1.template_id = T2.template_id	s104_cre_Doc_Template_Mgt
SELECT winner_name , winner_rank_points FROM matches GROUP BY winner_name ORDER BY count(*) DESC LIMIT 1	s105_wta_1
SELECT winner_name , winner_rank_points FROM matches GROUP BY winner_name ORDER BY count(*) DESC LIMIT 1	s106_wta_1
SELECT section_name , section_description FROM Sections	s107_student_transcripts_tracking
SELECT section_name , section_description FROM Sections	s108_student_transcripts_tracking
SELECT Money_Rank FROM poker_player ORDER BY Earnings DESC LIMIT 1	s109_poker_player
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID WHERE T2.Earnings > 300000	s110_poker_player
SELECT avg(T2.Earnings) FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID WHERE T1.Height > 200	s111_poker_player
SELECT Nationality , COUNT(*) FROM people GROUP BY Nationality	s112_poker_player
SELECT avg(LifeExpectancy) FROM country WHERE Name NOT IN (SELECT T1.Name FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE T2.Language = "English" AND T2.IsOfficial = "T")	s113_world_1
SELECT T2.Language FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE T1.HeadOfState = "Beatrix" AND T2.IsOfficial = "T"	s114_world_1
SELECT DISTINCT T2.Name FROM country AS T1 JOIN city AS T2 ON T2.CountryCode = T1.Code WHERE T1.Continent = 'Europe' AND T1.Name NOT IN (SELECT T3.Name FROM country AS T3 JOIN countrylanguage AS T4 ON T3.Code = T4.CountryCode WHERE T4.IsOfficial = 'T' AND T4.Language = 'English')	s115_world_1
SELECT Record_Company FROM orchestra ORDER BY Year_of_Founded DESC	s116_orchestra
SELECT Name FROM singer ORDER BY Net_Worth_Millions ASC	s117_singer
SELECT Name FROM singer ORDER BY Net_Worth_Millions DESC LIMIT 1	s118_singer
SELECT Citizenship , max(Net_Worth_Millions) FROM singer GROUP BY Citizenship	s119_singer
SELECT count(*) FROM concert WHERE YEAR = 2014 OR YEAR = 2015	s120_concert_singer
SELECT name FROM stadium EXCEPT SELECT T2.name FROM concert AS T1 JOIN stadium AS T2 ON T1.stadium_id = T2.stadium_id WHERE T1.year = 2014	s121_concert_singer
SELECT count(*) FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid = T2.stuid JOIN pets AS T3 ON T2.petid = T3.petid WHERE T1.sex = 'F' AND T3.pettype = 'dog'	s122_pets_1
select distinct year from cars_data where weight between 3000 and 4000	s123_car_1
select t1.countryid , t1.countryname from countries as t1 join car_makers as t2 on t1.countryid = t2.country group by t1.countryid having count(*) > 3 union select t1.countryid , t1.countryname from countries as t1 join car_makers as t2 on t1.countryid = t2.country join model_list as t3 on t2.id = t3.maker where t3.model = 'fiat'	s124_car_1
SELECT AirportCode , AirportName FROM AIRPORTS WHERE city = "Anthony"	s125_flight_2
SELECT count(*) FROM FLIGHTS AS T1 JOIN AIRPORTS AS T2 ON T1.SourceAirport = T2.AirportCode WHERE T2.City = "Aberdeen"	s126_flight_2
SELECT document_id , template_id , Document_Description FROM Documents WHERE document_name = "Robbin CV"	s127_cre_Doc_Template_Mgt
SELECT count(*) FROM matches WHERE YEAR = 2013 OR YEAR = 2016	s128_wta_1
SELECT T1.name , T1.date FROM battle AS T1 JOIN ship AS T2 ON T1.id = T2.lost_in_battle WHERE T2.name = 'Lettice' INTERSECT SELECT T1.name , T1.date FROM battle AS T1 JOIN ship AS T2 ON T1.id = T2.lost_in_battle WHERE T2.name = 'HMS Atalanta'	s129_battle_death
SELECT section_description FROM Sections WHERE section_name = 'h'	s130_student_transcripts_tracking
select t1.first_name from students as t1 join addresses as t2 on t1.permanent_address_id = t2.address_id where t2.country = 'haiti' or t1.cell_mobile_number = '09700166582'	s131_student_transcripts_tracking
SELECT count(*) FROM TV_Channel WHERE LANGUAGE = "English"	s132_tvshow
SELECT T1.series_name FROM TV_Channel AS T1 JOIN TV_series AS T2 ON T1.id = T2.Channel WHERE T2.Episode = "A Love of a Lifetime"	s133_tvshow
SELECT Name FROM people WHERE Nationality != "Russia"	s134_poker_player
SELECT Continent FROM country WHERE Name = "Anguilla"	s135_world_1
SELECT sum(SurfaceArea) FROM country WHERE Continent = "Asia" OR Continent = "Europe"	s136_world_1
SELECT max(SHARE) , min(SHARE) FROM performance WHERE TYPE != "Live final"	s137_orchestra
SELECT professional_id , last_name , cell_number FROM Professionals WHERE state = 'Indiana' UNION SELECT T1.professional_id , T1.last_name , T1.cell_number FROM Professionals AS T1 JOIN Treatments AS T2 ON T1.professional_id = T2.professional_id GROUP BY T1.professional_id HAVING count(*) > 2	s138_dog_kennels
SELECT Name FROM singer WHERE Citizenship != "France"	s139_singer
SELECT T2.name , count(*) FROM singer_in_concert AS T1 JOIN singer AS T2 ON T1.singer_id = T2.singer_id GROUP BY T2.singer_id	s140_concert_singer
SELECT count(*) FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid = T2.stuid WHERE T1.age > 20	s141_pets_1
SELECT COUNT(*) FROM CARS_DATA WHERE Cylinders > 6	s142_car_1
SELECT count(*) FROM FLIGHTS WHERE DestAirport = "ATO"	s143_flight_2
SELECT count(*) FROM FLIGHTS AS T1 JOIN AIRPORTS AS T2 ON T1.DestAirport = T2.AirportCode WHERE T2.City = "Aberdeen"	s144_flight_2
SELECT count(*) FROM FLIGHTS AS T1 JOIN AIRLINES AS T2 ON T1.Airline = T2.uid WHERE T2.Airline = "JetBlue Airways"	s145_flight_2
SELECT count(*) FROM Flights AS T1 JOIN Airports AS T2 ON T1.DestAirport = T2.AirportCode WHERE T2.city = "Aberdeen" OR T2.city = "Abilene"	s146_flight_2
SELECT count(*) , LOCATION FROM shop GROUP BY LOCATION	s147_employee_hire_evaluation
SELECT count(*) FROM Documents	s148_cre_Doc_Template_Mgt
SELECT count(*) FROM Templates	s149_cre_Doc_Template_Mgt
SELECT count(*) FROM Templates WHERE template_type_code = "CV"	s150_cre_Doc_Template_Mgt
SELECT Country , count(*) FROM TV_Channel GROUP BY Country ORDER BY count(*) DESC LIMIT 1	s151_tvshow
SELECT count(*) , Directed_by FROM cartoon GROUP BY Directed_by	s152_tvshow
SELECT count(*) FROM poker_player	s153_poker_player
SELECT count(DISTINCT LANGUAGE) FROM countrylanguage	s154_world_1
SELECT COUNT(*) FROM orchestra WHERE Major_Record_Format = "CD" OR Major_Record_Format = "DVD"	s155_orchestra
SELECT count(*) FROM Highschooler WHERE grade = 9 OR grade = 10	s156_network_1
SELECT count(*) FROM Friend AS T1 JOIN Highschooler AS T2 ON T1.student_id = T2.id WHERE T2.name = "Kyle"	s157_network_1
SELECT count(DISTINCT dog_id) FROM Treatments	s158_dog_kennels
SELECT count(*) FROM Professionals WHERE professional_id NOT IN ( SELECT professional_id FROM Treatments )	s159_dog_kennels
SELECT T1.fname , T1.sex FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid = T2.stuid GROUP BY T1.stuid HAVING count(*) > 1	s160_pets_1
SELECT DISTINCT T1.model FROM MODEL_LIST AS T1 JOIN CAR_NAMES AS T2 ON T1.Model = T2.Model JOIN CARS_DATA AS T3 ON T2.MakeId = T3.Id JOIN CAR_MAKERS AS T4 ON T1.Maker = T4.Id WHERE T3.weight < 3500 AND T4.FullName != 'Ford Motor Company'	s161_car_1
SELECT manager_name , district FROM shop ORDER BY number_products DESC LIMIT 1	s162_employee_hire_evaluation
SELECT t2.name FROM hiring AS t1 JOIN shop AS t2 ON t1.shop_id = t2.shop_id GROUP BY t1.shop_id ORDER BY count(*) DESC LIMIT 1	s163_employee_hire_evaluation
SELECT T1.template_type_code , count(*) FROM Templates AS T1 JOIN Documents AS T2 ON T1.template_id = T2.template_id GROUP BY T1.template_type_code	s164_cre_Doc_Template_Mgt
SELECT count(*) FROM Paragraphs	s165_cre_Doc_Template_Mgt
SELECT t1.name , t1.age FROM visitor AS t1 JOIN visit AS t2 ON t1.id = t2.visitor_id ORDER BY t2.num_of_ticket DESC LIMIT 1	s166_museum_visit
SELECT country_code FROM players GROUP BY country_code ORDER BY count(*) DESC LIMIT 1	s167_wta_1
SELECT max(killed) , min(killed) FROM death	s168_battle_death
SELECT T1.address_id , T1.line_1 , T1.line_2 FROM Addresses AS T1 JOIN Students AS T2 ON T1.address_id = T2.current_address_id GROUP BY T1.address_id ORDER BY count(*) DESC LIMIT 1	s169_student_transcripts_tracking
SELECT transcript_date , other_details FROM Transcripts ORDER BY transcript_date ASC LIMIT 1	s170_student_transcripts_tracking
SELECT avg(Earnings) FROM poker_player	s171_poker_player
SELECT max(Final_Table_Made) FROM poker_player WHERE Earnings < 200000	s172_poker_player
SELECT avg(GNP) , sum(population) FROM country WHERE GovernmentForm = "US Territory"	s173_world_1
SELECT COUNT(*) FROM (SELECT T1.Name FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE T2.Language = "English" INTERSECT SELECT T1.Name FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE T2.Language = "Dutch")	s174_world_1
SELECT Name FROM country WHERE Continent = "Asia" AND population > (SELECT min(population) FROM country WHERE Continent = "Africa")	s175_world_1
SELECT T1.Name FROM conductor AS T1 JOIN orchestra AS T2 ON T1.Conductor_ID = T2.Conductor_ID WHERE Year_of_Founded > 2008	s176_orchestra
SELECT grade FROM Highschooler GROUP BY grade ORDER BY count(*) DESC LIMIT 1	s177_network_1
SELECT T1.owner_id , T1.last_name FROM Owners AS T1 JOIN Dogs AS T2 ON T1.owner_id = T2.owner_id JOIN Treatments AS T3 ON T2.dog_id = T3.dog_id GROUP BY T1.owner_id ORDER BY count(*) DESC LIMIT 1	s178_dog_kennels
SELECT T1.professional_id , T1.cell_number FROM Professionals AS T1 JOIN Treatments AS T2 ON T1.professional_id = T2.professional_id GROUP BY T1.professional_id HAVING count(*) >= 2	s179_dog_kennels
SELECT avg(age) , min(age) , max(age) FROM singer WHERE country = 'France'	s180_concert_singer
SELECT count(*) FROM pets WHERE weight > 10	s181_pets_1
SELECT T1.cylinders FROM CARS_DATA AS T1 JOIN CAR_NAMES AS T2 ON T1.Id = T2.MakeId WHERE T2.Model = 'volvo' ORDER BY T1.accelerate ASC LIMIT 1	s182_car_1
SELECT T1.Model FROM CAR_NAMES AS T1 JOIN CARS_DATA AS T2 ON T1.MakeId = T2.Id WHERE T2.Cylinders = 4 ORDER BY T2.horsepower DESC LIMIT 1	s183_car_1
SELECT T2.MakeId , T2.Make FROM CARS_DATA AS T1 JOIN CAR_NAMES AS T2 ON T1.Id = T2.MakeId WHERE T1.Horsepower > (SELECT min(Horsepower) FROM CARS_DATA) AND T1.Cylinders <= 3	s184_car_1
SELECT T1.AirportCode FROM AIRPORTS AS T1 JOIN FLIGHTS AS T2 ON T1.AirportCode = T2.DestAirport OR T1.AirportCode = T2.SourceAirport GROUP BY T1.AirportCode ORDER BY count(*) DESC LIMIT 1	s185_flight_2
SELECT min(Number_products) , max(Number_products) FROM shop	s186_employee_hire_evaluation
SELECT Name FROM teacher WHERE Age = 32 OR Age = 33	s187_course_teach
SELECT T1.course_name , T1.course_id FROM Courses AS T1 JOIN Sections AS T2 ON T1.course_id = T2.course_id GROUP BY T1.course_id HAVING count(*) <= 2	s188_student_transcripts_tracking
SELECT T2.transcript_date , T1.transcript_id FROM Transcript_Contents AS T1 JOIN Transcripts AS T2 ON T1.transcript_id = T2.transcript_id GROUP BY T1.transcript_id HAVING count(*) >= 2	s189_student_transcripts_tracking
SELECT transcript_date , other_details FROM Transcripts ORDER BY transcript_date ASC LIMIT 1	s190_student_transcripts_tracking
SELECT Title FROM Cartoon WHERE Directed_by = "Ben Jones" OR Directed_by = "Brandon Vietti"	s191_tvshow
SELECT Package_Option FROM TV_Channel WHERE series_name = "Sky Radio"	s192_tvshow
SELECT LANGUAGE , count(*) FROM TV_Channel GROUP BY LANGUAGE ORDER BY count(*) ASC LIMIT 1	s193_tvshow
SELECT Earnings FROM poker_player ORDER BY Earnings DESC	s194_poker_player
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID ORDER BY T2.Final_Table_Made	s195_poker_player
SELECT Name FROM country WHERE Continent = "Asia" ORDER BY LifeExpectancy LIMIT 1	s196_world_1
SELECT Record_Company FROM orchestra GROUP BY Record_Company ORDER BY COUNT(*) DESC LIMIT 1	s197_orchestra
SELECT grade FROM Highschooler GROUP BY grade HAVING count(*) >= 4	s198_network_1
SELECT first_name , last_name , email_address FROM Owners WHERE state LIKE '%North%'	s199_dog_kennels
SELECT count(*) FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid = T2.stuid WHERE T1.age > 20	s200_pets_1
SELECT avg(weight) , pettype FROM pets GROUP BY pettype	s201_pets_1
SELECT count(*) FROM CAR_MAKERS AS T1 JOIN COUNTRIES AS T2 ON T1.Country = T2.CountryId WHERE T2.CountryName = 'france'	s202_car_1
select min(weight) from cars_data where cylinders = 8 and year = 1974	s203_car_1
SELECT T1.CountryName FROM COUNTRIES AS T1 JOIN CONTINENTS AS T2 ON T1.Continent = T2.ContId JOIN CAR_MAKERS AS T3 ON T1.CountryId = T3.Country WHERE T2.Continent = 'europe' GROUP BY T1.CountryName HAVING count(*) >= 3	s204_car_1
SELECT count(*) FROM AIRPORTS	s205_flight_2
SELECT t1.name FROM employee AS t1 JOIN evaluation AS t2 ON t1.Employee_ID = t2.Employee_ID GROUP BY t2.Employee_ID ORDER BY count(*) DESC LIMIT 1	s206_employee_hire_evaluation
SELECT template_id FROM Documents GROUP BY template_id HAVING count(*) > 1	s207_cre_Doc_Template_Mgt
SELECT DISTINCT T1.template_type_description FROM Ref_template_types AS T1 JOIN Templates AS T2 ON T1.template_type_code = T2.template_type_code JOIN Documents AS T3 ON T2.Template_ID = T3.template_ID	s208_cre_Doc_Template_Mgt
SELECT count(*) FROM teacher	s209_course_teach
SELECT avg(num_of_staff) FROM museum WHERE open_year < 2009	s210_museum_visit
select cell_mobile_number from students where first_name = 'timmothy' and last_name = 'ward'	s211_student_transcripts_tracking
SELECT T2.Money_Rank FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID ORDER BY T1.Height DESC LIMIT 1	s212_poker_player
SELECT Name FROM country WHERE Continent = "Africa" AND population < (SELECT min(population) FROM country WHERE Continent = "Asia")	s213_world_1
SELECT count(*) FROM conductor	s214_orchestra
SELECT student_id FROM Friend INTERSECT SELECT liked_id FROM Likes	s215_network_1
SELECT T1.date_of_treatment , T2.first_name FROM Treatments AS T1 JOIN Professionals AS T2 ON T1.professional_id = T2.professional_id	s216_dog_kennels
SELECT first_name , last_name , email_address FROM Owners WHERE state LIKE '%North%'	s217_dog_kennels
SELECT count(*) FROM Dogs WHERE age < ( SELECT avg(age) FROM Dogs )	s218_dog_kennels
SELECT T2.Title , T1.Name FROM singer AS T1 JOIN song AS T2 ON T1.Singer_ID = T2.Singer_ID	s219_singer
SELECT DISTINCT country FROM singer WHERE age > 20	s220_concert_singer
select min(weight) from cars_data where cylinders = 8 and year = 1974	s221_car_1
SELECT COUNT(*) FROM CARS_DATA WHERE Cylinders > 6	s222_car_1
SELECT T1.Model FROM CAR_NAMES AS T1 JOIN CARS_DATA AS T2 ON T1.MakeId = T2.Id WHERE T2.Cylinders = 4 ORDER BY T2.horsepower DESC LIMIT 1	s223_car_1
SELECT DISTINCT T1.model FROM MODEL_LIST AS T1 JOIN CAR_NAMES AS T2 ON T1.Model = T2.Model JOIN CARS_DATA AS T3 ON T2.MakeId = T3.Id JOIN CAR_MAKERS AS T4 ON T1.Maker = T4.Id WHERE T3.weight < 3500 AND T4.FullName != 'Ford Motor Company'	s224_car_1
SELECT T1.countryId , T1.CountryName FROM Countries AS T1 JOIN CAR_MAKERS AS T2 ON T1.CountryId = T2.Country GROUP BY T1.countryId HAVING count(*) > 3 UNION SELECT T1.countryId , T1.CountryName FROM Countries AS T1 JOIN CAR_MAKERS AS T2 ON T1.CountryId = T2.Country JOIN MODEL_LIST AS T3 ON T2.Id = T3.Maker WHERE T3.Model = 'fiat'	s225_car_1
SELECT count(*) FROM AIRLINES AS T1 JOIN FLIGHTS AS T2 ON T2.Airline = T1.uid WHERE T1.Airline = "United Airlines" AND T2.SourceAirport = "AHD"	s226_flight_2
SELECT district FROM shop WHERE Number_products < 3000 INTERSECT SELECT district FROM shop WHERE Number_products > 10000	s227_employee_hire_evaluation
SELECT version_number , template_type_code FROM Templates WHERE version_number > 5	s228_cre_Doc_Template_Mgt
SELECT version_number , template_type_code FROM Templates WHERE version_number > 5	s229_cre_Doc_Template_Mgt
SELECT template_type_code FROM Templates GROUP BY template_type_code HAVING count(*) < 3	s230_cre_Doc_Template_Mgt
SELECT T1.paragraph_text FROM Paragraphs AS T1 JOIN Documents AS T2 ON T1.document_id = T2.document_id WHERE T2.document_name = "Customer reviews"	s231_cre_Doc_Template_Mgt
SELECT document_id FROM Paragraphs GROUP BY document_id HAVING count(*) BETWEEN 1 AND 2	s232_cre_Doc_Template_Mgt
SELECT T3.Name FROM course_arrange AS T1 JOIN course AS T2 ON T1.Course_ID = T2.Course_ID JOIN teacher AS T3 ON T1.Teacher_ID = T3.Teacher_ID WHERE T2.Course = "Math"	s233_course_teach
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID WHERE T2.Earnings > 300000	s234_poker_player
SELECT Name FROM country WHERE SurfaceArea > (SELECT min(SurfaceArea) FROM country WHERE Continent = "Europe")	s235_world_1
SELECT Name FROM country ORDER BY Population DESC LIMIT 3	s236_world_1
SELECT name FROM city WHERE Population BETWEEN 160000 AND 900000	s237_world_1
SELECT T2.name FROM Likes AS T1 JOIN Highschooler AS T2 ON T1.student_id = T2.id GROUP BY T1.student_id HAVING count(*) >= 2	s238_network_1
SELECT T1.first_name , T2.name FROM Owners AS T1 JOIN Dogs AS T2 ON T1.owner_id = T2.owner_id WHERE T1.state = 'Virginia'	s239_dog_kennels
select t2.name , t2.capacity from concert as t1 join stadium as t2 on t1.stadium_id = t2.stadium_id where t1.year > 2014 group by t2.stadium_id order by count(*) desc limit 1	s240_concert_singer
SELECT T2.name , T2.location FROM concert AS T1 JOIN stadium AS T2 ON T1.stadium_id = T2.stadium_id WHERE T1.Year = 2014 INTERSECT SELECT T2.name , T2.location FROM concert AS T1 JOIN stadium AS T2 ON T1.stadium_id = T2.stadium_id WHERE T1.Year = 2014	s241_concert_singer
SELECT petid , weight FROM pets WHERE pet_age > 2	s242_pets_1
SELECT petid , weight FROM pets WHERE pet_age > 2	s243_pets_1
SELECT DISTINCT T1.model FROM MODEL_LIST AS T1 JOIN CAR_NAMES AS T2 ON T1.model = T2.model JOIN CARS_DATA AS T3 ON T2.MakeId = T3.id WHERE T3.year > 1976	s244_car_1
SELECT avg(mpg) FROM CARS_DATA WHERE Cylinders = 6	s245_car_1
SELECT count(*) FROM CARS_DATA WHERE Cylinders > 1	s246_car_1
SELECT count(*) FROM CARS_DATA WHERE YEAR = 1976	s247_car_1
SELECT t1.name FROM visitor AS t1 JOIN visit AS t2 ON t1.id = t2.visitor_id JOIN museum AS t3 ON t3.Museum_ID = t2.Museum_ID WHERE t3.open_year < 2019 INTERSECT SELECT t1.name FROM visitor AS t1 JOIN visit AS t2 ON t1.id = t2.visitor_id JOIN museum AS t3 ON t3.Museum_ID = t2.Museum_ID WHERE t3.open_year > 2011	s248_museum_visit
SELECT count(*) FROM visitor WHERE id NOT IN (SELECT t2.visitor_id FROM museum AS t1 JOIN visit AS t2 ON t1.Museum_ID = t2.Museum_ID WHERE t1.open_year > 2019)	s249_museum_visit
SELECT winner_name FROM matches WHERE YEAR = 2013 INTERSECT SELECT winner_name FROM matches WHERE YEAR = 2013	s250_wta_1
SELECT Name FROM country WHERE IndepYear > 1957	s251_world_1
SELECT count(DISTINCT T2.Language) FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE IndepYear < 1920 AND T2.IsOfficial = "T"	s252_world_1
SELECT count(DISTINCT T2.Language) FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE IndepYear < 1923 AND T2.IsOfficial = "T"	s253_world_1
SELECT sum(Population) , GovernmentForm FROM country GROUP BY GovernmentForm HAVING avg(LifeExpectancy) > 82	s254_world_1
SELECT sum(Population) , GovernmentForm FROM country GROUP BY GovernmentForm HAVING avg(LifeExpectancy) > 66	s255_world_1
SELECT sum(Population) , avg(LifeExpectancy) , Continent FROM country GROUP BY Continent HAVING avg(LifeExpectancy) < 76	s256_world_1
SELECT name FROM Highschooler WHERE grade = 9	s257_network_1
SELECT T2.name FROM Friend AS T1 JOIN Highschooler AS T2 ON T1.student_id = T2.id WHERE T2.grade > 9 GROUP BY T1.student_id HAVING count(*) >= 2	s258_network_1
SELECT Name FROM singer WHERE Birth_Year = 1952 OR Birth_Year = 1949	s259_singer
SELECT count(*) FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid = T2.stuid JOIN pets AS T3 ON T2.petid = T3.petid WHERE T1.sex = 'F' AND T3.pettype = 'cat'	s260_pets_1
SELECT DISTINCT T1.Fname FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid = T2.stuid JOIN pets AS T3 ON T3.petid = T2.petid WHERE T3.pettype = 'cat' OR T3.pettype = 'cat'	s261_pets_1
SELECT count(*) FROM Templates WHERE template_type_code = "BK"	s262_cre_Doc_Template_Mgt
SELECT T1.paragraph_id , T1.paragraph_text FROM Paragraphs AS T1 JOIN Documents AS T2 ON T1.document_id = T2.document_id WHERE T2.Document_Name = 'Summer Show'	s263_cre_Doc_Template_Mgt
SELECT Num_of_Staff , Open_Year FROM museum WHERE name = 'RiverPark Museum'	s264_museum_visit
SELECT winner_name FROM matches WHERE tourney_name = 'Birmingham' ORDER BY winner_rank_points DESC LIMIT 1	s265_wta_1
SELECT name , RESULT , bulgarian_commander FROM battle EXCEPT SELECT T1.name , T1.result , T1.bulgarian_commander FROM battle AS T1 JOIN ship AS T2 ON T1.id = T2.lost_in_battle WHERE T2.location = 'Mid-Atlantic'	s266_battle_death
SELECT section_description FROM Sections WHERE section_name = 'c'	s267_student_transcripts_tracking
select t1.first_name from students as t1 join addresses as t2 on t1.permanent_address_id = t2.address_id where t2.country = 'haiti' or t1.cell_mobile_number = '(462)246-7921'	s268_student_transcripts_tracking
SELECT Air_Date FROM TV_series WHERE Episode = "Emily"	s269_tvshow
SELECT T2.Episode FROM TV_Channel AS T1 JOIN TV_series AS T2 ON T1.id = T2.Channel WHERE T1.series_name = "MTV Music"	s270_tvshow
SELECT Pixel_aspect_ratio_PAR , country FROM tv_channel WHERE LANGUAGE != 'Italian'	s271_tvshow
SELECT contestant_name FROM contestants WHERE contestant_name != 'Nita Coster'	s272_voter_1
SELECT T3.area_code FROM contestants AS T1 JOIN votes AS T2 ON T1.contestant_number = T2.contestant_number JOIN area_code_state AS T3 ON T2.state = T3.state WHERE T1.contestant_name = 'Kelly Clauss' INTERSECT SELECT T3.area_code FROM contestants AS T1 JOIN votes AS T2 ON T1.contestant_number = T2.contestant_number JOIN area_code_state AS T3 ON T2.state = T3.state WHERE T1.contestant_name = 'Kelly Clauss'	s273_voter_1
SELECT T2.Language FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE T1.Name = "Lesotho" ORDER BY Percentage DESC LIMIT 1	s274_world_1
SELECT Population , Region FROM country WHERE Name = "Hong Kong"	s275_world_1
SELECT T2.Language FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE T1.HeadOfState = "Ricardo Lagos Escobar" AND T2.IsOfficial = "T"	s276_world_1
SELECT max(SHARE) , min(SHARE) FROM performance WHERE TYPE != "Auditions 1"	s277_orchestra
SELECT grade FROM Highschooler WHERE name = "Kris"	s278_network_1
SELECT T2.feature_type_name FROM Other_Available_Features AS T1 JOIN Ref_Feature_Types AS T2 ON T1.feature_type_code = T2.feature_type_code WHERE T1.feature_name = "BurglarAlarm"	s279_real_estate_properties
SELECT T1.CountryName FROM COUNTRIES AS T1 JOIN CONTINENTS AS T2 ON T1.Continent = T2.ContId JOIN CAR_MAKERS AS T3 ON T1.CountryId = T3.Country WHERE T2.Continent = 'europe' GROUP BY T1.CountryName HAVING count(*) >= 4	s280_car_1
SELECT T1.FullName , T1.Id FROM CAR_MAKERS AS T1 JOIN MODEL_LIST AS T2 ON T1.Id = T2.Maker GROUP BY T1.Id HAVING count(*) > 2	s281_car_1
select count(*) from countries as t1 join car_makers as t2 on t1.countryid = t2.country group by t1.countryid having count(*) > 4	s282_car_1
select count(*) from countries as t1 join car_makers as t2 on t1.countryid = t2.country group by t1.countryid having count(*) > 4	s283_car_1
SELECT template_type_code FROM Templates GROUP BY template_type_code HAVING count(*) < 6	s284_cre_Doc_Template_Mgt
SELECT document_id FROM Paragraphs GROUP BY document_id HAVING count(*) >= 3	s285_cre_Doc_Template_Mgt
SELECT document_id FROM Paragraphs GROUP BY document_id HAVING count(*) >= 3	s286_cre_Doc_Template_Mgt
SELECT tourney_name FROM matches GROUP BY tourney_name HAVING count(*) > 14	s287_wta_1
SELECT country_code FROM players GROUP BY country_code HAVING count(*) > 46	s288_wta_1
SELECT T1.first_name , T1.middle_name , T1.last_name , T1.student_id FROM Students AS T1 JOIN Student_Enrolment AS T2 ON T1.student_id = T2.student_id GROUP BY T1.student_id HAVING count(*) = 3	s289_student_transcripts_tracking
SELECT Episode , Rating FROM TV_series ORDER BY Rating DESC LIMIT 5	s290_tvshow
SELECT Episode , Rating FROM TV_series ORDER BY Rating DESC LIMIT 11	s291_tvshow
SELECT COUNT(T2.Language) , T1.Name FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode GROUP BY T1.Name HAVING COUNT(*) > 8	s292_world_1
SELECT Name FROM country ORDER BY Population DESC LIMIT 5	s293_world_1
SELECT T2.name FROM Friend AS T1 JOIN Highschooler AS T2 ON T1.student_id = T2.id GROUP BY T1.student_id HAVING count(*) >= 2	s294_network_1
SELECT T2.name FROM Friend AS T1 JOIN Highschooler AS T2 ON T1.student_id = T2.id WHERE T2.grade > 5 GROUP BY T1.student_id HAVING count(*) >= 3	s295_network_1
SELECT professional_id , last_name , cell_number FROM Professionals WHERE state = 'Indiana' UNION SELECT T1.professional_id , T1.last_name , T1.cell_number FROM Professionals AS T1 JOIN Treatments AS T2 ON T1.professional_id = T2.professional_id GROUP BY T1.professional_id HAVING count(*) > 9	s296_dog_kennels
SELECT T1.professional_id , T1.role_code , T1.first_name FROM Professionals AS T1 JOIN Treatments AS T2 ON T1.professional_id = T2.professional_id GROUP BY T1.professional_id HAVING count(*) >= 3	s297_dog_kennels
SELECT T1.professional_id , T1.role_code , T1.first_name FROM Professionals AS T1 JOIN Treatments AS T2 ON T1.professional_id = T2.professional_id GROUP BY T1.professional_id HAVING count(*) >= 3	s298_dog_kennels
SELECT T1.professional_id , T1.cell_number FROM Professionals AS T1 JOIN Treatments AS T2 ON T1.professional_id = T2.professional_id GROUP BY T1.professional_id HAVING count(*) >= 3	s299_dog_kennels
SELECT song_name FROM singer WHERE age < (SELECT avg(age) FROM singer)	s300_concert_singer
SELECT count(*) FROM pets WHERE weight < 10	s301_pets_1
SELECT T1.CountryName , T1.CountryId FROM COUNTRIES AS T1 JOIN CAR_MAKERS AS T2 ON T1.CountryId = T2.Country GROUP BY T1.CountryId HAVING count(*) > 1	s302_car_1
SELECT avg(horsepower) FROM CARS_DATA WHERE YEAR > 1980	s303_car_1
select avg(horsepower) from cars_data where year > 1980	s304_car_1
SELECT T1.FullName , T1.Id FROM CAR_MAKERS AS T1 JOIN MODEL_LIST AS T2 ON T1.Id = T2.Maker GROUP BY T1.Id HAVING count(*) <= 3	s305_car_1
SELECT DISTINCT T2.Model FROM CAR_NAMES AS T1 JOIN MODEL_LIST AS T2 ON T1.Model = T2.Model JOIN CAR_MAKERS AS T3 ON T2.Maker = T3.Id JOIN CARS_DATA AS T4 ON T1.MakeId = T4.Id WHERE T3.FullName = 'General Motors' OR T4.weight < 3500	s306_car_1
SELECT name FROM shop WHERE number_products < (SELECT avg(number_products) FROM shop)	s307_employee_hire_evaluation
SELECT name FROM shop WHERE number_products < (SELECT avg(number_products) FROM shop)	s308_employee_hire_evaluation
SELECT country_code FROM players GROUP BY country_code HAVING count(*) < 50	s309_wta_1
SELECT T1.course_name , T1.course_id FROM Courses AS T1 JOIN Sections AS T2 ON T1.course_id = T2.course_id GROUP BY T1.course_id HAVING count(*) >= 2	s310_student_transcripts_tracking
SELECT T2.transcript_date , T1.transcript_id FROM Transcript_Contents AS T1 JOIN Transcripts AS T2 ON T1.transcript_id = T2.transcript_id GROUP BY T1.transcript_id HAVING count(*) < 2	s311_student_transcripts_tracking
SELECT id FROM tv_channel GROUP BY country HAVING count(*) < 2	s312_tvshow
SELECT Nationality FROM people GROUP BY Nationality HAVING COUNT(*) < 2	s313_poker_player
SELECT Name FROM country WHERE Continent = "Asia" AND population < (SELECT max(population) FROM country WHERE Continent = "Africa")	s314_world_1
SELECT count(*) , District FROM city WHERE Population < (SELECT avg(Population) FROM city) GROUP BY District	s315_world_1
SELECT sum(Population) , avg(LifeExpectancy) , Continent FROM country GROUP BY Continent HAVING avg(LifeExpectancy) > 72	s316_world_1
SELECT T2.name FROM Friend AS T1 JOIN Highschooler AS T2 ON T1.student_id = T2.id GROUP BY T1.student_id HAVING count(*) <= 3	s317_network_1
SELECT DISTINCT T1.Name FROM singer AS T1 JOIN song AS T2 ON T1.Singer_ID = T2.Singer_ID WHERE T2.Sales <= 300000	s318_singer
SELECT DISTINCT T1.Name FROM singer AS T1 JOIN song AS T2 ON T1.Singer_ID = T2.Singer_ID WHERE T2.Sales < 300000	s319_singer
SELECT song_name , song_release_year FROM singer ORDER BY age DESC LIMIT 1	s320_concert_singer
SELECT YEAR FROM concert GROUP BY YEAR ORDER BY count(*) ASC LIMIT 1	s321_concert_singer
SELECT T2.horsepower , T1.Make FROM CAR_NAMES AS T1 JOIN CARS_DATA AS T2 ON T1.MakeId = T2.Id WHERE T2.cylinders = 3 ORDER BY T2.horsepower ASC LIMIT 1	s322_car_1
SELECT T1.Abbreviation , T1.Country FROM AIRLINES AS T1 JOIN FLIGHTS AS T2 ON T1.uid = T2.Airline GROUP BY T1.Airline ORDER BY count(*) DESC LIMIT 1	s323_flight_2
SELECT manager_name , district FROM shop ORDER BY number_products ASC LIMIT 1	s324_employee_hire_evaluation
SELECT t1.name FROM employee AS t1 JOIN evaluation AS t2 ON t1.Employee_ID = t2.Employee_ID ORDER BY t2.bonus ASC LIMIT 1	s325_employee_hire_evaluation
SELECT winner_name , loser_name FROM matches ORDER BY minutes ASC LIMIT 1	s326_wta_1
SELECT section_name FROM Sections ORDER BY section_name ASC	s327_student_transcripts_tracking
SELECT T1.semester_name , T1.semester_id FROM Semesters AS T1 JOIN Student_Enrolment AS T2 ON T1.semester_id = T2.semester_id GROUP BY T1.semester_id ORDER BY count(*) ASC LIMIT 1	s328_student_transcripts_tracking
SELECT first_name , middle_name , last_name FROM Students ORDER BY date_left DESC LIMIT 1	s329_student_transcripts_tracking
SELECT T2.transcript_date , T1.transcript_id FROM Transcript_Contents AS T1 JOIN Transcripts AS T2 ON T1.transcript_id = T2.transcript_id GROUP BY T1.transcript_id ORDER BY count(*) DESC LIMIT 1	s330_student_transcripts_tracking
SELECT T1.Birth_Date FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID ORDER BY T2.Earnings DESC LIMIT 1	s331_poker_player
SELECT Nationality FROM people GROUP BY Nationality ORDER BY COUNT(*) ASC LIMIT 1	s332_poker_player
SELECT Name , Birth_Date FROM people ORDER BY Name DESC	s333_poker_player
SELECT T2.Language FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE T1.Name = "Aruba" ORDER BY Percentage ASC LIMIT 1	s334_world_1
SELECT T1.Continent FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode GROUP BY T1.Continent ORDER BY COUNT(*) ASC LIMIT 1	s335_world_1
SELECT Name FROM conductor ORDER BY Age DESC	s336_orchestra
SELECT Name FROM conductor ORDER BY Year_of_Work ASC LIMIT 1	s337_orchestra
SELECT T1.Name FROM conductor AS T1 JOIN orchestra AS T2 ON T1.Conductor_ID = T2.Conductor_ID GROUP BY T2.Conductor_ID ORDER BY COUNT(*) ASC LIMIT 1	s338_orchestra
SELECT grade FROM Highschooler GROUP BY grade ORDER BY count(*) ASC LIMIT 1	s339_network_1
