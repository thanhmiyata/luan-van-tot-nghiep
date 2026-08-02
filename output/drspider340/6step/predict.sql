select PetType, weight from Pets order by birthyear desc limit 1	s000_pets_1_5
select Student.LName from Student inner join Has_Pet on Student.StuID = Has_Pet.StuID inner join Pets on Has_Pet.PetID = Pets.PetID where Pets.is_cat = true and Pets.pet_age = 3	s001_pets_1_4
select teacher.first_name, teacher.last_name, course.Course from teacher join course_arrange on course_arrange.Teacher_ID = teacher.Teacher_ID join course on course_arrange.Course_ID = course.Course_ID	s002_course_teach_5
select teacher.first_name, teacher.last_name, count(*) from teacher join course_arrange on teacher.Teacher_ID = course_arrange.Teacher_ID group by teacher.first_name, teacher.last_name	s003_course_teach_1
select Name, Level_of_membership from visitor where Level_of_membership > 4 order by birthyear asc	s004_museum_visit_1
select count(*) from matches inner join players on matches.winner_id = players.player_id where matches.is_winner_right_handed = false and matches.tourney_name = "WTA Championships"	s005_wta_1_0
select t.transcript_date, t.transcript_id from Transcripts as t join Transcript_Contents as tc on t.transcript_id = tc.transcript_id group by t.transcript_id having count(tc.student_course_id) = (select min(result_count) from (select count(student_course_id) as result_count from Transcript_Contents group by transcript_id))	s006_student_transcripts_tracking_0
select semester_id from Semesters where semester_id in (select semester_id from Student_Enrolment join Degree_Programs on Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id where Degree_Programs.is_bachelor = 1) intersect select semester_id from Student_Enrolment join Degree_Programs on Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id where Degree_Programs.is_master = 1	s007_student_transcripts_tracking_0
select distinct TV_Channel.Country from TV_Channel inner join Cartoon on Cartoon.Channel = TV_Channel.id where Cartoon.writer_firstname = "Todd" and Cartoon.writer_lastname = "Casey"	s008_tvshow_0
select id from TV_Channel where id not in (select Channel from Cartoon where director_firstname = "Ben" and director_lastname = "Jones")	s009_tvshow_5
select TV_Channel.id from TV_Channel where not EXISTS (select 1 from Cartoon where Cartoon.Channel = TV_Channel.id and Cartoon.director_firstname = "Ben" and Cartoon.director_lastname = "Jones")	s010_tvshow_5
select people.first_name, people.last_name from poker_player inner join people on poker_player.People_ID = people.People_ID	s011_poker_player_0
select first_name, last_name, Birth_Date from people order by last_name asc	s012_poker_player_0
select distinct state, created_time from VOTES	s013_voter_1_7
select first_name, last_name from conductor where Nationality <> "USA"	s014_orchestra_3
select first_name, last_name from conductor where Nationality <> "USA"	s015_orchestra_3
select Name from conductor order by year_start_to_work asc limit 1	s016_orchestra_1
select conductor.first_name, conductor.last_name from conductor join orchestra on orchestra.Conductor_ID = conductor.Conductor_ID where orchestra.Year_of_Founded > 2008	s017_orchestra_3
select s.first_name, s.last_name from singer s join song o on s.Singer_ID = o.Singer_ID group by s.Singer_ID having count(*) > 1	s018_singer_0
select first_name, last_name from singer where Singer_ID not in (select Singer_ID from song)	s019_singer_0
select PetType, max(wt) from Pets group by PetType	s020_pets_1_1
select model_list.Model from model_list join car_names on car_names.Model = model_list.Model join cars_data on cars_data.Id = car_names.MakeId where cars_data.wt < (select avg(wt) from cars_data)	s021_car_1_0
select car_makers.Maker, model_list.mdl from car_makers join model_list on car_makers.Id = model_list.Maker	s022_car_1_1
select cn.Make from car_names cn join cars_data cd on cn.MakeId = cd.Id order by cd.MPG desc limit 1	s023_car_1_3
select City, cntry from airports where apt_name = "Alton"	s024_flight_2_4
select count(*) from flights inner join airports on flights.srcapt = airports.AirportCode where airports.City = "Aberdeen"	s025_flight_2_4
select apt_name from airports where apt_code not in (select srcapt from flights) and apt_code not in (select destapt from flights)	s026_flight_2_0
select count(distinct shop.loc) from shop	s027_employee_hire_evaluation_0
select count(distinct Template_ID) from Templates	s028_cre_Doc_Template_Mgt_2
select Template_ID from Templates where Template_ID not in (select tpl_id from Documents where tpl_id is not null)	s029_cre_Doc_Template_Mgt_1
select teacher.Name from teacher inner join course_arrange on course_arrange.tchr_id = teacher.Teacher_ID group by course_arrange.tchr_id having count(course_arrange.Course_ID) >= 2	s030_course_teach_4
select Name from visitor where lvl_mem > 4 order by lvl_mem desc	s031_museum_visit_2
select players.first_name, players.country_code, players.dob from players inner join matches on players.player_id = matches.winner_id order by matches.winner_rank_points desc limit 1	s032_wta_1_3
select a.adr_id, a.line_1, a.line_2, a.line_3 from Addresses a join Students s on a.adr_id = s.permanent_address_id group by a.adr_id, a.line_1, a.line_2, a.line_3 order by count(*) desc limit 1	s033_student_transcripts_tracking_0
select Title, dir from Cartoon order by Original_air_date asc	s034_tvshow_0
select ep from TV_series order by rtg desc	s035_tvshow_0
select country.Region from city inner join country on city.cntry_code = country.Code where city.Name = "Kabul"	s036_world_1_4
select distinct country.Name from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "English" union select distinct country.Name from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "Dutch"	s037_world_1_1
select Name from country order by popn asc limit 3	s038_world_1_0
select record_co, Year_of_Founded from orchestra order by Year_of_Founded desc	s039_orchestra_0
select count(*) from concert where Stadium_ID = (select Stadium_ID from stadium order by max_carrying_number desc limit 1)	s040_concert_singer_1
select Student.Fname, Student.gender from Student join Has_Pet on Student.StuID = Has_Pet.StuID group by Student.StuID having count(Has_Pet.PetID) > 1	s041_pets_1_1
select count(*) from cars_data where engine > 150	s042_car_1_2
select cylinder_number, max(speed_up) from cars_data group by cylinder_number	s043_car_1_0
select producer from model_list group by producer having count(distinct version) >= (select max(version_count) from (select count(distinct version) as version_count from model_list group by producer))	s044_car_1_0
select count(*) from flights where flight_from = "APG"	s045_flight_2_0
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.air_way group by T1.Airline order by count(*) desc limit 1	s046_flight_2_2
select distinct category_cipher from Ref_Template_Types	s047_cre_Doc_Template_Mgt_3
select category_cipher from Ref_Template_Types where category_cipher not in (select template_kind_codification from Templates where Template_ID in (select Template_ID from Documents))	s048_cre_Doc_Template_Mgt_2
select category_code, description from Ref_Template_Types	s049_cre_Doc_Template_Mgt_0
select p.given_name, p.country_code from players p inner join matches m1 on p.player_id = m1.winner_id inner join matches m2 on p.player_id = m2.winner_id where m1.tourney_name = "WTA Championships" and m2.tourney_name = "Australian Open"	s050_wta_1_1
select nation_code, count(*) as count from players group by nation_code	s051_wta_1_4
select count(distinct c.mainland) from countrylanguage cl join country c on cl.CountryCode = c.Code where cl.official_language = "Chinese"	s052_world_1_0
select Name from country where Continent = "Africa" and how_many_people < (select min(how_many_people) from country where Continent = "Asia")	s053_world_1_3
select District, count(*) from city group by District having avg(total_citizens) > (select avg(total_citizens) from city)	s054_world_1_3
select count(*) from country where mainland = "Asia"	s055_world_1_4
select Treatments.time_of_therapeutics, Professionals.forename from Treatments join Professionals on Treatments.professional_id = Professionals.professional_id	s056_dog_kennels_0
select Owners.forename, Owners.last_name, Sizes.size_explanation from Owners join Dogs on Dogs.owner_id = Owners.owner_id join Sizes on Dogs.size_code = Sizes.size_code	s057_dog_kennels_4
select Name from singer where born_date = 1948 or born_date = 1949	s058_singer_4
select nationality, count(*) from singer group by nationality	s059_singer_0
select count(*) from concert join stadium on concert.Stadium_ID = stadium.Stadium_ID where stadium.Capacity = (select max(Capacity) from stadium)	s060_concert_singer
select model_list.Model from model_list join car_names on car_names.Model = model_list.Model join cars_data on cars_data.Id = car_names.MakeId where cars_data.Weight < (select avg(cars_data.Weight) from cars_data)	s061_car_1
select car_makers.Maker, cars_data.Horsepower from cars_data join car_names on cars_data.Id = car_names.MakeId join model_list on car_names.Model = model_list.Model join car_makers on model_list.Maker = car_makers.Id where cars_data.Cylinders = 3 order by cars_data.Horsepower desc limit 1	s062_car_1
select Id from cars_data order by MPG desc limit 1	s063_car_1
select count(*) from cars_data where Accelerate > (select max(Horsepower) from cars_data)	s064_car_1
select visitor.ID, sum(visit.Total_spent) as Total_spent, visitor.Level_of_membership from visitor join visit on visit.visitor_ID = visitor.ID group by visitor.ID, visitor.Level_of_membership having sum(visit.Total_spent) = (select max(total) from (select sum(visit.Total_spent) as total from visit group by visit.visitor_ID))	s065_museum_visit
select first_name, country_code from players order by birth_date asc limit 1	s066_wta_1
select players.first_name, players.last_name from players join matches on matches.winner_id = players.player_id where matches.tourney_name = "Australian Open" order by matches.winner_rank desc limit 1	s067_wta_1
select loser_name, winner_name from matches order by minutes desc limit 1	s068_wta_1
select first_name, middle_name, last_name from Students order by date_first_registered asc limit 1	s069_student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_first_registered asc limit 1	s070_student_transcripts_tracking
select Production_code, Channel from Cartoon order by Original_air_date desc limit 1	s071_tvshow
select Money_Rank from poker_player order by Earnings desc limit 1	s072_poker_player
select people.Birth_Date from poker_player inner join people on poker_player.People_ID = people.People_ID order by poker_player.Earnings asc limit 1	s073_poker_player
select poker_player.Money_Rank from poker_player inner join people on poker_player.People_ID = people.People_ID order by people.Height desc limit 1	s074_poker_player
select Name, Population, LifeExpectancy from country where Continent = "Asia" order by SurfaceArea desc limit 1	s075_world_1
select Name, Population, LifeExpectancy from country where Continent = "Asia" order by Population desc limit 1	s076_world_1
select Name, IndepYear, SurfaceArea from country order by Population asc limit 1	s077_world_1
select Population, Name, HeadOfState from country order by Population desc limit 1	s078_world_1
select Owners.owner_id, Owners.zip_code from Owners join Dogs on Dogs.owner_id = Owners.owner_id join Treatments on Treatments.dog_id = Dogs.dog_id group by Owners.owner_id, Owners.zip_code order by sum(Treatments.cost_of_treatment) desc limit 1	s079_dog_kennels
select Name, Country, Age from singer order by Age desc	s080_concert_singer
select stadium.Name from stadium where not EXISTS (select 1 from concert where concert.Stadium_ID = stadium.Stadium_ID and concert.Year = "2014")	s081_concert_singer
select stadium.Name, stadium.Location from stadium join concert on concert.Stadium_ID = stadium.Stadium_ID where concert.Year in ("2014", "2015")	s082_concert_singer
select Airline, Abbreviation from airlines where Country = "USA"	s083_flight_2
select AirportName from airports where City = "Aberdeen"	s084_flight_2
select shop.Name, count(*) from shop join hiring on shop.Shop_ID = hiring.Shop_ID group by shop.Shop_ID	s085_employee_hire_evaluation
select teacher.Name, course.Course from course_arrange inner join teacher on course_arrange.Teacher_ID = teacher.Teacher_ID inner join course on course_arrange.Course_ID = course.Course_ID	s086_course_teach
select avg(winner_age), avg(loser_age) from matches	s087_wta_1
select degree_summary_name from Degree_Programs join Student_Enrolment on Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id group by Degree_Programs.degree_summary_name order by count(*) desc limit 1	s088_student_transcripts_tracking
select semester_name from Semesters where semester_id not in (select distinct semester_id from Student_Enrolment)	s089_student_transcripts_tracking
select Courses.course_name from Courses inner join Student_Enrolment_Courses on Courses.course_id = Student_Enrolment_Courses.course_id group by Courses.course_id having count(Student_Enrolment_Courses.student_course_id) > 0	s090_student_transcripts_tracking
select Students.first_name, Students.last_name from Students inner join Student_Enrolment on Students.student_id = Student_Enrolment.student_id order by Students.date_first_registered asc limit 1	s091_student_transcripts_tracking
select TV_Channel.series_name, TV_Channel.Country from TV_Channel join Cartoon on Cartoon.Channel = TV_Channel.id where Cartoon.Directed_by = "Ben Jones" or Cartoon.Directed_by = "Michael Chang"	s092_tvshow
select TV_Channel.Country, TV_Channel.series_name from TV_Channel join Cartoon on TV_Channel.id = Cartoon.Channel where Cartoon.Directed_by = "Ben Jones" intersect select TV_Channel.Country, TV_Channel.series_name from TV_Channel join Cartoon on TV_Channel.id = Cartoon.Channel where Cartoon.Directed_by = "Michael Chang"	s093_tvshow
select people.Name from people where not EXISTS (select 1 from poker_player where poker_player.People_ID = people.People_ID)	s094_poker_player
select contestant_name from CONTESTANTS where contestant_name like "%Al%"	s095_voter_1
select Name from country order by Population asc limit 3	s096_world_1
select Name, Year_of_Work from conductor order by Year_of_Work desc	s097_orchestra
select Highschooler.name from Highschooler where Highschooler.ID not in (select Friend.student_id from Friend)	s098_network_1
select date_arrived, date_departed from Dogs	s099_dog_kennels
select model_list.Model from car_makers join model_list on model_list.Maker = car_makers.Id join car_names on car_names.Model = model_list.Model join cars_data on cars_data.Id = car_names.MakeId where car_makers.FullName = "General Motors" and cars_data.Weight > 1500	s100_car_1
select Year from cars_data where Weight >= 3000 and Weight <= 4000	s101_car_1
select FlightNo from flights where SourceAirport = "APG"	s102_flight_2
select Ref_Template_Types.Template_Type_Description from Documents inner join Templates on Documents.Template_ID = Templates.Template_ID inner join Ref_Template_Types on Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code where Documents.Document_Name = "Data base"	s103_cre_Doc_Template_Mgt
select Ref_Template_Types.Template_Type_Code from Ref_Template_Types left join Templates on Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code left join Documents on Templates.Template_ID = Documents.Template_ID where Documents.Document_ID is null	s104_cre_Doc_Template_Mgt
select p.first_name, p.last_name, r.ranking_points from players p join matches m on p.player_id = m.winner_id join rankings r on p.player_id = r.player_id group by m.winner_id order by count(*) desc limit 1	s105_wta_1
select winner_name, count(*) as match_count from matches group by winner_id, winner_name order by match_count desc limit 1	s106_wta_1
select section_name, section_description from Sections	s107_student_transcripts_tracking
select section_id, course_id, section_name, section_description, other_details from Sections	s108_student_transcripts_tracking
select Money_Rank from poker_player order by Earnings desc	s109_poker_player
select people.Name from poker_player inner join people on poker_player.People_ID = people.People_ID where poker_player.Earnings > 300000	s110_poker_player
select avg(poker_player.Earnings) from poker_player join people on poker_player.People_ID = people.People_ID where people.Height > 200	s111_poker_player
select Nationality, count(*) as "number of people" from people group by Nationality	s112_poker_player
select avg(country.LifeExpectancy) from country join countrylanguage on countrylanguage.CountryCode = country.Code where countrylanguage.Language <> "English" and countrylanguage.IsOfficial = "T"	s113_world_1
select countrylanguage.Language, countrylanguage.IsOfficial, countrylanguage.Percentage from country join countrylanguage on countrylanguage.CountryCode = country.Code where country.HeadOfState = "Beatrix"	s114_world_1
select city.Name from city join country on city.CountryCode = country.Code where country.Continent = "Europe" and not EXISTS (select 1 from countrylanguage where countrylanguage.CountryCode = country.Code and countrylanguage.Language = "English" and countrylanguage.IsOfficial = "T")	s115_world_1
select Orchestra, Year_of_Founded from orchestra order by Year_of_Founded desc	s116_orchestra
select Name, Net_Worth_Millions from singer order by Net_Worth_Millions asc	s117_singer
select Name from singer order by Net_Worth_Millions desc limit 1	s118_singer
select Citizenship, max(Net_Worth_Millions) from singer group by Citizenship	s119_singer
select count(*) from concert where Year = "2014" or Year = "2015"	s120_concert_singer
select Name from stadium where Stadium_ID not in (select Stadium_ID from concert where Year = "2014")	s121_concert_singer
select count(*) from Student join Has_Pet on Has_Pet.StuID = Student.StuID join Pets on Has_Pet.PetID = Pets.PetID where Student.Sex = "F" and Pets.PetType = "dog"	s122_pets_1
select distinct Year from cars_data where Weight < 4000 and Weight > 3000	s123_car_1
select countries.CountryId, countries.CountryName from countries join car_makers on countries.CountryId = car_makers.Country where car_makers.Maker = "fiat" group by countries.CountryId, countries.CountryName having count(*) > 3	s124_car_1
select AirportCode, AirportName from airports where City = "Anthony"	s125_flight_2
select count(*) from flights join airports on flights.SourceAirport = airports.AirportCode where airports.City = "Aberdeen"	s126_flight_2
select Document_ID, Template_ID, Document_Description from Documents where Document_Name = "Robbin CV"	s127_cre_Doc_Template_Mgt
select count(*) from matches where year in (2013, 2016)	s128_wta_1
select battle.name, battle.date from battle inner join ship on ship.lost_in_battle = battle.id where ship.name = "HMS Atalanta" or ship.name = "Lettice"	s129_battle_death
select section_description from Sections where section_name = "h"	s130_student_transcripts_tracking
select first_name from Students where cell_mobile_number = "09700166582" union select Students.first_name from Students join Addresses on Students.permanent_address_id = Addresses.address_id where Addresses.country = "Haiti"	s131_student_transcripts_tracking
select count(*) from TV_Channel where Language = "English"	s132_tvshow
select TV_Channel.series_name as Channel, TV_series.id from TV_Channel join TV_series on TV_series.Channel = TV_Channel.id where TV_series.Episode = "A Love of a Lifetime"	s133_tvshow
select Name from people where Nationality <> "Russia"	s134_poker_player
select Continent from country where Name = "Anguilla"	s135_world_1
select sum(SurfaceArea) from country where Continent = "Asia" or Continent = "Europe"	s136_world_1
select max(Share), min(Share) from performance where Type <> "live finals"	s137_orchestra
select Professionals.professional_id, Professionals.last_name, Professionals.cell_number from Professionals join Treatments on Professionals.professional_id = Treatments.professional_id where Professionals.state = "Indiana" group by Professionals.professional_id having count(Treatments.treatment_id) > 2	s138_dog_kennels
select singer.Name from singer where singer.Citizenship <> "France"	s139_singer
select singer.Name, count(*) from singer join singer_in_concert on singer.Singer_ID = singer_in_concert.Singer_ID group by singer.Name	s140_concert_singer
select count(*) from Student inner join Has_Pet on Student.StuID = Has_Pet.StuID where Student.Age > 20	s141_pets_1
select count(*) from cars_data where Cylinders > 6	s142_car_1
select count(*) from flights where DestAirport = "ATO"	s143_flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where airports.City = "Aberdeen"	s144_flight_2
select count(*) from flights where Airline = "JetBlue Airways"	s145_flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where airports.City = "Aberdeen" or airports.City = "Abilene"	s146_flight_2
select Location, count(*) from shop group by Location	s147_employee_hire_evaluation
select count(*) from Documents	s148_cre_Doc_Template_Mgt
select count(*) from Templates	s149_cre_Doc_Template_Mgt
select count(*) from Templates where Template_Type_Code = "CV"	s150_cre_Doc_Template_Mgt
select Country, count(*) from TV_Channel group by Country order by count(*) desc limit 1	s151_tvshow
select Directed_by, count(*) from Cartoon group by Directed_by	s152_tvshow
select count(*) from poker_player	s153_poker_player
select count(distinct Language) from countrylanguage	s154_world_1
select count(*) from orchestra where Major_Record_Format like "CD" or Major_Record_Format like "DVD"	s155_orchestra
select count(*) from Highschooler where grade = 9 or grade = 10	s156_network_1
select count(*) from Highschooler inner join Friend on Highschooler.ID = Friend.student_id where Highschooler.name = "Kyle"	s157_network_1
select count(*) from Dogs join Treatments on Dogs.dog_id = Treatments.dog_id	s158_dog_kennels
select count(*) from Professionals where not EXISTS (select 1 from Treatments where Treatments.professional_id = Professionals.professional_id)	s159_dog_kennels
select Student.Fname, Student.Sex from Student inner join Has_Pet on Student.StuID = Has_Pet.StuID group by Student.Fname, Student.Sex, Student.StuID having count(*) >= 2	s160_pets_1
select car_names.Model from car_names join model_list on car_names.Model = model_list.Model join car_makers on model_list.Maker = car_makers.Id join cars_data on car_names.MakeId = cars_data.Id where cars_data.Weight < 3500 and car_makers.FullName <> "Ford Motor Company"	s161_car_1
select Manager_name, District from shop where Number_products = (select max(Number_products) from shop)	s162_employee_hire_evaluation
select shop.Name from shop join hiring on shop.Shop_ID = hiring.Shop_ID group by shop.Shop_ID having count(hiring.Employee_ID) = (select max(employee_count) from (select count(Employee_ID) as employee_count from hiring group by Shop_ID)) limit 1	s163_employee_hire_evaluation
select Ref_Template_Types.Template_Type_Code, count(*) from Ref_Template_Types join Templates on Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code join Documents on Documents.Template_ID = Templates.Template_ID group by Ref_Template_Types.Template_Type_Code	s164_cre_Doc_Template_Mgt
select count(*) from Paragraphs	s165_cre_Doc_Template_Mgt
select visitor.Name, visitor.Age from visitor join visit on visit.visitor_ID = visitor.ID order by visit.Num_of_Ticket desc limit 1	s166_museum_visit
select country_code from players group by country_code having count(*) = (select max(count) from (select count(*) as count from players group by country_code))	s167_wta_1
select max(killed), min(killed) from death	s168_battle_death
select A.address_id, A.line_1, A.line_2 from Addresses A left join Students S on S.current_address_id = A.address_id or S.permanent_address_id = A.address_id group by A.address_id, A.line_1, A.line_2 order by count(S.student_id) desc limit 1	s169_student_transcripts_tracking
select transcript_date, other_details from Transcripts order by transcript_date asc limit 1	s170_student_transcripts_tracking
select avg(Earnings) from poker_player	s171_poker_player
select max(Final_Table_Made) from poker_player where Earnings < 200000	s172_poker_player
select avg(GNP), sum(Population) from country where GovernmentForm = "US Territory"	s173_world_1
select count(*) from (select CountryCode from countrylanguage where Language = "English" intersect select CountryCode from countrylanguage where Language = "Dutch")	s174_world_1
select Name from country where Continent = "Asia" and Population > (select max(Population) from country where Continent = "Africa")	s175_world_1
select conductor.Name from conductor inner join orchestra on orchestra.Conductor_ID = conductor.Conductor_ID where orchestra.Year_of_Founded > 2008	s176_orchestra
select grade from Highschooler group by grade order by count(*) desc limit 1	s177_network_1
select O.owner_id, O.first_name, O.last_name from Owners O join Dogs D on O.owner_id = D.owner_id join Treatments T on D.dog_id = T.dog_id group by O.owner_id, O.first_name, O.last_name having sum(T.cost_of_treatment) = (select max(total_cost) from (select sum(T1.cost_of_treatment) as total_cost from Treatments T1 join Dogs D1 on T1.dog_id = D1.dog_id group by D1.owner_id))	s178_dog_kennels
select Professionals.first_name, Professionals.cell_number from Professionals join Treatments on Treatments.professional_id = Professionals.professional_id group by Professionals.first_name, Professionals.cell_number having count(distinct Treatments.treatment_type_code) >= 2	s179_dog_kennels
select min(Age), max(Age), avg(Age) from singer where Country = "France"	s180_concert_singer
select count(*) from Pets where weight > 10	s181_pets_1
select cars_data.Cylinders from car_makers join model_list on model_list.Maker = car_makers.Id join car_names on car_names.Model = model_list.Model join cars_data on cars_data.Id = car_names.MakeId where car_makers.Maker = "volvo" order by cars_data.Accelerate asc limit 1	s182_car_1
select model_list.Model from cars_data inner join car_names on cars_data.Id = car_names.MakeId inner join model_list on car_names.Model = model_list.Model where cars_data.Cylinders = 4 order by cars_data.Horsepower desc limit 1	s183_car_1
select car_makers.Maker, car_makers.Id from car_makers join model_list on model_list.Maker = car_makers.Id join car_names on car_names.Model = model_list.Model join cars_data on cars_data.Id = car_names.MakeId where cars_data.Horsepower > (select min(Horsepower) from cars_data) and cars_data.Cylinders <= 3	s184_car_1
select a.AirportCode from airports as a join flights as f on a.AirportCode = f.SourceAirport or a.AirportCode = f.DestAirport group by a.AirportCode having count(*) = (select max(flight_count) from (select count(*) as flight_count from flights group by SourceAirport union ALL select count(*) from flights group by DestAirport))	s185_flight_2
select min(Number_products), max(Number_products) from shop	s186_employee_hire_evaluation
select Name from teacher where Age = "33"	s187_course_teach
select Courses.course_name, Courses.course_id from Courses left join Sections on Courses.course_id = Sections.course_id group by Courses.course_id having count(Sections.section_id) < 2	s188_student_transcripts_tracking
select Transcripts.transcript_date, Transcripts.transcript_id from Transcripts join Transcript_Contents on Transcript_Contents.transcript_id = Transcripts.transcript_id group by Transcripts.transcript_id, Transcripts.transcript_date having count(*) >= 2	s189_student_transcripts_tracking
select transcript_date, transcript_id, other_details from Transcripts order by transcript_date asc limit 1	s190_student_transcripts_tracking
select Title from Cartoon where Directed_by = "Brandon Nguyen" or Directed_by = "Benjamin Jones"	s191_tvshow
select series_name, Package_Option from TV_Channel where series_name = "Sky Radio"	s192_tvshow
select Language, count(*) from TV_Channel group by Language having count(*) = (select min(language_count) from (select Language, count(*) as language_count from TV_Channel group by Language))	s193_tvshow
select Earnings from poker_player order by Earnings desc	s194_poker_player
select people.Name from poker_player inner join people on poker_player.People_ID = people.People_ID order by poker_player.Final_Table_Made desc	s195_poker_player
select Name from country where Continent = "Asia" order by LifeExpectancy asc limit 1	s196_world_1
select Record_Company from orchestra group by Record_Company having count(Orchestra_ID) = (select max(count) from (select count(Orchestra_ID) as count from orchestra group by Record_Company))	s197_orchestra
select grade from Highschooler group by grade having count(*) >= 4	s198_network_1
select first_name, last_name, email_address from Owners where state like "%North%"	s199_dog_kennels
select count(*) from Student join Has_Pet on Student.StuID = Has_Pet.StuID where Student.Age > 20	s200_pets_1
select PetType, avg(weight) from Pets group by PetType	s201_pets_1
select count(*) from car_makers join countries on car_makers.Country = countries.CountryId where countries.CountryName = "france"	s202_car_1
select min(Weight) from cars_data where Year = 1974 and Cylinders = 8	s203_car_1
select countries.CountryName from countries join car_makers on car_makers.Country = countries.CountryId join continents on countries.Continent = continents.ContId where continents.Continent = "europe" group by countries.CountryName having count(*) >= 3	s204_car_1
select count(*) from airports	s205_flight_2
select employee.Name from employee join evaluation on evaluation.Employee_ID = employee.Employee_ID group by employee.Name having count(evaluation.Year_awarded) = (select max(awards_count) from (select count(*) as awards_count from evaluation group by Employee_ID))	s206_employee_hire_evaluation
select Templates.Template_ID from Templates join Documents on Templates.Template_ID = Documents.Template_ID group by Templates.Template_ID having count(*) > 1	s207_cre_Doc_Template_Mgt
select Ref_Template_Types.Template_Type_Description from Documents inner join Templates on Documents.Template_ID = Templates.Template_ID inner join Ref_Template_Types on Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code	s208_cre_Doc_Template_Mgt
select count(*) from teacher	s209_course_teach
select avg(Num_of_Staff) from museum where Open_Year < 2009	s210_museum_visit
select cell_mobile_number from Students where first_name = "Timmothy" and last_name = "Ward"	s211_student_transcripts_tracking
select Money_Rank from poker_player inner join people on poker_player.People_ID = people.People_ID order by people.Height desc limit 1	s212_poker_player
select Name from country where Continent = "Africa" and Population < (select min(Population) from country where Continent = "Asia")	s213_world_1
select Name, Conductor_ID from conductor	s214_orchestra
select T1.student_id from Friend as T1 join Likes as T2 on T1.student_id = T2.student_id and T1.friend_id = T2.liked_id	s215_network_1
select Treatments.date_of_treatment, Professionals.first_name from Treatments inner join Professionals on Treatments.professional_id = Professionals.professional_id	s216_dog_kennels
select first_name, last_name, email_address from Owners where state like "%North%"	s217_dog_kennels
select count(*) from Dogs where age < (select avg(age) from Dogs)	s218_dog_kennels
select song.Title, singer.Name from song inner join singer on song.Singer_ID = singer.Singer_ID	s219_singer
select distinct Country from singer where Age > 20	s220_concert_singer
select min(Weight) from cars_data where Cylinders = 8 and Year = 1974	s221_car_1
select count(*) from model_list join car_names on model_list.Model = car_names.Model join cars_data on cars_data.Id = car_names.MakeId where cars_data.Cylinders > 6	s222_car_1
select car_names.Model from cars_data inner join car_names on cars_data.Id = car_names.MakeId where cars_data.Cylinders = "four" order by cars_data.Horsepower desc limit 1	s223_car_1
select car_names.Model from cars_data join car_names on cars_data.Id = car_names.MakeId join model_list on car_names.Model = model_list.Model join car_makers on model_list.Maker = car_makers.Id where cars_data.Weight < 3500 and car_makers.Maker <> "ford"	s224_car_1
select countries.CountryId, countries.CountryName from countries join car_makers on car_makers.Country = countries.CountryId left join model_list on model_list.Maker = car_makers.Id group by countries.CountryId, countries.CountryName having count(model_list.ModelId) > 3 or max(car_makers.Maker = "fiat") = 1	s225_car_1
select count(*) from flights join airlines on flights.Airline = airlines.Airline where airlines.Airline = "United Airlines" and flights.SourceAirport = "AHD"	s226_flight_2
select count(*) from (select District from shop where Number_products < 3000 intersect select District from shop where Number_products > 10000)	s227_employee_hire_evaluation
select Version_Number, Template_Type_Code from Templates where Version_Number > 5	s228_cre_Doc_Template_Mgt
select Version_Number, Template_Type_Code from Templates where Version_Number > 5	s229_cre_Doc_Template_Mgt
select Ref_Template_Types.Template_Type_Code from Ref_Template_Types join Templates on Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code group by Ref_Template_Types.Template_Type_Code having count(*) < 3	s230_cre_Doc_Template_Mgt
select Paragraphs.Paragraph_Text from Documents inner join Paragraphs on Paragraphs.Document_ID = Documents.Document_ID where Documents.Document_Name = "customer review"	s231_cre_Doc_Template_Mgt
select Documents.Document_ID from Documents join Paragraphs on Documents.Document_ID = Paragraphs.Document_ID group by Documents.Document_ID having count(*) <= 2	s232_cre_Doc_Template_Mgt
select teacher.Name from teacher join course_arrange on course_arrange.Teacher_ID = teacher.Teacher_ID join course on course_arrange.Course_ID = course.Course_ID where course.Course = "Math"	s233_course_teach
select people.Name from poker_player inner join people on poker_player.People_ID = people.People_ID where poker_player.Earnings > 300000	s234_poker_player
select Name from country where SurfaceArea > (select max(SurfaceArea) from country where Continent = "Europe")	s235_world_1
select Name from country order by Population desc limit 3	s236_world_1
select Name from city where Population between 160000 and 900000	s237_world_1
select Highschooler.name from Highschooler join Likes on Highschooler.ID = Likes.student_id group by Highschooler.name having count(*) >= 2	s238_network_1
select Owners.first_name, Dogs.name from Owners inner join Dogs on Dogs.owner_id = Owners.owner_id where Owners.state = "Virginia"	s239_dog_kennels
select s.Name, s.Capacity from stadium s join concert c on s.Stadium_ID = c.Stadium_ID where c.Year > 2014 group by s.Stadium_ID, s.Name, s.Capacity having count(*) = (select max(sub.count) from (select count(*) as count from concert where Year > 2014 group by Stadium_ID) sub)	s240_concert_singer
select stadium.Name, stadium.Location from stadium join concert on concert.Stadium_ID = stadium.Stadium_ID where concert.Year = "2014" group by stadium.Name, stadium.Location having count(distinct concert.concert_ID) > 1	s241_concert_singer
select PetID, weight from Pets where pet_age > 2	s242_pets_1
select PetID, weight from Pets where pet_age > 2	s243_pets_1
select distinct model_list.Model from model_list join car_names on model_list.Model = car_names.Model join cars_data on cars_data.Id = car_names.MakeId where cars_data.Year > 1976	s244_car_1
select avg(MPG) from cars_data where Cylinders = 6	s245_car_1
select count(*) from cars_data where Cylinders > 1	s246_car_1
select count(*) from cars_data where Year = 1976	s247_car_1
select distinct v.Name from visitor v join visit vs on v.ID = vs.visitor_ID join museum m on vs.Museum_ID = m.Museum_ID where m.Open_Year < 2019 intersect select distinct v.Name from visitor v join visit vs on v.ID = vs.visitor_ID join museum m on vs.Museum_ID = m.Museum_ID where m.Open_Year > 2011	s248_museum_visit
select count(*) from visitor where not EXISTS (select 1 from visit join museum on visit.Museum_ID = museum.Museum_ID where visit.visitor_ID = visitor.ID and museum.Open_Year > 2019)	s249_museum_visit
select distinct p.first_name, p.last_name from players p join matches m1 on p.player_id = m1.winner_id join matches m2 on p.player_id = m2.winner_id where m1.year = 2013 and m2.year = 2013	s250_wta_1
select Name from country where IndepYear > 1957	s251_world_1
select count(distinct countrylanguage.Language) from country join countrylanguage on country.Code = countrylanguage.CountryCode where country.IndepYear < 1920	s252_world_1
select count(distinct countrylanguage.Language) as "total number of distinct official languages" from country join countrylanguage on country.Code = countrylanguage.CountryCode where country.IndepYear < 1923	s253_world_1
select GovernmentForm, sum(Population) from country group by GovernmentForm having avg(LifeExpectancy) > 82	s254_world_1
select GovernmentForm, sum(Population) from country where LifeExpectancy > (select avg(LifeExpectancy) from country) group by GovernmentForm	s255_world_1
select avg(LifeExpectancy), sum(Population), Continent from country group by Continent having avg(LifeExpectancy) < 76	s256_world_1
select name from Highschooler where grade = 9	s257_network_1
select Highschooler.name from Highschooler join Friend on Highschooler.ID = Friend.student_id where Highschooler.grade > 9 group by Highschooler.ID, Highschooler.name having count(Friend.friend_id) >= 2	s258_network_1
select Name from singer where Birth_Year = 1952 or Birth_Year = 1949	s259_singer
select count(*) from Student inner join Has_Pet on Student.StuID = Has_Pet.StuID inner join Pets on Has_Pet.PetID = Pets.PetID where Student.Sex = "F" and Pets.PetType = "cat"	s260_pets_1
select Student.Fname from Student join Has_Pet on Student.StuID = Has_Pet.StuID join Pets on Has_Pet.PetID = Pets.PetID where Pets.PetType = "cat"	s261_pets_1
select count(*) from Templates where Template_Type_Code = "BK"	s262_cre_Doc_Template_Mgt
select Paragraphs.Paragraph_ID, Paragraphs.Paragraph_Text from Documents inner join Paragraphs on Paragraphs.Document_ID = Documents.Document_ID where Documents.Document_Name = "Summer Show"	s263_cre_Doc_Template_Mgt
select Open_Year, Num_of_Staff from museum where Name = "RiverPark Museum"	s264_museum_visit
select players.first_name, players.last_name from matches join players on matches.winner_id = players.player_id where matches.tourney_name = "Birmingham" order by matches.winner_rank_points desc limit 1	s265_wta_1
select battle.name, battle.result, battle.bulgarian_commander from battle left join ship on ship.lost_in_battle = battle.id where ship.location = "Mid-Atlantic" and ship.lost_in_battle is null	s266_battle_death
select section_id, course_id, section_name, section_description, other_details from Sections where section_name = "c"	s267_student_transcripts_tracking
select Students.first_name from Students left join Addresses on Students.permanent_address_id = Addresses.address_id where Addresses.country = "Haiti" or Students.cell_mobile_number = "(462)246-7921"	s268_student_transcripts_tracking
select Original_air_date from Cartoon where Title = "Emily"	s269_tvshow
select TV_series.Episode from TV_series join TV_Channel on TV_series.Channel = TV_Channel.id where TV_Channel.series_name = "MTV Music"	s270_tvshow
select Pixel_aspect_ratio_PAR, Country from TV_Channel where Language <> "Italian"	s271_tvshow
select contestant_name from CONTESTANTS where contestant_name <> "Nita Coster"	s272_voter_1
select distinct AREA_CODE_STATE.area_code from VOTES join CONTESTANTS on VOTES.contestant_number = CONTESTANTS.contestant_number join AREA_CODE_STATE on VOTES.state = AREA_CODE_STATE.state where CONTESTANTS.contestant_name = "Kelly Clauss"	s273_voter_1
select countrylanguage.Language from country join countrylanguage on countrylanguage.CountryCode = country.Code where country.Name = "Lesotho"	s274_world_1
select Region, Population from country where Name = "Hong Kong"	s275_world_1
select countrylanguage.Language from country inner join countrylanguage on country.Code = countrylanguage.CountryCode where country.HeadOfState = "Ricardo Lagos Escobar"	s276_world_1
select max(Share), min(Share) from performance where Type <> "Auditions 1"	s277_orchestra
select grade from Highschooler where name = "Kris"	s278_network_1
select Ref_Feature_Types.feature_type_name from Other_Available_Features join Ref_Feature_Types on Other_Available_Features.feature_type_code = Ref_Feature_Types.feature_type_code where Other_Available_Features.feature_name = "BurglarAlarm"	s279_real_estate_properties
select countries.CountryName from continents inner join countries on countries.Continent = continents.ContId inner join car_makers on car_makers.Country = countries.CountryId where continents.Continent = "europe" group by countries.CountryName having count(car_makers.Id) >= 4	s280_car_1
select car_makers.Maker, car_makers.Id from car_makers join model_list on model_list.Maker = car_makers.Id group by car_makers.Maker, car_makers.Id having count(model_list.ModelId) > 2	s281_car_1
select count(*) from countries join car_makers on car_makers.Country = countries.CountryId group by countries.CountryId having count(*) > 4	s282_car_1
select count(*) from countries join car_makers on car_makers.Country = countries.CountryId group by countries.CountryName having count(car_makers.Id) > 4	s283_car_1
select Ref_Template_Types.Template_Type_Code from Ref_Template_Types join Templates on Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code group by Ref_Template_Types.Template_Type_Code having count(*) < 6	s284_cre_Doc_Template_Mgt
select Documents.Document_ID from Documents join Paragraphs on Documents.Document_ID = Paragraphs.Document_ID group by Documents.Document_ID having count(*) >= 3	s285_cre_Doc_Template_Mgt
select Documents.Document_ID from Documents inner join Paragraphs on Documents.Document_ID = Paragraphs.Document_ID group by Documents.Document_ID having count(Paragraphs.Paragraph_ID) >= 3	s286_cre_Doc_Template_Mgt
select tourney_name from matches group by tourney_id, tourney_name having count(*) > 14	s287_wta_1
select country_code from players group by country_code having count(*) > 46	s288_wta_1
select Students.first_name, Students.middle_name, Students.last_name, Students.student_id from Students join Student_Enrolment on Students.student_id = Student_Enrolment.student_id group by Student_Enrolment.student_id, Student_Enrolment.semester_id having count(Student_Enrolment.degree_program_id) = 3	s289_student_transcripts_tracking
select Episode, Rating from TV_series order by Rating desc limit 5	s290_tvshow
select Episode, Rating from TV_series order by Rating desc limit 11	s291_tvshow
select country.Name, count(*) as "Language count" from country join countrylanguage on country.Code = countrylanguage.CountryCode group by country.Code, country.Name having count(*) > 8	s292_world_1
select Name from country order by Population desc limit 5	s293_world_1
select Highschooler.name from Highschooler join Friend on Highschooler.ID = Friend.student_id group by Highschooler.ID having count(*) >= 2	s294_network_1
select Highschooler.name from Highschooler where Highschooler.grade > 5 and Highschooler.ID in (select Friend.student_id from Friend group by Friend.student_id having count(*) >= 3)	s295_network_1
select p.professional_id, p.last_name, p.cell_number from Professionals p left join Treatments t on p.professional_id = t.professional_id where p.state = "Indiana" or (select count(*) from Treatments where professional_id = p.professional_id) > 9	s296_dog_kennels
select Professionals.professional_id, Professionals.role_code, Professionals.first_name from Professionals join Treatments on Professionals.professional_id = Treatments.professional_id group by Professionals.professional_id, Professionals.role_code, Professionals.first_name having count(Treatments.treatment_id) >= 3	s297_dog_kennels
select Professionals.professional_id, Professionals.role_code, Professionals.first_name from Professionals join Treatments on Professionals.professional_id = Treatments.professional_id group by Professionals.professional_id having count(Treatments.treatment_id) >= 3	s298_dog_kennels
select Professionals.professional_id, Professionals.cell_number from Professionals join Treatments on Professionals.professional_id = Treatments.professional_id group by Professionals.professional_id, Professionals.cell_number having count(distinct Treatments.treatment_type_code) >= 3	s299_dog_kennels
select Song_Name from singer where Age < (select avg(Age) from singer)	s300_concert_singer
select count(*) from Pets where weight < 10	s301_pets_1
select countries.CountryName, countries.CountryId from countries join car_makers on car_makers.Country = countries.CountryId group by countries.CountryName, countries.CountryId having count(*) > 1	s302_car_1
select avg(Horsepower) from cars_data where Year > 1980	s303_car_1
select avg(Horsepower) from cars_data where Year > 1980	s304_car_1
select car_makers.FullName, car_makers.Id from car_makers join model_list on model_list.Maker = car_makers.Id group by car_makers.FullName, car_makers.Id having count(model_list.ModelId) <= 3	s305_car_1
select distinct model_list.Model from model_list join car_makers on model_list.Maker = car_makers.Id where car_makers.FullName = "General Motors" union select distinct model_list.Model from model_list join car_names on model_list.Model = car_names.Model join cars_data on car_names.MakeId = cars_data.Id where cars_data.Weight < 3500	s306_car_1
select Name from shop where Number_products < (select avg(Number_products) from shop)	s307_employee_hire_evaluation
select Name from shop where Number_products < (select avg(Number_products) from shop)	s308_employee_hire_evaluation
select country_code from players group by country_code having count(*) < 50	s309_wta_1
select Courses.course_name, Courses.course_id from Courses join Sections on Courses.course_id = Sections.course_id group by Courses.course_name, Courses.course_id having count(Sections.section_id) >= 2	s310_student_transcripts_tracking
select Transcripts.transcript_date, Transcripts.transcript_id from Transcripts join Transcript_Contents on Transcripts.transcript_id = Transcript_Contents.transcript_id group by Transcripts.transcript_date, Transcripts.transcript_id having count(Transcript_Contents.student_course_id) < 2	s311_student_transcripts_tracking
select id from TV_Channel where Country in (select Country from TV_Channel group by Country having count(*) < 2)	s312_tvshow
select Nationality from people group by Nationality having count(*) < 2	s313_poker_player
select Name from country where Continent = "Asia" and Population < (select min(Population) from country where Continent = "Africa")	s314_world_1
select District, count(*) from city group by District having avg(Population) < (select avg(Population) from city)	s315_world_1
select Continent, sum(Population), avg(LifeExpectancy) from country group by Continent having avg(LifeExpectancy) > 72	s316_world_1
select Highschooler.name from Highschooler join Friend on Highschooler.ID = Friend.student_id group by Highschooler.ID having count(*) <= 3	s317_network_1
select distinct singer.Name from singer inner join song on singer.Singer_ID = song.Singer_ID where song.Sales <= 300000	s318_singer
select distinct singer.Name from singer join song on song.Singer_ID = singer.Singer_ID where song.Sales < 300000	s319_singer
select Name, Song_release_year from singer order by Age asc limit 1	s320_concert_singer
select Year from concert group by Year having count(concert_ID) = (select min(count_per_year) from (select Year, count(concert_ID) as count_per_year from concert group by Year))	s321_concert_singer
select min(cars_data.Horsepower), car_makers.Maker from cars_data join car_names on cars_data.Id = car_names.MakeId join model_list on car_names.Model = model_list.Model join car_makers on model_list.Maker = car_makers.Id where cars_data.Cylinders = 3	s322_car_1
select a.Abbreviation, a.Country from airlines a join flights f on a.uid = f.Airline group by a.uid having count(*) = (select max(count) from (select f.Airline, count(*) as count from flights f group by f.Airline) subquery)	s323_flight_2
select Manager_name, District from shop where Number_products = (select min(Number_products) from shop)	s324_employee_hire_evaluation
select employee.Name from employee join evaluation on evaluation.Employee_ID = employee.Employee_ID order by evaluation.Bonus asc limit 1	s325_employee_hire_evaluation
select winner_name, loser_name from matches order by minutes asc limit 1	s326_wta_1
select section_name from Sections order by section_name asc	s327_student_transcripts_tracking
select s.semester_name, s.semester_id from Semesters s join Student_Enrolment se on s.semester_id = se.semester_id group by s.semester_id, s.semester_name order by count(*) asc limit 1	s328_student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_left desc limit 1	s329_student_transcripts_tracking
select Transcripts.transcript_date, Transcripts.transcript_id from Transcripts join Transcript_Contents on Transcript_Contents.transcript_id = Transcripts.transcript_id group by Transcripts.transcript_id order by count(*) desc limit 1	s330_student_transcripts_tracking
select people.Birth_Date from poker_player join people on poker_player.People_ID = people.People_ID order by poker_player.Earnings desc limit 1	s331_poker_player
select Nationality from people group by Nationality order by count(*) asc limit 1	s332_poker_player
select Name, Birth_Date from people order by Name desc	s333_poker_player
select countrylanguage.Language from country inner join countrylanguage on country.Code = countrylanguage.CountryCode where country.Name = "Aruba" order by countrylanguage.Percentage asc limit 1	s334_world_1
select Continent from country join countrylanguage on country.Code = countrylanguage.CountryCode group by Continent having count(Language) <= (select min(language_count) from (select count(*) as language_count from country join countrylanguage on country.Code = countrylanguage.CountryCode group by Continent))	s335_world_1
select Name from conductor order by Age desc	s336_orchestra
select Name from conductor order by Year_of_Work asc limit 1	s337_orchestra
select Name from conductor join orchestra on conductor.Conductor_ID = orchestra.Conductor_ID group by conductor.Conductor_ID having count(*) = (select min(orchestra_count) from (select count(*) as orchestra_count from orchestra group by Conductor_ID))	s338_orchestra
select grade from Highschooler group by grade having count(*) = (select min(student_count) from (select count(*) as student_count from Highschooler group by grade))	s339_network_1
