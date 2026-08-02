select PetType, weight from Pets order by birthyear desc limit 1	s000_pets_1_5
select Student.LName from Student join Has_Pet on Student.StuID = Has_Pet.StuID join Pets on Has_Pet.PetID = Pets.PetID where Pets.is_cat = "T" and Pets.pet_age = 3	s001_pets_1_4
select teacher.first_name, teacher.last_name, course.Course from course_arrange join teacher on course_arrange.Teacher_ID = teacher.Teacher_ID join course on course_arrange.Course_ID = course.Course_ID	s002_course_teach_5
select teacher.first_name, teacher.last_name, count(*) from teacher join course_arrange on teacher.Teacher_ID = course_arrange.Teacher_ID group by teacher.Teacher_ID	s003_course_teach_1
select Name, Level_of_membership from visitor where Level_of_membership > 4 order by birthyear asc	s004_museum_visit_1
select count(*) from matches inner join players on matches.winner_id = players.player_id where matches.tourney_name = "WTA Championships" and players.is_right_handed = "F"	s005_wta_1_0
select t.transcript_date, t.transcript_id from Transcripts t join Transcript_Contents tc on t.transcript_id = tc.transcript_id group by t.transcript_id having count(tc.student_course_id) = (select min(cnt) from (select count(tc.student_course_id) as cnt from Transcript_Contents tc group by tc.transcript_id))	s006_student_transcripts_tracking_0
select distinct Semesters.semester_id from Semesters inner join Student_Enrolment on Student_Enrolment.semester_id = Semesters.semester_id inner join Degree_Programs on Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id where (Degree_Programs.is_bachelor = "T") intersect select distinct Semesters.semester_id from Semesters inner join Student_Enrolment on Student_Enrolment.semester_id = Semesters.semester_id inner join Degree_Programs on Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id where (Degree_Programs.is_master = "T")	s007_student_transcripts_tracking_0
select distinct TV_Channel.Country from Cartoon join TV_Channel on Cartoon.Channel = TV_Channel.id where Cartoon.writer_firstname = "Todd" and Cartoon.writer_lastname = "Casey"	s008_tvshow_0
select id from TV_Channel where id not in (select Channel from Cartoon where director_firstname = "Ben" and director_lastname = "Jones")	s009_tvshow_5
select id from TV_Channel where id not in (select Channel from Cartoon where director_firstname = "Ben" and director_lastname = "Jones")	s010_tvshow_5
select people.first_name, people.last_name from poker_player join people on poker_player.People_ID = people.People_ID	s011_poker_player_0
select first_name, last_name, Birth_Date from people order by first_name asc, last_name asc	s012_poker_player_0
select distinct state, created_time from VOTES	s013_voter_1_7
select first_name, last_name from conductor where Nationality <> "USA"	s014_orchestra_3
select first_name, last_name from conductor where Nationality <> "USA"	s015_orchestra_3
select Name from conductor order by year_start_to_work asc limit 1	s016_orchestra_1
select conductor.first_name, conductor.last_name from conductor join orchestra on orchestra.Conductor_ID = conductor.Conductor_ID where orchestra.Year_of_Founded > 2008	s017_orchestra_3
select singer.first_name, singer.last_name from singer join song on singer.Singer_ID = song.Singer_ID group by singer.Singer_ID having count(song.Song_ID) > 1	s018_singer_0
select first_name, last_name from singer where not EXISTS (select 1 from song where song.Singer_ID = singer.Singer_ID)	s019_singer_0
select PetType, max(wt) from Pets group by PetType	s020_pets_1_1
select model_list.Model from model_list join car_names on model_list.Model = car_names.Model join cars_data on car_names.MakeId = cars_data.Id where cars_data.wt < (select avg(wt) from cars_data)	s021_car_1_0
select car_makers.Maker, model_list.mdl from car_makers join model_list on model_list.Maker = car_makers.Id	s022_car_1_1
select model_list.mdl from model_list join car_names on car_names.mdl = model_list.mdl join cars_data on cars_data.Id = car_names.MakeId order by cars_data.MPG desc limit 1	s023_car_1_3
select City, cntry from airports where apt_name = "Alton"	s024_flight_2_4
select count(*) from flights join airports on flights.srcapt = airports.AirportCode where airports.City = "Aberdeen"	s025_flight_2_4
select apt_name from airports where not EXISTS (select 1 from flights where flights.srcapt = airports.apt_code or flights.destapt = airports.apt_code)	s026_flight_2_0
select count(distinct loc) from shop	s027_employee_hire_evaluation_0
select count(distinct Templates.Template_ID) from Templates join Ref_Template_Types on Templates.tpl_tpye_code = Ref_Template_Types.tpl_type_code	s028_cre_Doc_Template_Mgt_2
select Templates.Template_ID from Templates where not EXISTS (select 1 from Documents where Documents.tpl_id = Templates.Template_ID)	s029_cre_Doc_Template_Mgt_1
select teacher.Name from teacher join course_arrange on course_arrange.tchr_id = teacher.Teacher_ID group by teacher.Teacher_ID having count(course_arrange.Course_ID) >= 2	s030_course_teach_4
select Name from visitor where lvl_mem > 4 order by lvl_mem desc	s031_museum_visit_2
select players.first_name, players.country_code, players.dob from players join matches on players.player_id = matches.winner_id order by matches.winner_rank_points desc limit 1	s032_wta_1_3
select Addresses.adr_id, Addresses.line_1, Addresses.line_2, Addresses.line_3 from Addresses join Students on Students.permanent_address_id = Addresses.adr_id group by Addresses.adr_id, Addresses.line_1, Addresses.line_2, Addresses.line_3 order by count(*) desc limit 1	s033_student_transcripts_tracking_0
select Title, dir from Cartoon order by Original_air_date asc	s034_tvshow_0
select ep from TV_series order by rtg desc	s035_tvshow_0
select country.Region from city join country on city.cntry_code = country.Code where city.Name = "Kabul"	s036_world_1_4
select country.Name from country join countrylanguage on country.Code = countrylanguage.CountryCode where (countrylanguage.Language = "English" and countrylanguage.ofcl = "T") or (countrylanguage.Language = "Dutch" and countrylanguage.ofcl = "T")	s037_world_1_1
select Name from country order by popn asc limit 3	s038_world_1_0
select record_co, Year_of_Founded from orchestra order by Year_of_Founded desc	s039_orchestra_0
select count(*) from concert where Stadium_ID = (select Stadium_ID from stadium order by max_carrying_number desc limit 1)	s040_concert_singer_1
select Student.Fname, Student.gender from Student inner join Has_Pet on Student.StuID = Has_Pet.StuID group by Student.StuID having count(Has_Pet.PetID) > 1	s041_pets_1_1
select count(*) from cars_data where engine > 150	s042_car_1_2
select cylinder_number, max(speed_up) from cars_data group by cylinder_number	s043_car_1_0
select ModelId from model_list group by ModelId order by count(distinct version) desc limit 1	s044_car_1_0
select count(*) from flights where flight_from = "APG"	s045_flight_2_0
select a.Airline from airlines a join flights f on a.uid = f.air_way group by a.Airline order by count(*) desc limit 1	s046_flight_2_2
select distinct category_cipher from Ref_Template_Types	s047_cre_Doc_Template_Mgt_3
select category_cipher from Ref_Template_Types except select template_kind_codification from Templates join Documents on Templates.Template_ID = Documents.Template_ID	s048_cre_Doc_Template_Mgt_2
select category_code, description from Ref_Template_Types	s049_cre_Doc_Template_Mgt_0
select distinct p.given_name, p.country_code from players p inner join matches m1 on m1.winner_id = p.player_id inner join matches m2 on m2.winner_id = p.player_id where m1.tourney_name = "WTA Championships" and m2.tourney_name = "Australian Open"	s050_wta_1_1
select nation_code, count(*) from players group by nation_code	s051_wta_1_4
select count(*) from country join countrylanguage on countrylanguage.CountryCode = country.Code where countrylanguage.official_language = "Chinese"	s052_world_1_0
select Name from country where Continent = "Africa" and how_many_people < (select min(how_many_people) from country where Continent = "Asia")	s053_world_1_3
select District, count(*) from city group by District having avg(total_citizens) < (select avg(total_citizens) from city)	s054_world_1_3
select count(*) from country where mainland = "Asia"	s055_world_1_4
select Treatments.time_of_therapeutics, Professionals.forename from Treatments inner join Professionals on Treatments.professional_id = Professionals.professional_id	s056_dog_kennels_0
select Owners.forename, Owners.last_name, Sizes.size_explanation from Owners inner join Dogs on Owners.owner_id = Dogs.owner_id inner join Sizes on Dogs.size_code = Sizes.size_code	s057_dog_kennels_4
select Name from singer where born_date = 1948 or born_date = 1949	s058_singer_4
select nationality, count(*) from singer group by nationality	s059_singer_0
select count(*) from concert join stadium on concert.Stadium_ID = stadium.Stadium_ID where stadium.Capacity = (select max(Capacity) from stadium)	s060_concert_singer
select model_list.Model from model_list join car_names on car_names.Model = model_list.Model join cars_data on cars_data.Id = car_names.MakeId where cars_data.Weight < (select avg(Weight) from cars_data)	s061_car_1
select car_names.Make, cars_data.Horsepower from cars_data inner join car_names on cars_data.Id = car_names.MakeId where cars_data.Cylinders = 3 order by cars_data.Horsepower desc limit 1	s062_car_1
select Id from cars_data order by MPG desc limit 1	s063_car_1
select count(*) from cars_data where Accelerate > (select max(Horsepower) from cars_data)	s064_car_1
select visitor.ID, sum(visit.Total_spent) as Total_spent, visitor.Level_of_membership from visitor join visit on visitor.ID = visit.visitor_ID group by visitor.ID, visitor.Level_of_membership having sum(visit.Total_spent) = (select max(total_spent) from (select sum(Total_spent) as total_spent from visit group by visitor_ID))	s065_museum_visit
select first_name, country_code from players order by birth_date asc limit 1	s066_wta_1
select players.first_name, players.last_name from players join matches on matches.winner_id = players.player_id where matches.tourney_name = "Australian Open" order by matches.winner_rank desc limit 1	s067_wta_1
select loser_name, winner_name from matches order by minutes desc limit 1	s068_wta_1
select first_name, middle_name, last_name from Students order by date_first_registered asc limit 1	s069_student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_first_registered asc limit 1	s070_student_transcripts_tracking
select Production_code, Channel from Cartoon order by Original_air_date desc limit 1	s071_tvshow
select Money_Rank from poker_player order by Earnings desc limit 1	s072_poker_player
select people.Birth_Date from poker_player join people on poker_player.People_ID = people.People_ID order by poker_player.Earnings asc limit 1	s073_poker_player
select poker_player.Money_Rank from poker_player join people on poker_player.People_ID = people.People_ID order by people.Height desc limit 1	s074_poker_player
select Name, Population, LifeExpectancy from country where Continent = "Asia" order by SurfaceArea desc limit 1	s075_world_1
select Name, Population, LifeExpectancy from country where Continent = "Asia" order by Population desc limit 1	s076_world_1
select Name, IndepYear, SurfaceArea from country order by Population asc limit 1	s077_world_1
select Population, Name, HeadOfState from country order by Population desc limit 1	s078_world_1
select O.owner_id, O.zip_code from Owners O join Dogs D on O.owner_id = D.owner_id join Treatments T on D.dog_id = T.dog_id group by O.owner_id, O.zip_code order by sum(T.cost_of_treatment) desc limit 1	s079_dog_kennels
select Name, Country, Age from singer order by Age desc	s080_concert_singer
select stadium.Name from stadium where not EXISTS (select 1 from concert where concert.Stadium_ID = stadium.Stadium_ID and concert.Year = "2014")	s081_concert_singer
select distinct stadium.Name, stadium.Location from stadium join concert on concert.Stadium_ID = stadium.Stadium_ID where concert.Year = "2014" union select distinct stadium.Name, stadium.Location from stadium join concert on concert.Stadium_ID = stadium.Stadium_ID where concert.Year = "2015"	s082_concert_singer
select Airline, Abbreviation from airlines where Country = "USA"	s083_flight_2
select AirportName from airports where City = "Aberdeen"	s084_flight_2
select shop.Name, count(*) from shop inner join hiring on shop.Shop_ID = hiring.Shop_ID group by shop.Name	s085_employee_hire_evaluation
select teacher.Name, course.Course from course_arrange inner join teacher on course_arrange.Teacher_ID = teacher.Teacher_ID inner join course on course_arrange.Course_ID = course.Course_ID	s086_course_teach
select avg(winner_age), avg(loser_age) from matches	s087_wta_1
select degree_summary_name from Degree_Programs join Student_Enrolment on Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id group by degree_summary_name order by count(*) desc limit 1	s088_student_transcripts_tracking
select semester_name from Semesters where not EXISTS (select 1 from Student_Enrolment where Student_Enrolment.semester_id = Semesters.semester_id)	s089_student_transcripts_tracking
select distinct Courses.course_id from Courses join Student_Enrolment_Courses on Courses.course_id = Student_Enrolment_Courses.course_id	s090_student_transcripts_tracking
select T1.first_name, T1.middle_name, T1.last_name from Students as T1 join Student_Enrolment as T2 on T1.student_id = T2.student_id join Student_Enrolment_Courses as T3 on T2.student_enrolment_id = T3.student_enrolment_id join Transcript_Contents as T4 on T3.student_course_id = T4.student_course_id join Transcripts as T5 on T4.transcript_id = T5.transcript_id order by T1.date_first_registered asc limit 1	s091_student_transcripts_tracking
select TV_Channel.series_name, TV_Channel.Country from TV_Channel join Cartoon on TV_Channel.id = Cartoon.Channel where Cartoon.Directed_by = "Ben Jones" or Cartoon.Directed_by = "Michael Chang"	s092_tvshow
select TV_Channel.Country, TV_Channel.series_name from TV_Channel inner join Cartoon on TV_Channel.id = Cartoon.Channel where Cartoon.Directed_by = "Ben Jones" intersect select TV_Channel.Country, TV_Channel.series_name from TV_Channel inner join Cartoon on TV_Channel.id = Cartoon.Channel where Cartoon.Directed_by = "Michael Chang"	s093_tvshow
select Name from people where not EXISTS (select 1 from poker_player where poker_player.People_ID = people.People_ID)	s094_poker_player
select contestant_name from CONTESTANTS where contestant_name like "%Al%"	s095_voter_1
select Name from country order by Population asc limit 3	s096_world_1
select Name, Year_of_Work from conductor order by Year_of_Work desc	s097_orchestra
select Highschooler.name from Highschooler where not EXISTS (select 1 from Friend where Friend.student_id = Highschooler.ID)	s098_network_1
select date_arrived, date_departed from Dogs	s099_dog_kennels
select car_names.Model from car_makers inner join model_list on model_list.Maker = car_makers.Id inner join car_names on car_names.Model = model_list.Model inner join cars_data on cars_data.Id = car_names.MakeId where car_makers.FullName = "General Motors" and cars_data.Weight > 1500	s100_car_1
select Year from cars_data where Weight between 3000 and 4000	s101_car_1
select FlightNo from flights where SourceAirport = "APG"	s102_flight_2
select Ref_Template_Types.Template_Type_Description from Documents inner join Templates on Documents.Template_ID = Templates.Template_ID inner join Ref_Template_Types on Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code where Documents.Document_Name = "Data base"	s103_cre_Doc_Template_Mgt
select Ref_Template_Types.Template_Type_Code from Ref_Template_Types left join Templates on Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code left join Documents on Templates.Template_ID = Documents.Template_ID where Documents.Template_ID is null	s104_cre_Doc_Template_Mgt
select p.first_name , p.last_name, r.ranking_points from players p join matches m on p.player_id = m.winner_id join rankings r on p.player_id = r.player_id group by m.winner_id, p.first_name, p.last_name, r.ranking_points having count(m.winner_id) = (select max(win_count) from (select count(m.winner_id) as win_count from matches m group by m.winner_id) subquery) limit 1	s105_wta_1
select winner_name, winner_rank_points from matches group by winner_name, winner_rank_points order by count(*) desc limit 1	s106_wta_1
select section_name, section_description from Sections	s107_student_transcripts_tracking
select section_id, course_id, section_name, section_description, other_details from Sections	s108_student_transcripts_tracking
select Money_Rank from poker_player order by Earnings desc limit 1	s109_poker_player
select people.Name from poker_player inner join people on poker_player.People_ID = people.People_ID where poker_player.Earnings > 300000	s110_poker_player
select avg(poker_player.Earnings) from poker_player join people on poker_player.People_ID = people.People_ID where people.Height > 200	s111_poker_player
select Nationality, count(*) from people group by Nationality	s112_poker_player
select avg(country.LifeExpectancy) from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language <> "English" and countrylanguage.IsOfficial = "T"	s113_world_1
select countrylanguage.Language, countrylanguage.IsOfficial, countrylanguage.Percentage from country join countrylanguage on country.Code = countrylanguage.CountryCode where country.HeadOfState = "Beatrix"	s114_world_1
select city.Name from city join country on city.CountryCode = country.Code join countrylanguage on country.Code = countrylanguage.CountryCode where country.Continent = "Europe" and countrylanguage.Language <> "English" and countrylanguage.IsOfficial = "T"	s115_world_1
select Orchestra, Year_of_Founded from orchestra order by Year_of_Founded desc	s116_orchestra
select Name from singer order by Net_Worth_Millions asc	s117_singer
select Name from singer order by Net_Worth_Millions desc limit 1	s118_singer
select Citizenship, max(Net_Worth_Millions) from singer group by Citizenship	s119_singer
select count(*) from concert where Year = "2014" or Year = "2015"	s120_concert_singer
select stadium.Name from stadium where not EXISTS (select 1 from concert where concert.Stadium_ID = stadium.Stadium_ID and concert.Year = "2014")	s121_concert_singer
select count(*) from Student inner join Has_Pet on Student.StuID = Has_Pet.StuID inner join Pets on Has_Pet.PetID = Pets.PetID where Student.Sex = "F" and Pets.PetType = "dog"	s122_pets_1
select distinct Year from cars_data where Weight < 4000 and Weight > 3000	s123_car_1
select countries.CountryId, countries.CountryName from countries join car_makers on car_makers.Country = countries.CountryId where car_makers.Maker = "fiat" group by countries.CountryId, countries.CountryName having count(car_makers.Id) > 3	s124_car_1
select AirportCode, AirportName from airports where City = "Anthony"	s125_flight_2
select count(*) from flights join airports on flights.SourceAirport = airports.AirportCode where airports.City = "Aberdeen"	s126_flight_2
select Document_ID, Template_ID, Document_Description from Documents where Document_Name = "Robbin CV"	s127_cre_Doc_Template_Mgt
select count(*) from matches where year = 2013 or year = 2016	s128_wta_1
select battle.name, battle.date from battle join ship on ship.lost_in_battle = battle.id where ship.name = "HMS Atalanta" or ship.name = "Lettice"	s129_battle_death
select section_description from Sections where section_name = "h"	s130_student_transcripts_tracking
select Students.first_name from Students left join Addresses on Students.permanent_address_id = Addresses.address_id where Addresses.country = "Haiti" or Students.cell_mobile_number = "09700166582"	s131_student_transcripts_tracking
select count(*) from TV_Channel where Language = "English"	s132_tvshow
select TV_series.Channel, TV_Channel.series_name from TV_series inner join TV_Channel on TV_series.Channel = TV_Channel.id where TV_series.Episode = "A Love of a Lifetime"	s133_tvshow
select Name from people where Nationality <> "Russia"	s134_poker_player
select Continent from country where Name = "Anguilla"	s135_world_1
select sum(SurfaceArea) from country where Continent = "Asia" or Continent = "Europe"	s136_world_1
select max(Share), min(Share) from performance where Type <> "live finals"	s137_orchestra
select Professionals.professional_id, Professionals.last_name, Professionals.cell_number from Professionals join Treatments on Treatments.professional_id = Professionals.professional_id where Professionals.state = "Indiana" group by Professionals.professional_id, Professionals.last_name, Professionals.cell_number having count(Treatments.treatment_id) > 2	s138_dog_kennels
select Name from singer where Citizenship <> "France"	s139_singer
select singer.Name, count(*) from singer inner join singer_in_concert on singer.Singer_ID = singer_in_concert.Singer_ID group by singer.Name	s140_concert_singer
select count(*) from Student join Has_Pet on Student.StuID = Has_Pet.StuID where Student.Age > 20	s141_pets_1
select count(*) from cars_data where Cylinders > 6	s142_car_1
select count(*) from flights where DestAirport = "ATO"	s143_flight_2
select count(*) from flights inner join airports on flights.DestAirport = airports.AirportCode where airports.City = "Aberdeen"	s144_flight_2
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
select count(*) from orchestra where Major_Record_Format like "%CD%" or Major_Record_Format like "%DVD%"	s155_orchestra
select count(*) from Highschooler where grade = 9 or grade = 10	s156_network_1
select count(*) from Highschooler inner join Friend on Highschooler.ID = Friend.student_id where Highschooler.name = "Kyle"	s157_network_1
select count(*) from Dogs inner join Treatments on Dogs.dog_id = Treatments.dog_id	s158_dog_kennels
select count(*) from Professionals where professional_id not in (select distinct professional_id from Treatments)	s159_dog_kennels
select Student.Fname, Student.Sex from Student join Has_Pet on Student.StuID = Has_Pet.StuID group by Has_Pet.StuID having count(Has_Pet.PetID) >= 2	s160_pets_1
select model_list.Model from model_list join cars_data on model_list.ModelId = cars_data.Id join car_makers on model_list.Maker = car_makers.Id where cars_data.Weight < 3500 and car_makers.FullName <> "Ford Motor Company"	s161_car_1
select Manager_name, District from shop order by Number_products desc limit 1	s162_employee_hire_evaluation
select shop.Name from shop join hiring on shop.Shop_ID = hiring.Shop_ID group by shop.Shop_ID, shop.Name order by count(*) desc limit 1	s163_employee_hire_evaluation
select Ref_Template_Types.Template_Type_Code, count(*) from Ref_Template_Types join Templates on Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code join Documents on Documents.Template_ID = Templates.Template_ID group by Ref_Template_Types.Template_Type_Code	s164_cre_Doc_Template_Mgt
select count(*) from Paragraphs	s165_cre_Doc_Template_Mgt
select visitor.Name, visitor.Age from visitor join visit on visit.visitor_ID = visitor.ID order by visit.Num_of_Ticket desc limit 1	s166_museum_visit
select country_code from players group by country_code having count(player_id) = (select max(player_count) from (select country_code, count(player_id) as player_count from players group by country_code))	s167_wta_1
select max(killed), min(killed) from death	s168_battle_death
select A.address_id, A.line_1, A.line_2 from Addresses as A join Students as S on A.address_id = S.permanent_address_id or A.address_id = S.current_address_id group by A.address_id order by count(*) desc limit 1	s169_student_transcripts_tracking
select transcript_date, other_details from Transcripts order by transcript_date asc limit 1	s170_student_transcripts_tracking
select avg(Earnings) from poker_player	s171_poker_player
select max(Final_Table_Made) from poker_player where Earnings < 200000	s172_poker_player
select avg(GNP), sum(Population) from country where GovernmentForm = "US Territory"	s173_world_1
select count(*) from (select distinct country.Code from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "English" or countrylanguage.Language = "Dutch")	s174_world_1
select Name from country where Continent = "Asia" and Population > (select max(Population) from country where Continent = "Africa")	s175_world_1
select conductor.Name from conductor join orchestra on conductor.Conductor_ID = orchestra.Conductor_ID where orchestra.Year_of_Founded > 2008	s176_orchestra
select grade from Highschooler group by grade having count(*) = (select max(student_count) from (select count(*) as student_count from Highschooler group by grade))	s177_network_1
select o.owner_id, o.first_name, o.last_name from Owners o join Dogs d on o.owner_id = d.owner_id join Treatments t on d.dog_id = t.dog_id group by o.owner_id, o.first_name, o.last_name having sum(t.cost_of_treatment) = (select max(total_cost) from (select sum(t.cost_of_treatment) as total_cost from Owners o join Dogs d on o.owner_id = d.owner_id join Treatments t on d.dog_id = t.dog_id group by o.owner_id))	s178_dog_kennels
select Professionals.first_name, Professionals.cell_number from Professionals join Treatments on Professionals.professional_id = Treatments.professional_id group by Professionals.professional_id having count(distinct Treatments.treatment_type_code) >= 2	s179_dog_kennels
select min(Age), max(Age), avg(Age) from singer where Country = "France"	s180_concert_singer
select count(*) from Pets where weight > 10	s181_pets_1
select cars_data.Cylinders from car_makers inner join model_list on model_list.Maker = car_makers.Id inner join car_names on car_names.Model = model_list.Model inner join cars_data on cars_data.Id = car_names.MakeId where car_makers.Maker = "volvo" order by cars_data.Accelerate asc limit 1	s182_car_1
select car_names.Model from car_names inner join cars_data on car_names.MakeId = cars_data.Id where cars_data.Cylinders = 4 order by cars_data.Horsepower desc limit 1	s183_car_1
select car_makers.Maker, car_makers.Id from car_makers join model_list on car_makers.Id = model_list.Maker join car_names on model_list.Model = car_names.Model join cars_data on car_names.MakeId = cars_data.Id where cars_data.Horsepower > (select min(Horsepower) from cars_data) and cars_data.Cylinders <= 3	s184_car_1
select airports.AirportCode from airports join flights on airports.AirportCode = flights.SourceAirport or airports.AirportCode = flights.DestAirport group by airports.AirportCode having count(*) >= (select max(flight_count) from (select count(*) as flight_count from flights join airports on flights.SourceAirport = airports.AirportCode or flights.DestAirport = airports.AirportCode group by airports.AirportCode))	s185_flight_2
select min(Number_products), max(Number_products) from shop	s186_employee_hire_evaluation
select Name from teacher where Age = "33"	s187_course_teach
select Courses.course_name, Courses.course_id from Courses join Sections on Courses.course_id = Sections.course_id group by Courses.course_id having count(Sections.section_id) < 2	s188_student_transcripts_tracking
select Transcripts.transcript_date, Transcripts.transcript_id from Transcripts join Transcript_Contents on Transcripts.transcript_id = Transcript_Contents.transcript_id group by Transcripts.transcript_id having count(Transcript_Contents.student_course_id) >= 2	s189_student_transcripts_tracking
select min(transcript_date), other_details from Transcripts where transcript_date = (select min(transcript_date) from Transcripts)	s190_student_transcripts_tracking
select Title from Cartoon where Directed_by = "Brandon Nguyen" or Directed_by = "Benjamin Jones"	s191_tvshow
select series_name, Package_Option from TV_Channel where series_name = "Sky Radio"	s192_tvshow
select Language, count(*) from TV_Channel group by Language order by count(*) asc limit 1	s193_tvshow
select Earnings from poker_player order by Earnings desc	s194_poker_player
select people.Name from poker_player join people on poker_player.People_ID = people.People_ID order by poker_player.Final_Table_Made desc	s195_poker_player
select Name from country where Continent = "Asia" order by LifeExpectancy asc limit 1	s196_world_1
select Record_Company from orchestra group by Record_Company having count(Orchestra_ID) = (select max(counts) from (select count(Orchestra_ID) as counts from orchestra group by Record_Company))	s197_orchestra
select grade from Highschooler group by grade having count(*) >= 4	s198_network_1
select first_name, email_address from Owners where state like "North%"	s199_dog_kennels
select count(*) from Student join Has_Pet on Student.StuID = Has_Pet.StuID where Student.Age > 20	s200_pets_1
select PetType, avg(weight) from Pets group by PetType	s201_pets_1
select count(*) from car_makers join countries on car_makers.Country = countries.CountryId where countries.CountryName = "france"	s202_car_1
select min(Weight) from cars_data where Year = 1974 and Cylinders = 8	s203_car_1
select countries.CountryName from countries join continents on countries.Continent = continents.ContId join car_makers on car_makers.Country = countries.CountryId where continents.Continent = "europe" group by countries.CountryName having count(*) >= 3	s204_car_1
select count(*) from airports	s205_flight_2
select employee.Name from employee join evaluation on employee.Employee_ID = evaluation.Employee_ID group by employee.Name having count(*) = (select max(awards_count) from (select count(*) as awards_count from evaluation group by Employee_ID))	s206_employee_hire_evaluation
select Templates.Template_ID from Templates inner join Documents on Documents.Template_ID = Templates.Template_ID group by Templates.Template_ID having count(Documents.Document_ID) > 1	s207_cre_Doc_Template_Mgt
select distinct Ref_Template_Types.Template_Type_Description from Ref_Template_Types join Templates on Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code join Documents on Documents.Template_ID = Templates.Template_ID	s208_cre_Doc_Template_Mgt
select count(*) from teacher	s209_course_teach
select avg(Num_of_Staff) from museum where Open_Year < 2009	s210_museum_visit
select cell_mobile_number from Students where first_name = "Timmothy" and last_name = "Ward"	s211_student_transcripts_tracking
select Poker_Player.Money_Rank from poker_player as Poker_Player join people as People on Poker_Player.People_ID = People.People_ID order by People.Height desc limit 1	s212_poker_player
select Name from country where Continent = "Africa" and Population < (select min(Population) from country where Continent = "Asia")	s213_world_1
select Name, Conductor_ID from conductor	s214_orchestra
select Friend.student_id from Friend join Likes on Friend.friend_id = Likes.liked_id	s215_network_1
select Treatments.date_of_treatment, Professionals.first_name from Treatments join Professionals on Treatments.professional_id = Professionals.professional_id	s216_dog_kennels
select first_name, last_name, email_address from Owners where state like "%North%"	s217_dog_kennels
select count(*) as count from Dogs where age < (select avg(age) from Dogs)	s218_dog_kennels
select song.Title, singer.Name from song inner join singer on song.Singer_ID = singer.Singer_ID	s219_singer
select distinct Country from singer where Age > 20	s220_concert_singer
select min(Weight) from cars_data where Cylinders = 8 and Year = 1974	s221_car_1
select count(*) from model_list join car_names on car_names.Model = model_list.Model join cars_data on cars_data.Id = car_names.MakeId where cars_data.Cylinders > 6	s222_car_1
select car_names.Model from cars_data inner join car_names on cars_data.Id = car_names.MakeId where cars_data.Cylinders = 4 order by cars_data.Horsepower desc limit 1	s223_car_1
select cars_data.Id from cars_data join car_names on cars_data.Id = car_names.MakeId join model_list on car_names.Model = model_list.Model join car_makers on model_list.Maker = car_makers.Id where cars_data.Weight < 3500 and car_makers.Maker <> "ford"	s224_car_1
select countries.CountryId, countries.CountryName from countries join car_makers on car_makers.Country = countries.CountryId where car_makers.Maker = "fiat" union select countries.CountryId, countries.CountryName from countries join car_makers on car_makers.Country = countries.CountryId join model_list on model_list.Maker = car_makers.Id join car_names on car_names.Model = model_list.Model join cars_data on cars_data.Id = car_names.MakeId group by countries.CountryId, countries.CountryName having count(cars_data.Id) > 3	s225_car_1
select count(*) from airlines join flights on airlines.Abbreviation = flights.Airline where flights.SourceAirport = "AHD" and airlines.Airline = "United Airlines"	s226_flight_2
select count(*) from (select District from shop where Number_products < 3000 group by District having count(*) > 0 intersect select District from shop where Number_products > 10000 group by District having count(*) > 0)	s227_employee_hire_evaluation
select Version_Number, Template_Type_Code from Templates where Version_Number > 5	s228_cre_Doc_Template_Mgt
select Version_Number, Template_Type_Code from Templates where Version_Number > 5	s229_cre_Doc_Template_Mgt
select Ref_Template_Types.Template_Type_Code from Ref_Template_Types join Templates on Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code group by Ref_Template_Types.Template_Type_Code having count(*) < 3	s230_cre_Doc_Template_Mgt
select Paragraphs.Paragraph_Text from Paragraphs join Documents on Paragraphs.Document_ID = Documents.Document_ID where Documents.Document_Name = "customer review"	s231_cre_Doc_Template_Mgt
select Documents.Document_ID from Documents join Paragraphs on Documents.Document_ID = Paragraphs.Document_ID group by Documents.Document_ID having count(Paragraphs.Paragraph_ID) <= 2	s232_cre_Doc_Template_Mgt
select teacher.Name from teacher join course_arrange on course_arrange.Teacher_ID = teacher.Teacher_ID join course on course_arrange.Course_ID = course.Course_ID where course.Course = "Math"	s233_course_teach
select people.Name from poker_player inner join people on poker_player.People_ID = people.People_ID where poker_player.Earnings > 300000	s234_poker_player
select Name from country where SurfaceArea > (select max(SurfaceArea) from country where Continent = "Europe")	s235_world_1
select Name from country order by Population desc limit 3	s236_world_1
select Name from city where Population between 160000 and 900000	s237_world_1
select Highschooler.name from Highschooler join Likes on Highschooler.ID = Likes.student_id group by Likes.student_id, Highschooler.name having count(*) >= 2	s238_network_1
select Owners.first_name, Dogs.name from Owners inner join Dogs on Dogs.owner_id = Owners.owner_id where Owners.state = "Virginia"	s239_dog_kennels
select stadium.Name, stadium.Capacity from stadium join concert on concert.Stadium_ID = stadium.Stadium_ID where concert.Year > 2014 group by stadium.Stadium_ID order by count(*) desc limit 1	s240_concert_singer
select stadium.Name, stadium.Location from stadium inner join concert on concert.Stadium_ID = stadium.Stadium_ID where concert.Year = "2014"	s241_concert_singer
select PetID, weight from Pets where pet_age > 2	s242_pets_1
select PetID, weight from Pets where pet_age > 2	s243_pets_1
select distinct model_list.Model from model_list inner join car_names on car_names.Model = model_list.Model inner join cars_data on cars_data.Id = car_names.MakeId where cars_data.Year > 1976	s244_car_1
select avg(MPG) from cars_data where Cylinders = 6	s245_car_1
select count(*) from cars_data where Cylinders > 1	s246_car_1
select count(*) from cars_data where Year = 1976	s247_car_1
select v.Name from visitor v where EXISTS (select 1 from visit vi join museum m on vi.Museum_ID = m.Museum_ID where vi.visitor_ID = v.ID and m.Open_Year < 2019) and EXISTS (select 1 from visit vi join museum m on vi.Museum_ID = m.Museum_ID where vi.visitor_ID = v.ID and m.Open_Year > 2011)	s248_museum_visit
select count(*) from visitor v where not EXISTS (select 1 from visit vi join museum m on vi.Museum_ID = m.Museum_ID where vi.visitor_ID = v.ID and m.Open_Year > 2019)	s249_museum_visit
select distinct p1.first_name, p1.last_name from players p1 inner join matches m1 on m1.winner_id = p1.player_id where m1.year = 2013 intersect select distinct p2.first_name, p2.last_name from players p2 inner join matches m2 on m2.winner_id = p2.player_id where m2.year = 2013	s250_wta_1
select Name from country where IndepYear > 1957	s251_world_1
select count(distinct countrylanguage.Language) from country join countrylanguage on countrylanguage.CountryCode = country.Code where country.IndepYear < 1920	s252_world_1
select count(distinct countrylanguage.Language) from country join countrylanguage on country.Code = countrylanguage.CountryCode where country.IndepYear < 1923	s253_world_1
select GovernmentForm, sum(Population) from country group by GovernmentForm having avg(LifeExpectancy) > 82	s254_world_1
select GovernmentForm, sum(Population) from country where LifeExpectancy > (select avg(LifeExpectancy) from country) group by GovernmentForm	s255_world_1
select avg(LifeExpectancy), sum(Population) from country group by Continent having avg(LifeExpectancy) < 76	s256_world_1
select name from Highschooler where grade = 9	s257_network_1
select Highschooler.name from Highschooler join Friend on Highschooler.ID = Friend.student_id where Highschooler.grade > 9 group by Highschooler.ID, Highschooler.name having count(Friend.friend_id) >= 2	s258_network_1
select Name from singer where Birth_Year = 1952 or Birth_Year = 1949	s259_singer
select count(*) from Student inner join Has_Pet on Student.StuID = Has_Pet.StuID inner join Pets on Has_Pet.PetID = Pets.PetID where Student.Sex = "F" and Pets.PetType = "cat"	s260_pets_1
select Student.Fname from Student join Has_Pet on Has_Pet.StuID = Student.StuID join Pets on Has_Pet.PetID = Pets.PetID where Pets.PetType = "cat"	s261_pets_1
select count(*) from Templates where Template_Type_Code = "BK"	s262_cre_Doc_Template_Mgt
select Paragraphs.Paragraph_ID, Paragraphs.Paragraph_Text from Documents inner join Paragraphs on Documents.Document_ID = Paragraphs.Document_ID where Documents.Document_Name = "Summer Show"	s263_cre_Doc_Template_Mgt
select Open_Year, Num_of_Staff from museum where Name = "RiverPark Museum"	s264_museum_visit
select p.first_name, p.last_name from players p join matches m on p.player_id = m.winner_id where m.tourney_name = "Birmingham" order by m.winner_rank_points desc limit 1	s265_wta_1
select battle.name, battle.result, battle.bulgarian_commander from battle left join ship on ship.lost_in_battle = battle.id where ship.location = "Mid-Atlantic" and ship.lost_in_battle is null	s266_battle_death
select section_id, course_id, section_name, section_description, other_details from Sections where section_name = "c"	s267_student_transcripts_tracking
select Students.first_name from Students left join Addresses on Students.permanent_address_id = Addresses.address_id where Addresses.country = "Haiti" or Students.cell_mobile_number = "(462)246-7921"	s268_student_transcripts_tracking
select Original_air_date from Cartoon where Title = "Emily"	s269_tvshow
select TV_series.Episode from TV_series join TV_Channel on TV_series.Channel = TV_Channel.id where TV_Channel.series_name = "MTV Music"	s270_tvshow
select Pixel_aspect_ratio_PAR, Country from TV_Channel where Language <> "Italian"	s271_tvshow
select contestant_name from CONTESTANTS where contestant_name <> "Nita Coster"	s272_voter_1
select area_code from AREA_CODE_STATE join VOTES on AREA_CODE_STATE.state = VOTES.state join CONTESTANTS on VOTES.contestant_number = CONTESTANTS.contestant_number where CONTESTANTS.contestant_name = "Kelly Clauss" group by area_code having count(distinct VOTES.vote_id) > 1	s273_voter_1
select countrylanguage.Language from countrylanguage join country on countrylanguage.CountryCode = country.Code where country.Name = "Lesotho"	s274_world_1
select Region, Population from country where Name = "Hong Kong"	s275_world_1
select countrylanguage.Language from country join countrylanguage on country.Code = countrylanguage.CountryCode where country.HeadOfState = "Ricardo Lagos Escobar"	s276_world_1
select max(Share), min(Share) from performance where Type <> "Auditions 1"	s277_orchestra
select grade from Highschooler where name = "Kris"	s278_network_1
select Ref_Feature_Types.feature_type_name from Ref_Feature_Types inner join Other_Available_Features on Other_Available_Features.feature_type_code = Ref_Feature_Types.feature_type_code where Other_Available_Features.feature_name = "BurglarAlarm"	s279_real_estate_properties
select countries.CountryName from continents join countries on countries.Continent = continents.ContId join car_makers on car_makers.Country = countries.CountryId where continents.Continent = "europe" group by countries.CountryName having count(*) >= 4	s280_car_1
select car_makers.Maker, car_makers.Id from car_makers join model_list on car_makers.Id = model_list.Maker group by car_makers.Maker, car_makers.Id having count(model_list.ModelId) > 2	s281_car_1
select count(*) from countries inner join car_makers on countries.CountryId = car_makers.Country group by countries.CountryId having count(*) > 4	s282_car_1
select count(*) from countries join car_makers on car_makers.Country = countries.CountryId group by countries.CountryId having count(*) > 4	s283_car_1
select Ref_Template_Types.Template_Type_Code from Ref_Template_Types left join Templates on Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code group by Ref_Template_Types.Template_Type_Code having count(Templates.Template_ID) < 6	s284_cre_Doc_Template_Mgt
select Documents.Document_ID from Documents join Paragraphs on Paragraphs.Document_ID = Documents.Document_ID group by Documents.Document_ID having count(Paragraphs.Paragraph_ID) >= 3	s285_cre_Doc_Template_Mgt
select Documents.Document_ID from Documents join Paragraphs on Documents.Document_ID = Paragraphs.Document_ID group by Documents.Document_ID having count(*) >= 3	s286_cre_Doc_Template_Mgt
select tourney_name from matches group by tourney_name having count(*) > 14	s287_wta_1
select country_code from players group by country_code having count(*) > 46	s288_wta_1
select Students.first_name, Students.middle_name, Students.last_name, Students.student_id from Students inner join Student_Enrolment on Students.student_id = Student_Enrolment.student_id group by Students.student_id having count(distinct Student_Enrolment.degree_program_id) = 3	s289_student_transcripts_tracking
select Episode, Rating from TV_series order by CAST(Rating as FLOAT) desc limit 5	s290_tvshow
select Episode, Rating from TV_series order by Rating desc limit 11	s291_tvshow
select country.Name, count(*) from country join countrylanguage on country.Code = countrylanguage.CountryCode group by country.Name having count(*) > 8	s292_world_1
select Name from country order by Population desc limit 5	s293_world_1
select Highschooler.name from Highschooler join Friend on Highschooler.ID = Friend.student_id group by Highschooler.name having count(Friend.friend_id) >= 2	s294_network_1
select Highschooler.name from Highschooler join Friend on Highschooler.ID = Friend.student_id where Highschooler.grade > 5 group by Highschooler.ID having count(Friend.friend_id) >= 3	s295_network_1
select Professionals.professional_id, Professionals.last_name, Professionals.cell_number from Professionals left join Treatments on Professionals.professional_id = Treatments.professional_id group by Professionals.professional_id having count(Treatments.treatment_id) > 9 or Professionals.state = "Indiana"	s296_dog_kennels
select Professionals.professional_id, Professionals.role_code, Professionals.first_name from Professionals join Treatments on Professionals.professional_id = Treatments.professional_id group by Professionals.professional_id, Professionals.role_code, Professionals.first_name having count(*) >= 3	s297_dog_kennels
select Professionals.professional_id, Professionals.role_code, Professionals.first_name from Professionals join Treatments on Treatments.professional_id = Professionals.professional_id group by Professionals.professional_id, Professionals.role_code, Professionals.first_name having count(Treatments.treatment_id) >= 3	s298_dog_kennels
select Professionals.professional_id, Professionals.cell_number from Professionals join Treatments on Treatments.professional_id = Professionals.professional_id group by Professionals.professional_id, Professionals.cell_number having count(distinct Treatments.treatment_type_code) >= 3	s299_dog_kennels
select Song_Name from singer where Age < (select avg(Age) from singer)	s300_concert_singer
select count(*) from Pets where weight < 10	s301_pets_1
select countries.CountryName, countries.CountryId from countries join car_makers on countries.CountryId = car_makers.Country group by countries.CountryId, countries.CountryName having count(car_makers.Id) > 1	s302_car_1
select avg(Horsepower) from cars_data where Year > 1980	s303_car_1
select avg(Horsepower) from cars_data where Year > 1980	s304_car_1
select car_makers.FullName, car_makers.Id from car_makers join model_list on model_list.Maker = car_makers.Id group by car_makers.FullName, car_makers.Id having count(model_list.ModelId) <= 3	s305_car_1
select distinct model_list.Model from model_list join car_makers on model_list.Maker = car_makers.Id join car_names on car_names.Model = model_list.Model join cars_data on cars_data.Id = car_names.MakeId where (car_makers.FullName = "General Motors") or (cars_data.Weight < 3500)	s306_car_1
select Name from shop where Number_products < (select avg(Number_products) from shop)	s307_employee_hire_evaluation
select Name from shop where Number_products < (select avg(Number_products) from shop)	s308_employee_hire_evaluation
select country_code from players group by country_code having count(*) < 50	s309_wta_1
select Courses.course_name, Courses.course_id from Courses join Sections on Courses.course_id = Sections.course_id group by Courses.course_id having count(Sections.section_id) >= 2	s310_student_transcripts_tracking
select T.transcript_date, T.transcript_id from Transcripts T join Transcript_Contents TC on TC.transcript_id = T.transcript_id group by T.transcript_id having count(TC.student_course_id) < 2	s311_student_transcripts_tracking
select id from TV_Channel where Country in (select Country from TV_Channel group by Country having count(*) < 2)	s312_tvshow
select Nationality from people group by Nationality having count(*) < 2	s313_poker_player
select Name from country where Continent = "Asia" and Population < (select min(Population) from country where Continent = "Africa")	s314_world_1
select District, count(*) from city where Population < (select avg(Population) from city) group by District	s315_world_1
select Continent, sum(Population), avg(LifeExpectancy) from country group by Continent having avg(LifeExpectancy) > 72	s316_world_1
select Highschooler.name from Highschooler join Friend on Highschooler.ID = Friend.student_id group by Highschooler.ID having count(*) <= 3	s317_network_1
select distinct singer.Name from singer join song on singer.Singer_ID = song.Singer_ID where song.Sales <= 300000	s318_singer
select distinct singer.Name from singer join song on song.Singer_ID = singer.Singer_ID where song.Sales < 300000	s319_singer
select Name, Song_release_year from singer order by Age asc limit 1	s320_concert_singer
select Year from concert group by Year having count(concert_ID) = (select min(concert_count) from (select count(concert_ID) as concert_count from concert group by Year))	s321_concert_singer
select min(cars_data.Horsepower), car_makers.Maker from cars_data join car_names on cars_data.Id = car_names.MakeId join model_list on car_names.Model = model_list.Model join car_makers on model_list.Maker = car_makers.Id where cars_data.Cylinders = 3 limit 1	s322_car_1
select airlines.Abbreviation, airlines.Country from airlines join flights on airlines.uid = flights.Airline group by airlines.Abbreviation, airlines.Country order by count(*) desc limit 1	s323_flight_2
select Manager_name, District from shop order by Number_products asc limit 1	s324_employee_hire_evaluation
select employee.Name from employee join evaluation on employee.Employee_ID = evaluation.Employee_ID order by evaluation.Bonus asc limit 1	s325_employee_hire_evaluation
select winner_name, loser_name from matches where minutes = (select min(minutes) from matches)	s326_wta_1
select section_name from Sections order by section_name asc	s327_student_transcripts_tracking
select Semesters.semester_name, Semesters.semester_id from Semesters join Student_Enrolment on Student_Enrolment.semester_id = Semesters.semester_id group by Semesters.semester_name, Semesters.semester_id having count(*) = (select min(student_count) from (select count(*) as student_count from Student_Enrolment group by semester_id))	s328_student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_left desc limit 1	s329_student_transcripts_tracking
select t.transcript_date, t.transcript_id from Transcripts t inner join Transcript_Contents tc on t.transcript_id = tc.transcript_id group by t.transcript_id order by count(*) desc limit 1	s330_student_transcripts_tracking
select people.Birth_Date from poker_player inner join people on poker_player.People_ID = people.People_ID order by poker_player.Earnings desc limit 1	s331_poker_player
select Nationality from people group by Nationality order by count(*) asc limit 1	s332_poker_player
select Name, Birth_Date from people order by Name desc	s333_poker_player
select cl.Language from countrylanguage cl join country c on cl.CountryCode = c.Code where c.Name = "Aruba" order by cl.Percentage asc limit 1	s334_world_1
select country.Continent from country join countrylanguage on country.Code = countrylanguage.CountryCode group by country.Continent order by count(countrylanguage.Language) asc limit 1	s335_world_1
select Name from conductor order by Age desc	s336_orchestra
select Name from conductor order by Year_of_Work asc limit 1	s337_orchestra
select Name from conductor left join orchestra on conductor.Conductor_ID = orchestra.Conductor_ID group by Name order by count(Orchestra_ID) asc limit 1	s338_orchestra
select grade from Highschooler group by grade having count(*) = (select min(CNT) from (select grade, count(*) as CNT from Highschooler group by grade))	s339_network_1
