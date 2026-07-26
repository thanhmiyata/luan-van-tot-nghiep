select teacher.first_name, teacher.last_name, count(*) from teacher join course_arrange on teacher.Teacher_ID = course_arrange.Teacher_ID group by teacher.first_name, teacher.last_name	s003_course_teach_1
select first_name, last_name from conductor where Nationality <> "USA"	s014_orchestra_3
select PetType, max(wt) from Pets group by PetType	s020_pets_1_1
select Template_ID from Templates where Template_ID not in (select tpl_id from Documents where tpl_id is not null)	s029_cre_Doc_Template_Mgt_1
select category_cipher from Ref_Template_Types where category_cipher not in (select template_kind_codification from Templates where Template_ID in (select Template_ID from Documents))	s048_cre_Doc_Template_Mgt_2
select car_makers.Maker, cars_data.Horsepower from cars_data join car_names on cars_data.Id = car_names.MakeId join model_list on car_names.Model = model_list.Model join car_makers on model_list.Maker = car_makers.Id where cars_data.Cylinders = 3 order by cars_data.Horsepower desc limit 1	s062_car_1
select players.first_name, players.last_name from players join matches on matches.winner_id = players.player_id where matches.tourney_name = "Australian Open" order by matches.winner_rank desc limit 1	s067_wta_1
select Airline, Abbreviation from airlines where Country = "USA"	s083_flight_2
select avg(winner_age), avg(loser_age) from matches	s087_wta_1
select Ref_Template_Types.Template_Type_Code from Ref_Template_Types left join Templates on Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code left join Documents on Templates.Template_ID = Documents.Template_ID where Documents.Document_ID is null	s104_cre_Doc_Template_Mgt
select distinct Year from cars_data where Weight < 4000 and Weight > 3000	s123_car_1
select first_name from Students where cell_mobile_number = "09700166582" union select Students.first_name from Students join Addresses on Students.permanent_address_id = Addresses.address_id where Addresses.country = "Haiti"	s131_student_transcripts_tracking
select Directed_by, count(*) from Cartoon group by Directed_by	s152_tvshow
select count(*) from Highschooler inner join Friend on Highschooler.ID = Friend.student_id where Highschooler.name = "Kyle"	s157_network_1
select Manager_name, District from shop where Number_products = (select max(Number_products) from shop)	s162_employee_hire_evaluation
select avg(Earnings) from poker_player	s171_poker_player
select grade from Highschooler group by grade having count(*) >= 4	s198_network_1
select countries.CountryName from countries join car_makers on car_makers.Country = countries.CountryId join continents on countries.Continent = continents.ContId where continents.Continent = "europe" group by countries.CountryName having count(*) >= 3	s204_car_1
select Name from country where Continent = "Africa" and Population < (select min(Population) from country where Continent = "Asia")	s213_world_1
select min(Weight) from cars_data where Cylinders = 8 and Year = 1974	s221_car_1
select Version_Number, Template_Type_Code from Templates where Version_Number > 5	s229_cre_Doc_Template_Mgt
select s.Name, s.Capacity from stadium s join concert c on s.Stadium_ID = c.Stadium_ID where c.Year > 2014 group by s.Stadium_ID, s.Name, s.Capacity having count(*) = (select max(sub.count) from (select count(*) as count from concert where Year > 2014 group by Stadium_ID) sub)	s240_concert_singer
select count(*) from Templates where Template_Type_Code = "BK"	s262_cre_Doc_Template_Mgt
select contestant_name from CONTESTANTS where contestant_name <> "Nita Coster"	s272_voter_1
select Documents.Document_ID from Documents inner join Paragraphs on Documents.Document_ID = Paragraphs.Document_ID group by Documents.Document_ID having count(Paragraphs.Paragraph_ID) >= 3	s286_cre_Doc_Template_Mgt
select tourney_name from matches group by tourney_id, tourney_name having count(*) > 14	s287_wta_1
select avg(Horsepower) from cars_data where Year > 1980	s303_car_1
select Name from shop where Number_products < (select avg(Number_products) from shop)	s307_employee_hire_evaluation
select people.Birth_Date from poker_player join people on poker_player.People_ID = people.People_ID order by poker_player.Earnings desc limit 1	s331_poker_player
select Name from conductor order by Age desc	s336_orchestra
