select Country from airlines where Airline = "JetBlue Airways"	flight_2
select Country from airlines where Airline = "Jetblue Airways"	flight_2
select Abbreviation from airlines where Airline = "JetBlue Airways"	flight_2
select Abbreviation from airlines where Airline = "Jetblue Airways"	flight_2
select Airline, Abbreviation from airlines where Country = "USA"	flight_2
select Airline, Abbreviation from airlines where Country = "USA"	flight_2
select AirportCode, AirportName from airports where City = "Anthony"	flight_2
select AirportCode, AirportName from airports where City = "Anthony"	flight_2
select count(*) from airlines	flight_2
select count(*) from airlines	flight_2
select count(*) from airports	flight_2
select count(*) from airports	flight_2
select count(*) from flights	flight_2
select count(*) from flights	flight_2
select Airline from airlines where Abbreviation = "UAL"	flight_2
select Airline from airlines where Abbreviation = "UAL"	flight_2
select count(*) from airlines where Country = "USA"	flight_2
select count(*) from airlines where Country = "USA"	flight_2
select City, Country from airports where AirportName = "Alton airport"	flight_2
select City, Country from airports where AirportName = "Alton airport"	flight_2
select AirportName from airports where AirportCode = "AKO"	flight_2
select AirportName from airports where AirportCode = "AKO"	flight_2
select AirportName from airports where City = "Aberdeen"	flight_2
select AirportName from airports where City = "Aberdeen"	flight_2
select count(*) from flights where SourceAirport = "APG"	flight_2
select count(*) from flights where SourceAirport = "APG"	flight_2
select count(*) from flights where DestAirport = "ATO"	flight_2
select count(*) from flights where DestAirport = "ATO"	flight_2
select count(*) from flights as T1 join airports as T2 on T1.SourceAirport = T2.AirportCode where T2.City = "Aberdeen"	flight_2
select count(*) from flights as T1 join airports as T2 on T1.SourceAirport = T2.AirportCode where T2.City = "Aberdeen"	flight_2
select count(*) from flights as T1 join airports as T2 on T1.DestAirport = T2.AirportCode where T2.City = "Aberdeen"	flight_2
select count(*) from flights as T1 join airports as T2 on T1.DestAirport = T2.AirportCode where T2.City = "Aberdeen"	flight_2
select count(*) from flights as T1 inner join airports as T2 on T1.SourceAirport = T2.AirportCode inner join airports as T3 on T1.DestAirport = T3.AirportCode where T2.City = "Aberdeen" and T3.City = "Ashley"	flight_2
select count(*) from flights as T1 inner join airports as T2 on T1.SourceAirport = T2.AirportCode inner join airports as T3 on T1.DestAirport = T3.AirportCode where T2.City = "Aberdeen" and T3.City = "Ashley"	flight_2
select count(*) from flights as T1 join airlines as T2 on T1.Airline = T2.uid where T2.Airline = "JetBlue Airways"	flight_2
select count(*) from flights as T1 join airlines as T2 on T1.Airline = T2.uid where T2.Airline = "Jetblue Airways"	flight_2
select count(*) from flights as T1 join airlines as T2 on T1.Airline = T2.uid where T2.Airline = "United Airlines" and T1.DestAirport = "ASY"	flight_2
select count(*) from flights as T1 join airlines as T2 on T1.Airline = T2.uid where T2.Airline = "United Airlines" and T1.DestAirport = "ASY"	flight_2
select count(*) from flights as T1 join airlines as T2 on T1.Airline = T2.uid where T2.Airline = "United Airlines" and T1.SourceAirport = "AHD"	flight_2
select count(*) from flights as T1 inner join airlines as T2 on T1.Airline = T2.uid where T2.Airline = "United Airlines" and T1.SourceAirport = "AHD"	flight_2
select count(T1.FlightNo) from flights as T1 inner join airlines as T2 on T1.Airline = T2.uid inner join airports as T3 on T1.DestAirport = T3.AirportCode where T2.Airline = "United Airlines" and T3.City = "Aberdeen"	flight_2
select count(*) from flights as T1 inner join airlines as T2 on T1.Airline = T2.uid inner join airports as T3 on T1.DestAirport = T3.AirportCode where T2.Airline = "United Airlines" and T3.City = "Aberdeen"	flight_2
select T2.City from flights as T1 join airports as T2 on T1.DestAirport = T2.AirportCode group by T2.City order by count(T1.FlightNo) desc limit 1	flight_2
select T1.City from airports as T1 join flights as T2 on T1.AirportCode = T2.DestAirport group by T1.City order by count(T2.DestAirport) desc limit 1	flight_2
select T2.City from flights as T1 join airports as T2 on T1.SourceAirport = T2.AirportCode group by T2.City order by count(T1.FlightNo) desc limit 1	flight_2
select T1.City from airports as T1 join flights as T2 on T1.AirportCode = T2.SourceAirport group by T1.City order by count(T2.SourceAirport) desc limit 1	flight_2
select AirportCode from (select SourceAirport from flights union ALL select DestAirport from flights) group by AirportCode order by count(AirportCode) desc limit 1	flight_2
select AirportCode from (select SourceAirport from flights union ALL select DestAirport from flights) group by AirportCode order by count(AirportCode) desc limit 1	flight_2
select AirportCode from (select SourceAirport from flights union ALL select DestAirport from flights) group by AirportCode order by count(AirportCode) asc limit 1	flight_2
select AirportCode from (select SourceAirport from flights union ALL select DestAirport from flights) group by AirportCode order by count(*) asc limit 1	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.Airline order by count(T2.FlightNo) desc limit 1	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.Airline order by count(T2.FlightNo) desc limit 1	flight_2
select T1.Abbreviation, T1.Country from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.uid order by count(T2.FlightNo) asc limit 1	flight_2
select T1.Abbreviation, T1.Country from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.uid order by count(*) asc limit 1	flight_2
select distinct T1.Airline from airlines as T1 inner join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport = "AHD"	flight_2
select distinct T1.Airline from airlines as T1 inner join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport = "AHD"	flight_2
select distinct T1.Airline from airlines as T1 inner join flights as T2 on T1.uid = T2.Airline where T2.DestAirport = "AHD"	flight_2
select distinct T1.Airline from airlines as T1 inner join flights as T2 on T1.uid = T2.Airline where T2.DestAirport = "AHD"	flight_2
select T1.Airline from airlines as T1 inner join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport in ("APG", "CVO") group by T1.Airline having count(distinct T2.SourceAirport) = 2	flight_2
select T1.Airline from airlines as T1 inner join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport = "APG" intersect select T1.Airline from airlines as T1 inner join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport = "CVO"	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport = "CVO" except select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport = "APG"	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport = "CVO" except select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport = "APG"	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.Airline having count(T2.FlightNo) >= 10	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.Airline having count(*) >= 10	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.Airline having count(*) < 200	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.Airline having count(T2.FlightNo) < 200	flight_2
select T1.FlightNo from flights as T1 inner join airlines as T2 on T1.Airline = T2.uid where T2.Airline = "United Airlines"	flight_2
select T1.FlightNo from flights as T1 inner join airlines as T2 on T1.Airline = T2.uid where T2.Airline = "United Airlines"	flight_2
select FlightNo from flights where SourceAirport = "APG"	flight_2
select FlightNo from flights where SourceAirport = "APG"	flight_2
select FlightNo from flights where DestAirport = "APG"	flight_2
select FlightNo from flights where DestAirport = "APG"	flight_2
select T1.FlightNo from flights as T1 inner join airports as T2 on T1.SourceAirport = T2.AirportCode where T2.City = "Aberdeen"	flight_2
select T1.FlightNo from flights as T1 inner join airports as T2 on T1.SourceAirport = T2.AirportCode where T2.City = "Aberdeen"	flight_2
select T1.FlightNo from flights as T1 inner join airports as T2 on T1.DestAirport = T2.AirportCode where T2.City = "Aberdeen"	flight_2
select T1.FlightNo from flights as T1 inner join airports as T2 on T1.DestAirport = T2.AirportCode where T2.City = "Aberdeen"	flight_2
select count(*) from flights as T1 join airports as T2 on T1.DestAirport = T2.AirportCode where T2.City = "Aberdeen" or T2.City = "Abilene"	flight_2
select count(*) from flights as T1 join airports as T2 on T1.DestAirport = T2.AirportCode where T2.City = "Aberdeen" or T2.City = "Abilene"	flight_2
select AirportName from airports where AirportCode not in (select SourceAirport from flights) and AirportCode not in (select DestAirport from flights)	flight_2
select AirportCode from airports except select SourceAirport from flights union select DestAirport from flights	flight_2
select Name from country where IndepYear > 1950	world_1
select Name from country where IndepYear > 1950	world_1
select count(*) from country where GovernmentForm like "%Republic%"	world_1
select count(*) from country where GovernmentForm like "%Republic%"	world_1
select sum(SurfaceArea) from country where Region = "Caribbean"	world_1
select sum(SurfaceArea) from country where Region = "Caribbean"	world_1
select Continent from country where Name = "Anguilla"	world_1
select Continent from country where Name = "Anguilla"	world_1
select T2.Region from city as T1 inner join country as T2 on T1.CountryCode = T2.Code where T1.Name = "Kabul"	world_1
select T2.Region from city as T1 inner join country as T2 on T1.CountryCode = T2.Code where T1.Name = "Kabul"	world_1
select T2.Language from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode where T1.Name = "Aruba" order by T2.Percentage desc limit 1	world_1
select T2.Language from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode where T1.Name = "Aruba" order by T2.Percentage desc limit 1	world_1
select Population, LifeExpectancy from country where Name = "Brazil"	world_1
select Population, LifeExpectancy from country where Name = "Brazil"	world_1
select Region, Population from country where Name = "Angola"	world_1
select Region, Population from country where Name = "Angola"	world_1
select avg(LifeExpectancy) from country where Region = "Central Africa"	world_1
select avg(LifeExpectancy) from country where Region = "Central Africa"	world_1
select Name from country where Continent = "Asia" order by LifeExpectancy asc limit 1	world_1
select Name from country where Continent = "Asia" order by LifeExpectancy asc limit 1	world_1
select sum(Population), max(GNP) from country where Continent = "Asia"	world_1
select sum(Population), max(GNP) from country where Continent = "Asia"	world_1
select avg(LifeExpectancy) from country where Continent = "Africa" and GovernmentForm = "Republic"	world_1
select avg(LifeExpectancy) from country where Continent = "Africa" and GovernmentForm = "Republic"	world_1
select sum(SurfaceArea) from country where Continent = "Asia" or Continent = "Europe"	world_1
select sum(SurfaceArea) from country where Continent = "Asia" or Continent = "Europe"	world_1
select sum(Population) from city where District = "Gelderland"	world_1
select sum(Population) from city where District = "Gelderland"	world_1
select avg(GNP), sum(Population) from country where GovernmentForm = "US Territory"	world_1
select avg(GNP), sum(Population) from country where GovernmentForm = "US Territory"	world_1
select count(distinct Language) from countrylanguage	world_1
select count(distinct Language) from countrylanguage	world_1
select count(distinct GovernmentForm) from country where Continent = "Africa"	world_1
select count(distinct GovernmentForm) from country where Continent = "Africa"	world_1
select count(T2.Language) from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode where T1.Name = "Aruba"	world_1
select count(T1.Language) from countrylanguage as T1 inner join country as T2 on T1.CountryCode = T2.Code where T2.Name = "Aruba"	world_1
select count(T2.Language) from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode where T1.Name = "Afghanistan" and T2.IsOfficial = "T"	world_1
select count(T1.Language) from countrylanguage as T1 inner join country as T2 on T1.CountryCode = T2.Code where T2.Name = "Afghanistan" and T1.IsOfficial = "T"	world_1
select T1.Name from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode group by T1.Code order by count(T2.Language) desc limit 1	world_1
select T1.Name from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode group by T1.Code order by count(T2.Language) desc limit 1	world_1
select T1.Continent from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode group by T1.Continent order by count(T2.Language) desc limit 1	world_1
select T1.Continent from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode group by T1.Continent order by count(T2.Language) desc limit 1	world_1
select count(*) from (select CountryCode from countrylanguage where Language = "English" intersect select CountryCode from countrylanguage where Language = "Dutch")	world_1
select count(T1.CountryCode) from countrylanguage as T1 join countrylanguage as T2 on T1.CountryCode = T2.CountryCode where T1.Language = "English" and T2.Language = "Dutch"	world_1
select T1.Name from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language = "English" intersect select T1.Name from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language = "French"	world_1
select T1.Name from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language = "English" intersect select T1.Name from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language = "French"	world_1
select T1.Name from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language in ("English", "French") and T2.IsOfficial = "T" group by T1.Code having count(distinct T2.Language) = 2	world_1
select T1.Name from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language = "English" and T2.IsOfficial = "T" intersect select T1.Name from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language = "French" and T2.IsOfficial = "T"	world_1
select count(distinct T2.Continent) from countrylanguage as T1 inner join country as T2 on T1.CountryCode = T2.Code where T1.Language = "Chinese"	world_1
select count(distinct T2.Continent) from countrylanguage as T1 inner join country as T2 on T1.CountryCode = T2.Code where T1.Language = "Chinese"	world_1
select distinct T1.Region from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language = "English" or T2.Language = "Dutch"	world_1
select distinct T1.Region from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language = "Dutch" or T2.Language = "English"	world_1
select T1.Name from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.IsOfficial = "T" and T2.Language in ("English", "Dutch")	world_1
select T1.Name from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.IsOfficial = "T" and T2.Language in ("English", "Dutch")	world_1
select T2.Language from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode where T1.Continent = "Asia" group by T2.Language order by sum(T1.Population * T2.Percentage / 100.0) desc limit 1	world_1
select T2.Language from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode where T1.Continent = "Asia" group by T2.Language order by count(T1.Code) desc limit 1	world_1
select T2.Language from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode where T1.GovernmentForm like "%Republic%" group by T2.Language having count(T1.Code) = 1	world_1
select T2.Language from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode where T1.GovernmentForm = "Republic" group by T2.Language having count(T1.Code) = 1	world_1
select T1.Name from city as T1 inner join countrylanguage as T2 on T1.CountryCode = T2.CountryCode where T2.Language = "English" order by T1.Population desc limit 1	world_1
select T1.Name from city as T1 inner join countrylanguage as T2 on T1.CountryCode = T2.CountryCode where T2.Language = "English" order by T1.Population desc limit 1	world_1
select Name, Population, LifeExpectancy from country where Continent = "Asia" order by SurfaceArea desc limit 1	world_1
select Name, Population, LifeExpectancy from country where Continent = "Asia" order by SurfaceArea desc limit 1	world_1
select avg(T1.LifeExpectancy) from country as T1 where T1.Code not in (select T2.CountryCode from countrylanguage as T2 where T2.Language = "English" and T2.IsOfficial = "T")	world_1
select avg(T1.LifeExpectancy) from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language = "English" and T2.IsOfficial = "F"	world_1
select sum(T1.Population) from country as T1 where T1.Code not in ( select T2.CountryCode from countrylanguage as T2 where T2.Language = "English" )	world_1
select sum(T1.Population) from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode where T1.Code not in ( select CountryCode from countrylanguage where Language = "English" )	world_1
select T2.Language from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode where T1.HeadOfState = "Beatrix" and T2.IsOfficial = "T"	world_1
select T2.Language from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode where T1.HeadOfState = "Beatrix" and T2.IsOfficial = "T"	world_1
select count(distinct T2.Language) from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode where T1.IndepYear < 1930 and T2.IsOfficial = "T"	world_1
select count(distinct T2.Language) from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode where T1.IndepYear < 1930 and T2.IsOfficial = "T"	world_1
select Name from country where SurfaceArea > (select max(SurfaceArea) from country where Continent = "Europe")	world_1
select Name from country where SurfaceArea > (select max(SurfaceArea) from country where Continent = "Europe")	world_1
select Name from country where Continent = "Africa" and Population < (select min(Population) from country where Continent = "Asia")	world_1
select Name from country where Continent = "Africa" and Population < (select min(Population) from country where Continent = "Asia")	world_1
select Name from country where Continent = "Asia" and Population > (select max(Population) from country where Continent = "Africa")	world_1
select Name from country where Continent = "Asia" and Population > (select max(Population) from country where Continent = "Africa")	world_1
select Code from country where Code not in (select CountryCode from countrylanguage where Language = "English")	world_1
select CountryCode from countrylanguage where Language != "English"	world_1
select distinct CountryCode from countrylanguage where Language != "English"	world_1
select CountryCode from countrylanguage where Language != "English"	world_1
select T1.Code from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language != "English" and T1.GovernmentForm != "Republic"	world_1
select Code from country where Code not in ( select CountryCode from countrylanguage where Language = "English" ) and GovernmentForm not like "%Republic%"	world_1
select T1.Name from city as T1 inner join country as T2 on T1.CountryCode = T2.Code where T2.Continent = "Europe" and T2.Code not in ( select CountryCode from countrylanguage where Language = "English" and IsOfficial = "T" )	world_1
select T1.Name from city as T1 inner join country as T2 on T1.CountryCode = T2.Code where T2.Continent = "Europe" and T1.CountryCode not in ( select CountryCode from countrylanguage where Language = "English" and IsOfficial = "T" )	world_1
select distinct T1.Name from city as T1 inner join country as T2 on T1.CountryCode = T2.Code inner join countrylanguage as T3 on T2.Code = T3.CountryCode where T2.Continent = "Asia" and T3.Language = "Chinese" and T3.IsOfficial = "T"	world_1
select distinct T1.Name from city as T1 inner join country as T2 on T1.CountryCode = T2.Code inner join countrylanguage as T3 on T2.Code = T3.CountryCode where T2.Continent = "Asia" and T3.Language = "Chinese" and T3.IsOfficial = "T"	world_1
select Name, IndepYear, SurfaceArea from country order by Population asc limit 1	world_1
select Name, IndepYear, SurfaceArea from country order by Population asc limit 1	world_1
select Population, Name, HeadOfState from country order by SurfaceArea desc limit 1	world_1
select Name, Population, HeadOfState from country order by SurfaceArea desc limit 1	world_1
select T1.Name, count(T2.Language) from country as T1 inner join countrylanguage as T2 on T1.Code = T2.CountryCode group by T1.Name having count(T2.Language) >= 3	world_1
select T1.Name, count(T2.Language) from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode group by T1.Name having count(T2.Language) > 2	world_1
select District, count(ID) from city where Population > (select avg(Population) from city) group by District	world_1
select District, count(ID) from city where Population > (select avg(Population) from city) group by District	world_1
select GovernmentForm, sum(Population) from country group by GovernmentForm having avg(LifeExpectancy) > 72	world_1
select GovernmentForm, sum(Population) from country group by GovernmentForm having avg(LifeExpectancy) > 72	world_1
select Continent, avg(LifeExpectancy), sum(Population) from country group by Continent having avg(LifeExpectancy) < 72	world_1
select Continent, sum(Population), avg(LifeExpectancy) from country group by Continent having avg(LifeExpectancy) < 72	world_1
select Name, SurfaceArea from country order by SurfaceArea desc limit 5	world_1
select Name, SurfaceArea from country order by SurfaceArea desc limit 5	world_1
select Name from country order by Population desc limit 3	world_1
select Name from country order by Population desc limit 3	world_1
select Name from country order by Population asc limit 3	world_1
select Name from country order by Population asc limit 3	world_1
select count(*) from country where Continent = "Asia"	world_1
select count(*) from country where Continent = "Asia"	world_1
select Name from country where Continent = "Europe" and Population = 80000	world_1
select Name from country where Continent = "Europe" and Population = 80000	world_1
select sum(Population), avg(SurfaceArea) from country where Continent = "North America" and SurfaceArea > 3000	world_1
select sum(Population), avg(SurfaceArea) from country where Continent = "North America" and SurfaceArea > 3000	world_1
select Name from city where Population between 160000 and 900000	world_1
select Name from city where Population between 160000 and 900000	world_1
select Language from countrylanguage group by Language order by count(CountryCode) desc limit 1	world_1
select Language from countrylanguage group by Language order by count(CountryCode) desc limit 1	world_1
select CountryCode, Language from countrylanguage where (CountryCode, Percentage) in ( select CountryCode, max(Percentage) from countrylanguage group by CountryCode )	world_1
select T1.CountryCode, T1.Language from countrylanguage as T1 inner join (select CountryCode, max(Percentage) from countrylanguage group by CountryCode) on T1.CountryCode = T2.CountryCode and T1.Percentage = T2.MaxPercentage	world_1
select count(distinct CountryCode) from (select CountryCode, Language, RANK() OVER (PARTITION by CountryCode order by Percentage desc) from countrylanguage) where rnk = 1 and Language = "Spanish"	world_1
select count(T1.CountryCode) from countrylanguage as T1 where T1.Language = "Spanish" and T1.IsOfficial = "T" and T1.Percentage = (select max(T2.Percentage) from countrylanguage as T2 where T2.CountryCode = T1.CountryCode)	world_1
select CountryCode from countrylanguage where Language = "Spanish" order by Percentage desc limit 1	world_1
ite select T1.CountryCode from countrylanguage as T1 inner join (select CountryCode, max(Percentage) from countrylanguage group by CountryCode) on T1.CountryCode = T2.CountryCode where T1.Language = "Spanish" and T1.Percentage = T2.MaxPercentage	world_1
select count(*) from continents	car_1
select count(ContId) from continents	car_1
select T1.ContId, T1.Continent, count(T2.CountryId) from continents as T1 join countries as T2 on T1.ContId = T2.Continent group by T1.ContId, T1.Continent	car_1
select T1.ContId, T1.Continent, count(T2.CountryId) from continents as T1 join countries as T2 on T1.ContId = T2.Continent group by T1.ContId, T1.Continent	car_1
select count(*) from countries	car_1
select count(*) from countries	car_1
select T1.FullName, T1.Id, count(T2.Model) from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker group by T1.FullName, T1.Id	car_1
select T1.FullName, T1.Id, count(T2.ModelId) from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker group by T1.Id, T1.FullName	car_1
select T1.Model from car_names as T1 inner join cars_data as T2 on T1.MakeId = T2.Id order by CAST(T2.Horsepower as NUMERIC) asc limit 1	car_1
select T1.Model from car_names as T1 join cars_data as T2 on T1.MakeId = T2.Id order by CAST(T2.Horsepower as INTEGER) asc limit 1	car_1
select T1.Model from car_names as T1 join cars_data as T2 on T1.MakeId = T2.Id where T2.Weight < (select avg(Weight) from cars_data)	car_1
select T1.Model from car_names as T1 join cars_data as T2 on T1.MakeId = T2.Id where T2.Weight < (select avg(Weight) from cars_data)	car_1
select distinct T3.Maker from cars_data as T1 inner join car_names as T2 on T1.Id = T2.MakeId inner join model_list as T4 on T2.Model = T4.Model inner join car_makers as T3 on T4.Maker = T3.Id where T1.Year = 1970	car_1
select distinct T1.Maker from car_makers as T1 inner join model_list as T2 on T1.Id = T2.Maker inner join car_names as T3 on T2.Model = T3.Model inner join cars_data as T4 on T3.MakeId = T4.Id where T4.Year = 1970	car_1
select T1.Make, T2.Year from car_names as T1 inner join cars_data as T2 on T1.MakeId = T2.Id where T2.Year = (select min(Year) from cars_data)	car_1
select T4.Maker, T1.Year from cars_data as T1 inner join car_names as T2 on T1.Id = T2.MakeId inner join model_list as T3 on T2.Model = T3.Model inner join car_makers as T4 on T3.Maker = T4.Id order by T1.Year asc limit 1	car_1
select distinct T1.Model from car_names as T1 join cars_data as T2 on T1.MakeId = T2.Id where T2.Year > 1980	car_1
select distinct T1.Model from car_names as T1 inner join cars_data as T2 on T1.MakeId = T2.Id where T2.Year > 1980	car_1
select T3.Continent, count(T1.Id) from car_makers as T1 join countries as T2 on T1.Country = T2.CountryId join continents as T3 on T2.Continent = T3.ContId group by T3.Continent	car_1
select T1.Continent, count(T3.Id) from continents as T1 join countries as T2 on T1.ContId = T2.Continent join car_makers as T3 on T2.CountryId = T3.Country group by T1.Continent	car_1
select T2.CountryName from car_makers as T1 join countries as T2 on T1.Country = T2.CountryId group by T2.CountryName order by count(T1.Id) desc limit 1	car_1
select T1.CountryName from countries as T1 join car_makers as T2 on T1.CountryId = T2.Country group by T1.CountryName order by count(T2.Id) desc limit 1	car_1
select T2.FullName, count(T1.ModelId) from model_list as T1 join car_makers as T2 on T1.Maker = T2.Id group by T2.FullName	car_1
select T1.Id, T1.FullName, count(T2.ModelId) from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker group by T1.Id, T1.FullName	car_1
select T1.Accelerate from cars_data as T1 inner join car_names as T2 on T1.Id = T2.MakeId where T2.Make = "amc hornet sportabout (sw)"	car_1
select T1.Accelerate from cars_data as T1 inner join car_names as T2 on T1.Id = T2.MakeId where T2.Model = "amc hornet sportabout (sw)"	car_1
select count(*) from car_makers as T1 join countries as T2 on T1.Country = T2.CountryId where T2.CountryName = "France"	car_1
select count(T1.Maker) from car_makers as T1 inner join countries as T2 on T1.Country = T2.CountryId where T2.CountryName = "France"	car_1
select count(T1.Model) from model_list as T1 inner join car_makers as T2 on T1.Maker = T2.Id inner join countries as T3 on T2.Country = T3.CountryId where T3.CountryName = "usa"	car_1
select count(T1.Model) from model_list as T1 inner join car_makers as T2 on T1.Maker = T2.Id inner join countries as T3 on T2.Country = T3.CountryId where T3.CountryName = "United States"	car_1
select avg(CAST(MPG as REAL)) from cars_data where Cylinders = 4	car_1
select avg(CAST(MPG as REAL)) from cars_data where Cylinders = 4	car_1
select min(Weight) from cars_data where Cylinders = 8 and Year = 1974	car_1
select min(Weight) from cars_data where Cylinders = 8 and Year = 1974	car_1
select T1.Maker, T2.Model from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker	car_1
select T1.Maker, T2.Model from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker	car_1
select T2.CountryName, T2.CountryId from car_makers as T1 join countries as T2 on T1.Country = T2.CountryId	car_1
select T1.CountryName, T1.CountryId from countries as T1 join car_makers as T2 on T1.CountryId = T2.Country	car_1
select count(*) from cars_data where Horsepower > 150	car_1
select count(*) from cars_data where Horsepower > 150	car_1
select avg(Weight), Year from cars_data group by Year	car_1
select Year, avg(Weight), avg(Year) from cars_data group by Year	car_1
select T1.CountryName from countries as T1 inner join continents as T2 on T1.Continent = T2.ContId inner join car_makers as T3 on T1.CountryId = T3.Country where T2.Continent = "Europe" group by T1.CountryName having count(T3.Id) >= 3	car_1
select T1.CountryName from countries as T1 inner join continents as T2 on T1.Continent = T2.ContId inner join car_makers as T3 on T1.CountryId = T3.Country where T2.Continent = "Europe" group by T1.CountryName having count(T3.Id) >= 3	car_1
select T2.Make, max(T1.Horsepower) from cars_data as T1 inner join car_names as T2 on T1.Id = T2.MakeId where T1.Cylinders = 3	car_1
select T2.Make, T1.Horsepower from cars_data as T1 inner join car_names as T2 on T1.Id = T2.MakeId where T1.Cylinders = 3 order by T1.Horsepower desc limit 1	car_1
select T1.Model from car_names as T1 inner join cars_data as T2 on T1.MakeId = T2.Id where T2.MPG != "NA" order by CAST(T2.MPG as REAL) desc limit 1	car_1
select T1.Model from car_names as T1 inner join cars_data as T2 on T1.MakeId = T2.Id order by CAST(T2.MPG as REAL) desc limit 1	car_1
select avg(CAST(Horsepower as REAL)) from cars_data where Year < 1980	car_1
select avg(CAST(Horsepower as REAL)) from cars_data where Year < 1980	car_1
select avg(T1.Edispl) from cars_data as T1 inner join car_names as T2 on T1.Id = T2.MakeId where T2.Model = "volvo"	car_1
select avg(T1.Edispl) from cars_data as T1 inner join car_names as T2 on T1.Id = T2.MakeId where T2.Make = "volvo"	car_1
select max(Accelerate), Cylinders from cars_data group by Cylinders	car_1
select Cylinders, max(Accelerate) from cars_data group by Cylinders	car_1
select Model from car_names group by Model order by count(Make) desc limit 1	car_1
select Model from car_names group by Model order by count(Make) desc limit 1	car_1
select count(*) from cars_data where Cylinders > 4	car_1
select count(*) from cars_data where Cylinders > 4	car_1
select count(*) from cars_data where Year = 1980	car_1
select count(*) from cars_data where Year = 1980	car_1
select count(T1.ModelId) from model_list as T1 inner join car_makers as T2 on T1.Maker = T2.Id where T2.FullName = "American Motor Company"	car_1
select count(T1.Model) from model_list as T1 inner join car_makers as T2 on T1.Maker = T2.Id where T2.FullName = "American Motor Company"	car_1
select T1.FullName, T1.Id from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker group by T1.Id having count(T2.ModelId) > 3	car_1
select T1.Maker, T1.Id from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker group by T1.Id having count(T2.ModelId) > 3	car_1
select distinct T1.Model from model_list as T1 left join car_makers as T2 on T1.Maker = T2.Id left join car_names as T3 on T1.Model = T3.Model left join cars_data as T4 on T3.MakeId = T4.Id where T2.FullName = "General Motors" or T4.Weight > 3500	car_1
select distinct T1.Model from model_list as T1 left join car_makers as T2 on T1.Maker = T2.Id left join car_names as T3 on T1.Model = T3.Model left join cars_data as T4 on T3.MakeId = T4.Id where T2.FullName = "General Motors" or T4.Weight > 3500	car_1
select distinct Year from cars_data where Weight >= 3000 and Weight <= 4000	car_1
select Year from cars_data where Weight < 4000 intersect select Year from cars_data where Weight > 3000	car_1
select Horsepower from cars_data order by Accelerate desc limit 1	car_1
select Horsepower from cars_data order by Accelerate desc limit 1	car_1
select T1.Cylinders from cars_data as T1 inner join car_names as T2 on T1.Id = T2.MakeId where T2.Model = "volvo" order by T1.Accelerate asc limit 1	car_1
select T1.Cylinders from cars_data as T1 inner join car_names as T2 on T1.Id = T2.MakeId where T2.Make = "volvo" order by T1.Accelerate asc limit 1	car_1
select count(Id) from cars_data where Accelerate > (select Accelerate from cars_data where CAST(Horsepower as REAL) = (select max(CAST(Horsepower as REAL)) from cars_data) limit 1)	car_1
select count(*) from cars_data where Accelerate > (select Accelerate from cars_data order by CAST(Horsepower as INTEGER) desc limit 1)	car_1
select count(T1.Country) from car_makers as T1 group by T1.Country having count(T1.Maker) > 2	car_1
select count(Country) from car_makers group by Country having count(Id) > 2	car_1
select count(*) from cars_data where Cylinders > 6	car_1
select count(*) from cars_data where Cylinders > 6	car_1
select T1.Model from car_names as T1 inner join cars_data as T2 on T1.MakeId = T2.Id where T2.Cylinders = 4 order by CAST(T2.Horsepower as INTEGER) desc limit 1	car_1
select T2.Model from cars_data as T1 inner join car_names as T2 on T1.Id = T2.MakeId where T1.Cylinders = 4 order by T1.Horsepower desc limit 1	car_1
select T1.MakeId, T1.Make from car_names as T1 inner join cars_data as T2 on T1.MakeId = T2.Id where CAST(T2.Horsepower as INTEGER) > ( select min(CAST(Horsepower as INTEGER)) from cars_data where Horsepower != "NA" ) and T2.Cylinders <= 3	car_1
select T1.MakeId, T1.Model from car_names as T1 inner join cars_data as T2 on T1.MakeId = T2.Id where T2.Cylinders < 4 and CAST(T2.Horsepower as NUMERIC) > (select min(CAST(Horsepower as NUMERIC)) from cars_data)	car_1
select max(CAST(MPG as REAL)) from cars_data where Cylinders = 8 or Year < 1980	car_1
select max(CAST(MPG as REAL)) from cars_data where Cylinders = 8 or Year < 1980	car_1
select distinct T1.Model from model_list as T1 inner join car_makers as T2 on T1.Maker = T2.Id inner join car_names as T3 on T1.Model = T3.Model inner join cars_data as T4 on T3.MakeId = T4.Id where T4.Weight < 3500 and T2.FullName != "Ford Motor Company"	car_1
select distinct T3.Model from cars_data as T1 inner join car_names as T2 on T1.Id = T2.MakeId inner join model_list as T3 on T2.Model = T3.Model inner join car_makers as T4 on T3.Maker = T4.Id where T1.Weight < 3500 and T4.FullName != "Ford Motor Company"	car_1
select CountryName from countries where CountryId not in (select Country from car_makers)	car_1
select CountryName from countries where CountryId not in (select Country from car_makers)	car_1
ite WITH EligibleMakers as ( select T1.Id, T1.Maker from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker group by T1.Id, T1.Maker having count(T2.ModelId) >= 2 ) select Id, Maker from EligibleMakers where ( select count(*) from EligibleMakers ) > 3	car_1
select T1.Id, T1.Maker from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker join car_names as T3 on T2.Model = T3.Model join cars_data as T4 on T3.MakeId = T4.Id group by T1.Id, T1.Maker having	car_1
select T1.CountryId, T1.CountryName from countries as T1 join car_makers as T2 on T1.CountryId = T2.Country group by T1.CountryId having count(T2.Id) > 3 union select T1.CountryId, T1.CountryName from countries as T1 join car_makers as T2 on T1.CountryId = T2.Country join model_list as T3 on T2.Id = T3.Maker where T3.Model = "fiat"	car_1
select T1.CountryId, T1.CountryName from countries as T1 join car_makers as T2 on T1.CountryId = T2.Country group by T1.CountryId having count(T2.Id) > 3 union select T1.CountryId, T1.CountryName from countries as T1 join car_makers as T2 on T1.CountryId = T2.Country join model_list as T3 on T2.Id = T3.Maker where T3.Model = "fiat"	car_1
select count(*) from Documents	cre_Doc_Template_Mgt
select count(*) from Documents	cre_Doc_Template_Mgt
select Document_ID, Document_Name, Document_Description from Documents	cre_Doc_Template_Mgt
select Document_ID, Document_Name, Document_Description from Documents	cre_Doc_Template_Mgt
select Document_Name, Template_ID from Documents where Document_Description like "%w%"	cre_Doc_Template_Mgt
select Document_Name, Template_ID from Documents where Document_Description like "%w%"	cre_Doc_Template_Mgt
select Document_ID, Template_ID, Document_Description from Documents where Document_Name = "Robbin CV"	cre_Doc_Template_Mgt
select Document_ID, Template_ID, Document_Description from Documents where Document_Name = "Robbin CV"	cre_Doc_Template_Mgt
select count(distinct Template_ID) from Documents	cre_Doc_Template_Mgt
select count(distinct Template_ID) from Documents	cre_Doc_Template_Mgt
select count(T1.Document_ID) from Documents as T1 inner join Templates as T2 on T1.Template_ID = T2.Template_ID where T2.Template_Type_Code = "PPT"	cre_Doc_Template_Mgt
select count(T1.Document_ID) from Documents as T1 inner join Templates as T2 on T1.Template_ID = T2.Template_ID where T2.Template_Type_Code = "PPT"	cre_Doc_Template_Mgt
select T1.Template_ID, count(T2.Document_ID) from Templates as T1 join Documents as T2 on T1.Template_ID = T2.Template_ID group by T1.Template_ID	cre_Doc_Template_Mgt
select Template_ID, count(Template_ID) from Documents group by Template_ID	cre_Doc_Template_Mgt
select T1.Template_ID, T1.Template_Type_Code from Templates as T1 join Documents as T2 on T1.Template_ID = T2.Template_ID group by T1.Template_ID order by count(T2.Document_ID) desc limit 1	cre_Doc_Template_Mgt
select T1.Template_ID, T1.Template_Type_Code from Templates as T1 join Documents as T2 on T1.Template_ID = T2.Template_ID group by T1.Template_ID, T1.Template_Type_Code order by count(T2.Document_ID) desc limit 1	cre_Doc_Template_Mgt
select Template_ID from Documents group by Template_ID having count(Document_ID) > 1	cre_Doc_Template_Mgt
select Template_ID from Documents group by Template_ID having count(Document_ID) > 1	cre_Doc_Template_Mgt
select Template_ID from Templates except select Template_ID from Documents	cre_Doc_Template_Mgt
select Template_ID from Templates except select Template_ID from Documents	cre_Doc_Template_Mgt
select count(*) from Templates	cre_Doc_Template_Mgt
select count(*) from Templates	cre_Doc_Template_Mgt
select Template_ID, Version_Number, Template_Type_Code from Templates	cre_Doc_Template_Mgt
select Template_ID, Version_Number, Template_Type_Code from Templates	cre_Doc_Template_Mgt
select distinct Template_Type_Code from Templates	cre_Doc_Template_Mgt
select distinct Template_Type_Code from Ref_Template_Types	cre_Doc_Template_Mgt
select Template_ID from Templates where Template_Type_Code in ("PP", "PPT")	cre_Doc_Template_Mgt
select Template_ID from Templates where Template_Type_Code in ("PP", "PPT")	cre_Doc_Template_Mgt
select count(*) from Templates where Template_Type_Code = "CV"	cre_Doc_Template_Mgt
select count(T1.Template_ID) from Templates as T1 inner join Ref_Template_Types as T2 on T1.Template_Type_Code = T2.Template_Type_Code where T2.Template_Type_Description = "CV"	cre_Doc_Template_Mgt
select Version_Number, Template_Type_Code from Templates where Version_Number > 5	cre_Doc_Template_Mgt
select Version_Number, Template_Type_Code from Templates where Version_Number > 5	cre_Doc_Template_Mgt
select T1.Template_Type_Code, count(T2.Template_ID) from Ref_Template_Types as T1 left join Templates as T2 on T1.Template_Type_Code = T2.Template_Type_Code group by T1.Template_Type_Code	cre_Doc_Template_Mgt
select Template_Type_Code, count(Template_ID) from Templates group by Template_Type_Code	cre_Doc_Template_Mgt
select Template_Type_Code from Templates group by Template_Type_Code order by count(Template_ID) desc limit 1	cre_Doc_Template_Mgt
select Template_Type_Code from Templates group by Template_Type_Code order by count(Template_ID) desc limit 1	cre_Doc_Template_Mgt
select Template_Type_Code from Templates group by Template_Type_Code having count(*) < 3	cre_Doc_Template_Mgt
select Template_Type_Code from Templates group by Template_Type_Code having count(*) < 3	cre_Doc_Template_Mgt
select Version_Number, Template_Type_Code from Templates order by Version_Number asc limit 1	cre_Doc_Template_Mgt
select Template_Type_Code, Version_Number from Templates order by Version_Number asc limit 1	cre_Doc_Template_Mgt
select T1.Template_Type_Code from Templates as T1 inner join Documents as T2 on T1.Template_ID = T2.Template_ID where T2.Document_Name = "Data base"	cre_Doc_Template_Mgt
select T2.Template_Type_Code from Documents as T1 inner join Templates as T2 on T1.Template_ID = T2.Template_ID where T1.Document_Name = "Data base"	cre_Doc_Template_Mgt
select T1.Document_Name from Documents as T1 inner join Templates as T2 on T1.Template_ID = T2.Template_ID where T2.Template_Type_Code = "BK"	cre_Doc_Template_Mgt
select T1.Document_Name from Documents as T1 inner join Templates as T2 on T1.Template_ID = T2.Template_ID where T2.Template_Type_Code = "BK"	cre_Doc_Template_Mgt
select T1.Template_Type_Code, count(T3.Document_ID) from Ref_Template_Types as T1 left join Templates as T2 on T1.Template_Type_Code = T2.Template_Type_Code left join Documents as T3 on T2.Template_ID = T3.Template_ID group by T1.Template_Type_Code	cre_Doc_Template_Mgt
select T1.Template_Type_Code, count(T3.Document_ID) from Ref_Template_Types as T1 join Templates as T2 on T1.Template_Type_Code = T2.Template_Type_Code left join Documents as T3 on T2.Template_ID = T3.Template_ID group by T1.Template_Type_Code	cre_Doc_Template_Mgt
select T1.Template_Type_Code from Templates as T1 join Documents as T2 on T1.Template_ID = T2.Template_ID group by T1.Template_Type_Code order by count(T2.Document_ID) desc limit 1	cre_Doc_Template_Mgt
select T1.Template_Type_Code from Templates as T1 join Documents as T2 on T1.Template_ID = T2.Template_ID group by T1.Template_Type_Code order by count(T2.Document_ID) desc limit 1	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types where Template_Type_Code not in ( select T1.Template_Type_Code from Templates as T1 join Documents as T2 on T1.Template_ID = T2.Template_ID )	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types except select T1.Template_Type_Code from Templates as T1 join Documents as T2 on T1.Template_ID = T2.Template_ID	cre_Doc_Template_Mgt
select Template_Type_Code, Template_Type_Description from Ref_Template_Types	cre_Doc_Template_Mgt
select Template_Type_Code, Template_Type_Description from Ref_Template_Types	cre_Doc_Template_Mgt
select Template_Type_Description from Ref_Template_Types where Template_Type_Code = "AD"	cre_Doc_Template_Mgt
select Template_Type_Description from Ref_Template_Types where Template_Type_Code = "AD"	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types where Template_Type_Description = "Book"	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types where Template_Type_Description = "Book"	cre_Doc_Template_Mgt
select distinct T2.Template_Type_Description from Templates as T1 inner join Ref_Template_Types as T2 on T1.Template_Type_Code = T2.Template_Type_Code where T1.Template_ID in ( select Template_ID from Documents )	cre_Doc_Template_Mgt
select distinct T1.Template_Type_Description from Ref_Template_Types as T1 inner join Templates as T2 on T1.Template_Type_Code = T2.Template_Type_Code inner join Documents as T3 on T2.Template_ID = T3.Template_ID	cre_Doc_Template_Mgt
select T1.Template_ID from Templates as T1 inner join Ref_Template_Types as T2 on T1.Template_Type_Code = T2.Template_Type_Code where T2.Template_Type_Description = "Presentation"	cre_Doc_Template_Mgt
select T1.Template_ID from Templates as T1 inner join Ref_Template_Types as T2 on T1.Template_Type_Code = T2.Template_Type_Code where T2.Template_Type_Description = "Presentation"	cre_Doc_Template_Mgt
select count(*) from Paragraphs	cre_Doc_Template_Mgt
select count(*) from Paragraphs	cre_Doc_Template_Mgt
select count(T1.Paragraph_ID) from Paragraphs as T1 inner join Documents as T2 on T1.Document_ID = T2.Document_ID where T2.Document_Name = "Summer Show"	cre_Doc_Template_Mgt
select count(T1.Paragraph_ID) from Paragraphs as T1 inner join Documents as T2 on T1.Document_ID = T2.Document_ID where T2.Document_Name = "Summer Show"	cre_Doc_Template_Mgt
select * from Paragraphs where Paragraph_Text = "Korea "	cre_Doc_Template_Mgt
select * from Paragraphs where Paragraph_Text like "%Korea %"	cre_Doc_Template_Mgt
select T1.Paragraph_ID, T1.Paragraph_Text from Paragraphs as T1 inner join Documents as T2 on T1.Document_ID = T2.Document_ID where T2.Document_Name = "Welcome to NY"	cre_Doc_Template_Mgt
select T1.Paragraph_ID, T1.Paragraph_Text from Paragraphs as T1 inner join Documents as T2 on T1.Document_ID = T2.Document_ID where T2.Document_Name = "Welcome to NY"	cre_Doc_Template_Mgt
select T1.Paragraph_Text from Paragraphs as T1 inner join Documents as T2 on T1.Document_ID = T2.Document_ID where T2.Document_Name = "Customer reviews"	cre_Doc_Template_Mgt
select T1.Paragraph_Text from Paragraphs as T1 inner join Documents as T2 on T1.Document_ID = T2.Document_ID where T2.Document_Name = "Customer reviews"	cre_Doc_Template_Mgt
select Document_ID, count(Paragraph_ID) from Paragraphs group by Document_ID order by Document_ID	cre_Doc_Template_Mgt
select Document_ID, count(Paragraph_ID) from Paragraphs group by Document_ID order by Document_ID	cre_Doc_Template_Mgt
select T1.Document_ID, T1.Document_Name, count(T2.Paragraph_ID) from Documents as T1 join Paragraphs as T2 on T1.Document_ID = T2.Document_ID group by T1.Document_ID, T1.Document_Name	cre_Doc_Template_Mgt
select T1.Document_ID, T1.Document_Name, count(T2.Paragraph_ID) from Documents as T1 inner join Paragraphs as T2 on T1.Document_ID = T2.Document_ID group by T1.Document_ID, T1.Document_Name	cre_Doc_Template_Mgt
select Document_ID from Paragraphs group by Document_ID having count(*) >= 2	cre_Doc_Template_Mgt
select Document_ID from Paragraphs group by Document_ID having count(*) >= 2	cre_Doc_Template_Mgt
select T1.Document_ID, T1.Document_Name from Documents as T1 join Paragraphs as T2 on T1.Document_ID = T2.Document_ID group by T1.Document_ID order by count(T2.Paragraph_ID) desc limit 1	cre_Doc_Template_Mgt
select T1.Document_ID, T1.Document_Name from Documents as T1 inner join Paragraphs as T2 on T1.Document_ID = T2.Document_ID group by T1.Document_ID order by count(T2.Paragraph_ID) desc limit 1	cre_Doc_Template_Mgt
select Document_ID from Paragraphs group by Document_ID order by count(Paragraph_ID) asc limit 1	cre_Doc_Template_Mgt
select Document_ID from Paragraphs group by Document_ID order by count(Paragraph_ID) asc limit 1	cre_Doc_Template_Mgt
select Document_ID from Paragraphs group by Document_ID having count(*) between 1 and 2	cre_Doc_Template_Mgt
select Document_ID from Paragraphs group by Document_ID having count(Paragraph_ID) between 1 and 2	cre_Doc_Template_Mgt
select Document_ID from Paragraphs where Paragraph_Text in ("Brazil", "Ireland") group by Document_ID having count(distinct Paragraph_Text) = 2	cre_Doc_Template_Mgt
select Document_ID from Paragraphs where Paragraph_Text like "%Brazil%" intersect select Document_ID from Paragraphs where Paragraph_Text like "%Ireland%"	cre_Doc_Template_Mgt
select T1.state from Owners as T1 intersect select T1.state from Professionals as T1	dog_kennels
select state from Owners intersect select state from Professionals	dog_kennels
select avg(T1.age) from Dogs as T1 inner join Treatments as T2 on T1.dog_id = T2.dog_id	dog_kennels
select avg(T1.age) from Dogs as T1 inner join Treatments as T2 on T1.dog_id = T2.dog_id	dog_kennels
select professional_id, last_name, cell_number from Professionals where state = "in" union select T1.professional_id, T1.last_name, T1.cell_number from Professionals as T1 join Treatments as T2 on T1.professional_id = T2.professional_id group by T1.professional_id having count(T2.treatment_id) > 2	dog_kennels
select professional_id, last_name, cell_number from Professionals where state = "in" union select T1.professional_id, T1.last_name, T1.cell_number from Professionals as T1 inner join Treatments as T2 on T1.professional_id = T2.professional_id group by T1.professional_id having count(T2.treatment_id) > 2	dog_kennels
select T1.name from Dogs as T1 join Treatments as T2 on T1.dog_id = T2.dog_id group by T1.dog_id having sum(T2.cost_of_treatment) <= 1000	dog_kennels
select T1.name from Dogs as T1 inner join Treatments as T2 on T1.dog_id = T2.dog_id group by T1.dog_id having sum(T2.cost_of_treatment) <= 1000	dog_kennels
select first_name from Professionals union select first_name from Owners except select name from Dogs	dog_kennels
select first_name from Professionals union select first_name from Owners except select name from Dogs	dog_kennels
select professional_id, role_code, email_address from Professionals where professional_id not in (select professional_id from Treatments)	dog_kennels
select professional_id, role_code, email_address from Professionals where professional_id not in (select professional_id from Treatments)	dog_kennels
select T1.owner_id, T1.first_name, T1.last_name from Owners as T1 join Dogs as T2 on T1.owner_id = T2.owner_id group by T1.owner_id order by count(T2.dog_id) desc limit 1	dog_kennels
select T1.owner_id, T1.first_name, T1.last_name from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id group by T1.owner_id order by count(T2.dog_id) desc limit 1	dog_kennels
select T1.professional_id, T1.role_code, T1.first_name from Professionals as T1 inner join Treatments as T2 on T1.professional_id = T2.professional_id group by T1.professional_id, T1.role_code, T1.first_name having count(T2.treatment_id) >= 2	dog_kennels
select T1.professional_id, T1.role_code, T1.first_name from Professionals as T1 inner join Treatments as T2 on T1.professional_id = T2.professional_id group by T1.professional_id having count(T2.treatment_id) >= 2	dog_kennels
select T1.breed_name from Breeds as T1 join Dogs as T2 on T1.breed_code = T2.breed_code group by T1.breed_name order by count(T2.dog_id) desc limit 1	dog_kennels
select T1.breed_name from Breeds as T1 inner join Dogs as T2 on T1.breed_code = T2.breed_code group by T1.breed_name order by count(T2.dog_id) desc limit 1	dog_kennels
select T1.owner_id, T1.last_name from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id inner join Treatments as T3 on T2.dog_id = T3.dog_id group by T1.owner_id, T1.last_name order by count(T3.treatment_id) desc limit 1	dog_kennels
select T1.owner_id, T1.last_name from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id inner join Treatments as T3 on T2.dog_id = T3.dog_id group by T1.owner_id order by sum(T3.cost_of_treatment) desc limit 1	dog_kennels
select T2.treatment_type_description from Treatments as T1 inner join Treatment_Types as T2 on T1.treatment_type_code = T2.treatment_type_code group by T1.treatment_type_code order by sum(T1.cost_of_treatment) asc limit 1	dog_kennels
select T2.treatment_type_description from Treatments as T1 join Treatment_Types as T2 on T1.treatment_type_code = T2.treatment_type_code group by T2.treatment_type_description order by sum(T1.cost_of_treatment) asc limit 1	dog_kennels
select T1.owner_id, T1.zip_code from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id inner join Treatments as T3 on T2.dog_id = T3.dog_id group by T1.owner_id order by sum(T3.cost_of_treatment) desc limit 1	dog_kennels
select T1.owner_id, T1.zip_code from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id inner join Treatments as T3 on T2.dog_id = T3.dog_id group by T1.owner_id order by sum(T3.cost_of_treatment) desc limit 1	dog_kennels
select T1.professional_id, T1.cell_number from Professionals as T1 inner join Treatments as T2 on T1.professional_id = T2.professional_id group by T1.professional_id having count(distinct T2.treatment_type_code) >= 2	dog_kennels
select T1.professional_id, T1.cell_number from Professionals as T1 inner join Treatments as T2 on T1.professional_id = T2.professional_id group by T1.professional_id, T1.cell_number having count(distinct T2.treatment_type_code) >= 2	dog_kennels
select T1.first_name, T1.last_name from Professionals as T1 inner join Treatments as T2 on T1.professional_id = T2.professional_id where T2.cost_of_treatment < (select avg(cost_of_treatment) from Treatments) group by T1.professional_id	dog_kennels
select T1.first_name, T1.last_name from Professionals as T1 inner join Treatments as T2 on T1.professional_id = T2.professional_id where T2.cost_of_treatment < ( select avg(cost_of_treatment) from Treatments )	dog_kennels
select T1.date_of_treatment, T2.first_name from Treatments as T1 inner join Professionals as T2 on T1.professional_id = T2.professional_id	dog_kennels
select T1.date_of_treatment, T2.first_name from Treatments as T1 inner join Professionals as T2 on T1.professional_id = T2.professional_id	dog_kennels
select T1.cost_of_treatment, T2.treatment_type_description from Treatments as T1 inner join Treatment_Types as T2 on T1.treatment_type_code = T2.treatment_type_code	dog_kennels
select T1.cost_of_treatment, T2.treatment_type_description from Treatments as T1 inner join Treatment_Types as T2 on T1.treatment_type_code = T2.treatment_type_code	dog_kennels
select T1.first_name, T1.last_name, T3.size_description from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id inner join Sizes as T3 on T2.size_code = T3.size_code	dog_kennels
select T1.first_name, T1.last_name, T3.size_description from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id inner join Sizes as T3 on T2.size_code = T3.size_code	dog_kennels
select T1.first_name, T2.name from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id	dog_kennels
select T1.first_name, T2.name from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id	dog_kennels
ite select T1.name, T2.date_of_treatment from Dogs as T1 inner join Treatments as T2 on T1.dog_id = T2.dog_id where T1.breed_code = ( select breed_code from Dogs group by breed_code order by count(breed_code) asc limit 1 )	dog_kennels
select T1.name, T2.date_of_treatment from Dogs as T1 inner join Treatments as T2 on T1.dog_id = T2.dog_id where T1.breed_code in ( select breed_code from Dogs group by breed_code having count(dog_id) = ( select min(count_per_breed) from ( select count(dog_id) from Dogs group by breed_code ) ) )	dog_kennels
select T1.first_name, T2.name from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id where T1.state = "VA"	dog_kennels
select T1.first_name, T2.name from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id where T1.state = "VA"	dog_kennels
select distinct T1.date_arrived, T1.date_departed from Dogs as T1 inner join Treatments as T2 on T1.dog_id = T2.dog_id	dog_kennels
select T1.date_arrived, T1.date_departed from Dogs as T1 inner join Treatments as T2 on T1.dog_id = T2.dog_id	dog_kennels
select T1.last_name from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id order by T2.date_of_birth desc limit 1	dog_kennels
select T1.last_name from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id order by T2.date_of_birth desc limit 1	dog_kennels
select email_address from Professionals where state = "Hawaii" or state = "Wisconsin"	dog_kennels
select email_address from Professionals where state = "HI" or state = "WI"	dog_kennels
select date_arrived, date_departed from Dogs	dog_kennels
select date_arrived, date_departed from Dogs	dog_kennels
select count(distinct dog_id) from Treatments	dog_kennels
select count(distinct dog_id) from Treatments	dog_kennels
select count(distinct professional_id) from Treatments	dog_kennels
select count(distinct professional_id) from Treatments	dog_kennels
select role_code, street, city, state from Professionals where city like "%West%"	dog_kennels
select role_code, street, city, state from Professionals where city like "%West%"	dog_kennels
select first_name, last_name, email_address from Owners where state like "%North%"	dog_kennels
select first_name, last_name, email_address from Owners where state like "%North%"	dog_kennels
select count(dog_id) from Dogs where age < (select avg(age) from Dogs)	dog_kennels
select count(dog_id) from Dogs where age < (select avg(age) from Dogs)	dog_kennels
select cost_of_treatment from Treatments order by date_of_treatment desc limit 1	dog_kennels
select cost_of_treatment from Treatments order by date_of_treatment desc limit 1	dog_kennels
select count(dog_id) from Dogs where dog_id not in (select dog_id from Treatments)	dog_kennels
select count(dog_id) from Dogs where dog_id not in (select dog_id from Treatments)	dog_kennels
select count(T1.owner_id) from Owners as T1 where T1.owner_id not in ( select T2.owner_id from Dogs as T2 where T2.date_adopted is null and T2.date_departed is null )	dog_kennels
select count(T1.owner_id) from Owners as T1 where T1.owner_id not in ( select T2.owner_id from Dogs as T2 where T2.date_adopted is null and T2.date_departed is null )	dog_kennels
select count(professional_id) from Professionals where professional_id not in (select professional_id from Treatments)	dog_kennels
select count(professional_id) from Professionals where professional_id not in (select professional_id from Treatments)	dog_kennels
select name, age, weight from Dogs where abandoned_yn = "1"	dog_kennels
select name, age, weight from Dogs where abandoned_yn = "1"	dog_kennels
select avg(age) from Dogs	dog_kennels
select avg(age) from Dogs	dog_kennels
select max(age) from Dogs	dog_kennels
select max(age) from Dogs	dog_kennels
select charge_type, charge_amount from Charges	dog_kennels
select charge_type, charge_amount from Charges	dog_kennels
select max(charge_amount) from Charges	dog_kennels
select max(charge_amount) from Charges	dog_kennels
select email_address, cell_number, home_phone from Professionals	dog_kennels
select email_address, cell_number, home_phone from Professionals	dog_kennels
select T1.breed_name, T2.size_description from Breeds as T1 CROSS join Sizes as T2	dog_kennels
select distinct T1.breed_name, T2.size_description from Breeds as T1 inner join Sizes as T2 inner join Dogs as T3 on T1.breed_code = T3.breed_code and T2.size_code = T3.size_code	dog_kennels
select T1.first_name, T3.treatment_type_description from Professionals as T1 inner join Treatments as T2 on T1.professional_id = T2.professional_id inner join Treatment_Types as T3 on T2.treatment_type_code = T3.treatment_type_code	dog_kennels
select T1.first_name, T3.treatment_type_description from Professionals as T1 inner join Treatments as T2 on T1.professional_id = T2.professional_id inner join Treatment_Types as T3 on T2.treatment_type_code = T3.treatment_type_code	dog_kennels
select line_1, line_2 from Addresses	student_transcripts_tracking
select line_1, line_2 from Addresses	student_transcripts_tracking
select count(course_id) from Courses	student_transcripts_tracking
select count(*) from Courses	student_transcripts_tracking
select course_description from Courses where course_name = "math"	student_transcripts_tracking
select course_description from Courses where course_name like "%Math%" or course_name like "%mathematics%"	student_transcripts_tracking
select zip_postcode from Addresses where city = "Port Chelsea"	student_transcripts_tracking
select zip_postcode from Addresses where city = "Port Chelsea"	student_transcripts_tracking
select T1.department_name, T1.department_id from Departments as T1 inner join Degree_Programs as T2 on T1.department_id = T2.department_id group by T1.department_id order by count(T2.degree_program_id) desc limit 1	student_transcripts_tracking
select T1.department_name, T1.department_id from Departments as T1 inner join Degree_Programs as T2 on T1.department_id = T2.department_id group by T1.department_id order by count(T2.degree_program_id) desc limit 1	student_transcripts_tracking
select count(distinct T1.department_id) from Departments as T1 inner join Degree_Programs as T2 on T1.department_id = T2.department_id	student_transcripts_tracking
select count(distinct department_id) from Degree_Programs	student_transcripts_tracking
select count(distinct degree_summary_name) from Degree_Programs	student_transcripts_tracking
select count(distinct degree_summary_name) from Degree_Programs	student_transcripts_tracking
select count(T1.degree_program_id) from Degree_Programs as T1 inner join Departments as T2 on T1.department_id = T2.department_id where T2.department_name = "Engineering"	student_transcripts_tracking
select count(T1.degree_program_id) from Degree_Programs as T1 inner join Departments as T2 on T1.department_id = T2.department_id where T2.department_name = "Engineering"	student_transcripts_tracking
select section_name, section_description from Sections	student_transcripts_tracking
select section_name, section_description from Sections	student_transcripts_tracking
select T1.course_name, T1.course_id from Courses as T1 join Sections as T2 on T1.course_id = T2.course_id group by T1.course_id having count(T2.section_id) <= 2	student_transcripts_tracking
select T1.course_name, T1.course_id from Courses as T1 join Sections as T2 on T1.course_id = T2.course_id group by T1.course_id having count(T2.section_id) < 2	student_transcripts_tracking
select section_name from Sections order by section_name desc	student_transcripts_tracking
select section_name from Sections order by section_name desc	student_transcripts_tracking
select T1.semester_name, T1.semester_id from Semesters as T1 join Student_Enrolment as T2 on T1.semester_id = T2.semester_id group by T1.semester_id order by count(T2.student_id) desc limit 1	student_transcripts_tracking
ite select T1.semester_name, T1.semester_id from Semesters as T1 inner join Student_Enrolment as T2 on T1.semester_id = T2.semester_id group by T1.semester_id order by count(T2.student_id) desc limit 1	student_transcripts_tracking
select department_description from Departments where department_name like "%the computer%"	student_transcripts_tracking
select department_description from Departments where department_name like "%computer%"	student_transcripts_tracking
select T1.first_name, T1.middle_name, T1.last_name, T1.student_id from Students as T1 inner join Student_Enrolment as T2 on T1.student_id = T2.student_id group by T1.student_id, T2.semester_id having count(distinct T2.degree_program_id) = 2	student_transcripts_tracking
select T1.first_name, T1.middle_name, T1.last_name, T1.student_id from Students as T1 inner join Student_Enrolment as T2 on T1.student_id = T2.student_id group by T1.student_id, T2.semester_id having count(distinct T2.degree_program_id) = 2	student_transcripts_tracking
select T1.first_name, T1.middle_name, T1.last_name from Students as T1 inner join Student_Enrolment as T2 on T1.student_id = T2.student_id inner join Degree_Programs as T3 on T2.degree_program_id = T3.degree_program_id where T3.degree_summary_name like "%Bachelor%"	student_transcripts_tracking
select T1.first_name, T1.middle_name, T1.last_name from Students as T1 inner join Student_Enrolment as T2 on T1.student_id = T2.student_id inner join Degree_Programs as T3 on T2.degree_program_id = T3.degree_program_id where T3.degree_summary_name like "%Bachelors%"	student_transcripts_tracking
select T2.degree_summary_name from Student_Enrolment as T1 inner join Degree_Programs as T2 on T1.degree_program_id = T2.degree_program_id group by T1.degree_program_id order by count(T1.student_id) desc limit 1	student_transcripts_tracking
ite select T2.degree_summary_name from Student_Enrolment as T1 inner join Degree_Programs as T2 on T1.degree_program_id = T2.degree_program_id group by T2.degree_summary_name order by count(T1.student_id) desc limit 1	student_transcripts_tracking
select T1.degree_program_id, T1.degree_summary_name from Degree_Programs as T1 join Student_Enrolment as T2 on T1.degree_program_id = T2.degree_program_id group by T1.degree_program_id order by count(T2.student_id) desc limit 1	student_transcripts_tracking
ite select T1.degree_program_id, T1.degree_summary_name from Degree_Programs as T1 inner join Student_Enrolment as T2 on T1.degree_program_id = T2.degree_program_id group by T1.degree_program_id, T1.degree_summary_name order by count(T2.student_id) desc limit 1	student_transcripts_tracking
ite select T1.student_id, T1.first_name, T1.middle_name, T1.last_name, count(T2.student_enrolment_id), T1.student_id from Students as T1 inner join Student_Enrolment as T2 on T1.student_id = T2.student_id group by T1.student_id, T1.first_name, T1.middle_name, T1.last_name order by num_enrollments desc limit 1	student_transcripts_tracking
select T1.first_name, T1.middle_name, T1.last_name, T1.student_id, count(T2.student_enrolment_id) from Students as T1 inner join Student_Enrolment as T2 on T1.student_id = T2.student_id group by T1.student_id order by num_enrollments desc limit 1	student_transcripts_tracking
select semester_name from Semesters where semester_id not in ( select semester_id from Student_Enrolment )	student_transcripts_tracking
select T1.semester_name from Semesters as T1 where T1.semester_id not in (select T2.semester_id from Student_Enrolment as T2)	student_transcripts_tracking
select distinct T1.course_name from Courses as T1 inner join Student_Enrolment_Courses as T2 on T1.course_id = T2.course_id	student_transcripts_tracking
select distinct T1.course_name from Courses as T1 inner join Student_Enrolment_Courses as T2 on T1.course_id = T2.course_id	student_transcripts_tracking
select T1.course_name from Courses as T1 join Student_Enrolment_Courses as T2 on T1.course_id = T2.course_id group by T1.course_id order by count(T2.course_id) desc limit 1	student_transcripts_tracking
select T1.course_name from Courses as T1 join Student_Enrolment_Courses as T2 on T1.course_id = T2.course_id group by T1.course_id order by count(T2.student_course_id) desc limit 1	student_transcripts_tracking
ite select T1.last_name from Students as T1 inner join Addresses as T2 on T1.current_address_id = T2.address_id where T2.state_province_county = "North Carolina" and T1.student_id not in ( select student_id from Student_Enrolment )	student_transcripts_tracking
select T1.last_name from Students as T1 inner join Addresses as T2 on T1.current_address_id = T2.address_id where T2.state_province_county = "North Carolina" and T1.student_id not in ( select student_id from Student_Enrolment )	student_transcripts_tracking
select T1.transcript_date, T1.transcript_id from Transcripts as T1 inner join Transcript_Contents as T2 on T1.transcript_id = T2.transcript_id group by T1.transcript_id having count(T2.student_course_id) >= 2	student_transcripts_tracking
select T1.transcript_date, T1.transcript_id from Transcripts as T1 join Transcript_Contents as T2 on T1.transcript_id = T2.transcript_id group by T1.transcript_id having count(T2.student_course_id) >= 2	student_transcripts_tracking
select cell_mobile_number from Students where first_name = "Timmothy" and last_name = "Ward"	student_transcripts_tracking
select cell_mobile_number from Students where first_name = "Timmothy" and last_name = "Ward"	student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_first_registered asc limit 1	student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_first_registered asc limit 1	student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_left asc limit 1	student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_left asc limit 1	student_transcripts_tracking
select first_name from Students where permanent_address_id != current_address_id	student_transcripts_tracking
select first_name from Students where permanent_address_id != current_address_id	student_transcripts_tracking
select T1.address_id, T1.line_1, T1.line_2, T1.line_3 from Addresses as T1 inner join Students as T2 on T1.address_id = T2.current_address_id group by T1.address_id order by count(T2.student_id) desc limit 1	student_transcripts_tracking
select T1.address_id, T1.line_1, T1.line_2 from Addresses as T1 join ( select current_address_id from Students where current_address_id is not null union ALL select permanent_address_id from Students where permanent_address_id is not null ) on T1.address_id = T2.address_id group by T1.address_id order by count(T2.address_id) desc limit 1	student_transcripts_tracking
select datetime(avg(julianday(transcript_date))) from Transcripts	student_transcripts_tracking
select avg(transcript_date) from Transcripts	student_transcripts_tracking
select transcript_date, other_details from Transcripts order by transcript_date asc limit 1	student_transcripts_tracking
select * from Transcripts order by transcript_date asc limit 1	student_transcripts_tracking
select count(*) from Transcripts	student_transcripts_tracking
select count(transcript_id) from Transcripts	student_transcripts_tracking
select max(transcript_date) from Transcripts	student_transcripts_tracking
select max(transcript_date) from Transcripts	student_transcripts_tracking
select student_course_id, count(transcript_id) from Transcript_Contents group by student_course_id order by num_transcripts desc limit 1	student_transcripts_tracking
ite select count(T1.transcript_id), T2.student_enrolment_id from Transcript_Contents as T1 inner join Student_Enrolment_Courses as T2 on T1.student_course_id = T2.student_course_id group by T2.course_id order by count(T1.transcript_id) desc limit 1	student_transcripts_tracking
ite select T1.transcript_date, T1.transcript_id from Transcripts as T1 inner join Transcript_Contents as T2 on T1.transcript_id = T2.transcript_id group by T1.transcript_id order by count(T2.student_course_id) limit 1	student_transcripts_tracking
select T1.transcript_date, T1.transcript_id from Transcripts as T1 join Transcript_Contents as T2 on T1.transcript_id = T2.transcript_id group by T1.transcript_id order by count(T2.student_course_id) asc limit 1	student_transcripts_tracking
select T1.semester_name from Semesters as T1 join Student_Enrolment as T2 on T1.semester_id = T2.semester_id join Degree_Programs as T3 on T2.degree_program_id = T3.degree_program_id where T3.degree_summary_name like "%Master%" intersect select T1.semester_name from Semesters as T1 join Student_Enrolment as T2 on T1.semester_id = T2.semester_id join Degree_Programs as T3 on T2.degree_program_id = T3.degree_program_id where T3.degree_summary_name like "%Bachelor%"	student_transcripts_tracking
select T1.semester_id from Student_Enrolment as T1 inner join Degree_Programs as T2 on T1.degree_program_id = T2.degree_program_id where T2.degree_summary_name like "%Masters%" intersect select T1.semester_id from Student_Enrolment as T1 inner join Degree_Programs as T2 on T1.degree_program_id = T2.degree_program_id where T2.degree_summary_name like "%Bachelors%"	student_transcripts_tracking
select count(distinct current_address_id) from Students	student_transcripts_tracking
ite select distinct T1.* from Addresses as T1 join Students as T2 on T1.address_id = T2.current_address_id or T1.address_id = T2.permanent_address_id	student_transcripts_tracking
select * from Students order by first_name desc, last_name desc	student_transcripts_tracking
select other_student_details from Students order by first_name desc	student_transcripts_tracking
select section_description from Sections where section_name = "h"	student_transcripts_tracking
select section_description from Sections where section_name = "h"	student_transcripts_tracking
select T1.first_name from Students as T1 inner join Addresses as T2 on T1.permanent_address_id = T2.address_id where T2.country = "Haiti" or T1.cell_mobile_number = "09700166582"	student_transcripts_tracking
select T1.first_name from Students as T1 inner join Addresses as T2 on T1.permanent_address_id = T2.address_id where T2.country = "Haiti" or T1.cell_mobile_number = "09700166582"	student_transcripts_tracking
select count(player_id) from players	wta_1
select count(player_id) from players	wta_1
select count(*) from matches	wta_1
select count(*) from matches	wta_1
select first_name, birth_date from players where country_code = "USA"	wta_1
select first_name, birth_date from players where country_code = "USA"	wta_1
select avg(age) from (select loser_age from matches union ALL select winner_age from matches)	wta_1
select avg(loser_age), avg(winner_age) from matches	wta_1
select avg(winner_rank) from matches	wta_1
select avg(winner_rank) from matches	wta_1
select max(loser_rank) from matches	wta_1
select min(loser_rank) from matches	wta_1
select count(distinct country_code) from players	wta_1
select count(distinct country_code) from players	wta_1
select count(distinct loser_name) from matches	wta_1
select count(distinct loser_name) from matches	wta_1
select tourney_name from matches group by tourney_name having count(match_num) > 10	wta_1
select tourney_name from matches group by tourney_name having count(match_num) > 10	wta_1
select distinct T1.first_name, T1.last_name from players as T1 join matches as T2 on T1.player_id = T2.winner_id where T2.year = 2013 intersect select T1.first_name, T1.last_name from players as T1 join matches as T2 on T1.player_id = T2.winner_id where T2.year = 2016	wta_1
select T1.first_name, T1.last_name from players as T1 join matches as T2 on T1.player_id = T2.winner_id where T2.year = 2013 intersect select T1.first_name, T1.last_name from players as T1 join matches as T2 on T1.player_id = T2.winner_id where T2.year = 2016	wta_1
select count(*) from matches where year = 2013 or year = 2016	wta_1
select count(*) from matches where year = 2013 or year = 2016	wta_1
select T1.country_code, T1.first_name from players as T1 join matches as T2 on T1.player_id = T2.winner_id where T2.tourney_name = "WTA Championships" intersect select T1.country_code, T1.first_name from players as T1 join matches as T2 on T1.player_id = T2.winner_id where T2.tourney_name = "Australian Open"	wta_1
select T1.first_name, T1.country_code from players as T1 inner join matches as T2 on T1.player_id = T2.winner_id where T2.tourney_name = "WTA Championships" intersect select T1.first_name, T1.country_code from players as T1 inner join matches as T2 on T1.player_id = T2.winner_id where T2.tourney_name = "Australian Open"	wta_1
select first_name, country_code from players order by birth_date asc limit 1	wta_1
select first_name, country_code from players order by birth_date asc limit 1	wta_1
select first_name, last_name from players order by birth_date	wta_1
select first_name, last_name from players order by birth_date	wta_1
select first_name, last_name from players where hand = "L" order by birth_date	wta_1
select first_name, last_name from players where hand = "L" order by birth_date	wta_1
select T1.first_name, T1.country_code from players as T1 inner join rankings as T2 on T1.player_id = T2.player_id group by T1.player_id order by sum(T2.tours) desc limit 1	wta_1
select T1.first_name, T1.country_code from players as T1 inner join rankings as T2 on T1.player_id = T2.player_id group by T1.player_id order by sum(T2.tours) desc limit 1	wta_1
select year from matches group by year order by count(match_num) desc limit 1	wta_1
select year from matches group by year order by count(match_num) desc limit 1	wta_1
select T1.first_name, T1.last_name, ( select ranking_points from rankings where player_id = T1.player_id order by ranking_date desc limit 1 ) from players as T1 where T1.player_id = ( select winner_id from matches group by winner_id order by count(*) desc limit 1 )	wta_1
select winner_name, winner_rank_points from matches group by winner_id order by count(winner_id) desc limit 1	wta_1
select winner_name from matches where tourney_name = "Australian Open" order by winner_rank_points desc limit 1	wta_1
select winner_name from matches where tourney_name = "Australian Open" order by winner_rank_points desc limit 1	wta_1
select winner_name, loser_name from matches order by minutes desc limit 1	wta_1
select winner_name, loser_name from matches order by minutes desc limit 1	wta_1
select T1.first_name, avg(T2.ranking) from players as T1 inner join rankings as T2 on T1.player_id = T2.player_id group by T1.player_id, T1.first_name	wta_1
select T1.first_name, avg(T2.ranking) from players as T1 inner join rankings as T2 on T1.player_id = T2.player_id group by T1.player_id	wta_1
select T1.first_name, sum(T2.ranking_points) from players as T1 inner join rankings as T2 on T1.player_id = T2.player_id group by T1.player_id, T1.first_name	wta_1
select T1.first_name, sum(T2.ranking_points) from players as T1 inner join rankings as T2 on T1.player_id = T2.player_id group by T1.first_name	wta_1
select count(player_id), country_code from players group by country_code	wta_1
select count(*) , country_code from players group by country_code	wta_1
select country_code from players group by country_code order by count(player_id) desc limit 1	wta_1
select country_code from players group by country_code order by count(player_id) desc limit 1	wta_1
select country_code from players group by country_code having count(player_id) > 50	wta_1
select country_code from players group by country_code having count(player_id) > 50	wta_1
select ranking_date, sum(tours) from rankings group by ranking_date	wta_1
select ranking_date, sum(tours) from rankings group by ranking_date	wta_1
select year, count(*) from matches group by year	wta_1
select year, count(*) from matches group by year	wta_1
select winner_name, winner_rank from matches order by winner_age asc limit 3	wta_1
select winner_name, winner_rank from matches order by winner_age asc limit 3	wta_1
select count(distinct T1.winner_id) from matches as T1 inner join players as T2 on T1.winner_id = T2.player_id where T1.tourney_name = "WTA Championships" and T2.hand = "L"	wta_1
select count(distinct winner_id) from matches where winner_hand = "L" and tourney_name = "WTA Championships"	wta_1
select T1.first_name, T1.country_code, T1.birth_date from players as T1 inner join matches as T2 on T1.player_id = T2.winner_id order by T2.winner_rank_points desc limit 1	wta_1
select T1.first_name, T1.country_code, T1.birth_date from players as T1 inner join matches as T2 on T1.player_id = T2.winner_id order by T2.winner_rank_points desc limit 1	wta_1
select hand, count(player_id) from players group by hand	wta_1
select hand, count(player_id) from players group by hand	wta_1
select Title from Cartoon order by Title	tvshow
select Title from Cartoon order by Title	tvshow
select Title from Cartoon where Directed_by = "Ben Jones"	tvshow
select Title from Cartoon where Directed_by = "Ben Jones"	tvshow
select count(*) from Cartoon where Written_by = "Joseph Kuhr"	tvshow
select count(*) from Cartoon where Written_by = "Joseph Kuhr"	tvshow
select Title, Directed_by from Cartoon order by Original_air_date	tvshow
select Title, Directed_by from Cartoon order by Original_air_date	tvshow
select Title from Cartoon where Directed_by = "Ben Jones" or Directed_by = "Brandon Vietti"	tvshow
select Title from Cartoon where Directed_by = "Ben Jones" or Directed_by = "Brandon Vietti"	tvshow
select Country, count(id) from TV_Channel group by Country order by count(id) desc limit 1	tvshow
select Country, count(id) from TV_Channel group by Country order by count(id) desc limit 1	tvshow
select count(distinct series_name), count(distinct Content) from TV_Channel	tvshow
select count(distinct series_name), count(distinct Content) from TV_Channel	tvshow
select Content from TV_Channel where series_name = "Sky Radio"	tvshow
select Content from TV_Channel where series_name = "Sky Radio"	tvshow
select Package_Option from TV_Channel where series_name = "Sky Radio"	tvshow
select Package_Option from TV_Channel where series_name = "Sky Radio"	tvshow
select count(*) from TV_Channel where Language = "English"	tvshow
select count(id) from TV_Channel where Language = "English"	tvshow
select Language, count(id) from TV_Channel group by Language order by count(id) asc limit 1	tvshow
select Language, count(id) from TV_Channel group by Language having count(id) = (select min(channel_count) from (select count(id) from TV_Channel group by Language))	tvshow
select Language, count(id) from TV_Channel group by Language	tvshow
select Language, count(id) from TV_Channel group by Language	tvshow
select T1.series_name from TV_Channel as T1 inner join Cartoon as T2 on T1.id = T2.Channel where T2.Title = "The Rise of the Blue Beetle!"	tvshow
select T1.series_name from TV_Channel as T1 inner join Cartoon as T2 on T1.id = T2.Channel where T2.Title = "The Rise of the Blue Beetle"	tvshow
select T1.Title from Cartoon as T1 inner join TV_Channel as T2 on T1.Channel = T2.id where T2.series_name = "Sky Radio"	tvshow
select T1.Title from Cartoon as T1 inner join TV_Channel as T2 on T1.Channel = T2.id where T2.series_name = "Sky Radio"	tvshow
select Episode from TV_series order by Rating	tvshow
select Episode from TV_series order by Rating	tvshow
ite select Episode, Rating from TV_series order by Rating desc limit 3	tvshow
select Episode, Rating from TV_series order by Rating desc limit 3	tvshow
select min(Share), max(Share) from TV_series	tvshow
select max(Share), min(Share) from TV_series	tvshow
select Air_Date from TV_series where Episode = "A Love of a Lifetime"	tvshow
select Air_Date from TV_series where Episode = "A Love of a Lifetime"	tvshow
select Weekly_Rank from TV_series where Episode = "A Love of a Lifetime"	tvshow
select Weekly_Rank from TV_series where Episode = "A Love of a Lifetime"	tvshow
select T1.series_name from TV_Channel as T1 join TV_series as T2 on T1.id = T2.Channel where T2.Episode = "A Love of a Lifetime"	tvshow
select T1.series_name from TV_Channel as T1 inner join TV_series as T2 on T1.id = T2.Channel where T2.Episode = "A Love of a Lifetime"	tvshow
select T1.Episode from TV_series as T1 inner join TV_Channel as T2 on T1.Channel = T2.id where T2.series_name = "Sky Radio"	tvshow
select T1.Episode from TV_series as T1 inner join TV_Channel as T2 on T1.Channel = T2.id where T2.series_name = "Sky Radio"	tvshow
select Directed_by, count(id) from Cartoon group by Directed_by	tvshow
select Directed_by, count(Title) from Cartoon group by Directed_by	tvshow
select Production_code, Channel from Cartoon order by Original_air_date desc limit 1	tvshow
select Production_code, Channel from Cartoon order by Original_air_date desc limit 1	tvshow
select Package_Option, series_name from TV_Channel where Hight_definition_TV = "Yes"	tvshow
select Package_Option, series_name from TV_Channel where Hight_definition_TV = "Yes"	tvshow
select distinct T1.Country from TV_Channel as T1 join Cartoon as T2 on T1.id = T2.Channel where T2.Written_by = "Todd Casey"	tvshow
select distinct T1.Country from TV_Channel as T1 join Cartoon as T2 on T1.id = T2.Channel where T2.Written_by = "Todd Casey"	tvshow
select Country from TV_Channel except select T1.Country from TV_Channel as T1 join Cartoon as T2 on T1.id = T2.Channel where T2.Written_by = "Todd Casey"	tvshow
select distinct Country from TV_Channel where id not in (select Channel from Cartoon where Written_by = "Todd Casey")	tvshow
select T1.series_name, T1.Country from TV_Channel as T1 join Cartoon as T2 on T1.id = T2.Channel where T2.Directed_by = "Ben Jones" or T2.Directed_by = "Michael Chang"	tvshow
select T1.series_name, T1.Country from TV_Channel as T1 join Cartoon as T2 on T1.id = T2.Channel where T2.Directed_by in ("Ben Jones", "Michael Chang") group by T1.id having count(distinct T2.Directed_by) = 2	tvshow
select Pixel_aspect_ratio_PAR, Country from TV_Channel where Language != "English"	tvshow
select Pixel_aspect_ratio_PAR, Country from TV_Channel where Language != "English"	tvshow
select id from TV_Channel where Country in ( select Country from TV_Channel group by Country having count(id) > 2 )	tvshow
select id from TV_Channel group by id having count(id) > 2	tvshow
select id from TV_Channel except select Channel from Cartoon where Directed_by = "Ben Jones"	tvshow
select id from TV_Channel except select Channel from Cartoon where Directed_by = "Ben Jones"	tvshow
select Package_Option from TV_Channel where id not in ( select Channel from Cartoon where Directed_by = "Ben Jones" )	tvshow
select Package_Option from TV_Channel where id not in ( select Channel from Cartoon where Directed_by = "Ben Jones" )	tvshow
select count(*) from Highschooler	network_1
select count(*) from Highschooler	network_1
select name, grade from Highschooler	network_1
select name, grade from Highschooler	network_1
select grade from Highschooler	network_1
select name, grade from Highschooler	network_1
select grade from Highschooler where name = "Kyle"	network_1
select grade from Highschooler where name = "Kyle"	network_1
select name from Highschooler where grade = 10	network_1
select name from Highschooler where grade = 10	network_1
select ID from Highschooler where name = "Kyle"	network_1
select ID from Highschooler where name = "Kyle"	network_1
select count(ID) from Highschooler where grade = 9 or grade = 10	network_1
select count(ID) from Highschooler where grade = 9 or grade = 10	network_1
select grade, count(ID) from Highschooler group by grade	network_1
select grade, count(ID) from Highschooler group by grade	network_1
select grade from Highschooler group by grade order by count(ID) desc limit 1	network_1
select grade from Highschooler group by grade order by count(ID) desc limit 1	network_1
select grade from Highschooler group by grade having count(ID) >= 4	network_1
select grade from Highschooler group by grade having count(*) >= 4	network_1
select student_id, count(friend_id) from Friend group by student_id	network_1
select student_id, count(friend_id) from Friend group by student_id	network_1
select T1.name, count(T2.friend_id) from Highschooler as T1 left join Friend as T2 on T1.ID = T2.student_id group by T1.ID, T1.name	network_1
select T1.name, count(T2.friend_id) from Highschooler as T1 left join Friend as T2 on T1.ID = T2.student_id group by T1.ID, T1.name	network_1
select T1.name from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id group by T1.ID order by count(T2.friend_id) desc limit 1	network_1
select T1.name from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id group by T1.ID order by count(T2.friend_id) desc limit 1	network_1
select T1.name from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id group by T1.ID having count(T2.friend_id) >= 3	network_1
select T1.name from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id group by T1.ID having count(T2.friend_id) >= 3	network_1
select T2.name from Friend as T1 join Highschooler as T2 on T1.friend_id = T2.ID join Highschooler as T3 on T1.student_id = T3.ID where T3.name = "Kyle"	network_1
select T2.name from Friend as T1 join Highschooler as T2 on T1.friend_id = T2.ID join Highschooler as T3 on T1.student_id = T3.ID where T3.name = "Kyle"	network_1
select count(T1.friend_id) from Friend as T1 inner join Highschooler as T2 on T1.student_id = T2.ID where T2.name = "Kyle"	network_1
select count(T1.friend_id) from Friend as T1 inner join Highschooler as T2 on T1.student_id = T2.ID where T2.name = "Kyle"	network_1
select ID from Highschooler except select student_id from Friend	network_1
select ID from Highschooler except select student_id from Friend	network_1
select name from Highschooler where ID not in (select student_id from Friend)	network_1
select T1.name from Highschooler as T1 where T1.ID not in ( select student_id from Friend union select friend_id from Friend )	network_1
select student_id from Friend intersect select liked_id from Likes	network_1
select T1.student_id from Friend as T1 intersect select T2.liked_id from Likes as T2	network_1
select distinct T1.name from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id join Likes as T3 on T1.ID = T3.liked_id	network_1
select distinct T1.name from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id join Likes as T3 on T1.ID = T3.liked_id	network_1
select student_id, count(*) from Likes group by student_id	network_1
select student_id, count(*) from Likes group by student_id	network_1
select T1.name, count(T2.liked_id) from Highschooler as T1 join Likes as T2 on T1.ID = T2.liked_id group by T1.ID	network_1
select T1.name, count(T2.liked_id) from Highschooler as T1 join Likes as T2 on T1.ID = T2.liked_id group by T1.ID	network_1
ite select T1.name from Highschooler as T1 join Likes as T2 on T1.ID = T2.liked_id group by T1.ID order by count(T2.student_id) desc limit 1	network_1
select T1.name from Highschooler as T1 inner join Likes as T2 on T1.ID = T2.liked_id group by T1.ID order by count(T2.liked_id) desc limit 1	network_1
select T1.name from Highschooler as T1 join Likes as T2 on T1.ID = T2.liked_id group by T1.ID having count(T2.student_id) >= 2	network_1
select T1.name from Highschooler as T1 join Likes as T2 on T1.ID = T2.liked_id group by T1.ID having count(T2.student_id) >= 2	network_1
select T1.name from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id where T1.grade > 5 group by T1.ID having count(T2.friend_id) >= 2	network_1
select T1.name from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id where T1.grade > 5 group by T1.ID having count(T2.friend_id) >= 2	network_1
select count(T1.liked_id) from Likes as T1 join Highschooler as T2 on T1.student_id = T2.ID where T2.name = "Kyle"	network_1
select count(T1.student_id) from Likes as T1 inner join Highschooler as T2 on T1.student_id = T2.ID where T2.name = "Kyle"	network_1
select avg(T1.grade) from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id	network_1
select avg(T1.grade) from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id	network_1
select min(T1.grade) from Highschooler as T1 where T1.ID not in ( select student_id from Friend )	network_1
select min(T1.grade) from Highschooler as T1 where T1.ID not in ( select student_id from Friend )	network_1
select count(*) from singer	concert_singer
select count(*) from singer	concert_singer
select Name, Country, Age from singer order by Age desc	concert_singer
select Name, Country, Age from singer order by Age desc	concert_singer
select avg(Age), min(Age), max(Age) from singer where Country = "France"	concert_singer
select avg(Age), min(Age), max(Age) from singer where Country = "France"	concert_singer
select Song_Name, Song_release_year from singer order by Age asc limit 1	concert_singer
select Song_Name, Song_release_year from singer where Age = (select min(Age) from singer)	concert_singer
select distinct Country from singer where Age > 20	concert_singer
select distinct Country from singer where Age > 20	concert_singer
select Country, count(*) from singer group by Country	concert_singer
select Country, count(*) from singer group by Country	concert_singer
select Song_Name from singer where Age > (select avg(Age) from singer)	concert_singer
select Song_Name from singer where Age > (select avg(Age) from singer)	concert_singer
select Location, Name from stadium where Capacity between 5000 and 10000	concert_singer
select Location, Name from stadium where Capacity between 5000 and 10000	concert_singer
select max(Capacity), avg(Capacity) from stadium	concert_singer
select avg(Capacity), max(Capacity) from stadium	concert_singer
select Name, Capacity from stadium order by Average desc limit 1	concert_singer
select Name, Capacity from stadium order by Average desc limit 1	concert_singer
select count(*) from concert where Year = "2014" or Year = "2015"	concert_singer
select count(*) from concert where Year = "2014" or Year = "2015"	concert_singer
select T1.Name, count(T2.concert_ID) from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID group by T1.Name	concert_singer
select T1.Name, count(T2.concert_ID) from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID group by T1.Stadium_ID	concert_singer
select T1.Name, T1.Capacity from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year >= 2014 group by T1.Stadium_ID order by count(T2.concert_ID) desc limit 1	concert_singer
select T1.Name, T1.Capacity from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year > "2013" group by T1.Stadium_ID order by count(T2.concert_ID) desc limit 1	concert_singer
select Year from concert group by Year order by count(concert_ID) desc limit 1	concert_singer
select Year from concert group by Year order by count(*) desc limit 1	concert_singer
select Name from stadium except select T1.Name from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID	concert_singer
select Name from stadium except select T1.Name from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID	concert_singer
select T1.Country from singer as T1 where T1.Age > 40 intersect select T2.Country from singer as T2 where T2.Age < 30	concert_singer
select Name from stadium except select T1.Name from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year = "2014"	concert_singer
select Name from stadium except select T1.Name from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year = "2014"	concert_singer
select T1.concert_Name, T1.Theme, count(T2.Singer_ID) from concert as T1 join singer_in_concert as T2 on T1.concert_ID = T2.concert_ID group by T1.concert_ID	concert_singer
select T1.concert_Name, T1.Theme, count(T2.Singer_ID) from concert as T1 join singer_in_concert as T2 on T1.concert_ID = T2.concert_ID group by T1.concert_ID	concert_singer
select T1.Name, count(T2.concert_ID) from singer as T1 join singer_in_concert as T2 on T1.Singer_ID = T2.Singer_ID group by T1.Name	concert_singer
select T1.Name, count(T2.concert_ID) from singer as T1 join singer_in_concert as T2 on T1.Singer_ID = T2.Singer_ID group by T1.Name	concert_singer
select distinct T1.Name from singer as T1 inner join singer_in_concert as T2 on T1.Singer_ID = T2.Singer_ID inner join concert as T3 on T2.concert_ID = T3.concert_ID where T3.Year = "2014"	concert_singer
select T1.Name from singer as T1 inner join singer_in_concert as T2 on T1.Singer_ID = T2.Singer_ID inner join concert as T3 on T2.concert_ID = T3.concert_ID where T3.Year = "2014"	concert_singer
select Name, Country from singer where Song_Name like "%Hey%"	concert_singer
select Name, Country from singer where Song_Name like "%Hey%"	concert_singer
select T1.Name, T1.Location from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year in ("2014", "2015") group by T1.Stadium_ID having count(distinct T2.Year) = 2	concert_singer
select T1.Name, T1.Location from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year = "2014" intersect select T1.Name, T1.Location from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year = "2015"	concert_singer
select count(*) from concert where Stadium_ID = (select Stadium_ID from stadium order by Capacity desc limit 1)	concert_singer
select count(*) from concert where Stadium_ID = (select Stadium_ID from stadium order by Capacity desc limit 1)	concert_singer
select count(*) from Pets where weight > 10	pets_1
select count(*) from Pets where weight > 10	pets_1
select weight from Pets where PetType = "dog" order by pet_age asc limit 1	pets_1
select weight from Pets where PetType = "Dog" order by pet_age asc limit 1	pets_1
select max(weight), PetType from Pets group by PetType	pets_1
select PetType, max(weight) from Pets group by PetType	pets_1
select count(T1.PetID) from Has_Pet as T1 inner join Student as T2 on T1.StuID = T2.StuID where T2.Age > 20	pets_1
select count(T2.PetID) from Student as T1 inner join Has_Pet as T2 on T1.StuID = T2.StuID where T1.Age > 20	pets_1
select count(T1.PetID) from Pets as T1 inner join Has_Pet as T2 on T1.PetID = T2.PetID inner join Student as T3 on T2.StuID = T3.StuID where T1.PetType = "dog" and T3.Sex = "F"	pets_1
select count(T1.PetID) from Pets as T1 inner join Has_Pet as T2 on T1.PetID = T2.PetID inner join Student as T3 on T2.StuID = T3.StuID where T1.PetType = "dog" and T3.Sex = "F"	pets_1
select count(distinct PetType) from Pets	pets_1
select count(distinct PetType) from Pets	pets_1
select distinct T1.Fname from Student as T1 inner join Has_Pet as T2 on T1.StuID = T2.StuID inner join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "cat" or T3.PetType = "dog"	pets_1
select T1.Fname from Student as T1 inner join Has_Pet as T2 on T1.StuID = T2.StuID inner join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "cat" or T3.PetType = "dog"	pets_1
select T1.Fname from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID join Pets as T3 on T2.PetID = T3.PetID where T3.PetType in ("cat", "dog") group by T1.StuID having count(distinct T3.PetType) = 2	pets_1
select T1.Fname from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "cat" intersect select T1.Fname from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "dog"	pets_1
select Major, Age from Student where StuID not in ( select T1.StuID from Has_Pet as T1 inner join Pets as T2 on T1.PetID = T2.PetID where T2.PetType = "cat" )	pets_1
select Major, Age from Student where StuID not in ( select T1.StuID from Has_Pet as T1 inner join Pets as T2 on T1.PetID = T2.PetID where T2.PetType = "cat" )	pets_1
select StuID from Student except select T1.StuID from Has_Pet as T1 inner join Pets as T2 on T1.PetID = T2.PetID where T2.PetType = "cat"	pets_1
select StuID from Student except select T1.StuID from Has_Pet as T1 inner join Pets as T2 on T1.PetID = T2.PetID where T2.PetType = "cat"	pets_1
select T1.Fname, T1.Age from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "dog" and T1.StuID not in ( select T1.StuID from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "cat" )	pets_1
select T1.Fname from Student as T1 where T1.StuID in ( select T2.StuID from Has_Pet as T2 inner join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "Dog" ) and T1.StuID not in ( select T2.StuID from Has_Pet as T2 inner join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "Cat" )	pets_1
select PetType, weight from Pets order by pet_age asc limit 1	pets_1
select PetType, weight from Pets order by pet_age asc limit 1	pets_1
select PetID, weight from Pets where pet_age > 1	pets_1
select PetID , weight from Pets where pet_age > 1	pets_1
select PetType, avg(pet_age), max(pet_age) from Pets group by PetType	pets_1
select PetType, avg(pet_age), max(pet_age) from Pets group by PetType	pets_1
select PetType, avg(weight) from Pets group by PetType	pets_1
select PetType, avg(weight) from Pets group by PetType	pets_1
select T1.Fname, T1.Age from Student as T1 inner join Has_Pet as T2 on T1.StuID = T2.StuID	pets_1
select distinct T1.Fname, T1.Age from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID	pets_1
select T1.PetID from Has_Pet as T1 inner join Student as T2 on T1.StuID = T2.StuID where T2.LName = "Smith"	pets_1
select T1.PetID from Has_Pet as T1 inner join Student as T2 on T1.StuID = T2.StuID where T2.LName = "Smith"	pets_1
select T1.StuID, count(T2.PetID) from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID group by T1.StuID	pets_1
select T1.StuID, count(T2.PetID) from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID group by T1.StuID	pets_1
select T1.Fname, T1.Sex from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID group by T1.StuID having count(T2.PetID) > 1	pets_1
select T1.Fname, T1.Sex from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID group by T1.StuID having count(T2.PetID) > 1	pets_1
select T1.LName from Student as T1 inner join Has_Pet as T2 on T1.StuID = T2.StuID inner join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "cat" and T3.pet_age = 3	pets_1
select T1.LName from Student as T1 inner join Has_Pet as T2 on T1.StuID = T2.StuID inner join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "cat" and T3.pet_age = 3	pets_1
select avg(Age) from Student where StuID not in ( select StuID from Has_Pet )	pets_1
select avg(Age) from Student where StuID not in (select StuID from Has_Pet)	pets_1
select count(*) from poker_player	poker_player
select count(*) from poker_player	poker_player
select Earnings from poker_player order by Earnings desc	poker_player
select Earnings from poker_player order by Earnings desc	poker_player
select Final_Table_Made, Best_Finish from poker_player	poker_player
select Final_Table_Made, Best_Finish from poker_player	poker_player
select avg(Earnings) from poker_player	poker_player
select avg(Earnings) from poker_player	poker_player
select Money_Rank from poker_player order by Earnings desc limit 1	poker_player
select Money_Rank from poker_player order by Earnings desc limit 1	poker_player
select max(Final_Table_Made) from poker_player where Earnings < 200000	poker_player
select max(Final_Table_Made) from poker_player where Earnings < 200000	poker_player
select T1.Name from people as T1 join poker_player as T2 on T1.People_ID = T2.People_ID	poker_player
select T1.Name from people as T1 join poker_player as T2 on T1.People_ID = T2.People_ID	poker_player
select T1.Name from people as T1 join poker_player as T2 on T1.People_ID = T2.People_ID where T2.Earnings > 300000	poker_player
select T1.Name from people as T1 inner join poker_player as T2 on T1.People_ID = T2.People_ID where T2.Earnings > 300000	poker_player
select T1.Name from people as T1 join poker_player as T2 on T1.People_ID = T2.People_ID order by T2.Final_Table_Made asc	poker_player
select T1.Name from people as T1 join poker_player as T2 on T1.People_ID = T2.People_ID order by T2.Final_Table_Made asc	poker_player
select T1.Birth_Date from people as T1 inner join poker_player as T2 on T1.People_ID = T2.People_ID order by T2.Earnings asc limit 1	poker_player
select T1.Birth_Date from people as T1 inner join poker_player as T2 on T1.People_ID = T2.People_ID order by T2.Earnings asc limit 1	poker_player
select T1.Money_Rank from poker_player as T1 inner join people as T2 on T1.People_ID = T2.People_ID order by T2.Height desc limit 1	poker_player
select T1.Money_Rank from poker_player as T1 inner join people as T2 on T1.People_ID = T2.People_ID order by T2.Height desc limit 1	poker_player
select avg(T1.Earnings) from poker_player as T1 inner join people as T2 on T1.People_ID = T2.People_ID where T2.Height > 200	poker_player
select avg(T1.Earnings) from poker_player as T1 inner join people as T2 on T1.People_ID = T2.People_ID where T2.Height > 200	poker_player
select T1.Name from people as T1 join poker_player as T2 on T1.People_ID = T2.People_ID order by T2.Earnings desc	poker_player
select T1.Name from people as T1 join poker_player as T2 on T1.People_ID = T2.People_ID order by T2.Earnings desc	poker_player
select Nationality, count(*) from people group by Nationality	poker_player
select count(*) , Nationality from people group by Nationality	poker_player
select Nationality from people group by Nationality order by count(Nationality) desc limit 1	poker_player
select Nationality from people group by Nationality order by count(Nationality) desc limit 1	poker_player
select Nationality from people group by Nationality having count(*) >= 2	poker_player
select Nationality from people group by Nationality having count(*) >= 2	poker_player
select Name, Birth_Date from people order by Name asc	poker_player
select Name, Birth_Date from people order by Name	poker_player
select Name from people where Nationality != "Russia"	poker_player
select Name from people where Nationality != "Russia"	poker_player
select Name from people except select T1.Name from people as T1 join poker_player as T2 on T1.People_ID = T2.People_ID	poker_player
select Name from people where People_ID not in ( select People_ID from poker_player )	poker_player
select count(distinct Nationality) from people	poker_player
select count(distinct Nationality) from people	poker_player
select count(*) from conductor	orchestra
select count(*) from conductor	orchestra
select Name from conductor order by Age asc	orchestra
select Name from conductor order by Age	orchestra
select Name from conductor where Nationality != "USA"	orchestra
select Name from conductor where Nationality != "USA"	orchestra
select Record_Company from orchestra order by Year_of_Founded desc	orchestra
select Record_Company from orchestra order by Year_of_Founded desc	orchestra
select avg(Attendance) from show	orchestra
select avg(Attendance) from show	orchestra
select max(Share), min(Share) from performance where Type != "Live final"	orchestra
select max(Share), min(Share) from performance where Type != "Live final"	orchestra
select count(distinct Nationality) from conductor	orchestra
select count(distinct Nationality) from conductor	orchestra
select Name from conductor order by Year_of_Work desc	orchestra
select Name from conductor order by Year_of_Work desc	orchestra
select Name from conductor order by Year_of_Work desc limit 1	orchestra
select Name from conductor order by Year_of_Work desc limit 1	orchestra
select T1.Name, T2.Orchestra from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID	orchestra
select T1.Name, T2.Orchestra from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID	orchestra
select T1.Name from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID group by T1.Conductor_ID having count(T2.Orchestra_ID) > 1	orchestra
select T1.Name from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID group by T1.Conductor_ID having count(T2.Orchestra_ID) > 1	orchestra
select T1.Name from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID group by T1.Conductor_ID order by count(T2.Orchestra_ID) desc limit 1	orchestra
select T1.Name from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID group by T1.Conductor_ID order by count(T2.Orchestra_ID) desc limit 1	orchestra
select T1.Name from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID where T2.Year_of_Founded > 2008	orchestra
select T1.Name from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID where T2.Year_of_Founded > 2008	orchestra
select Record_Company, count(Orchestra_ID) from orchestra group by Record_Company	orchestra
select Record_Company, count(Orchestra_ID) from orchestra group by Record_Company	orchestra
select Major_Record_Format from orchestra group by Major_Record_Format order by count(Major_Record_Format) asc	orchestra
select Major_Record_Format from orchestra group by Major_Record_Format order by count(*) desc	orchestra
select Record_Company from orchestra group by Record_Company order by count(Orchestra_ID) desc limit 1	orchestra
select Record_Company from orchestra group by Record_Company order by count(Orchestra_ID) desc limit 1	orchestra
select Orchestra from orchestra except select T1.Orchestra from orchestra as T1 join performance as T2 on T1.Orchestra_ID = T2.Orchestra_ID	orchestra
select Orchestra from orchestra except select T1.Orchestra from orchestra as T1 join performance as T2 on T1.Orchestra_ID = T2.Orchestra_ID	orchestra
select Record_Company from orchestra where Year_of_Founded < 2003 intersect select Record_Company from orchestra where Year_of_Founded > 2003	orchestra
select Record_Company from orchestra where Year_of_Founded < 2003 intersect select Record_Company from orchestra where Year_of_Founded > 2003	orchestra
select count(*) from orchestra where Major_Record_Format = "CD" or Major_Record_Format = "DVD"	orchestra
select count(*) from orchestra where Major_Record_Format = "CD" or Major_Record_Format = "DVD"	orchestra
select T1.Year_of_Founded from orchestra as T1 join performance as T2 on T1.Orchestra_ID = T2.Orchestra_ID group by T1.Orchestra_ID having count(T2.Performance_ID) > 1	orchestra
select T1.Year_of_Founded from orchestra as T1 join performance as T2 on T1.Orchestra_ID = T2.Orchestra_ID group by T1.Orchestra_ID having count(T2.Performance_ID) > 1	orchestra
select count(*) from employee	employee_hire_evaluation
select count(*) from employee	employee_hire_evaluation
select Name from employee order by Age asc	employee_hire_evaluation
select Name from employee order by Age asc	employee_hire_evaluation
select count(*) , City from employee group by City	employee_hire_evaluation
select count(*) , City from employee group by City	employee_hire_evaluation
select City from employee where Age < 30 group by City having count(Employee_ID) > 1	employee_hire_evaluation
select City from employee where Age < 30 group by City having count(Employee_ID) > 1	employee_hire_evaluation
select count(*) , Location from shop group by Location	employee_hire_evaluation
select count(*) , Location from shop group by Location	employee_hire_evaluation
select Manager_name , District from shop order by Number_products desc limit 1	employee_hire_evaluation
select Manager_name , District from shop order by Number_products desc limit 1	employee_hire_evaluation
select min(Number_products), max(Number_products) from shop	employee_hire_evaluation
select min(Number_products), max(Number_products) from shop	employee_hire_evaluation
select Name, Location, District from shop order by Number_products desc	employee_hire_evaluation
select Name, Location, District from shop order by Number_products desc	employee_hire_evaluation
select Name from shop where Number_products > (select avg(Number_products) from shop)	employee_hire_evaluation
select Name from shop where Number_products > (select avg(Number_products) from shop)	employee_hire_evaluation
select T1.Name from employee as T1 join evaluation as T2 on T1.Employee_ID = T2.Employee_ID group by T1.Employee_ID order by count(T2.Employee_ID) desc limit 1	employee_hire_evaluation
select T1.Name from employee as T1 join evaluation as T2 on T1.Employee_ID = T2.Employee_ID group by T1.Employee_ID order by count(T2.Year_awarded) desc limit 1	employee_hire_evaluation
select T1.Name from employee as T1 inner join evaluation as T2 on T1.Employee_ID = T2.Employee_ID order by T2.Bonus desc limit 1	employee_hire_evaluation
select T1.Name from employee as T1 inner join evaluation as T2 on T1.Employee_ID = T2.Employee_ID order by T2.Bonus desc limit 1	employee_hire_evaluation
select Name from employee where Employee_ID not in ( select Employee_ID from evaluation )	employee_hire_evaluation
select Name from employee where Employee_ID not in (select Employee_ID from evaluation)	employee_hire_evaluation
select T1.Name from shop as T1 join hiring as T2 on T1.Shop_ID = T2.Shop_ID group by T1.Shop_ID order by count(T2.Employee_ID) desc limit 1	employee_hire_evaluation
select T1.Name from shop as T1 join hiring as T2 on T1.Shop_ID = T2.Shop_ID group by T1.Shop_ID order by count(T2.Employee_ID) desc limit 1	employee_hire_evaluation
select Name from shop except select T1.Name from shop as T1 join hiring as T2 on T1.Shop_ID = T2.Shop_ID	employee_hire_evaluation
select T1.Name from shop as T1 left join hiring as T2 on T1.Shop_ID = T2.Shop_ID where T2.Shop_ID is null	employee_hire_evaluation
select T1.Name, count(T2.Employee_ID) from shop as T1 join hiring as T2 on T1.Shop_ID = T2.Shop_ID group by T1.Shop_ID	employee_hire_evaluation
select T1.Name, count(T2.Employee_ID) from shop as T1 join hiring as T2 on T1.Shop_ID = T2.Shop_ID group by T1.Shop_ID	employee_hire_evaluation
select sum(Bonus) from evaluation	employee_hire_evaluation
select sum(Bonus) from evaluation	employee_hire_evaluation
select * from hiring	employee_hire_evaluation
select * from hiring	employee_hire_evaluation
select District from shop where Number_products < 3000 intersect select District from shop where Number_products > 10000	employee_hire_evaluation
select T1.District from shop as T1 where T1.Number_products < 3000 intersect select T1.District from shop as T1 where T1.Number_products > 10000	employee_hire_evaluation
select count(distinct Location) from shop	employee_hire_evaluation
select count(distinct Location) from shop	employee_hire_evaluation
select count(*) from singer	singer
select count(*) from singer	singer
select Name from singer order by Net_Worth_Millions asc	singer
select Name from singer order by Net_Worth_Millions asc	singer
select Birth_Year, Citizenship from singer	singer
select Birth_Year, Citizenship from singer	singer
select Name from singer where Citizenship != "France"	singer
select Name from singer where Citizenship != "French"	singer
select Name from singer where Birth_Year in (1948, 1949)	singer
select Name from singer where Birth_Year in (1948, 1949)	singer
select Name from singer order by Net_Worth_Millions desc limit 1	singer
select Name from singer order by Net_Worth_Millions desc limit 1	singer
select Citizenship, count(Singer_ID) from singer group by Citizenship	singer
select count(*) , Citizenship from singer group by Citizenship	singer
select Citizenship from singer group by Citizenship order by count(*) desc limit 1	singer
select Citizenship from singer group by Citizenship order by count(*) desc limit 1	singer
select Citizenship, max(Net_Worth_Millions) from singer group by Citizenship	singer
select Citizenship, max(Net_Worth_Millions) from singer group by Citizenship	singer
select T1.Title, T2.Name from song as T1 join singer as T2 on T1.Singer_ID = T2.Singer_ID	singer
select T1.Title, T2.Name from song as T1 join singer as T2 on T1.Singer_ID = T2.Singer_ID	singer
select distinct T1.Name from singer as T1 join song as T2 on T1.Singer_ID = T2.Singer_ID where T2.Sales > 300000	singer
select distinct T1.Name from singer as T1 join song as T2 on T1.Singer_ID = T2.Singer_ID where T2.Sales > 300000	singer
select T1.Name from singer as T1 join song as T2 on T1.Singer_ID = T2.Singer_ID group by T1.Singer_ID having count(T2.Song_ID) > 1	singer
select T1.Name from singer as T1 join song as T2 on T1.Singer_ID = T2.Singer_ID group by T1.Singer_ID having count(T2.Song_ID) > 1	singer
select T1.Name, sum(T2.Sales) from singer as T1 join song as T2 on T1.Singer_ID = T2.Singer_ID group by T1.Name	singer
select T1.Name, sum(T2.Sales) from singer as T1 join song as T2 on T1.Singer_ID = T2.Singer_ID group by T1.Name	singer
select T1.Name from singer as T1 left join song as T2 on T1.Singer_ID = T2.Singer_ID where T2.Song_ID is null	singer
select Name from singer where Singer_ID not in ( select Singer_ID from song )	singer
select Citizenship from singer where Birth_Year < 1945 intersect select Citizenship from singer where Birth_Year > 1955	singer
select Citizenship from singer where Birth_Year < 1945 intersect select Citizenship from singer where Birth_Year > 1955	singer
select count(*) from teacher	course_teach
select count(*) from teacher	course_teach
select Name from teacher order by Age asc	course_teach
select Name from teacher order by Age asc	course_teach
select Age, Hometown from teacher	course_teach
select Age, Hometown from teacher	course_teach
select Name from teacher where Hometown != "Little Lever Urban District"	course_teach
select Name from teacher where Hometown != "Little Lever Urban District"	course_teach
select Name from teacher where Age = "32" or Age = "33"	course_teach
select Name from teacher where Age = "32" or Age = "33"	course_teach
select Hometown from teacher order by Age limit 1	course_teach
select Hometown from teacher order by Age limit 1	course_teach
select Hometown, count(*) from teacher group by Hometown	course_teach
select count(*) , Hometown from teacher group by Hometown	course_teach
select Hometown from teacher group by Hometown order by count(Hometown) desc limit 1	course_teach
select Hometown from teacher group by Hometown order by count(*) desc limit 1	course_teach
select Hometown from teacher group by Hometown having count(*) >= 2	course_teach
select Hometown from teacher group by Hometown having count(*) >= 2	course_teach
select T1.Name, T3.Course from teacher as T1 join course_arrange as T2 on T1.Teacher_ID = T2.Teacher_ID join course as T3 on T2.Course_ID = T3.Course_ID	course_teach
select T1.Name, T3.Course from teacher as T1 join course_arrange as T2 on T1.Teacher_ID = T2.Teacher_ID join course as T3 on T2.Course_ID = T3.Course_ID	course_teach
select T1.Name, T3.Course from teacher as T1 join course_arrange as T2 on T1.Teacher_ID = T2.Teacher_ID join course as T3 on T2.Course_ID = T3.Course_ID order by T1.Name asc	course_teach
select T2.Name, T3.Course from course_arrange as T1 join teacher as T2 on T1.Teacher_ID = T2.Teacher_ID join course as T3 on T1.Course_ID = T3.Course_ID order by T2.Name asc	course_teach
select T2.Name from course as T1 join course_arrange as T3 on T1.Course_ID = T3.Course_ID join teacher as T2 on T3.Teacher_ID = T2.Teacher_ID where T1.Course = "math"	course_teach
select T2.Name from course as T1 join course_arrange as T3 on T1.Course_ID = T3.Course_ID join teacher as T2 on T3.Teacher_ID = T2.Teacher_ID where T1.Course = "math"	course_teach
select T2.Name, count(T1.Course_ID) from course_arrange as T1 join teacher as T2 on T1.Teacher_ID = T2.Teacher_ID group by T2.Name	course_teach
select T2.Name, count(T1.Course_ID) from course_arrange as T1 join teacher as T2 on T1.Teacher_ID = T2.Teacher_ID group by T2.Name	course_teach
select T2.Name from course_arrange as T1 join teacher as T2 on T1.Teacher_ID = T2.Teacher_ID group by T1.Teacher_ID having count(T1.Course_ID) >= 2	course_teach
select T2.Name from course_arrange as T1 join teacher as T2 on T1.Teacher_ID = T2.Teacher_ID group by T1.Teacher_ID having count(T1.Course_ID) >= 2	course_teach
select Name from teacher where Teacher_ID not in (select Teacher_ID from course_arrange)	course_teach
select Name from teacher where Teacher_ID not in ( select Teacher_ID from course_arrange )	course_teach
select count(*) from visitor where Age < 30	museum_visit
select Name from visitor where Level_of_membership > 4 order by Level_of_membership desc	museum_visit
select avg(Age) from visitor where Level_of_membership <= 4	museum_visit
select Name , Level_of_membership from visitor where Level_of_membership > 4 order by Age desc	museum_visit
select Museum_ID, Name from museum order by Num_of_Staff desc limit 1	museum_visit
select avg(Num_of_Staff) from museum where Open_Year < "2009"	museum_visit
select Open_Year, Num_of_Staff from museum where Name = "Plaza Museum"	museum_visit
select Name from museum where Num_of_Staff > (select min(Num_of_Staff) from museum where Open_Year > "2010")	museum_visit
select T1.ID, T1.Name, T1.Age from visitor as T1 where T1.ID in ( select T2.visitor_ID from visit as T2 group by T2.visitor_ID, T2.Museum_ID having count(*) > 1 )	museum_visit
select T1.ID, T1.Name, T1.Level_of_membership from visitor as T1 inner join visit as T2 on T1.ID = T2.visitor_ID group by T1.ID having sum(T2.Total_spent) = ( select max(TotalSpent) from ( select sum(Total_spent) from visit group by visitor_ID ) )	museum_visit
select T1.Museum_ID, T1.Name from museum as T1 join visit as T2 on T1.Museum_ID = T2.Museum_ID group by T1.Museum_ID order by count(T2.Museum_ID) desc limit 1	museum_visit
select Name from museum except select T1.Name from museum as T1 join visit as T2 on T1.Museum_ID = T2.Museum_ID	museum_visit
select T1.Name, T1.Age from visitor as T1 inner join visit as T2 on T1.ID = T2.visitor_ID order by T2.Num_of_Ticket desc limit 1	museum_visit
select avg(Num_of_Ticket), max(Num_of_Ticket) from visit	museum_visit
select sum(T1.Total_spent) from visit as T1 inner join visitor as T2 on T1.visitor_ID = T2.ID where T2.Level_of_membership = 1	museum_visit
select T3.Name from visitor as T3 where T3.ID in ( select T1.visitor_ID from visit as T1 inner join museum as T2 on T1.Museum_ID = T2.Museum_ID where T2.Open_Year < "2009" intersect select T1.visitor_ID from visit as T1 inner join museum as T2 on T1.Museum_ID = T2.Museum_ID where T2.Open_Year > "2011" )	museum_visit
select count(ID) from visitor where ID not in ( select T1.visitor_ID from visit as T1 join museum as T2 on T1.Museum_ID = T2.Museum_ID where T2.Open_Year > "2010" )	museum_visit
select count(*) from museum where Open_Year > "2013" or Open_Year < "2008"	museum_visit
select count(*) from ship where disposition_of_ship = "Captured"	battle_death
select name, tonnage from ship order by name desc	battle_death
select name, date, result from battle	battle_death
select max(Killed), min(Killed) from death	battle_death
select avg(Injured) from death	battle_death
select T1.killed, T1.injured from death as T1 inner join ship as T2 on T1.caused_by_ship_id = T2.id where T2.tonnage = "t"	battle_death
select name, result from battle where bulgarian_commander != "Boril"	battle_death
select distinct T1.id, T1.name from battle as T1 inner join ship as T2 on T1.id = T2.lost_in_battle where T2.ship_type = "Brig"	battle_death
select T1.id, T1.name from battle as T1 join ship as T2 on T1.id = T2.lost_in_battle join death as T3 on T2.id = T3.caused_by_ship_id group by T1.id having sum(T3.killed) > 10	battle_death
select T1.id, T1.name from ship as T1 join death as T2 on T1.id = T2.caused_by_ship_id group by T1.id order by sum(T2.injured) desc limit 1	battle_death
select distinct name from battle where bulgarian_commander = "Kaloyan" and latin_commander = "Baldwin I"	battle_death
select count(distinct result) from battle	battle_death
select count(id) from battle where id not in ( select lost_in_battle from ship where tonnage = "225" )	battle_death
select T1.name, T1.date from battle as T1 inner join ship as T2 on T1.id = T2.lost_in_battle inner join ship as T3 on T1.id = T3.lost_in_battle where T2.name = "Lettice" and T3.name = "HMS Atalanta"	battle_death
select name, result, bulgarian_commander from battle where id not in ( select lost_in_battle from ship where location = "English Channel" )	battle_death
select note from death where note like "%East%"	battle_death
select count(state) from AREA_CODE_STATE	voter_1
select contestant_number, contestant_name from CONTESTANTS order by contestant_name desc	voter_1
select vote_id, phone_number, state from VOTES	voter_1
select max(area_code), min(area_code) from AREA_CODE_STATE	voter_1
select max(created) from VOTES where state = "CA"	voter_1
select contestant_name from CONTESTANTS where contestant_name != "Jessie Alloway"	voter_1
select distinct state, created from VOTES	voter_1
select T1.contestant_number, T1.contestant_name from CONTESTANTS as T1 join VOTES as T2 on T1.contestant_number = T2.contestant_number group by T1.contestant_number having count(T2.vote_id) >= 2	voter_1
select T1.contestant_number, T1.contestant_name from CONTESTANTS as T1 join VOTES as T2 on T1.contestant_number = T2.contestant_number group by T1.contestant_number order by count(T2.vote_id) asc limit 1	voter_1
select count(*) from VOTES where state = "NY" or state = "CA"	voter_1
select count(*) from CONTESTANTS except select T1.contestant_number from CONTESTANTS as T1 join VOTES as T2 on T1.contestant_number = T2.contestant_number	voter_1
select T1.area_code from AREA_CODE_STATE as T1 join VOTES as T2 on T1.state = T2.state group by T1.area_code order by count(T2.vote_id) desc limit 1	voter_1
select T1.created, T1.state, T1.phone_number from VOTES as T1 inner join CONTESTANTS as T2 on T1.contestant_number = T2.contestant_number where T2.contestant_name = "Tabatha Gehling"	voter_1
select distinct T3.area_code from VOTES as T1 inner join CONTESTANTS as T2 on T1.contestant_number = T2.contestant_number inner join AREA_CODE_STATE as T3 on T1.state = T3.state where T2.contestant_name = "Tabatha Gehling" intersect select distinct T3.area_code from VOTES as T1 inner join CONTESTANTS as T2 on T1.contestant_number = T2.contestant_number inner join AREA_CODE_STATE as T3 on T1.state = T3.state where T2.contestant_name = "Kelly Clauss"	voter_1
select contestant_name from CONTESTANTS where contestant_name like "%Al%"	voter_1
select count(feature_id) from Other_Available_Features	real_estate_properties
select T1.feature_type_name from Ref_Feature_Types as T1 inner join Other_Available_Features as T2 on T1.feature_type_code = T2.feature_type_code where T2.feature_name = "AirCon"	real_estate_properties
select distinct T1.property_type_description from Ref_Property_Types as T1 join Properties as T2 on T1.property_type_code = T2.property_type_code	real_estate_properties
select T1.property_name from Properties as T1 inner join Ref_Property_Types as T2 on T1.property_type_code = T2.property_type_code where T2.property_type_description in ("House", "Apartment") and T1.room_count > 1	real_estate_properties
