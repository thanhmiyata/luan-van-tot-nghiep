select Name from country where IndepYear > 1950	world_1
select Name from country where IndepYear > 1950	world_1
select count(distinct Code) from country where GovernmentForm = "republic"	world_1
select count(distinct Code) from country where GovernmentForm = "republic"	world_1
select sum(SurfaceArea) from country where Region = "Caribbean"	world_1
select sum(SurfaceArea) from country where Region like "%Caribbean%"	world_1
select Continent from country where Name = "Anguilla"	world_1
select Continent from country where Name = "Anguilla"	world_1
select T2.Region from city as T1 join country as T2 on T1.CountryCode = T2.Code where T1.Name = "Kabul"	world_1
select T2.Region from city as T1 join country as T2 on T1.CountryCode = T2.Code where T1.Name = "Kabul"	world_1
select T1.Language from countrylanguage as T1 join country as T2 on T1.CountryCode = T2.Code where T2.Name = "Aruba" order by T1.Percentage desc limit 1	world_1
select Language from countrylanguage where CountryCode = "ABW" order by Percentage desc	world_1
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
select count(distinct countrylanguage.Language) from countrylanguage join country on countrylanguage.CountryCode = country.Code where country.Name = "Aruba"	world_1
select count(distinct countrylanguage.Language) as "Number of Languages" from countrylanguage join country on countrylanguage.CountryCode = country.Code where country.Name = "Aruba"	world_1
select count(*) from countrylanguage where CountryCode = "AFG" and IsOfficial = "T"	world_1
select count(distinct Language) from countrylanguage where CountryCode = "AFG" and IsOfficial = "T"	world_1
select c.Name from country c join countrylanguage cl on c.Code = cl.CountryCode group by c.Code, c.Name order by count(distinct cl.Language) desc limit 1	world_1
select country.Name from country join countrylanguage on country.Code = countrylanguage.CountryCode group by country.Name order by count(distinct countrylanguage.Language) desc limit 1	world_1
select T1.Continent from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode group by T1.Continent order by count(distinct T2.Language) desc limit 1	world_1
select Continent from country join countrylanguage on country.Code = countrylanguage.CountryCode group by Continent order by count(distinct countrylanguage.Language) desc limit 1	world_1
select count(*) from (select CountryCode from countrylanguage where Language = "English" intersect select CountryCode from countrylanguage where Language = "Dutch")	world_1
select count(distinct CountryCode) from countrylanguage where Language in ("English", "Dutch")	world_1
select country.Name from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "English" intersect select country.Name from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "French"	world_1
select T1.Name from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language = "English" intersect select T1.Name from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language = "French"	world_1
select Name from country where Code in (select CountryCode from countrylanguage where Language = "English" and IsOfficial = "T") and Code in (select CountryCode from countrylanguage where Language = "French" and IsOfficial = "T")	world_1
select Name from country where Code in (select CountryCode from countrylanguage where (Language = "English" or Language = "French") and IsOfficial = "T" group by CountryCode having count(distinct Language) = 2)	world_1
select count(distinct T1.Continent) from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language = "Chinese"	world_1
select count(distinct country.Continent) from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "Chinese"	world_1
select Region from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language in ("English", "Dutch") group by Region	world_1
select distinct country.Region from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language in ("Dutch", "English")	world_1
select Name from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language in ("English", "Dutch") and countrylanguage.IsOfficial = "T"	world_1
select country.Name from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language in ("English", "Dutch") and countrylanguage.IsOfficial = "T"	world_1
select countrylanguage.Language from country join countrylanguage on country.Code = countrylanguage.CountryCode where country.Continent = "Asia" group by countrylanguage.Language order by sum(countrylanguage.Percentage) desc limit 1	world_1
select Language from country join countrylanguage on country.Code = countrylanguage.CountryCode where Continent = "Asia" group by Language order by count(distinct country.Code) desc limit 1	world_1
select T1.Language from countrylanguage as T1 join country as T2 on T1.CountryCode = T2.Code where T2.GovernmentForm = "republic" group by T1.Language having count(distinct T2.Code) = 1	world_1
select Language from countrylanguage where CountryCode in (select Code from country where GovernmentForm = "Republic") group by Language having count(distinct CountryCode) = 1	world_1
select city.Name from city join country on city.CountryCode = country.Code join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "English" order by city.Population desc limit 1	world_1
select T1.Name, T1.Population from city as T1 join country as T2 on T1.CountryCode = T2.Code join countrylanguage as T3 on T2.Code = T3.CountryCode where T3.Language = "English" order by T1.Population desc limit 1	world_1
select Name, Population, LifeExpectancy from country where Continent = "Asia" order by SurfaceArea desc limit 1	world_1
select Name, Population, LifeExpectancy from country where Continent = "Asia" order by SurfaceArea desc limit 1	world_1
select avg(T1.LifeExpectancy) from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language = "English" and T2.IsOfficial <> "T"	world_1
select avg(country.LifeExpectancy) from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language <> "English" and countrylanguage.IsOfficial <> "T"	world_1
select sum(c.Population) from country c join countrylanguage cl on c.Code = cl.CountryCode where cl.Language <> "English"	world_1
select sum(T1.Population) as "Country Population sum" from country as T1 where T1.Code in (select T2.CountryCode from countrylanguage as T2 where T2.Language <> "English" and T2.IsOfficial = "T")	world_1
select T2.Language from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode where T1.HeadOfState = "Beatrix" and T2.IsOfficial = "T"	world_1
select countrylanguage.Language from country join countrylanguage on country.Code = countrylanguage.CountryCode where country.HeadOfState = "Beatrix" and countrylanguage.IsOfficial = "T"	world_1
select count(distinct cl.Language) from country c join countrylanguage cl on c.Code = cl.CountryCode where c.IndepYear < 1930 and cl.IsOfficial = "T"	world_1
select count(distinct countrylanguage.Language) from country inner join countrylanguage on country.Code = countrylanguage.CountryCode where country.IndepYear < 1930	world_1
select Name from country where SurfaceArea > (select max(SurfaceArea) from country where Continent = "Europe")	world_1
select Name from country where SurfaceArea > (select max(SurfaceArea) from country where Continent = "Europe")	world_1
select Name from country where Continent = "Africa" and Population < (select min(Population) from country where Continent = "Asia")	world_1
select Name from country where Continent = "Africa" and Population < (select min(Population) from country where Continent = "Asia")	world_1
select Name from country where Continent = "Asia" and Population > ALL (select Population from country where Continent = "Africa")	world_1
select Name from country where Continent = "Asia" and Population > (select max(Population) from country where Continent = "Africa")	world_1
select country.Code from country inner join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language <> "English"	world_1
select c.Code from country c where c.Code not in (select cl.CountryCode from countrylanguage cl where cl.Language = "English" and cl.IsOfficial = "T")	world_1
select country.Code from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language <> "English"	world_1
select country.Code from countrylanguage join country on countrylanguage.CountryCode = country.Code where countrylanguage.Language <> "English"	world_1
select T1.Code from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language <> "English" and T1.GovernmentForm <> "Republic" and T2.IsOfficial <> "T"	world_1
select country.Code from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language <> "English" and country.GovernmentForm <> "Republic"	world_1
select T1.Name from city as T1 join country as T2 on T1.CountryCode = T2.Code join countrylanguage as T3 on T2.Code = T3.CountryCode where T2.Continent = "Europe" and T3.Language = "English" and T3.IsOfficial = "F"	world_1
select T1.Name from city as T1 join country as T2 on T1.CountryCode = T2.Code join countrylanguage as T3 on T2.Code = T3.CountryCode where T2.Continent = "Europe" and T3.Language <> "English" and T3.IsOfficial = "F"	world_1
select distinct T1.Name from city as T1 join country as T2 on T1.CountryCode = T2.Code join countrylanguage as T3 on T2.Code = T3.CountryCode where T3.Language = "Chinese" and T3.IsOfficial = "T" and T2.Continent = "Asia"	world_1
select distinct city.Name from city join country on city.CountryCode = country.Code join countrylanguage on country.Code = countrylanguage.CountryCode where country.Continent = "Asia" and countrylanguage.Language = "Chinese" and countrylanguage.IsOfficial = "T"	world_1
select Name, IndepYear, SurfaceArea from country order by Population asc limit 1	world_1
select Name, IndepYear, SurfaceArea from country order by Population asc limit 1	world_1
select Population, Name, HeadOfState from country order by SurfaceArea desc limit 1	world_1
select Name, Population, HeadOfState from country where SurfaceArea = (select max(SurfaceArea) from country)	world_1
select T1.Name, count(distinct T2.Language) as "Number of Languages" from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode group by T1.Code having count(distinct T2.Language) >= 3	world_1
select country.Name, count(distinct countrylanguage.Language) from country join countrylanguage on country.Code = countrylanguage.CountryCode group by country.Name having count(distinct countrylanguage.Language) > 2	world_1
select District, count(distinct ID) from city where Population > (select avg(Population) from city) group by District	world_1
select District, count(distinct ID) from city where Population > (select avg(Population) from city) group by District	world_1
select GovernmentForm, sum(Population) from country group by GovernmentForm having avg(LifeExpectancy) > 72	world_1
select GovernmentForm, sum(Population) from country group by GovernmentForm having avg(LifeExpectancy) > 72	world_1
select avg(LifeExpectancy), sum(Population) from country group by Continent having avg(LifeExpectancy) < 72	world_1
select Continent, sum(Population), avg(LifeExpectancy) from country group by Continent having avg(LifeExpectancy) < 72	world_1
select Name, SurfaceArea from country order by SurfaceArea desc limit 5	world_1
select Name, SurfaceArea from country order by SurfaceArea desc limit 5	world_1
select Name from country order by Population desc limit 3	world_1
select Name from country order by Population desc limit 3	world_1
select Name from country order by Population asc limit 3	world_1
select Name from country order by Population asc limit 3	world_1
select count(distinct Code) from country where Continent = "Asia"	world_1
select count(distinct Code) from country where Continent = "Asia"	world_1
select Name from country where Continent = "Europe" and Population = 80000	world_1
select Name from country where Continent = "Europe" and Population = 80000	world_1
select sum(Population), avg(SurfaceArea) from country where Continent = "North America" and SurfaceArea > 3000	world_1
select sum(Population), avg(SurfaceArea) from country where Continent = "North America" and SurfaceArea > 3000	world_1
select Name from city where Population between 160000 and 900000	world_1
select Name from city where Population between 160000 and 900000	world_1
select countrylanguage.Language, count(distinct country.Code) from countrylanguage join country on countrylanguage.CountryCode = country.Code group by countrylanguage.Language order by count(distinct country.Code) desc limit 1	world_1
select Language from countrylanguage group by Language order by count(distinct CountryCode) desc limit 1	world_1
select T1.Name, T2.Language from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode where (T2.CountryCode, T2.Percentage) in (select CountryCode, max(Percentage) from countrylanguage group by CountryCode)	world_1
select c.Code, cl.Language from country c join countrylanguage cl on c.Code = cl.CountryCode where cl.Percentage = (select max(cl2.Percentage) from countrylanguage cl2 where cl2.CountryCode = cl.CountryCode)	world_1
select count(distinct T1.Code) from country as T1 join countrylanguage as T2 on T1.Code = T2.CountryCode where T2.Language = "Spanish" and T2.Percentage = (select max(T3.Percentage) from countrylanguage as T3 where T3.CountryCode = T2.CountryCode)	world_1
select count(distinct cl.CountryCode) from countrylanguage cl where cl.Language = "Spanish"	world_1
select country.Code from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "Spanish" order by countrylanguage.Percentage desc limit 1	world_1
select country.Code from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "Spanish"	world_1
