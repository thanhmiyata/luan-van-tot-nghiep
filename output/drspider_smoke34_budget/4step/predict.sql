select teacher.first_name, teacher.last_name, count(course_arrange.Course_ID) from teacher join course_arrange on teacher.Teacher_ID = course_arrange.Teacher_ID group by teacher.first_name, teacher.last_name	s003_course_teach_1
select distinct s.semester_id from Semesters s join Student_Enrolment se on s.semester_id = se.semester_id join Degree_Programs dp on se.degree_program_id = dp.degree_program_id where dp.is_bachelor = true intersect select distinct s.semester_id from Semesters s join Student_Enrolment se on s.semester_id = se.semester_id join Degree_Programs dp on se.degree_program_id = dp.degree_program_id where dp.is_master = true	s007_student_transcripts_tracking_0
select PetType, max(wt) from Pets group by PetType	s020_pets_1_1
select City, cntry from airports where apt_name = "Alton"	s024_flight_2_4
select Ref_Template_Types.category_cipher from Ref_Template_Types left join Templates on Ref_Template_Types.category_cipher = Templates.template_kind_codification left join Documents on Templates.Template_ID = Documents.Template_ID where Documents.Template_ID is null	s048_cre_Doc_Template_Mgt_2
select Name from singer where born_date = 1948 or born_date = 1949	s058_singer_4
select m.winner_name from matches m inner join players p on m.winner_id = p.player_id inner join rankings r on p.player_id = r.player_id where m.tourney_name = "Australian Open" order by m.winner_rank desc limit 1	s067_wta_1
select Money_Rank from poker_player order by Earnings desc limit 1	s072_poker_player
select Name from stadium where Stadium_ID not in (select Stadium_ID from concert where Year = "2014")	s081_concert_singer
select avg(winner_age), avg(loser_age) from matches	s087_wta_1
select Ref_Template_Types.Template_Type_Code from Ref_Template_Types where not EXISTS (select 1 from Templates inner join Documents on Templates.Template_ID = Documents.Template_ID where Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code)	s104_cre_Doc_Template_Mgt
select people.Name from poker_player inner join people on poker_player.People_ID = people.People_ID where poker_player.Earnings > 300000	s110_poker_player
select distinct Year from cars_data where Weight < 4000 and Weight > 3000	s123_car_1
select Students.first_name from Students left join Addresses on Students.permanent_address_id = Addresses.address_id where Addresses.country = "Haiti" or Students.cell_mobile_number = "09700166582"	s131_student_transcripts_tracking
select count(*) from Documents	s148_cre_Doc_Template_Mgt
select count(*) from Highschooler inner join Friend on Highschooler.ID = Friend.student_id where Highschooler.name = "Kyle"	s157_network_1
select Manager_name, District from shop order by Number_products desc limit 1	s162_employee_hire_evaluation
select Ref_Template_Types.Template_Type_Code, count(*) from Ref_Template_Types join Templates on Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code join Documents on Documents.Template_ID = Templates.Template_ID group by Ref_Template_Types.Template_Type_Code	s164_cre_Doc_Template_Mgt
select series_name, Package_Option from TV_Channel where series_name = "Sky Radio"	s192_tvshow
select grade from Highschooler group by grade having count(*) >= 4	s198_network_1
select count(*) from car_makers join countries on car_makers.Country = countries.CountryId where countries.CountryName = "france"	s202_car_1
select Name from country where Continent = "Africa" and Population < (select min(Population) from country where Continent = "Asia")	s213_world_1
select min(Weight) from cars_data where Cylinders = 8 and Year = 1974	s221_car_1
select model_list.Model from model_list inner join car_makers on model_list.Maker = car_makers.Id inner join car_names on car_names.Model = model_list.Model inner join cars_data on cars_data.Id = car_names.MakeId where cars_data.Weight < 3500 and car_makers.Maker <> "ford"	s224_car_1
select stadium.Name, stadium.Capacity from stadium join concert on concert.Stadium_ID = stadium.Stadium_ID where concert.Year > 2014 group by stadium.Stadium_ID having count(*) = (select max(concert_count) from (select count(*) as concert_count from concert where Year > 2014 group by Stadium_ID) subquery)	s240_concert_singer
select PetID, weight from Pets where pet_age > 2	s243_pets_1
select count(*) from Templates where Template_Type_Code = "BK"	s262_cre_Doc_Template_Mgt
select Region, Population from country where Name = "Hong Kong"	s275_world_1
select Documents.Document_ID from Documents join Paragraphs on Documents.Document_ID = Paragraphs.Document_ID group by Documents.Document_ID having count(Paragraphs.Paragraph_ID) >= 3	s286_cre_Doc_Template_Mgt
select Name from country order by Population desc limit 5	s293_world_1
select Name from shop where Number_products < (select avg(Number_products) from shop)	s307_employee_hire_evaluation
select id from TV_Channel where Country in (select Country from TV_Channel group by Country having count(*) < 2)	s312_tvshow
select Name from conductor order by Age desc	s336_orchestra
select conductor.Name from conductor join orchestra on conductor.Conductor_ID = orchestra.Conductor_ID group by conductor.Conductor_ID having count(orchestra.Orchestra_ID) = (select min(cnt) from (select count(orchestra.Orchestra_ID) as cnt from orchestra group by orchestra.Conductor_ID))	s338_orchestra
