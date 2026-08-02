select teacher.first_name, teacher.last_name, count(*) from teacher join course_arrange on teacher.Teacher_ID = course_arrange.Teacher_ID group by teacher.Teacher_ID	s003_course_teach_1
select distinct Semesters.semester_id from Semesters inner join Student_Enrolment on Student_Enrolment.semester_id = Semesters.semester_id inner join Degree_Programs on Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id where (Degree_Programs.is_bachelor = "T") intersect select distinct Semesters.semester_id from Semesters inner join Student_Enrolment on Student_Enrolment.semester_id = Semesters.semester_id inner join Degree_Programs on Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id where (Degree_Programs.is_master = "T")	s007_student_transcripts_tracking_0
select PetType, max(wt) from Pets group by PetType	s020_pets_1_1
select City, cntry from airports where apt_name = "Alton"	s024_flight_2_4
select category_cipher from Ref_Template_Types except select template_kind_codification from Templates join Documents on Templates.Template_ID = Documents.Template_ID	s048_cre_Doc_Template_Mgt_2
select Name from singer where born_date = 1948 or born_date = 1949	s058_singer_4
select players.first_name, players.last_name from players join matches on matches.winner_id = players.player_id where matches.tourney_name = "Australian Open" order by matches.winner_rank desc limit 1	s067_wta_1
select Money_Rank from poker_player order by Earnings desc limit 1	s072_poker_player
select stadium.Name from stadium where not EXISTS(select 1 from concert where concert.Stadium_ID = stadium.Stadium_ID and concert.Year = "2014")	s081_concert_singer
select avg(winner_age), avg(loser_age) from matches	s087_wta_1
select Template_Type_Code from Ref_Template_Types where not Template_Type_Code in (select T1.Template_Type_Code from Templates as T1 join Documents as T2 on T1.Template_ID = T2.Template_ID)	s104_cre_Doc_Template_Mgt
select people.Name from poker_player inner join people on poker_player.People_ID = people.People_ID where poker_player.Earnings > 300000	s110_poker_player
select distinct Year from cars_data where Weight < 4000 and Weight > 3000	s123_car_1
select Students.first_name from Students join Addresses on Students.permanent_address_id = Addresses.address_id where Addresses.country = "Haiti" or Students.cell_mobile_number = "09700166582"	s131_student_transcripts_tracking
select count(*) from Documents	s148_cre_Doc_Template_Mgt
select count(*) from Highschooler inner join Friend on Highschooler.ID = Friend.student_id where Highschooler.name = "Kyle"	s157_network_1
select Manager_name, District from shop order by Number_products desc limit 1	s162_employee_hire_evaluation
select Ref_Template_Types.Template_Type_Code, count(*) from Ref_Template_Types join Templates on Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code join Documents on Documents.Template_ID = Templates.Template_ID group by Ref_Template_Types.Template_Type_Code	s164_cre_Doc_Template_Mgt
select Package_Option from TV_Channel where series_name = "Sky Radio"	s192_tvshow
select grade from Highschooler group by grade having count(*) >= 4	s198_network_1
select count(*) from car_makers join countries on car_makers.Country = countries.CountryId where countries.CountryName = "france"	s202_car_1
select Name from country where Continent = "Africa" and Population < (select Population from country where Continent = "Asia" order by Population asc limit 1)	s213_world_1
select min(Weight) from cars_data where Cylinders = 8 and Year = 1974	s221_car_1
select cars_data.Id from cars_data join car_names on cars_data.Id = car_names.MakeId join model_list on car_names.Model = model_list.Model join car_makers on model_list.Maker = car_makers.Id where cars_data.Weight < 3500 and car_makers.Maker <> "ford"	s224_car_1
select stadium.Name, stadium.Capacity from stadium join concert on concert.Stadium_ID = stadium.Stadium_ID where concert.Year > 2014 group by stadium.Stadium_ID order by count(*) desc limit 1	s240_concert_singer
select PetID, weight from Pets where pet_age > 2	s243_pets_1
select count(*) from Templates where Template_Type_Code = "BK"	s262_cre_Doc_Template_Mgt
select Region, Population from country where Name = "Hong Kong"	s275_world_1
select Documents.Document_ID from Documents join Paragraphs on Documents.Document_ID = Paragraphs.Document_ID group by Documents.Document_ID having count(*) >= 3	s286_cre_Doc_Template_Mgt
select Name from country order by Population desc limit 5	s293_world_1
select Name from shop where Number_products < (select avg(Number_products) from shop)	s307_employee_hire_evaluation
select id from TV_Channel where Country in (select Country from TV_Channel group by Country having count(*) < 2)	s312_tvshow
select Name from conductor order by Age desc	s336_orchestra
select Name from conductor join orchestra on conductor.Conductor_ID = orchestra.Conductor_ID group by Name order by count(*) asc limit 1	s338_orchestra
