SELECT teacher.first_name , teacher.last_name , count(*) FROM course_arrange JOIN teacher ON course_arrange.Teacher_ID = teacher.Teacher_ID GROUP BY teacher.first_name , teacher.last_name	s003_course_teach_1
SELECT conductor.first_name , conductor.last_name FROM conductor WHERE conductor.Nationality != "USA"	s014_orchestra_3
SELECT max(Pets.wt) , Pets.PetType FROM Pets GROUP BY Pets.PetType	s020_pets_1_1
SELECT Templates.Template_ID FROM Templates EXCEPT SELECT Documents.tpl_id FROM Documents	s029_cre_Doc_Template_Mgt_1
SELECT Templates.template_kind_codification FROM Templates EXCEPT SELECT Templates.template_kind_codification FROM Templates JOIN Documents ON Templates.Template_ID = Documents.Template_ID	s048_cre_Doc_Template_Mgt_2
SELECT T2.horsepower , T1.Make FROM CAR_NAMES AS T1 JOIN CARS_DATA AS T2 ON T1.MakeId = T2.Id WHERE T2.cylinders = 3 ORDER BY T2.horsepower DESC LIMIT 1	s062_car_1
SELECT winner_name FROM matches WHERE tourney_name = 'Australian Open' ORDER BY winner_rank_points DESC LIMIT 1	s067_wta_1
SELECT Airline , Abbreviation FROM AIRLINES WHERE Country = "USA"	s083_flight_2
SELECT avg(loser_age) , avg(winner_age) FROM matches	s087_wta_1
SELECT template_type_code FROM Templates EXCEPT SELECT template_type_code FROM Templates AS T1 JOIN Documents AS T2 ON T1.template_id = T2.template_id	s104_cre_Doc_Template_Mgt
select distinct year from cars_data where weight between 3000 and 4000	s123_car_1
select t1.first_name from students as t1 join addresses as t2 on t1.permanent_address_id = t2.address_id where t2.country = 'haiti' or t1.cell_mobile_number = '09700166582'	s131_student_transcripts_tracking
SELECT count(*) , Directed_by FROM cartoon GROUP BY Directed_by	s152_tvshow
SELECT count(*) FROM Friend AS T1 JOIN Highschooler AS T2 ON T1.student_id = T2.id WHERE T2.name = "Kyle"	s157_network_1
SELECT manager_name , district FROM shop ORDER BY number_products DESC LIMIT 1	s162_employee_hire_evaluation
SELECT avg(Earnings) FROM poker_player	s171_poker_player
SELECT grade FROM Highschooler GROUP BY grade HAVING count(*) >= 4	s198_network_1
SELECT T1.CountryName FROM COUNTRIES AS T1 JOIN CONTINENTS AS T2 ON T1.Continent = T2.ContId JOIN CAR_MAKERS AS T3 ON T1.CountryId = T3.Country WHERE T2.Continent = 'europe' GROUP BY T1.CountryName HAVING count(*) >= 3	s204_car_1
SELECT Name FROM country WHERE Continent = "Africa" AND population < (SELECT min(population) FROM country WHERE Continent = "Asia")	s213_world_1
select min(weight) from cars_data where cylinders = 8 and year = 1974	s221_car_1
SELECT version_number , template_type_code FROM Templates WHERE version_number > 5	s229_cre_Doc_Template_Mgt
select t2.name , t2.capacity from concert as t1 join stadium as t2 on t1.stadium_id = t2.stadium_id where t1.year > 2014 group by t2.stadium_id order by count(*) desc limit 1	s240_concert_singer
SELECT count(*) FROM Templates WHERE template_type_code = "BK"	s262_cre_Doc_Template_Mgt
SELECT contestant_name FROM contestants WHERE contestant_name != 'Nita Coster'	s272_voter_1
SELECT document_id FROM Paragraphs GROUP BY document_id HAVING count(*) >= 3	s286_cre_Doc_Template_Mgt
SELECT tourney_name FROM matches GROUP BY tourney_name HAVING count(*) > 14	s287_wta_1
SELECT avg(horsepower) FROM CARS_DATA WHERE YEAR > 1980	s303_car_1
SELECT name FROM shop WHERE number_products < (SELECT avg(number_products) FROM shop)	s307_employee_hire_evaluation
SELECT T1.Birth_Date FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID = T2.People_ID ORDER BY T2.Earnings DESC LIMIT 1	s331_poker_player
SELECT Name FROM conductor ORDER BY Age DESC	s336_orchestra
