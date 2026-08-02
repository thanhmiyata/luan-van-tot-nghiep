select Name from country where IndepYear > 1950	world_1
select Name from country where IndepYear > 1950	world_1
select count(*) from country where GovernmentForm = "Republic"	world_1
select count(*) from country where GovernmentForm = "Republic"	world_1
select sum(SurfaceArea) from country where Region = "Caribbean"	world_1
select sum(SurfaceArea) from country where Region = "Caribbean"	world_1
select Continent from country where Name = "Anguilla"	world_1
select Continent from country where Name = "Anguilla"	world_1
select country.Region from city join country on city.CountryCode = country.Code where city.Name = "Kabul"	world_1
select country.Region from city join country on city.CountryCode = country.Code where city.Name = "Kabul"	world_1
select countrylanguage.Language from country join countrylanguage on countrylanguage.CountryCode = country.Code where country.Name = "Aruba" order by countrylanguage.Percentage desc limit 1	world_1
SELECT Language FROM countrylanguage WHERE CountryCode = (SELECT Code FROM country WHERE Name = 'Aruba') ORDER BY Percentage DESC LIMIT 1	world_1
select Population, LifeExpectancy from country where Name = "Brazil"	world_1
select Population, LifeExpectancy from country where Name = "Brazil"	world_1
select Region, Population from country where Name = "Angola"	world_1
select Region, Population from country where Name = "Angola"	world_1
select avg(LifeExpectancy) from country where Region = "Central Africa"	world_1
select avg(LifeExpectancy) from country where Region = "Central Africa"	world_1
select Name from country where Continent = "Asia" order by LifeExpectancy asc limit 1	world_1
select Name from country where Continent = "Asia" order by LifeExpectancy asc limit 1	world_1
select sum(Population), max(GNP) from country where Continent = "Asia"	world_1
SELECT SUM(Population), MAX(GNP) FROM country WHERE Continent = 'Asia'	world_1
select avg(LifeExpectancy) from country where Continent = "Africa" and GovernmentForm = "Republic"	world_1
select avg(LifeExpectancy) from country where Continent = "Africa" and GovernmentForm = "Republic"	world_1
select sum(SurfaceArea) from country where Continent = "Asia" or Continent = "Europe"	world_1
select sum(SurfaceArea) from country where Continent = "Asia" or Continent = "Europe"	world_1
SELECT SUM(Population) FROM city WHERE District = 'Gelderland'	world_1
select sum(Population) from city where District = "Gelderland"	world_1
select avg(GNP), sum(Population) from country where GovernmentForm = "US Territory"	world_1
SELECT avg(GNP) ,  sum(population) FROM country WHERE GovernmentForm  =  "US Territory"	world_1
select count(distinct Language) from countrylanguage	world_1
SELECT count(DISTINCT LANGUAGE) FROM countrylanguage	world_1
SELECT count(DISTINCT GovernmentForm) FROM country WHERE Continent  =  "Africa"	world_1
select count(distinct GovernmentForm) from country where Continent = "Africa"	world_1
SELECT COUNT(T2.Language) FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code  =  T2.CountryCode WHERE T1.Name  =  "Aruba"	world_1
select count(*) as "number of languages" from countrylanguage where CountryCode = "ABW"	world_1
SELECT COUNT(*) FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code  =  T2.CountryCode WHERE T1.Name  =  "Afghanistan" AND IsOfficial  =  "T"	world_1
SELECT COUNT(*) FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code  =  T2.CountryCode WHERE T1.Name  =  "Afghanistan" AND IsOfficial  =  "T"	world_1
SELECT country.Name FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode GROUP BY country.Code ORDER BY COUNT(*) DESC LIMIT 1	world_1
SELECT country.Name FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode GROUP BY country.Code ORDER BY COUNT(*) DESC LIMIT 1	world_1
select country.Continent from country join countrylanguage on countrylanguage.CountryCode = country.Code group by country.Continent having count(distinct countrylanguage.Language) = (select max(language_count) from (select count(distinct countrylanguage.Language) as language_count from country join countrylanguage on country.Code = countrylanguage.CountryCode group by country.Continent))	world_1
SELECT T1.Continent FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code  =  T2.CountryCode GROUP BY T1.Continent ORDER BY COUNT(*) DESC LIMIT 1	world_1
SELECT COUNT(*) FROM (SELECT cl1.CountryCode FROM countrylanguage AS cl1 JOIN countrylanguage AS cl2 ON cl1.CountryCode = cl2.CountryCode WHERE cl1.Language = 'English' AND cl2.Language = 'Dutch')	world_1
select count(*) from (select country.Code from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "English" intersect select country.Code from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "Dutch")	world_1
select Name from country where Code in (select CountryCode from countrylanguage where Language = "English") intersect select Name from country where Code in (select CountryCode from countrylanguage where Language = "French")	world_1
select distinct country.Name from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "English" intersect select distinct country.Name from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "French"	world_1
select Name from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "English" and countrylanguage.IsOfficial = "T" intersect select Name from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "French" and countrylanguage.IsOfficial = "T"	world_1
select distinct c.Name from country c join countrylanguage cl1 on c.Code = cl1.CountryCode where cl1.Language = "English" and cl1.IsOfficial = "T" intersect select distinct c.Name from country c join countrylanguage cl2 on c.Code = cl2.CountryCode where cl2.Language = "French" and cl2.IsOfficial = "T"	world_1
select count(distinct country.Continent) from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "Chinese"	world_1
select count(distinct country.Continent) from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "Chinese"	world_1
SELECT DISTINCT T1.Region FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code  =  T2.CountryCode WHERE T2.Language  =  "English" OR T2.Language  =  "Dutch"	world_1
select distinct country.Region from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "Dutch" or countrylanguage.Language = "English"	world_1
SELECT country.Name FROM country INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.IsOfficial = 'T' AND countrylanguage.Language = 'English' UNION SELECT country.Name FROM country INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.IsOfficial = 'T' AND countrylanguage.Language = 'Dutch'	world_1
SELECT DISTINCT T1.Name FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code = T2.CountryCode WHERE T2.IsOfficial = 'T' AND (T2.Language = 'English' OR T2.Language = 'Dutch')	world_1
SELECT cl."Language" FROM countrylanguage AS cl JOIN country AS c ON cl."CountryCode" = c."Code" WHERE c."Continent" = 'Asia' GROUP BY cl."Language" ORDER BY SUM(cl."Percentage") DESC LIMIT 1	world_1
select cl.Language from countrylanguage cl join country c on cl.CountryCode = c.Code where c.Continent = "Asia" group by cl.Language having count(cl.CountryCode) = (select max(country_count) from (select count(cl_sub.CountryCode) as country_count from countrylanguage cl_sub join country c_sub on cl_sub.CountryCode = c_sub.Code where c_sub.Continent = "Asia" group by cl_sub.Language))	world_1
SELECT T2.Language FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code  =  T2.CountryCode WHERE T1.GovernmentForm  =  "Republic" GROUP BY T2.Language HAVING COUNT(*)  =  1	world_1
select distinct countrylanguage.Language from countrylanguage join country on countrylanguage.CountryCode = country.Code where country.GovernmentForm = "Republic" group by countrylanguage.Language having count(distinct countrylanguage.CountryCode) = 1	world_1
SELECT city.Name FROM city JOIN countrylanguage ON city.CountryCode = countrylanguage.CountryCode WHERE countrylanguage.Language = 'English' ORDER BY city.Population DESC LIMIT 1	world_1
SELECT city.Name FROM city JOIN countrylanguage ON city.CountryCode = countrylanguage.CountryCode WHERE countrylanguage.Language = 'English' ORDER BY city.Population DESC LIMIT 1	world_1
select Name, Population, LifeExpectancy from country where Continent = "Asia" order by SurfaceArea desc limit 1	world_1
select Name, Population, LifeExpectancy from country where Continent = "Asia" order by SurfaceArea desc limit 1	world_1
SELECT AVG(country.LifeExpectancy) FROM country WHERE NOT country.Code IN (SELECT countrylanguage.CountryCode FROM countrylanguage WHERE countrylanguage.Language = 'English' AND countrylanguage.IsOfficial = 'T')	world_1
SELECT AVG(country.LifeExpectancy) FROM country WHERE NOT country.Code IN (SELECT countrylanguage.CountryCode FROM countrylanguage WHERE countrylanguage.Language = 'English' AND countrylanguage.IsOfficial = 'T')	world_1
SELECT SUM(country.Population) AS total_population FROM country WHERE NOT EXISTS(SELECT 1 FROM countrylanguage WHERE country.Code = countrylanguage.CountryCode AND countrylanguage.Language = 'English')	world_1
SELECT SUM(Population) FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.Language <> 'English'	world_1
SELECT countrylanguage.Language FROM country INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE country.HeadOfState = 'Beatrix'	world_1
select countrylanguage.Language from country join countrylanguage on countrylanguage.CountryCode = country.Code where country.HeadOfState = "Beatrix" and countrylanguage.IsOfficial = "T"	world_1
select count(distinct countrylanguage.Language) from country join countrylanguage on countrylanguage.CountryCode = country.Code where country.IndepYear < 1930 and countrylanguage.IsOfficial = "T"	world_1
SELECT COUNT(DISTINCT countrylanguage.Language) FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE country.IndepYear < 1930	world_1
SELECT country.Name FROM country WHERE country.SurfaceArea > (SELECT MAX(SurfaceArea) FROM country WHERE Continent = 'Europe')	world_1
SELECT Name FROM country WHERE SurfaceArea > (SELECT MAX(SurfaceArea) FROM country WHERE Continent = 'Europe')	world_1
SELECT Name FROM country WHERE Continent = 'Africa' AND Population < (SELECT MIN(Population) FROM country WHERE Continent = 'Asia')	world_1
select Name from country where Continent = "Africa" and Population < (select min(Population) from country where Continent = "Asia")	world_1
select Name from country where Continent = "Asia" and Population > (select max(Population) from country where Continent = "Africa")	world_1
SELECT Name FROM country WHERE Continent = 'Asia' AND Population > (SELECT MAX(Population) FROM country WHERE Continent = 'Africa')	world_1
SELECT DISTINCT country.Code FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.Language <> 'English'	world_1
SELECT Code FROM country WHERE NOT EXISTS(SELECT 1 FROM countrylanguage WHERE countrylanguage.CountryCode = country.Code AND countrylanguage.Language = 'English')	world_1
SELECT DISTINCT CountryCode FROM countrylanguage WHERE LANGUAGE != "English"	world_1
select distinct country.Code from country join countrylanguage on countrylanguage.CountryCode = country.Code where countrylanguage.Language <> "English"	world_1
SELECT country.Code FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.Language <> 'English' AND country.GovernmentForm <> 'Republic'	world_1
SELECT c.Code FROM country AS c WHERE c.GovernmentForm <> 'Republic' AND NOT EXISTS(SELECT 1 FROM countrylanguage AS cl WHERE cl.CountryCode = c.Code AND cl.Language = 'English')	world_1
SELECT city.Name FROM city JOIN country ON city.CountryCode = country.Code JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE country.Continent = 'Europe' AND countrylanguage.Language = 'English' AND countrylanguage.IsOfficial <> 'T'	world_1
SELECT city.Name FROM city JOIN country ON city.CountryCode = country.Code JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE country.Continent = 'Europe' AND countrylanguage.IsOfficial = 'T' AND countrylanguage.Language <> 'English'	world_1
SELECT DISTINCT city.Name FROM city JOIN country ON city.CountryCode = country.Code JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE country.Continent = 'Asia' AND countrylanguage.Language = 'Chinese' AND countrylanguage.IsOfficial = 'T'	world_1
select distinct city.Name from city join country on city.CountryCode = country.Code join countrylanguage on country.Code = countrylanguage.CountryCode where country.Continent = "Asia" and countrylanguage.Language = "Chinese" and countrylanguage.IsOfficial = "T"	world_1
select Name, IndepYear, SurfaceArea from country order by Population asc limit 1	world_1
SELECT Name, IndepYear, SurfaceArea FROM country ORDER BY Population ASC LIMIT 1	world_1
select Population, Name, HeadOfState from country order by SurfaceArea desc limit 1	world_1
select Name, Population, HeadOfState from country order by SurfaceArea desc limit 1	world_1
select country.Name, count(countrylanguage.Language) from country inner join countrylanguage on countrylanguage.CountryCode = country.Code group by country.Name having count(countrylanguage.Language) >= 3	world_1
SELECT COUNT(T2.Language) ,  T1.Name FROM country AS T1 JOIN countrylanguage AS T2 ON T1.Code  =  T2.CountryCode GROUP BY T1.Name HAVING COUNT(*)  >  2	world_1
select city.District, count(*) from city where city.Population > (select avg(city.Population) from city) group by city.District	world_1
select District, count(*) from city where Population > (select avg(Population) from city) group by District	world_1
select GovernmentForm, sum(Population) from country group by GovernmentForm having avg(LifeExpectancy) > 72	world_1
SELECT GovernmentForm, SUM(Population) AS total_population FROM country GROUP BY GovernmentForm HAVING AVG(LifeExpectancy) > 72	world_1
SELECT AVG(LifeExpectancy), SUM(Population) FROM country GROUP BY Continent HAVING AVG(LifeExpectancy) < 72	world_1
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
SELECT SUM(Population) AS total_population, AVG(SurfaceArea) AS average_area FROM country WHERE Continent = 'North America' AND SurfaceArea > 3000	world_1
SELECT SUM(Population), AVG(SurfaceArea) FROM country WHERE Continent = 'North America' AND SurfaceArea > 3000	world_1
select Name from city where Population between 160000 and 900000	world_1
select Name from city where Population between 160000 and 900000	world_1
select Language from countrylanguage group by Language having count(CountryCode) = (select max(country_count) from (select count(CountryCode) as country_count from countrylanguage group by Language))	world_1
select Language from countrylanguage group by Language having count(CountryCode) = (select max(CNT) from (select count(CountryCode) as CNT from countrylanguage group by Language))	world_1
SELECT Language, CountryCode FROM countrylanguage WHERE (CountryCode, Percentage) IN (SELECT CountryCode, MAX(Percentage) FROM countrylanguage GROUP BY CountryCode) ORDER BY Percentage DESC LIMIT 1	world_1
SELECT country.Code, countrylanguage.Language FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode GROUP BY country.Code, countrylanguage.Language HAVING countrylanguage.Percentage = (SELECT MAX(cl.Percentage) FROM countrylanguage AS cl WHERE cl.CountryCode = country.Code)	world_1
SELECT COUNT(*) AS total_number_of_countries FROM (SELECT CountryCode FROM countrylanguage WHERE Language = 'Spanish' ORDER BY Percentage DESC LIMIT 1) AS top_country	world_1
SELECT COUNT(*) FROM country INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.Language = 'Spanish'	world_1
SELECT country.Code FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.Language = 'Spanish' ORDER BY countrylanguage.Percentage DESC LIMIT 1	world_1
SELECT country.Code FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.Language = 'Spanish'	world_1
