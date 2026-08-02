select Name from country where IndepYear > 1950	world_1
select Name from country where IndepYear > 1950	world_1
select count(*) from country where GovernmentForm = "Republic"	world_1
select count(*) from country where GovernmentForm = "Republic"	world_1
select sum(SurfaceArea) from country where Region = "Caribbean"	world_1
select sum(SurfaceArea) from country where Region = "Caribbean"	world_1
select Continent from country where Name = "Anguilla"	world_1
select Continent from country where Name = "Anguilla"	world_1
select country.Region from city join country on city.CountryCode = country.Code where city.Name = "Kabul"	world_1
select country.Region from city inner join country on city.CountryCode = country.Code where city.Name = "Kabul"	world_1
select countrylanguage.Language from country inner join countrylanguage on country.Code = countrylanguage.CountryCode where country.Name = "Aruba" order by countrylanguage.Percentage desc limit 1	world_1
select countrylanguage.Language from country join countrylanguage on country.Code = countrylanguage.CountryCode where country.Name = "Aruba"	world_1
select Population, LifeExpectancy from country where Name = "Brazil"	world_1
select Population, LifeExpectancy from country where Name = "Brazil"	world_1
select Region, Population from country where Name = "Angola"	world_1
select Region, Population from country where Name = "Angola"	world_1
select avg(LifeExpectancy) from country where Region = "Central Africa"	world_1
select avg(LifeExpectancy) from country where Region = "Central Africa"	world_1
select Name from country where Continent = "Asia" order by LifeExpectancy asc limit 1	world_1
select Name from country where Continent = "Asia" order by LifeExpectancy asc limit 1	world_1
select sum(Population), max(GNP) from country where Continent = "Asia"	world_1
select count(*), max(GNP) from country where Continent = "Asia"	world_1
select avg(LifeExpectancy) from country where Continent = "Africa" and GovernmentForm = "Republic"	world_1
select avg(LifeExpectancy) from country where Continent = "Africa" and GovernmentForm = "Republic"	world_1
select sum(SurfaceArea) from country where Continent = "Asia" or Continent = "Europe"	world_1
select sum(SurfaceArea) from country where Continent = "Asia" or Continent = "Europe"	world_1
select count(*) from city where District = "Gelderland"	world_1
select sum(Population) from city where District = "Gelderland"	world_1
select avg(GNP), sum(Population) from country where GovernmentForm = "US Territory"	world_1
select avg(GNP), sum(Population) from country where GovernmentForm = "US Territory"	world_1
select count(distinct Language) from countrylanguage	world_1
select count(distinct Language) from countrylanguage	world_1
select count(*) from (select distinct GovernmentForm from country where Continent = "Africa")	world_1
select count(distinct GovernmentForm) from country where Continent = "Africa"	world_1
select count(*) from country inner join countrylanguage on countrylanguage.CountryCode = country.Code where country.Name = "Aruba"	world_1
select count(*) from country inner join countrylanguage on country.Code = countrylanguage.CountryCode where country.Name = "Aruba"	world_1
select count(*) from country join countrylanguage on country.Code = countrylanguage.CountryCode where country.Name = "Afghanistan" and countrylanguage.IsOfficial = "T"	world_1
select count(*) from countrylanguage inner join country on countrylanguage.CountryCode = country.Code where country.Name = "Afghanistan" and countrylanguage.IsOfficial = "T"	world_1
select country.Name from country join countrylanguage on country.Code = countrylanguage.CountryCode group by country.Code, country.Name order by count(countrylanguage.Language) desc limit 1	world_1
select country.Name from country join countrylanguage on country.Code = countrylanguage.CountryCode group by country.Code, country.Name order by count(countrylanguage.Language) desc limit 1	world_1
select country.Continent from country join countrylanguage on country.Code = countrylanguage.CountryCode group by country.Continent order by count(distinct countrylanguage.Language) desc limit 1	world_1
select c.Continent from country c join countrylanguage cl on c.Code = cl.CountryCode group by c.Continent order by count(*) desc limit 1	world_1
select count(*) from (select CountryCode from countrylanguage where Language = "English" intersect select CountryCode from countrylanguage where Language = "Dutch")	world_1
select count(*) from (select CountryCode from countrylanguage where Language = "English" intersect select CountryCode from countrylanguage where Language = "Dutch")	world_1
select country.Name from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "English" intersect select country.Name from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "French"	world_1
select Name from country where Code in (select CountryCode from countrylanguage where Language = "English" intersect select CountryCode from countrylanguage where Language = "French")	world_1
select distinct c.Name from country c join countrylanguage cl1 on c.Code = cl1.CountryCode join countrylanguage cl2 on c.Code = cl2.CountryCode where cl1.Language = "English" and cl1.IsOfficial = "T" and cl2.Language = "French" and cl2.IsOfficial = "T"	world_1
select distinct country.Name from country join countrylanguage on countrylanguage.CountryCode = country.Code where countrylanguage.Language = "English" intersect select distinct country.Name from country join countrylanguage on countrylanguage.CountryCode = country.Code where countrylanguage.Language = "French"	world_1
select count(distinct country.Continent) from country join countrylanguage on countrylanguage.CountryCode = country.Code where countrylanguage.Language = "Chinese"	world_1
select count(*) from country inner join countrylanguage on countrylanguage.CountryCode = country.Code where countrylanguage.Language = "Chinese"	world_1
select distinct country.Region from country join countrylanguage on countrylanguage.CountryCode = country.Code where countrylanguage.Language = "English" or countrylanguage.Language = "Dutch"	world_1
select distinct country.Region from country join countrylanguage on countrylanguage.CountryCode = country.Code where countrylanguage.Language = "Dutch" or countrylanguage.Language = "English"	world_1
select distinct country.Name from country join countrylanguage on country.Code = countrylanguage.CountryCode where (countrylanguage.Language = "English" and countrylanguage.IsOfficial = "T") union select distinct country.Name from country join countrylanguage on country.Code = countrylanguage.CountryCode where (countrylanguage.Language = "Dutch" and countrylanguage.IsOfficial = "T")	world_1
select distinct country.Name from country join countrylanguage on country.Code = countrylanguage.CountryCode where (countrylanguage.Language = "English" and countrylanguage.IsOfficial = "T") or (countrylanguage.Language = "Dutch" and countrylanguage.IsOfficial = "T")	world_1
select countrylanguage.Language from countrylanguage join country on countrylanguage.CountryCode = country.Code where country.Continent = "Asia" order by countrylanguage.Percentage desc limit 1	world_1
select cl.Language from countrylanguage cl join country c on cl.CountryCode = c.Code where c.Continent = "Asia" group by cl.Language order by count(*) desc limit 1	world_1
select countrylanguage.Language from countrylanguage join country on countrylanguage.CountryCode = country.Code where country.GovernmentForm = "Republic" group by countrylanguage.Language having count(distinct countrylanguage.CountryCode) = 1	world_1
select Language from countrylanguage join country on countrylanguage.CountryCode = country.Code where country.GovernmentForm = "Republic" group by Language having count(countrylanguage.CountryCode) = 1	world_1
select city.Name from city join countrylanguage on city.CountryCode = countrylanguage.CountryCode where countrylanguage.Language = "English" order by city.Population desc limit 1	world_1
select city.Name from city join countrylanguage on city.CountryCode = countrylanguage.CountryCode where countrylanguage.Language = "English" order by city.Population desc limit 1	world_1
select Name, Population, LifeExpectancy from country where Continent = "Asia" order by SurfaceArea desc limit 1	world_1
select Name, Population, LifeExpectancy from country where Continent = "Asia" order by SurfaceArea desc limit 1	world_1
select avg(country.LifeExpectancy) from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language <> "English" and countrylanguage.IsOfficial = "T"	world_1
select avg(country.LifeExpectancy) as LifeExpectancy from country where not EXISTS (select 1 from countrylanguage where countrylanguage.CountryCode = country.Code and countrylanguage.Language = "English" and countrylanguage.IsOfficial = "T")	world_1
select sum(country.Population) from country where not EXISTS (select 1 from countrylanguage where country.Code = countrylanguage.CountryCode and countrylanguage.Language = "English")	world_1
select count(*) from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language <> "English"	world_1
select countrylanguage.Language from country inner join countrylanguage on country.Code = countrylanguage.CountryCode where country.HeadOfState = "Beatrix"	world_1
select countrylanguage.Language from country join countrylanguage on countrylanguage.CountryCode = country.Code where country.HeadOfState = "Beatrix" and countrylanguage.IsOfficial = "T"	world_1
select count(distinct countrylanguage.Language) as count from country inner join countrylanguage on country.Code = countrylanguage.CountryCode where country.IndepYear < 1930 and countrylanguage.IsOfficial = "T"	world_1
select count(distinct countrylanguage.Language) from country join countrylanguage on country.Code = countrylanguage.CountryCode where country.IndepYear < 1930	world_1
select country.Name from country where country.SurfaceArea > (select max(SurfaceArea) from country where Continent = "Europe")	world_1
select Name from country where SurfaceArea > (select max(SurfaceArea) from country where Continent = "Europe")	world_1
select Name from country where Continent = "Africa" and Population < (select min(Population) from country where Continent = "Asia")	world_1
select Name from country where Continent = "Africa" and Population < (select min(Population) from country where Continent = "Asia")	world_1
select Name from country where Continent = "Asia" and Population > (select max(Population) from country where Continent = "Africa")	world_1
select Name from country where Continent = "Asia" and Population > (select max(Population) from country where Continent = "Africa")	world_1
select distinct country.Code from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language <> "English"	world_1
select Code from country where not EXISTS (select 1 from countrylanguage where countrylanguage.CountryCode = country.Code and countrylanguage.Language = "English")	world_1
select country.Code from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language <> "English"	world_1
select distinct country.Code from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language <> "English"	world_1
select country.Code from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language <> "English" and country.GovernmentForm <> "Republic"	world_1
select country.Code from country join countrylanguage on countrylanguage.CountryCode = country.Code where countrylanguage.Language <> "English" and country.GovernmentForm <> "Republic"	world_1
select city.Name from city join country on city.CountryCode = country.Code join countrylanguage on country.Code = countrylanguage.CountryCode where country.Continent = "Europe" and countrylanguage.Language = "English" and countrylanguage.IsOfficial <> "T"	world_1
select city.Name from city join country on city.CountryCode = country.Code join countrylanguage on country.Code = countrylanguage.CountryCode where country.Continent = "Europe" and countrylanguage.IsOfficial = "T" and countrylanguage.Language <> "English"	world_1
select distinct city.Name from city join country on city.CountryCode = country.Code join countrylanguage on country.Code = countrylanguage.CountryCode where country.Continent = "Asia" and countrylanguage.Language = "Chinese" and countrylanguage.IsOfficial = "T"	world_1
select distinct city.Name from city inner join country on city.CountryCode = country.Code inner join countrylanguage on country.Code = countrylanguage.CountryCode where country.Continent = "Asia" and countrylanguage.Language = "Chinese" and countrylanguage.IsOfficial = "T"	world_1
select Name, IndepYear, SurfaceArea from country order by Population asc limit 1	world_1
select Name, IndepYear, SurfaceArea from country order by Population asc limit 1	world_1
select Population, Name, HeadOfState from country where SurfaceArea = (select max(SurfaceArea) from country)	world_1
select Name, Population, HeadOfState from country order by SurfaceArea desc limit 1	world_1
select country.Name, count(countrylanguage.Language) from country join countrylanguage on country.Code = countrylanguage.CountryCode group by country.Name having count(countrylanguage.Language) >= 3	world_1
select country.Name, count(*) from country join countrylanguage on country.Code = countrylanguage.CountryCode group by country.Name having count(*) > 2	world_1
select District, count(*) as count from city where Population > (select avg(Population) from city) group by District	world_1
select District, count(*) from city where Population > (select avg(Population) from city) group by District	world_1
select GovernmentForm, sum(Population) from country group by GovernmentForm having avg(LifeExpectancy) > 72	world_1
select GovernmentForm, sum(Population) from country group by GovernmentForm having avg(LifeExpectancy) > (select avg(LifeExpectancy) from country)	world_1
select avg(LifeExpectancy), sum(Population) from country where LifeExpectancy < 72 group by Continent	world_1
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
select Language from countrylanguage group by Language having count(*) = (select max(language_count) from (select count(*) as language_count from countrylanguage group by Language))	world_1
select Language from countrylanguage group by Language having count(*) = (select max(country_count) from (select Language, count(*) as country_count from countrylanguage group by Language))	world_1
select Language, CountryCode from countrylanguage where (CountryCode, Percentage) in (select CountryCode, max(Percentage) from countrylanguage group by CountryCode)	world_1
select country.Code, countrylanguage.Language from country inner join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Percentage = (select max(cl2.Percentage) from countrylanguage cl2 where cl2.CountryCode = countrylanguage.CountryCode)	world_1
select count(*) from (select CountryCode from countrylanguage where Language = "Spanish" order by Percentage desc limit 1)	world_1
select count(*) from country inner join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "Spanish"	world_1
select country.Code from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "Spanish" order by countrylanguage.Percentage desc limit 1	world_1
select country.Code from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "Spanish"	world_1
