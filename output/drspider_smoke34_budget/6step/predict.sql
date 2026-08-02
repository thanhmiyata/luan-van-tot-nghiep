select teacher.first_name, teacher.last_name, count(*) from teacher join course_arrange on teacher.Teacher_ID = course_arrange.Teacher_ID group by teacher.Teacher_ID	s003_course_teach_1
select distinct a.semester_id from Student_Enrolment as a join Degree_Programs as b on a.degree_program_id = b.degree_program_id where (b.is_bachelor = "T") and a.semester_id in (select semester_id from Student_Enrolment join Degree_Programs on Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id where is_master = "T")	s007_student_transcripts_tracking_0
select max(wt), PetType from Pets group by PetType	s020_pets_1_1
select City, cntry from airports where apt_name = "Alton" or City = "Alton" or AirportCode = "and"	s024_flight_2_4
select category_cipher from Ref_Template_Types where not category_cipher in (select T1.template_kind_codification from Templates as T1 join Documents as T2 on T1.Template_ID = T2.Template_ID)	s048_cre_Doc_Template_Mgt_2
select Name from singer where born_date in (1948, 1949)	s058_singer_4
select winner_name from matches where tourney_name = "Australian Open" order by winner_rank asc limit 1	s067_wta_1
select Money_Rank from poker_player order by Earnings desc limit 1	s072_poker_player
select Name from stadium where not Stadium_ID in (select Stadium_ID from concert where Year = 2014)	s081_concert_singer
select avg(winner_age), avg(loser_age) from matches	s087_wta_1
select Template_Type_Code from Ref_Template_Types where not Template_Type_Code in (select T1.Template_Type_Code from Templates as T1 inner join Documents as T2 on T1.Template_ID = T2.Template_ID)	s104_cre_Doc_Template_Mgt
select people.Name from poker_player join people on poker_player.People_ID = people.People_ID where poker_player.Earnings > 300000	s110_poker_player
select distinct Year from cars_data where Weight < 4000 and Weight > 3000	s123_car_1
select Students.first_name from Students left join Addresses on Students.current_address_id = Addresses.address_id or Students.permanent_address_id = Addresses.address_id where Addresses.country = "Haiti" or Students.cell_mobile_number = "09700166582"	s131_student_transcripts_tracking
select count(*) from Documents	s148_cre_Doc_Template_Mgt
select count(*) from Friend join Highschooler on Friend.student_id = Highschooler.ID where Highschooler.name = "Kyle"	s157_network_1
select Manager_name, District from shop order by Number_products desc limit 1	s162_employee_hire_evaluation
select Ref_Template_Types.Template_Type_Code, count(*) from Ref_Template_Types join Templates on Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code join Documents on Documents.Template_ID = Templates.Template_ID group by Ref_Template_Types.Template_Type_Code	s164_cre_Doc_Template_Mgt
select Package_Option from TV_Channel where series_name = "Sky Radio"	s192_tvshow
select grade from Highschooler group by grade having count(*) >= 4	s198_network_1
select count(*) from car_makers inner join countries on car_makers.Country = countries.CountryId where countries.CountryName = "france"	s202_car_1
select Name from country where Continent = "Africa" and Population < (select min(Population) from country where Continent = "Asia")	s213_world_1
select min(Weight) from cars_data where Cylinders = 8 and Year = 1974	s221_car_1
select model_list.Model from model_list inner join car_makers on model_list.Maker = car_makers.Id where car_makers.Maker <> "ford" and model_list.ModelId in (select car_names.Model from car_names inner join cars_data on car_names.MakeId = cars_data.Id where cars_data.Weight < 3500)	s224_car_1
select stadium.Name, stadium.Capacity from stadium join concert on stadium.Stadium_ID = concert.Stadium_ID where concert.Year > 2014 group by stadium.Stadium_ID order by count(*) desc limit 1	s240_concert_singer
select PetID, weight from Pets where pet_age > 2	s243_pets_1
select count(*) from Templates where Template_Type_Code = "BK"	s262_cre_Doc_Template_Mgt
select Region, Population from country where Name = "Hong Kong"	s275_world_1
select Documents.Document_ID from Documents join Paragraphs on Documents.Document_ID = Paragraphs.Document_ID group by Documents.Document_ID having count(*) >= 3	s286_cre_Doc_Template_Mgt
select Name from country order by Population desc limit 5	s293_world_1
select Name from shop where Number_products < (select avg(Number_products) from shop)	s307_employee_hire_evaluation
select id from TV_Channel where Country in (select Country from TV_Channel group by Country having count(*) < 2)	s312_tvshow
select Name from conductor order by Age desc	s336_orchestra
select Name from conductor join orchestra on conductor.Conductor_ID = orchestra.Conductor_ID group by conductor.Conductor_ID order by count(*) asc limit 1	s338_orchestra
