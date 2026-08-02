SELECT teacher.first_name , teacher.last_name , count(*) FROM course_arrange JOIN teacher ON course_arrange.Teacher_ID = teacher.Teacher_ID GROUP BY teacher.first_name , teacher.last_name	s003_course_teach_1
SELECT DISTINCT Student_Enrolment.semester_id FROM Degree_Programs JOIN Student_Enrolment ON Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id WHERE Degree_Programs.is_master = "T" INTERSECT SELECT DISTINCT Student_Enrolment.semester_id FROM Degree_Programs JOIN Student_Enrolment ON Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id WHERE Degree_Programs.is_bachelor = "T"	s007_student_transcripts_tracking_0
SELECT max(Pets.wt) , Pets.PetType FROM Pets GROUP BY Pets.PetType	s020_pets_1_1
SELECT airports.City , airports.cntry FROM airports WHERE airports.apt_name = "Alton"	s024_flight_2_4
SELECT Templates.template_kind_codification FROM Templates EXCEPT SELECT Templates.template_kind_codification FROM Templates JOIN Documents ON Templates.Template_ID = Documents.Template_ID	s048_cre_Doc_Template_Mgt_2
SELECT singer.Name FROM singer WHERE singer.born_date = 1948 or singer.born_date = 1949	s058_singer_4
SELECT winner_name FROM matches WHERE tourney_name = 'Australian Open' ORDER BY winner_rank_points DESC LIMIT 1	s067_wta_1
SELECT Money_Rank FROM poker_player ORDER BY Earnings DESC LIMIT 1	s072_poker_player
SELECT name FROM stadium EXCEPT SELECT T2.name FROM concert AS T1 JOIN stadium AS T2 ON T1.stadium_id = T2.stadium_id WHERE T1.year = 2014	s081_concert_singer
SELECT avg(loser_age) , avg(winner_age) FROM matches	s087_wta_1
SELECT template_type_code FROM Templates EXCEPT SELECT template_type_code FROM Templates AS T1 JOIN Documents AS T2 ON T1.template_id = T2.template_id	s104_cre_Doc_Template_Mgt
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID WHERE T2.Earnings > 300000	s110_poker_player
select distinct year from cars_data where weight between 3000 and 4000	s123_car_1
select t1.first_name from students as t1 join addresses as t2 on t1.permanent_address_id = t2.address_id where t2.country = 'haiti' or t1.cell_mobile_number = '09700166582'	s131_student_transcripts_tracking
SELECT count(*) FROM Documents	s148_cre_Doc_Template_Mgt
SELECT count(*) FROM Friend AS T1 JOIN Highschooler AS T2 ON T1.student_id = T2.id WHERE T2.name = "Kyle"	s157_network_1
SELECT manager_name , district FROM shop ORDER BY number_products DESC LIMIT 1	s162_employee_hire_evaluation
SELECT T1.template_type_code , count(*) FROM Templates AS T1 JOIN Documents AS T2 ON T1.template_id = T2.template_id GROUP BY T1.template_type_code	s164_cre_Doc_Template_Mgt
SELECT Package_Option FROM TV_Channel WHERE series_name = "Sky Radio"	s192_tvshow
SELECT grade FROM Highschooler GROUP BY grade HAVING count(*) >= 4	s198_network_1
SELECT count(*) FROM CAR_MAKERS AS T1 JOIN COUNTRIES AS T2 ON T1.Country = T2.CountryId WHERE T2.CountryName = 'france'	s202_car_1
SELECT Name FROM country WHERE Continent = "Africa" AND population < (SELECT min(population) FROM country WHERE Continent = "Asia")	s213_world_1
select min(weight) from cars_data where cylinders = 8 and year = 1974	s221_car_1
SELECT DISTINCT T1.model FROM MODEL_LIST AS T1 JOIN CAR_NAMES AS T2 ON T1.Model = T2.Model JOIN CARS_DATA AS T3 ON T2.MakeId = T3.Id JOIN CAR_MAKERS AS T4 ON T1.Maker = T4.Id WHERE T3.weight < 3500 AND T4.FullName != 'Ford Motor Company'	s224_car_1
select t2.name , t2.capacity from concert as t1 join stadium as t2 on t1.stadium_id = t2.stadium_id where t1.year > 2014 group by t2.stadium_id order by count(*) desc limit 1	s240_concert_singer
SELECT petid , weight FROM pets WHERE pet_age > 2	s243_pets_1
SELECT count(*) FROM Templates WHERE template_type_code = "BK"	s262_cre_Doc_Template_Mgt
SELECT Population , Region FROM country WHERE Name = "Hong Kong"	s275_world_1
SELECT document_id FROM Paragraphs GROUP BY document_id HAVING count(*) >= 3	s286_cre_Doc_Template_Mgt
SELECT Name FROM country ORDER BY Population DESC LIMIT 5	s293_world_1
SELECT name FROM shop WHERE number_products < (SELECT avg(number_products) FROM shop)	s307_employee_hire_evaluation
SELECT id FROM tv_channel GROUP BY country HAVING count(*) < 2	s312_tvshow
SELECT Name FROM conductor ORDER BY Age DESC	s336_orchestra
SELECT T1.Name FROM conductor AS T1 JOIN orchestra AS T2 ON T1.Conductor_ID = T2.Conductor_ID GROUP BY T2.Conductor_ID ORDER BY COUNT(*) ASC LIMIT 1	s338_orchestra
