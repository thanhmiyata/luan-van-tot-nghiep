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
