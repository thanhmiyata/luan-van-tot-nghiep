select Name from country where IndepYear > 1950	world_1
select Name from country where IndepYear > 1950	world_1
select count(*) from country where GovernmentForm = "republic"	world_1
select count(*) from country where GovernmentForm = "republic"	world_1
select sum(SurfaceArea) from country where Region = "Caribbean"	world_1
select sum(SurfaceArea) from country where Region = "Carribean"	world_1
select Continent from country where Name = "Anguilla"	world_1
select Continent from country where Name = "Anguilla"	world_1
select country.Region from city join country on city.CountryCode = country.Code where city.Name = "Kabul"	world_1
select 1	world_1
select countrylanguage.Language from country inner join countrylanguage on country.Code = countrylanguage.CountryCode where country.Name = "Aruba" order by countrylanguage.Percentage desc limit 1	world_1
select Language from countrylanguage where CountryCode = "ABW" order by Percentage desc limit 1	world_1
select Population, LifeExpectancy from country where Name = "Brazil"	world_1
select Population, LifeExpectancy from country where Name = "Brazil"	world_1
select Region, Population from country where Name = "Angola"	world_1
select Region, Population from country where Name = "Angola"	world_1
select avg(LifeExpectancy) from country where Region = "Central Africa"	world_1
select avg(LifeExpectancy) from country where Region = "Central Africa"	world_1
select Name from country where Continent = "Asia" order by LifeExpectancy asc limit 1	world_1
select Name from country where Continent = "Asia" order by LifeExpectancy asc limit 1	world_1
select sum(Population), max(GNP) from country where Continent = "Asia"	world_1
select sum(Population) as "Population count", max(GNP) as "Largest GNP" from country where Continent = "Asia"	world_1
select avg(LifeExpectancy) as "Average Life Expectancy" from country where Continent = "Africa" and GovernmentForm = "Republic"	world_1
select avg(LifeExpectancy) from country where Continent = "Africa" and GovernmentForm = "Republic"	world_1
select sum(SurfaceArea) from country where Continent in ("Asia", "Europe")	world_1
select sum(SurfaceArea) from country where Continent in ("Asia", "Europe")	world_1
select sum(Population) from city where District = "Gelderland"	world_1
select sum(Population) from city where District = "Gelderland"	world_1
select avg(GNP), sum(Population) from country where GovernmentForm = "US territory"	world_1
select avg(GNP), sum(Population) from country where Name like "%US%"	world_1
select count(distinct Language) from countrylanguage	world_1
select count(distinct Language) from countrylanguage	world_1
select count(distinct GovernmentForm) from country where Continent = "Africa"	world_1
select count(distinct GovernmentForm) from country where Continent = "Africa"	world_1
select count(distinct T2.Language) from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode where T1.Name = "Aruba"	world_1
select count(distinct Language) from countrylanguage where CountryCode = "ABW"	world_1
select count(*) from country join countrylanguage on country.Code = countrylanguage.CountryCode where country.Name = "Afghanistan" and countrylanguage.IsOfficial = "T"	world_1
select count(distinct Language) from countrylanguage where CountryCode = "AFG" and IsOfficial = "T"	world_1
select T1.Name from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode group by T1.Code order by count(T2.Language) desc limit 1	world_1
select T1.Name from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode group by T1.Code order by count(distinct T2.Language) desc limit 1	world_1
select country.Continent from country join countrylanguage on country.Code = countrylanguage.CountryCode group by country.Continent order by count(distinct countrylanguage.Language) desc limit 1	world_1
select T1.Continent, count(T2.Language) from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode group by T1.Continent order by LanguageCount desc	world_1
select count(distinct CountryCode) from (select CountryCode from countrylanguage where Language = "English" intersect select CountryCode from countrylanguage where Language = "Dutch")	world_1
select count(distinct T1.Name) from country as T1 join (select CountryCode from countrylanguage where Language = "English" intersect select CountryCode from countrylanguage where Language = "Dutch") on T1.Code = T2.CountryCode	world_1
select Name from country where Code in (select CountryCode from countrylanguage where Language = "English") intersect select Name from country where Code in (select CountryCode from countrylanguage where Language = "French")	world_1
select Name from country where Code in (select CountryCode from countrylanguage where Language = "English") intersect select Name from country where Code in (select CountryCode from countrylanguage where Language = "French")	world_1
select Name from country where Code in (select CountryCode from countrylanguage where Language = "English" and IsOfficial = "T" intersect select CountryCode from countrylanguage where Language = "French" and IsOfficial = "T")	world_1
select Name from country where Code in (select CountryCode from countrylanguage where Language = "English" and IsOfficial = "T" intersect select CountryCode from countrylanguage where Language = "French" and IsOfficial = "T")	world_1
select count(distinct country.Continent) from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "Chinese"	world_1
select count(distinct country.Continent) from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "Chinese"	world_1
select distinct T1.Region from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language in ("English", "Dutch")	world_1
select distinct country.Region from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language in ("Dutch", "English")	world_1
select distinct T1.Name from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language in ("English", "Dutch") and T2.IsOfficial = "T"	world_1
select distinct country.Name from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language in ("English", "Dutch") and countrylanguage.IsOfficial = "true"	world_1
select countrylanguage.Language from country join countrylanguage on country.Code = countrylanguage.CountryCode where country.Continent = "Asia" group by countrylanguage.Language order by sum(countrylanguage.Percentage) desc limit 1	world_1
select T2.Language from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode where T1.Continent = "Asia" group by T2.Language order by count(distinct T1.Code) desc limit 1	world_1
select countrylanguage.Language from countrylanguage join country on countrylanguage.CountryCode = country.Code where country.GovernmentForm = "republic" group by countrylanguage.Language having count(distinct country.Code) = 1	world_1
select T1.Language from countrylanguage as T1 join country as T2 on T1.CountryCode = T2.Code where T2.GovernmentForm = "Republic" group by T1.Language having count(distinct T1.CountryCode) = 1	world_1
select city.Name from city join countrylanguage on city.CountryCode = countrylanguage.CountryCode where countrylanguage.Language = "English" order by city.Population desc limit 1	world_1
select T1.Name from city as T1 join countrylanguage as T2 on T1.CountryCode = T2.CountryCode where T2.Language = "English" order by T1.Population desc limit 1	world_1
select Name, Population, LifeExpectancy from country where Continent = "Asia" order by SurfaceArea desc limit 1	world_1
select Name, Population, LifeExpectancy from country where Continent = "Asia" order by SurfaceArea desc limit 1	world_1
select avg(country.LifeExpectancy) from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "English" and countrylanguage.IsOfficial <> "T"	world_1
select avg(country.LifeExpectancy) from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language <> "English" and countrylanguage.IsOfficial = "T"	world_1
select sum(T1.Population) from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language <> "English"	world_1
select sum(country.Population) from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language <> "English"	world_1
select T2.Language from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode where T1.HeadOfState = "Beatrix"	world_1
select countrylanguage.Language from country inner join countrylanguage on country.Code = countrylanguage.CountryCode where country.HeadOfState = "Beatrix" and countrylanguage.IsOfficial = "T"	world_1
select count(distinct cl.Language) from country c join countrylanguage cl on c.Code = cl.CountryCode where c.IndepYear < 1930 and cl.IsOfficial = "T"	world_1
select count(distinct T2.Language) from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode where T1.IndepYear < 1930 and T2.IsOfficial = "T"	world_1
select Name from country where SurfaceArea > (select max(SurfaceArea) from country where Continent = "Europe")	world_1
select Name from country where SurfaceArea > (select max(SurfaceArea) from country where Continent = "Europe")	world_1
select T1.Name from country as T1 where T1.Continent = "Africa" and T1.Population < (select min(T2.Population) from country as T2 where T2.Continent = "Asia")	world_1
select Name from country where Continent = "Africa" and Population < (select min(Population) from country where Continent = "Asia")	world_1
select Name from country where Continent = "Asia" and Population > (select max(Population) from country where Continent = "Africa")	world_1
select Name from country where Continent = "Asia" and Population > (select max(Population) from country where Continent = "Africa")	world_1
select distinct T1.Code from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language <> "English"	world_1
select distinct country.Code from country inner join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language <> "English" and countrylanguage.IsOfficial <> "T"	world_1
select T1.Code from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language <> "English"	world_1
select country.Code from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language <> "English"	world_1
select T1.Code from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language <> "English" and T2.IsOfficial = "T" and T1.GovernmentForm <> "Republic"	world_1
select T1.Code from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language <> "English" and T2.IsOfficial = "T" and T1.GovernmentForm <> "Republic"	world_1
select T1.Name from city as T1 join country as T2 on T1.CountryCode = T2.Code join countrylanguage as T3 on T2.Code = T3.CountryCode where T2.Continent = "Europe" and T3.Language <> "English" and T3.IsOfficial = "T"	world_1
select city.Name from city join country on city.CountryCode = country.Code join countrylanguage on country.Code = countrylanguage.CountryCode where country.Continent = "Europe" and countrylanguage.Language <> "English" and countrylanguage.IsOfficial = "T"	world_1
select distinct city.Name from city join country on city.CountryCode = country.Code join countrylanguage on country.Code = countrylanguage.CountryCode where country.Continent = "Asia" and countrylanguage.Language = "Chinese" and countrylanguage.IsOfficial = "T"	world_1
select distinct city.Name from city join country on city.CountryCode = country.Code join countrylanguage on country.Code = countrylanguage.CountryCode where country.Continent = "Asia" and countrylanguage.Language = "Chinese" and countrylanguage.IsOfficial = "T"	world_1
select Name, IndepYear, SurfaceArea from country order by Population asc limit 1	world_1
select Name, IndepYear, SurfaceArea from country order by Population asc limit 1	world_1
select Population, Name, HeadOfState from country order by SurfaceArea desc limit 1	world_1
select Name, Population, HeadOfState from country order by SurfaceArea desc limit 1	world_1
select country.Name, count(countrylanguage.Language) from country join countrylanguage on country.Code = countrylanguage.CountryCode group by country.Code having count(countrylanguage.Language) >= 3	world_1
select country.Name, count(distinct countrylanguage.Language) from country join countrylanguage on country.Code = countrylanguage.CountryCode group by country.Name having count(distinct countrylanguage.Language) > 2	world_1
select District, count(*) as "Number of Cities" from city where Population > (select avg(Population) from city) group by District	world_1
select District, count(*) from city where Population > (select avg(Population) from city) group by District	world_1
select GovernmentForm, sum(Population) from country where LifeExpectancy > 72 group by GovernmentForm	world_1
select GovernmentForm, sum(Population) from country where LifeExpectancy > 72 group by GovernmentForm	world_1
select avg(LifeExpectancy), sum(Population) from country where LifeExpectancy < 72 group by Continent	world_1
select Continent, sum(Population), avg(LifeExpectancy) from country where LifeExpectancy < 72 group by Continent	world_1
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
select Language from countrylanguage group by Language order by count(distinct CountryCode) desc limit 1	world_1
select Language, count(distinct CountryCode) from countrylanguage group by Language order by CountryCount desc limit 1	world_1
select cl.CountryCode, cl.Language, cl.Percentage from countrylanguage cl join (select CountryCode, max(Percentage) from countrylanguage group by CountryCode) sub on cl.CountryCode = sub.CountryCode and cl.Percentage = sub.max_percentage order by cl.Percentage desc	world_1
select country.Code, countrylanguage.Language from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Percentage = (select max(Percentage) from countrylanguage cl where cl.CountryCode = country.Code) order by countrylanguage.Percentage desc	world_1
select count(distinct CountryCode) from countrylanguage where Language = "Spanish" and Percentage = (select max(Percentage) from countrylanguage where Language = "Spanish")	world_1
select count(distinct country.Code) from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "Spanish" and countrylanguage.IsOfficial = "T"	world_1
select T1.Code from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language = "Spanish" order by T2.Percentage desc	world_1
select T1.Code from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language = "Spanish"	world_1
