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
SELECT count(*) FROM CONTINENTS;	car_1
select count(*) from continents	car_1
select continents.ContId, continents.Continent, count(*) from continents join countries on countries.Continent = continents.ContId group by continents.ContId, continents.Continent	car_1
select continents.ContId, continents.Continent, count(*) from continents inner join countries on countries.Continent = continents.ContId group by continents.ContId, continents.Continent	car_1
select count(*) from countries	car_1
SELECT count(*) FROM COUNTRIES;	car_1
select car_makers.FullName, car_makers.Id, count(*) from car_makers join model_list on model_list.Maker = car_makers.Id group by car_makers.FullName, car_makers.Id	car_1
select car_makers.FullName, car_makers.Id, count(*) from car_makers join model_list on model_list.Maker = car_makers.Id group by car_makers.FullName, car_makers.Id	car_1
SELECT "Model" FROM "model_list" WHERE "ModelId" = (SELECT "ModelId" FROM "model_list" JOIN "car_names" ON "model_list"."Model" = "car_names"."Model" JOIN "cars_data" ON "car_names"."MakeId" = "cars_data"."Id" ORDER BY "cars_data"."Horsepower" ASC LIMIT 1)	car_1
select model_list.Model from model_list join car_names on car_names.Model = model_list.Model join cars_data on cars_data.Id = car_names.MakeId order by cars_data.Horsepower asc limit 1	car_1
SELECT c."Model" FROM "model_list" AS c JOIN "car_names" AS cn ON cn."Model" = c."Model" JOIN "cars_data" AS cd ON cd."Id" = cn."MakeId" WHERE cd."Weight" < (SELECT AVG("Weight") FROM "cars_data")	car_1
SELECT car_names.Model FROM cars_data JOIN car_names ON cars_data.Id = car_names.MakeId WHERE cars_data.Weight < (SELECT AVG(Weight) FROM cars_data)	car_1
select distinct car_makers.Maker from car_makers join model_list on model_list.Maker = car_makers.Id join car_names on car_names.Model = model_list.Model join cars_data on cars_data.Id = car_names.MakeId where cars_data.Year = 1970	car_1
select distinct car_makers.Maker from car_makers join model_list on model_list.Maker = car_makers.Id join car_names on car_names.Model = model_list.Model join cars_data on cars_data.Id = car_names.MakeId where cars_data.Year = 1970	car_1
SELECT car_makers.Maker, cars_data.Year FROM car_makers JOIN model_list ON model_list.Maker = car_makers.Id JOIN car_names ON car_names.Model = model_list.Model JOIN cars_data ON cars_data.Id = car_names.MakeId WHERE cars_data.Year = (SELECT MIN(cars_data.Year) FROM cars_data)	car_1
SELECT car_makers.Maker, cars_data.Year FROM cars_data JOIN car_names ON cars_data.Id = car_names.MakeId JOIN model_list ON car_names.Model = model_list.Model JOIN car_makers ON model_list.Maker = car_makers.Id ORDER BY cars_data.Year ASC LIMIT 1	car_1
select distinct car_names.Model from car_names inner join cars_data on car_names.MakeId = cars_data.Id where cars_data.Year > 1980	car_1
select distinct model_list.Model from model_list join car_names on car_names.Model = model_list.Model join cars_data on cars_data.Id = car_names.MakeId where cars_data.Year > 1980	car_1
SELECT T1.Continent ,  count(*) FROM CONTINENTS AS T1 JOIN COUNTRIES AS T2 ON T1.ContId  =  T2.continent JOIN car_makers AS T3 ON T2.CountryId  =  T3.Country GROUP BY T1.Continent;	car_1
select continents.Continent, count(*) as "Number of Car Makers" from continents join countries on countries.Continent = continents.ContId join car_makers on car_makers.Country = countries.CountryId group by continents.Continent	car_1
select countries.CountryName from countries join car_makers on car_makers.Country = countries.CountryId group by car_makers.Country having count(car_makers.Maker) = (select max(maker_count) from (select count(car_makers.Maker) as maker_count from car_makers group by car_makers.Country))	car_1
SELECT T2.CountryName FROM CAR_MAKERS AS T1 JOIN COUNTRIES AS T2 ON T1.Country  =  T2.CountryId GROUP BY T1.Country ORDER BY Count(*) DESC LIMIT 1;	car_1
select count(*) ,  t2.fullname from model_list as t1 join car_makers as t2 on t1.maker  =  t2.id group by t2.id;	car_1
select count(model_list.ModelId), car_makers.Id, car_makers.FullName from car_makers join model_list on model_list.Maker = car_makers.Id group by car_makers.Id, car_makers.FullName	car_1
select cars_data.Accelerate from car_names inner join cars_data on car_names.MakeId = cars_data.Id where car_names.Make = "amc hornet sportabout (sw)"	car_1
select cars_data.Accelerate from car_names inner join cars_data on cars_data.Id = car_names.MakeId where car_names.Make = "amc hornet sportabout (sw)"	car_1
SELECT count(*) FROM CAR_MAKERS AS T1 JOIN COUNTRIES AS T2 ON T1.Country  =  T2.CountryId WHERE T2.CountryName  =  'france';	car_1
SELECT count(*) FROM CAR_MAKERS AS T1 JOIN COUNTRIES AS T2 ON T1.Country  =  T2.CountryId WHERE T2.CountryName  =  'france';	car_1
select count(*) as count from countries join car_makers on car_makers.Country = countries.CountryId join model_list on model_list.Maker = car_makers.Id where countries.CountryName = "usa"	car_1
SELECT count(*) FROM MODEL_LIST AS T1 JOIN CAR_MAKERS AS T2 ON T1.Maker  =  T2.Id JOIN COUNTRIES AS T3 ON T2.Country  =  T3.CountryId WHERE T3.CountryName  =  'usa';	car_1
select avg(MPG) from cars_data where Cylinders = 4	car_1
select avg(MPG) from cars_data where Cylinders = 4	car_1
select min(Weight) from cars_data where Cylinders = 8 and Year = 1974	car_1
select min(Weight) from cars_data where Cylinders = 8 and Year = 1974	car_1
SELECT car_makers.Maker, model_list.Model FROM car_makers JOIN model_list ON car_makers.Id = model_list.Maker	car_1
SELECT car_makers.Maker, model_list.Model FROM car_makers INNER JOIN model_list ON car_makers.Id = model_list.Maker	car_1
select countries.CountryName, countries.CountryId from countries where EXISTS (select 1 from car_makers where car_makers.Country = countries.CountryId)	car_1
select countries.CountryName, countries.CountryId from countries where EXISTS (select 1 from car_makers where car_makers.Country = countries.CountryId)	car_1
select count(*) from cars_data where Horsepower > 150	car_1
select count(*) from cars_data where Horsepower > 150	car_1
select avg(Weight), Year from cars_data group by Year	car_1
select avg(Weight), Year from cars_data group by Year	car_1
select countries.CountryName from continents join countries on countries.Continent = continents.ContId join car_makers on car_makers.Country = countries.CountryId where continents.Continent = "europe" group by countries.CountryId having count(car_makers.Maker) >= 3	car_1
select countries.CountryName from countries join continents on countries.Continent = continents.ContId join car_makers on car_makers.Country = countries.CountryId where continents.Continent = "europe" group by countries.CountryName having count(car_makers.Country) >= 3	car_1
select max(cars_data.Horsepower), car_names.Make from cars_data join car_names on cars_data.Id = car_names.MakeId where cars_data.Cylinders = 3	car_1
SELECT cm.Maker, MAX(cd.Horsepower) FROM cars_data AS cd JOIN car_names AS cn ON cd.Id = cn.MakeId JOIN model_list AS ml ON cn.Model = ml.Model JOIN car_makers AS cm ON ml.Maker = cm.Id WHERE cd.Cylinders = 3 GROUP BY cm.Maker ORDER BY MAX(cd.Horsepower) DESC LIMIT 1	car_1
select model_list.Model from model_list join car_names on car_names.Model = model_list.Model join cars_data on cars_data.Id = car_names.MakeId order by cars_data.MPG desc limit 1	car_1
select t1.model from car_names as t1 join cars_data as t2 on t1.makeid  =  t2.id order by t2.mpg desc limit 1;	car_1
select avg(Horsepower) from cars_data where Year < 1980	car_1
select avg(Horsepower) from cars_data where Year < 1980	car_1
SELECT avg(T2.edispl) FROM CAR_NAMES AS T1 JOIN CARS_DATA AS T2 ON T1.MakeId  =  T2.Id WHERE T1.Model  =  'volvo';	car_1
select avg(T4.Edispl) from car_makers as T1 join model_list as T2 on T2.Maker = T1.Id join car_names as T3 on T3.Model = T2.Model join cars_data as T4 on T4.Id = T3.MakeId where T1.Maker = "volvo"	car_1
select Cylinders, max(Accelerate) from cars_data group by Cylinders	car_1
select Cylinders, max(Accelerate) from cars_data group by Cylinders	car_1
select model_list.Model from model_list join car_names on car_names.Model = model_list.Model group by model_list.Model having count(car_names.Make) = (select max(subquery.counts) from (select count(*) as counts from car_names group by car_names.Model) as subquery)	car_1
select model_list.Model from model_list join car_names on model_list.Model = car_names.Model group by car_names.Model having count(car_names.MakeId) = (select max(version_count) from (select count(MakeId) as version_count from car_names group by Model))	car_1
select count(*) from cars_data where Cylinders > 4	car_1
select count(*) from cars_data where Cylinders > 4	car_1
select count(*) from cars_data where Year = 1980	car_1
select count(*) from cars_data where Year = 1980	car_1
SELECT count(*) FROM CAR_MAKERS AS T1 JOIN MODEL_LIST AS T2 ON T1.Id  =  T2.Maker WHERE T1.FullName  =  'American Motor Company';	car_1
select count(*) from car_makers join model_list on model_list.Maker = car_makers.Id where car_makers.FullName = "American Motor Company"	car_1
SELECT T1.FullName ,  T1.Id FROM CAR_MAKERS AS T1 JOIN MODEL_LIST AS T2 ON T1.Id  =  T2.Maker GROUP BY T1.Id HAVING count(*)  >  3;	car_1
SELECT car_makers.Id, car_makers.FullName FROM car_makers JOIN model_list ON car_makers.Id = model_list.Maker GROUP BY car_makers.Id, car_makers.FullName HAVING COUNT(model_list.Model) > 3	car_1
SELECT DISTINCT model_list.Model FROM model_list JOIN car_makers ON model_list.Maker = car_makers.Id JOIN car_names ON car_names.Model = model_list.Model JOIN cars_data ON cars_data.Id = car_names.MakeId WHERE car_makers.FullName = 'General Motors' OR cars_data.Weight > 3500	car_1
SELECT DISTINCT model_list.Model FROM model_list JOIN car_makers ON model_list.Maker = car_makers.Id JOIN car_names ON model_list.Model = car_names.Model JOIN cars_data ON car_names.MakeId = cars_data.Id WHERE car_makers.FullName = 'General Motors' OR cars_data.Weight > 3500	car_1
select Year from cars_data where Weight between 3000 and 4000	car_1
SELECT Year FROM cars_data WHERE Weight < 4000 INTERSECT SELECT Year FROM cars_data WHERE Weight > 3000	car_1
select Horsepower from cars_data where Accelerate = (select max(Accelerate) from cars_data)	car_1
select Horsepower from cars_data order by Accelerate desc limit 1	car_1
select cars_data.Cylinders from cars_data join car_names on cars_data.Id = car_names.MakeId join model_list on car_names.Model = model_list.Model where model_list.Model = "volvo" order by cars_data.Accelerate asc limit 1	car_1
SELECT T1.cylinders FROM CARS_DATA AS T1 JOIN CAR_NAMES AS T2 ON T1.Id  =  T2.MakeId WHERE T2.Model  =  'volvo' ORDER BY T1.accelerate ASC LIMIT 1;	car_1
SELECT COUNT(*) FROM cars_data WHERE Accelerate > (SELECT Horsepower FROM cars_data ORDER BY Horsepower DESC LIMIT 1)	car_1
SELECT COUNT(*) FROM cars_data WHERE Accelerate > (SELECT Accelerate FROM cars_data WHERE Horsepower = (SELECT MAX(Horsepower) FROM cars_data) LIMIT 1)	car_1
SELECT COUNT(*) FROM (SELECT "car_makers"."Country" FROM "car_makers" GROUP BY "car_makers"."Country" HAVING COUNT("car_makers"."Id") > 2)	car_1
select count(*) from countries as t1 join car_makers as t2 on t1.countryid  =  t2.country group by t1.countryid having count(*)  >  2	car_1
select count(*) from cars_data where Cylinders > 6	car_1
select count(*) from cars_data where Cylinders > 6	car_1
SELECT T1.Model FROM CAR_NAMES AS T1 JOIN CARS_DATA AS T2 ON T1.MakeId  =  T2.Id WHERE T2.Cylinders  =  4 ORDER BY T2.horsepower DESC LIMIT 1;	car_1
SELECT car_names.Model FROM cars_data JOIN car_names ON cars_data.Id = car_names.MakeId WHERE cars_data.Cylinders = 4 ORDER BY cars_data.Horsepower DESC LIMIT 1	car_1
SELECT car_makers.Id, car_makers.Maker FROM cars_data JOIN car_names ON cars_data.Id = car_names.MakeId JOIN car_makers ON car_names.Make = car_makers.Id WHERE cars_data.Horsepower > (SELECT MIN(Horsepower) FROM cars_data) AND cars_data.Cylinders <= 3	car_1
SELECT car_makers.Id, car_makers.FullName FROM car_makers JOIN model_list ON car_makers.Id = model_list.Maker JOIN car_names ON model_list.Model = car_names.Model JOIN cars_data ON car_names.MakeId = cars_data.Id WHERE cars_data.Horsepower <> (SELECT MIN(Horsepower) FROM cars_data) AND cars_data.Cylinders < 4	car_1
select max(MPG) from cars_data where Cylinders = 8 or Year < 1980	car_1
select max(MPG) from cars_data where Cylinders = 8 or Year < 1980	car_1
select T1.Model from model_list as T1 join car_makers as T2 on T1.Maker = T2.Id join car_names as T3 on T1.Model = T3.Model join cars_data as T4 on T3.MakeId = T4.Id where T4.Weight < 3500 and T2.FullName <> "Ford Motor Company"	car_1
select distinct T1.Model from model_list as T1 join car_makers as T2 on T1.Maker = T2.Id join car_names as T3 on T1.Model = T3.Model join cars_data as T4 on T3.MakeId = T4.Id where T4.Weight < 3500 and T2.FullName <> "Ford Motor Company"	car_1
select CountryName from countries where not EXISTS (select 1 from car_makers where car_makers.Country = countries.CountryId)	car_1
select CountryName from countries where not EXISTS (select 1 from car_makers where car_makers.Country = countries.CountryId)	car_1
SELECT car_makers.Id, car_makers.Maker FROM car_makers JOIN model_list ON model_list.Maker = car_makers.Id GROUP BY car_makers.Id, car_makers.Maker HAVING COUNT(model_list.ModelId) >= 2 AND (SELECT COUNT(DISTINCT car_makers.Id) FROM car_makers) > 3	car_1
SELECT car_makers.Id, car_makers.Maker FROM car_makers WHERE (SELECT COUNT(DISTINCT model_list.Model) FROM model_list WHERE model_list.Maker = car_makers.Id) >= 2 AND (SELECT COUNT(*) FROM car_names INNER JOIN cars_data ON car_names.MakeId = cars_data.Id WHERE car_names.Make = car_makers.Id) > 3	car_1
select countries.CountryId, countries.CountryName from countries join car_makers on car_makers.Country = countries.CountryId group by countries.CountryId, countries.CountryName having count(*) > 3 union select countries.CountryId, countries.CountryName from countries join car_makers on car_makers.Country = countries.CountryId join model_list on model_list.Maker = car_makers.Id where model_list.Model = "fiat"	car_1
select countries.CountryId, countries.CountryName from countries join car_makers on countries.CountryId = car_makers.Country group by countries.CountryId having count(car_makers.Maker) > 3 union select countries.CountryId, countries.CountryName from countries join car_makers on car_makers.Country = countries.CountryId join model_list on model_list.Maker = car_makers.Id where model_list.Model = "fiat"	car_1
select count(*) from Documents	cre_Doc_Template_Mgt
select count(*) from Documents	cre_Doc_Template_Mgt
select Document_ID, Document_Name, Document_Description from Documents	cre_Doc_Template_Mgt
select Document_ID, Document_Name, Document_Description from Documents	cre_Doc_Template_Mgt
select Document_Name, Template_ID from Documents where Document_Description like "%w%"	cre_Doc_Template_Mgt
select Document_Name, Template_ID from Documents where Document_Description like "%w%"	cre_Doc_Template_Mgt
select Document_ID, Template_ID, Document_Description from Documents where Document_Name = "Robbin CV"	cre_Doc_Template_Mgt
select Document_ID, Template_ID, Document_Description from Documents where Document_Name = "Robbin CV"	cre_Doc_Template_Mgt
select count(distinct Template_ID) from Documents	cre_Doc_Template_Mgt
select count(distinct Templates.Template_ID) from Documents join Templates on Documents.Template_ID = Templates.Template_ID	cre_Doc_Template_Mgt
select count(*) from Documents join Templates on Documents.Template_ID = Templates.Template_ID where Templates.Template_Type_Code = "PPT"	cre_Doc_Template_Mgt
select count(*) from Documents join Templates on Documents.Template_ID = Templates.Template_ID where Templates.Template_Type_Code = "PPT"	cre_Doc_Template_Mgt
select Templates.Template_ID, count(*) from Templates join Documents on Templates.Template_ID = Documents.Template_ID group by Templates.Template_ID	cre_Doc_Template_Mgt
select T1.Template_ID, count(*) from Templates as T1 join Documents as T2 on T1.Template_ID = T2.Template_ID group by T1.Template_ID	cre_Doc_Template_Mgt
select Templates.Template_ID, Templates.Template_Type_Code from Templates join Documents on Templates.Template_ID = Documents.Template_ID group by Templates.Template_ID order by count(*) desc limit 1	cre_Doc_Template_Mgt
select T.Template_ID, T.Template_Type_Code from Templates as T join Documents as D on T.Template_ID = D.Template_ID group by T.Template_ID, T.Template_Type_Code order by count(*) desc limit 1	cre_Doc_Template_Mgt
select Templates.Template_ID from Templates inner join Documents on Templates.Template_ID = Documents.Template_ID group by Templates.Template_ID having count(*) > 1	cre_Doc_Template_Mgt
select Template_ID from Documents group by Template_ID having count(*) > 1	cre_Doc_Template_Mgt
SELECT template_id FROM Templates EXCEPT SELECT template_id FROM Documents	cre_Doc_Template_Mgt
SELECT template_id FROM Templates EXCEPT SELECT template_id FROM Documents	cre_Doc_Template_Mgt
select count(*) from Templates	cre_Doc_Template_Mgt
select count(*) from Templates	cre_Doc_Template_Mgt
select Template_ID, Version_Number, Template_Type_Code from Templates	cre_Doc_Template_Mgt
select Template_ID, Version_Number, Template_Type_Code from Templates	cre_Doc_Template_Mgt
select distinct Template_Type_Code from Ref_Template_Types	cre_Doc_Template_Mgt
select distinct Template_Type_Code from Ref_Template_Types	cre_Doc_Template_Mgt
SELECT template_id FROM Templates WHERE template_type_code  =  "PP" OR template_type_code  =  "PPT"	cre_Doc_Template_Mgt
SELECT template_id FROM Templates WHERE template_type_code  =  "PP" OR template_type_code  =  "PPT"	cre_Doc_Template_Mgt
select count(*) from Templates where Template_Type_Code = "CV"	cre_Doc_Template_Mgt
select count(*) from Templates where Template_Type_Code = "CV"	cre_Doc_Template_Mgt
select Version_Number, Template_Type_Code from Templates where Version_Number > 5	cre_Doc_Template_Mgt
select Version_Number, Template_Type_Code from Templates where Version_Number > 5	cre_Doc_Template_Mgt
select Ref_Template_Types.Template_Type_Code, count(*) from Ref_Template_Types join Templates on Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code group by Ref_Template_Types.Template_Type_Code	cre_Doc_Template_Mgt
select Template_Type_Code, count(*) from Templates group by Template_Type_Code	cre_Doc_Template_Mgt
select Template_Type_Code from Templates group by Template_Type_Code order by count(*) desc limit 1	cre_Doc_Template_Mgt
select Templates.Template_Type_Code from Templates group by Templates.Template_Type_Code order by count(*) desc limit 1	cre_Doc_Template_Mgt
select Template_Type_Code from Templates group by Template_Type_Code having count(*) < 3	cre_Doc_Template_Mgt
select T1.Template_Type_Code from Ref_Template_Types as T1 join Templates as T2 on T1.Template_Type_Code = T2.Template_Type_Code group by T1.Template_Type_Code having count(*) < 3	cre_Doc_Template_Mgt
SELECT min(Version_Number) ,  template_type_code FROM Templates	cre_Doc_Template_Mgt
SELECT min(Version_Number) ,  template_type_code FROM Templates	cre_Doc_Template_Mgt
select T1.Template_Type_Code from Documents as T1 join Templates as T2 on T1.Template_ID = T2.Template_ID where T1.Document_Name = "Data base"	cre_Doc_Template_Mgt
SELECT T1.template_type_code FROM Templates AS T1 JOIN Documents AS T2 ON T1.template_id  =  T2.template_id WHERE T2.document_name  =  "Data base"	cre_Doc_Template_Mgt
select T1.Document_Name from Documents as T1 join Templates as T2 on T1.Template_ID = T2.Template_ID where T2.Template_Type_Code = "BK"	cre_Doc_Template_Mgt
select T1.Document_Name from Documents as T1 join Templates as T2 on T1.Template_ID = T2.Template_ID where T2.Template_Type_Code = "BK"	cre_Doc_Template_Mgt
select Ref_Template_Types.Template_Type_Code, count(*) from Ref_Template_Types join Templates on Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code join Documents on Templates.Template_ID = Documents.Template_ID group by Ref_Template_Types.Template_Type_Code	cre_Doc_Template_Mgt
SELECT T1.template_type_code ,  count(*) FROM Templates AS T1 JOIN Documents AS T2 ON T1.template_id  =  T2.template_id GROUP BY T1.template_type_code	cre_Doc_Template_Mgt
select Ref_Template_Types.Template_Type_Code from Documents join Templates on Documents.Template_ID = Templates.Template_ID join Ref_Template_Types on Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code group by Ref_Template_Types.Template_Type_Code order by count(*) desc limit 1	cre_Doc_Template_Mgt
select Templates.Template_Type_Code from Documents join Templates on Documents.Template_ID = Templates.Template_ID group by Templates.Template_Type_Code order by count(*) desc limit 1	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types where Template_Type_Code not in (select Template_Type_Code from Templates)	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types except select distinct t.Template_Type_Code from Templates t join Documents d on t.Template_ID = d.Template_ID	cre_Doc_Template_Mgt
select Template_Type_Code, Template_Type_Description from Ref_Template_Types	cre_Doc_Template_Mgt
select Template_Type_Code, Template_Type_Description from Ref_Template_Types	cre_Doc_Template_Mgt
select Template_Type_Description from Ref_Template_Types where Template_Type_Code = "AD"	cre_Doc_Template_Mgt
select Template_Type_Description from Ref_Template_Types where Template_Type_Code = "AD"	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types where Template_Type_Description = "Book"	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types where Template_Type_Description = "Book"	cre_Doc_Template_Mgt
select distinct Ref_Template_Types.Template_Type_Description from Ref_Template_Types join Templates on Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code join Documents on Templates.Template_ID = Documents.Template_ID	cre_Doc_Template_Mgt
select distinct Ref_Template_Types.Template_Type_Description from Ref_Template_Types join Templates on Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code join Documents on Templates.Template_ID = Documents.Template_ID	cre_Doc_Template_Mgt
select Templates.Template_ID from Templates join Ref_Template_Types on Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code where Ref_Template_Types.Template_Type_Description = "Presentation"	cre_Doc_Template_Mgt
select T1.Template_ID from Templates as T1 join Ref_Template_Types as T2 on T1.Template_Type_Code = T2.Template_Type_Code where T2.Template_Type_Description = "Presentation"	cre_Doc_Template_Mgt
select count(*) from Paragraphs	cre_Doc_Template_Mgt
select count(*) from Paragraphs	cre_Doc_Template_Mgt
SELECT count(*) FROM Paragraphs AS T1 JOIN Documents AS T2 ON T1.document_ID  =  T2.document_ID WHERE T2.document_name  =  'Summer Show'	cre_Doc_Template_Mgt
select count(*) from Paragraphs join Documents on Paragraphs.Document_ID = Documents.Document_ID where Documents.Document_Name = "Summer Show"	cre_Doc_Template_Mgt
select Paragraph_ID, Document_ID, Paragraph_Text, Other_Details from Paragraphs where Paragraph_Text = "Korea"	cre_Doc_Template_Mgt
select Paragraph_ID, Document_ID, Paragraph_Text, Other_Details from Paragraphs where Paragraph_Text like "%Korea%"	cre_Doc_Template_Mgt
select Paragraphs.Paragraph_ID, Paragraphs.Paragraph_Text from Paragraphs join Documents on Documents.Document_ID = Paragraphs.Document_ID where Documents.Document_Name = "Welcome to NY"	cre_Doc_Template_Mgt
SELECT T1.paragraph_id ,   T1.paragraph_text FROM Paragraphs AS T1 JOIN Documents AS T2 ON T1.document_id  =  T2.document_id WHERE T2.Document_Name  =  'Welcome to NY'	cre_Doc_Template_Mgt
select Paragraphs.Paragraph_Text from Paragraphs join Documents on Paragraphs.Document_ID = Documents.Document_ID where Documents.Document_Name = "Customer reviews"	cre_Doc_Template_Mgt
select Paragraphs.Paragraph_Text from Paragraphs join Documents on Paragraphs.Document_ID = Documents.Document_ID where Documents.Document_Name = "Customer reviews"	cre_Doc_Template_Mgt
select Documents.Document_ID, count(*) from Documents join Paragraphs on Documents.Document_ID = Paragraphs.Document_ID group by Documents.Document_ID order by Documents.Document_ID	cre_Doc_Template_Mgt
select Documents.Document_ID, count(*) from Documents join Paragraphs on Documents.Document_ID = Paragraphs.Document_ID group by Documents.Document_ID order by Documents.Document_ID asc	cre_Doc_Template_Mgt
select T1.Document_ID, T1.Document_Name, count(T2.Paragraph_ID) from Documents as T1 left join Paragraphs as T2 on T1.Document_ID = T2.Document_ID group by T1.Document_ID, T1.Document_Name	cre_Doc_Template_Mgt
select T1.Document_ID, T1.Document_Name, count(T2.Paragraph_ID) from Documents as T1 left join Paragraphs as T2 on T1.Document_ID = T2.Document_ID group by T1.Document_ID	cre_Doc_Template_Mgt
SELECT document_id FROM Paragraphs GROUP BY document_id HAVING count(*)  >=  2	cre_Doc_Template_Mgt
select T1.Document_ID from Documents as T1 join Paragraphs as T2 on T1.Document_ID = T2.Document_ID group by T1.Document_ID having count(T2.Paragraph_ID) >= 2	cre_Doc_Template_Mgt
SELECT T1.document_id ,  T2.document_name FROM Paragraphs AS T1 JOIN Documents AS T2 ON T1.document_id  =  T2.document_id GROUP BY T1.document_id ORDER BY count(*) DESC LIMIT 1	cre_Doc_Template_Mgt
SELECT T1.document_id ,  T2.document_name FROM Paragraphs AS T1 JOIN Documents AS T2 ON T1.document_id  =  T2.document_id GROUP BY T1.document_id ORDER BY count(*) DESC LIMIT 1	cre_Doc_Template_Mgt
select p.Document_ID from Documents as T1 join Paragraphs as T2 on T1.Document_ID = T2.Document_ID group by p.Document_ID order by count(*) asc limit 1	cre_Doc_Template_Mgt
select Paragraphs.Document_ID from Paragraphs group by Paragraphs.Document_ID order by count(*) asc limit 1	cre_Doc_Template_Mgt
SELECT document_id FROM Paragraphs GROUP BY document_id HAVING count(*) BETWEEN 1 AND 2	cre_Doc_Template_Mgt
SELECT document_id FROM Paragraphs GROUP BY document_id HAVING count(*) BETWEEN 1 AND 2	cre_Doc_Template_Mgt
SELECT document_id FROM Paragraphs WHERE paragraph_text  =  'Brazil' INTERSECT SELECT document_id FROM Paragraphs WHERE paragraph_text  =  'Ireland'	cre_Doc_Template_Mgt
SELECT document_id FROM Paragraphs WHERE paragraph_text  =  'Brazil' INTERSECT SELECT document_id FROM Paragraphs WHERE paragraph_text  =  'Ireland'	cre_Doc_Template_Mgt
select state from Owners intersect select state from Professionals	dog_kennels
select distinct state from Owners intersect select distinct state from Professionals	dog_kennels
SELECT AVG(Dogs.age) FROM Dogs INNER JOIN Treatments ON Dogs.dog_id = Treatments.dog_id	dog_kennels
select avg(T1.age) from Dogs as T1 where T1.dog_id in (select T2.dog_id from Treatments as T2)	dog_kennels
select T1.professional_id, T1.last_name, T1.cell_number from Professionals as T1 where T1.state = "Indiana" or (select count(*) from Treatments as T2 where T2.professional_id = T1.professional_id) > 2	dog_kennels
select P.professional_id, P.last_name, P.cell_number from Professionals as P left join Treatments as T on P.professional_id = T.professional_id group by P.professional_id, P.last_name, P.cell_number having count(T.treatment_id) > 2 or max(P.state = "Indiana") = 1	dog_kennels
select name from Dogs where dog_id not in (select dog_id from Treatments group by dog_id having sum(cost_of_treatment) > 1000)	dog_kennels
SELECT Dogs.name FROM Dogs WHERE NOT Dogs.dog_id IN (SELECT dog_id FROM Treatments GROUP BY dog_id HAVING SUM(cost_of_treatment) > 1000)	dog_kennels
SELECT first_name FROM (SELECT first_name FROM Owners UNION SELECT first_name FROM Professionals) AS combined WHERE NOT first_name IN (SELECT name FROM Dogs)	dog_kennels
select first_name from Owners except select name from Dogs union select first_name from Professionals except select name from Dogs	dog_kennels
select professional_id, role_code, email_address from Professionals where professional_id not in (select professional_id from Treatments)	dog_kennels
select professional_id, role_code, email_address from Professionals where professional_id not in (select professional_id from Treatments)	dog_kennels
select Owners.owner_id, Owners.first_name, Owners.last_name from Owners join Dogs on Owners.owner_id = Dogs.owner_id group by Owners.owner_id order by count(*) desc limit 1	dog_kennels
SELECT T1.owner_id ,  T2.first_name ,  T2.last_name FROM Dogs AS T1 JOIN Owners AS T2 ON T1.owner_id  =  T2.owner_id GROUP BY T1.owner_id ORDER BY count(*) DESC LIMIT 1	dog_kennels
select Professionals.professional_id, Professionals.role_code, Professionals.first_name from Professionals join Treatments on Professionals.professional_id = Treatments.professional_id group by Professionals.professional_id having count(*) >= 2	dog_kennels
select Professionals.professional_id , Professionals.role_code, Professionals.first_name from Professionals join Treatments on Professionals.professional_id = Treatments.professional_id group by Professionals.professional_id having count(*) >= 2	dog_kennels
SELECT T1.breed_name FROM Breeds AS T1 JOIN Dogs AS T2 ON T1.breed_code  =  T2.breed_code GROUP BY T1.breed_name ORDER BY count(*) DESC LIMIT 1	dog_kennels
SELECT T1.breed_name FROM Breeds AS T1 JOIN Dogs AS T2 ON T1.breed_code  =  T2.breed_code GROUP BY T1.breed_name ORDER BY count(*) DESC LIMIT 1	dog_kennels
SELECT o.owner_id, o.last_name FROM Owners AS o JOIN Dogs AS d ON o.owner_id = d.owner_id JOIN Treatments AS t ON d.dog_id = t.dog_id GROUP BY o.owner_id, o.last_name ORDER BY COUNT(*) DESC LIMIT 1	dog_kennels
SELECT O.owner_id, O.last_name FROM Owners AS O JOIN Dogs AS D ON O.owner_id = D.owner_id JOIN Treatments AS T ON D.dog_id = T.dog_id GROUP BY O.owner_id, O.last_name ORDER BY SUM(T.cost_of_treatment) DESC LIMIT 1	dog_kennels
SELECT T1.treatment_type_description FROM Treatment_types AS T1 JOIN Treatments AS T2 ON T1.treatment_type_code  =  T2.treatment_type_code GROUP BY T1.treatment_type_code ORDER BY sum(cost_of_treatment) ASC LIMIT 1	dog_kennels
select T1.treatment_type_description from Treatment_Types as T1 join Treatments as T2 on T1.treatment_type_code = T2.treatment_type_code group by T1.treatment_type_code order by sum(T2.cost_of_treatment) asc limit 1	dog_kennels
SELECT Owners.owner_id, Owners.zip_code FROM Owners JOIN Dogs ON Dogs.owner_id = Owners.owner_id JOIN Charges ON Charges.charge_id = Dogs.dog_id GROUP BY Owners.owner_id, Owners.zip_code ORDER BY SUM(Charges.charge_amount) DESC LIMIT 1	dog_kennels
SELECT T1.owner_id ,  T1.zip_code FROM Owners AS T1 JOIN Dogs AS T2 ON T1.owner_id  =  T2.owner_id JOIN Treatments AS T3 ON T2.dog_id  =  T3.dog_id GROUP BY T1.owner_id ORDER BY sum(T3.cost_of_treatment) DESC LIMIT 1	dog_kennels
select Professionals.professional_id, Professionals.cell_number from Professionals join Treatments on Professionals.professional_id = Treatments.professional_id group by Professionals.professional_id, Professionals.cell_number having count(distinct Treatments.treatment_type_code) >= 2	dog_kennels
select Professionals.professional_id, Professionals.cell_number from Professionals join Treatments on Treatments.professional_id = Professionals.professional_id join Treatment_Types on Treatments.treatment_type_code = Treatment_Types.treatment_type_code group by Professionals.professional_id, Professionals.cell_number having count(distinct Treatment_Types.treatment_type_code) >= 2	dog_kennels
SELECT Professionals.first_name, Professionals.last_name FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id WHERE Treatments.cost_of_treatment < (SELECT AVG(cost_of_treatment) FROM Treatments)	dog_kennels
SELECT Professionals.first_name, Professionals.last_name FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id WHERE Treatments.cost_of_treatment < (SELECT AVG(cost_of_treatment) FROM Treatments)	dog_kennels
select T1.date_of_treatment, T2.first_name from Treatments as T1 join Professionals as T2 on T1.professional_id = T2.professional_id	dog_kennels
select Treatments.date_of_treatment, Professionals.first_name from Treatments join Professionals on Treatments.professional_id = Professionals.professional_id	dog_kennels
select Treatments.cost_of_treatment, Treatment_Types.treatment_type_description from Treatments join Treatment_Types on Treatments.treatment_type_code = Treatment_Types.treatment_type_code	dog_kennels
select Treatments.cost_of_treatment, Treatment_Types.treatment_type_description from Treatments join Treatment_Types on Treatments.treatment_type_code = Treatment_Types.treatment_type_code	dog_kennels
SELECT Owners.first_name, Owners.last_name, Sizes.size_description FROM Owners JOIN Dogs ON Owners.owner_id = Dogs.owner_id JOIN Sizes ON Dogs.size_code = Sizes.size_code	dog_kennels
SELECT Owners.first_name, Owners.last_name, Sizes.size_description FROM Owners JOIN Dogs ON Owners.owner_id = Dogs.owner_id JOIN Sizes ON Dogs.size_code = Sizes.size_code	dog_kennels
select T1.first_name, T2.name from Owners as T1 join Dogs as T2 on T1.owner_id = T2.owner_id	dog_kennels
select Owners.first_name, Dogs.name from Owners join Dogs on Owners.owner_id = Dogs.owner_id	dog_kennels
select Dogs.name, Treatments.date_of_treatment from Dogs join Treatments on Dogs.dog_id = Treatments.dog_id where Dogs.breed_code = (select breed_code from (select breed_code, count(*) from Dogs group by breed_code order by breed_count asc limit 1)) order by Treatments.date_of_treatment asc	dog_kennels
select Dogs.name, Treatments.date_of_treatment from Dogs join Treatments on Dogs.dog_id = Treatments.dog_id where Dogs.breed_code = (select Breeds.breed_code from Breeds left join Dogs on Dogs.breed_code = Breeds.breed_code group by Breeds.breed_code order by count(Dogs.dog_id) asc limit 1)	dog_kennels
select T1.first_name, T2.name from Owners as T1 join Dogs as T2 on T1.owner_id = T2.owner_id where T1.state = "Virginia"	dog_kennels
select Owners.first_name, Dogs.name from Owners join Dogs on Owners.owner_id = Dogs.owner_id where Owners.state = "Virginia"	dog_kennels
select Dogs.date_arrived, Dogs.date_departed from Dogs join Treatments on Dogs.dog_id = Treatments.dog_id	dog_kennels
select T1.date_arrived, T1.date_departed from Dogs as T1 join Treatments as T2 on T1.dog_id = T2.dog_id	dog_kennels
SELECT last_name FROM Owners JOIN Dogs ON Owners.owner_id = Dogs.owner_id ORDER BY Dogs.age ASC LIMIT 1	dog_kennels
SELECT Owners.last_name FROM Dogs JOIN Owners ON Dogs.owner_id = Owners.owner_id ORDER BY Dogs.age ASC LIMIT 1	dog_kennels
SELECT email_address FROM Professionals WHERE state  =  'Hawaii' OR state  =  'Wisconsin'	dog_kennels
SELECT email_address FROM Professionals WHERE state  =  'Hawaii' OR state  =  'Wisconsin'	dog_kennels
select date_arrived, date_departed from Dogs	dog_kennels
select date_arrived, date_departed from Dogs	dog_kennels
SELECT count(DISTINCT dog_id) FROM Treatments	dog_kennels
select count(distinct Dogs.dog_id) from Dogs join Treatments on Dogs.dog_id = Treatments.dog_id	dog_kennels
select count(distinct T2.professional_id) from Treatments as T1 join Professionals as T2 on T1.professional_id = T2.professional_id where T1.dog_id is not null	dog_kennels
select count(distinct T1.professional_id) from Professionals as T1 join Treatments as T2 on T1.professional_id = T2.professional_id join Dogs as T3 on T2.dog_id = T3.dog_id	dog_kennels
select role_code, street, city, state from Professionals where city like "%West%"	dog_kennels
select role_code, street, city, state from Professionals where city like "%West%"	dog_kennels
select first_name, last_name, email_address from Owners where state like "%North%"	dog_kennels
select first_name, last_name, email_address from Owners where state like "%North%"	dog_kennels
select count(*) from Dogs where age < (select avg(age) from Dogs)	dog_kennels
select count(*) from Dogs where age < (select avg(age) from Dogs)	dog_kennels
select cost_of_treatment from Treatments order by date_of_treatment desc limit 1	dog_kennels
select cost_of_treatment from Treatments order by date_of_treatment desc limit 1	dog_kennels
select count(*) from Dogs where dog_id not in (select dog_id from Treatments)	dog_kennels
select count(*) from Dogs where dog_id not in (select dog_id from Treatments)	dog_kennels
select count(*) from Owners where owner_id not in (select owner_id from Dogs)	dog_kennels
select count(*) from Owners where not EXISTS (select 1 from Dogs where Dogs.owner_id = Owners.owner_id)	dog_kennels
SELECT count(*) FROM Professionals WHERE professional_id NOT IN ( SELECT professional_id FROM Treatments )	dog_kennels
select count(*) from Professionals where professional_id not in (select professional_id from Treatments)	dog_kennels
select name, age, weight from Dogs where abandoned_yn = 1	dog_kennels
select name, age, weight from Dogs where abandoned_yn = "1"	dog_kennels
select avg(age) from Dogs	dog_kennels
select avg(age) from Dogs	dog_kennels
select max(age) from Dogs	dog_kennels
select max(age) from Dogs	dog_kennels
select charge_type, charge_amount from Charges	dog_kennels
select charge_type, charge_amount from Charges	dog_kennels
select charge_amount from Charges order by charge_amount desc limit 1	dog_kennels
select charge_amount from Charges order by charge_amount desc limit 1	dog_kennels
select email_address, cell_number, home_phone from Professionals	dog_kennels
select email_address, cell_number, home_phone from Professionals	dog_kennels
SELECT Breeds.breed_name, Sizes.size_description FROM Dogs JOIN Breeds ON Dogs.breed_code = Breeds.breed_code JOIN Sizes ON Dogs.size_code = Sizes.size_code	dog_kennels
SELECT Breeds.breed_name, Sizes.size_description FROM Dogs JOIN Breeds ON Dogs.breed_code = Breeds.breed_code JOIN Sizes ON Dogs.size_code = Sizes.size_code GROUP BY Breeds.breed_name, Sizes.size_description	dog_kennels
select Professionals.first_name, Treatment_Types.treatment_type_description from Professionals join Treatments on Professionals.professional_id = Treatments.professional_id join Treatment_Types on Treatments.treatment_type_code = Treatment_Types.treatment_type_code	dog_kennels
select Professionals.first_name, Treatment_Types.treatment_type_description from Treatments join Professionals on Treatments.professional_id = Professionals.professional_id join Treatment_Types on Treatments.treatment_type_code = Treatment_Types.treatment_type_code	dog_kennels
select Country from airlines where Airline = "JetBlue Airways"	flight_2
select Country from airlines where Airline = "JetBlue Airways"	flight_2
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
SELECT count(*) FROM AIRLINES WHERE Country  =  "USA"	flight_2
select City, Country from airports where AirportName = "Alton"	flight_2
select City, Country from airports where AirportName = "Alton"	flight_2
select AirportName from airports where AirportCode = "AKO"	flight_2
select AirportName from airports where AirportCode = "AKO"	flight_2
select AirportName from airports where City = "Aberdeen"	flight_2
select AirportName from airports where City = "Aberdeen"	flight_2
select count(*) from flights where SourceAirport = " APG"	flight_2
select count(*) from flights where SourceAirport = "APG"	flight_2
select count(*) from flights where DestAirport = "ATO"	flight_2
select count(*) from flights where DestAirport = "ATO"	flight_2
select count(*) from flights join airports on flights.SourceAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
SELECT count(*) FROM FLIGHTS AS T1 JOIN AIRPORTS AS T2 ON T1.SourceAirport  =  T2.AirportCode WHERE T2.City  =  "Aberdeen"	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where airports.City = "Aberdeen "	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where airports.City = "Aberdeen "	flight_2
select count(*) from flights join airports as source_airport on flights.SourceAirport = source_airport.AirportCode join airports as dest_airport on flights.DestAirport = dest_airport.AirportCode where source_airport.City = "Aberdeen " and dest_airport.City = "Ashley"	flight_2
select count(*) from flights where SourceAirport = "APG" and DestAirport = "ASY"	flight_2
select count(*) from flights where Airline = "JetBlue Airways"	flight_2
SELECT count(*) FROM FLIGHTS AS T1 JOIN AIRLINES AS T2 ON T1.Airline  =  T2.uid WHERE T2.Airline = "JetBlue Airways"	flight_2
select count(*) from flights as T1 join airlines as T2 on T1.Airline = T2.uid where T2.Airline = "United Airlines" and T1.DestAirport = " ASY"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid where airlines.Airline = "United Airlines" and flights.DestAirport = "ASY"	flight_2
SELECT count(*) FROM AIRLINES AS T1 JOIN FLIGHTS AS T2 ON T2.Airline  =  T1.uid WHERE T1.Airline  =  "United Airlines" AND T2.SourceAirport  =  "AHD"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid where flights.SourceAirport = "AHD" and airlines.Airline = "United Airlines"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid join airports on flights.DestAirport = airports.AirportCode where airlines.Airline = "United Airlines" and airports.City = "Aberdeen"	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where flights.Airline = "United Airlines" and airports.City = "Aberdeen "	flight_2
SELECT T1.City FROM AIRPORTS AS T1 JOIN FLIGHTS AS T2 ON T1.AirportCode  =  T2.DestAirport GROUP BY T1.City ORDER BY count(*) DESC LIMIT 1	flight_2
select airports.City from flights inner join airports on flights.DestAirport = airports.AirportCode group by airports.City order by count(*) desc limit 1	flight_2
select T1.City from airports as T1 join flights as T2 on T2.SourceAirport = T1.AirportCode group by T1.City order by count(*) desc limit 1	flight_2
select airports.City from flights join airports on flights.SourceAirport = airports.AirportCode group by airports.City order by count(*) desc limit 1	flight_2
SELECT T1.AirportCode FROM AIRPORTS AS T1 JOIN FLIGHTS AS T2 ON T1.AirportCode  =  T2.DestAirport OR T1.AirportCode  =  T2.SourceAirport GROUP BY T1.AirportCode ORDER BY count(*) DESC LIMIT 1	flight_2
select a.AirportCode from airports as a join flights as f on f.SourceAirport = a.AirportCode group by a.AirportCode order by count(*) desc limit 1	flight_2
select a.AirportCode from airports as a join flights as f on a.AirportCode = f.SourceAirport group by a.AirportCode order by count(*) asc limit 1	flight_2
select a.AirportCode from airports as a join flights as f on a.AirportCode = f.SourceAirport group by a.AirportCode order by count(*) asc limit 1	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.Airline order by count(*) desc limit 1	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.uid order by count(T2.Airline) desc limit 1	flight_2
SELECT T1.Abbreviation ,  T1.Country FROM AIRLINES AS T1 JOIN FLIGHTS AS T2 ON T1.uid  =  T2.Airline GROUP BY T1.Airline ORDER BY count(*) LIMIT 1	flight_2
SELECT T1.Abbreviation ,  T1.Country FROM AIRLINES AS T1 JOIN FLIGHTS AS T2 ON T1.uid  =  T2.Airline GROUP BY T1.Airline ORDER BY count(*) LIMIT 1	flight_2
select distinct airlines.Airline from airlines join flights on airlines.Airline = flights.Airline where flights.SourceAirport = "AHD"	flight_2
select distinct T1.Airline from airlines as T1 join flights as T2 on T1.Airline = T2.Airline where T2.SourceAirport = "AHD"	flight_2
select distinct airlines.Airline from airlines join flights on airlines.Airline = flights.Airline where flights.DestAirport = "AHD"	flight_2
select distinct airlines.Airline from airlines join flights on airlines.Airline = flights.Airline where flights.DestAirport = "AHD"	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport = "APG" intersect select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport = "CVO"	flight_2
select distinct Airline from flights where SourceAirport = "APG" intersect select distinct Airline from flights where SourceAirport = "CVO"	flight_2
SELECT T1.Airline FROM AIRLINES AS T1 JOIN FLIGHTS AS T2 ON T1.uid  =  T2.Airline WHERE T2.SourceAirport  =  "CVO" EXCEPT SELECT T1.Airline FROM AIRLINES AS T1 JOIN FLIGHTS AS T2 ON T1.uid  =  T2.Airline WHERE T2.SourceAirport  =  "APG"	flight_2
select T1.Airline from airlines as T1 join (select distinct Airline from flights where SourceAirport = "CVO" except select distinct Airline from flights where SourceAirport = "APG") on T1.Airline = T2.Airline	flight_2
select airlines.Airline from airlines join flights on airlines.Airline = flights.Airline group by airlines.Airline having count(*) >= 10	flight_2
select airlines.Airline from flights join airlines on flights.Airline = airlines.Airline group by airlines.Airline having count(*) >= 10	flight_2
select airlines.Airline from airlines join flights on airlines.Airline = flights.Airline group by airlines.Airline having count(*) < 200	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.Airline = T2.Airline group by T1.Airline having count(*) < 200	flight_2
select flights.FlightNo from flights join airlines on flights.Airline = airlines.Airline where airlines.Airline = "United Airlines"	flight_2
select FlightNo from flights where Airline = "United Airlines"	flight_2
select FlightNo from flights where SourceAirport = " APG"	flight_2
select FlightNo from flights where SourceAirport = " APG"	flight_2
select FlightNo from flights where DestAirport = "APG"	flight_2
select FlightNo from flights where DestAirport = "APG"	flight_2
select flights.FlightNo from flights join airports on flights.SourceAirport = airports.AirportCode where airports.City = "Aberdeen "	flight_2
SELECT T1.FlightNo FROM FLIGHTS AS T1 JOIN AIRPORTS AS T2 ON T1.SourceAirport   =  T2.AirportCode WHERE T2.City  =  "Aberdeen"	flight_2
select T1.FlightNo from flights as T1 join airports as T2 on T1.DestAirport = T2.AirportCode where T2.City = "Aberdeen "	flight_2
select T1.FlightNo from flights as T1 join airports as T2 on T1.DestAirport = T2.AirportCode where T2.City = "Aberdeen"	flight_2
SELECT count(*) FROM Flights AS T1 JOIN Airports AS T2 ON T1.DestAirport  =  T2.AirportCode WHERE T2.city  =  "Aberdeen" OR T2.city  =  "Abilene"	flight_2
SELECT count(*) FROM Flights AS T1 JOIN Airports AS T2 ON T1.DestAirport  =  T2.AirportCode WHERE T2.city  =  "Aberdeen" OR T2.city  =  "Abilene"	flight_2
select AirportName from airports where AirportCode not in (select SourceAirport from flights union select DestAirport from flights)	flight_2
select AirportCode, AirportName from airports where AirportCode not in (select SourceAirport from flights union select DestAirport from flights)	flight_2
select line_1, line_2 from Addresses	student_transcripts_tracking
select line_1, line_2 from Addresses	student_transcripts_tracking
select count(*) from Courses	student_transcripts_tracking
select count(*) from Courses	student_transcripts_tracking
select course_description from Courses where course_name = "math"	student_transcripts_tracking
SELECT course_description FROM Courses WHERE course_name  =  'math'	student_transcripts_tracking
select zip_postcode from Addresses where city = "Port Chelsea"	student_transcripts_tracking
select zip_postcode from Addresses where city = "Port Chelsea"	student_transcripts_tracking
SELECT T2.department_name ,  T1.department_id FROM Degree_Programs AS T1 JOIN Departments AS T2 ON T1.department_id  =  T2.department_id GROUP BY T1.department_id ORDER BY count(*) DESC LIMIT 1	student_transcripts_tracking
select t2.department_name ,  t1.department_id from degree_programs as t1 join departments as t2 on t1.department_id  =  t2.department_id group by t1.department_id order by count(*) desc limit 1	student_transcripts_tracking
select count(distinct department_id) from Degree_Programs	student_transcripts_tracking
select count(distinct T1.department_id) from Departments as T1 join Degree_Programs as T2 on T1.department_id = T2.department_id	student_transcripts_tracking
select count(distinct degree_summary_name) from Degree_Programs	student_transcripts_tracking
select count(distinct degree_summary_name) from Degree_Programs	student_transcripts_tracking
select count(*) as "Number of Degrees" from Degree_Programs join Departments on Degree_Programs.department_id = Departments.department_id where Departments.department_name = "engineering"	student_transcripts_tracking
select count(*) from Degree_Programs join Departments on Degree_Programs.department_id = Departments.department_id where Departments.department_name = "engineering"	student_transcripts_tracking
select section_name, section_description from Sections	student_transcripts_tracking
select section_name, section_description from Sections	student_transcripts_tracking
SELECT T1.course_name ,  T1.course_id FROM Courses AS T1 JOIN Sections AS T2 ON T1.course_id  =  T2.course_id GROUP BY T1.course_id HAVING count(*)  <=  2	student_transcripts_tracking
SELECT course_name, course_id FROM Courses WHERE NOT course_id IN (SELECT course_id FROM Sections GROUP BY course_id HAVING COUNT(section_id) >= 2)	student_transcripts_tracking
select section_name from Sections order by section_name desc	student_transcripts_tracking
select section_name from Sections order by section_name desc	student_transcripts_tracking
SELECT T1.semester_name ,  T1.semester_id FROM Semesters AS T1 JOIN Student_Enrolment AS T2 ON T1.semester_id  =  T2.semester_id GROUP BY T1.semester_id ORDER BY count(*) DESC LIMIT 1	student_transcripts_tracking
SELECT T1.semester_name ,  T1.semester_id FROM Semesters AS T1 JOIN Student_Enrolment AS T2 ON T1.semester_id  =  T2.semester_id GROUP BY T1.semester_id ORDER BY count(*) DESC LIMIT 1	student_transcripts_tracking
SELECT department_description FROM Departments WHERE department_name LIKE '%the computer%'	student_transcripts_tracking
select department_description from Departments where department_name like "%computer%"	student_transcripts_tracking
SELECT s.first_name, s.middle_name, s.last_name, s.student_id FROM Students AS s JOIN Student_Enrolment AS se ON s.student_id = se.student_id GROUP BY s.first_name, s.middle_name, s.last_name, s.student_id HAVING COUNT(DISTINCT se.degree_program_id) = 2	student_transcripts_tracking
SELECT Students.first_name, Students.middle_name, Students.last_name, Students.student_id FROM Students JOIN Student_Enrolment ON Students.student_id = Student_Enrolment.student_id JOIN (SELECT student_id, semester_id FROM Student_Enrolment GROUP BY student_id, semester_id HAVING COUNT(DISTINCT degree_program_id) = 2) AS EnrolledTwice ON Students.student_id = EnrolledTwice.student_id AND Student_Enrolment.semester_id = EnrolledTwice.semester_id	student_transcripts_tracking
select Students.first_name, Students.middle_name, Students.last_name from Students join Student_Enrolment on Students.student_id = Student_Enrolment.student_id join Degree_Programs on Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id where Degree_Programs.degree_summary_name = "Bachelor"	student_transcripts_tracking
select Students.first_name, Students.middle_name, Students.last_name from Students join Student_Enrolment on Students.student_id = Student_Enrolment.student_id join Degree_Programs on Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id where Degree_Programs.degree_summary_name = "Bachelor"	student_transcripts_tracking
SELECT T1.degree_summary_name FROM Degree_Programs AS T1 JOIN Student_Enrolment AS T2 ON T1.degree_program_id  =  T2.degree_program_id GROUP BY T1.degree_summary_name ORDER BY count(*) DESC LIMIT 1	student_transcripts_tracking
SELECT T1.degree_summary_name FROM Degree_Programs AS T1 JOIN Student_Enrolment AS T2 ON T1.degree_program_id  =  T2.degree_program_id GROUP BY T1.degree_summary_name ORDER BY count(*) DESC LIMIT 1	student_transcripts_tracking
SELECT Degree_Programs.degree_program_id, Degree_Programs.degree_summary_description FROM Degree_Programs JOIN Student_Enrolment ON Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id GROUP BY Degree_Programs.degree_program_id, Degree_Programs.degree_summary_description ORDER BY COUNT(Student_Enrolment.student_id) DESC LIMIT 1	student_transcripts_tracking
SELECT Degree_Programs.degree_program_id, Degree_Programs.degree_summary_name FROM Degree_Programs JOIN Student_Enrolment ON Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id GROUP BY Degree_Programs.degree_program_id, Degree_Programs.degree_summary_name ORDER BY COUNT(*) DESC LIMIT 1	student_transcripts_tracking
SELECT s.student_id, s.first_name, s.middle_name, s.last_name, COUNT(*) AS number_of_enrollments, s.student_id AS student_id_duplicate FROM Students AS s JOIN Student_Enrolment AS se ON s.student_id = se.student_id GROUP BY s.student_id, s.first_name, s.middle_name, s.last_name ORDER BY number_of_enrollments DESC LIMIT 1	student_transcripts_tracking
SELECT S.first_name, S.middle_name, S.last_name, S.student_id, COUNT(*) AS number_of_enrollments FROM Students AS S JOIN Student_Enrolment AS SE ON S.student_id = SE.student_id GROUP BY S.student_id, S.first_name, S.middle_name, S.last_name ORDER BY number_of_enrollments DESC LIMIT 1	student_transcripts_tracking
select semester_name from Semesters where semester_id not in (select semester_id from Student_Enrolment)	student_transcripts_tracking
select semester_name from Semesters left join Student_Enrolment on Semesters.semester_id = Student_Enrolment.semester_id where Student_Enrolment.semester_id is null	student_transcripts_tracking
select distinct Courses.course_name from Courses join Student_Enrolment_Courses on Courses.course_id = Student_Enrolment_Courses.course_id where EXISTS (select 1 from Student_Enrolment where Student_Enrolment.student_enrolment_id = Student_Enrolment_Courses.student_enrolment_id)	student_transcripts_tracking
select distinct T1.course_name from Courses as T1 join Student_Enrolment_Courses as T2 on T1.course_id = T2.course_id	student_transcripts_tracking
SELECT Courses.course_name FROM Courses JOIN Student_Enrolment_Courses ON Courses.course_id = Student_Enrolment_Courses.course_id GROUP BY Student_Enrolment_Courses.course_id ORDER BY COUNT(*) DESC LIMIT 1	student_transcripts_tracking
SELECT course_name FROM Courses JOIN Student_Enrolment_Courses ON Courses.course_id = Student_Enrolment_Courses.course_id GROUP BY course_name ORDER BY COUNT(*) DESC LIMIT 1	student_transcripts_tracking
SELECT Students.last_name FROM Students WHERE Students.current_address_id IN (SELECT address_id FROM Addresses WHERE state_province_county = 'North Carolina') AND NOT Students.student_id IN (SELECT student_id FROM Student_Enrolment)	student_transcripts_tracking
SELECT S.last_name FROM Students AS S JOIN Addresses AS A ON S.current_address_id = A.address_id WHERE A.state_province_county = 'NorthCarolina' AND NOT S.student_id IN (SELECT student_id FROM Student_Enrolment)	student_transcripts_tracking
SELECT T2.transcript_date ,  T1.transcript_id FROM Transcript_Contents AS T1 JOIN Transcripts AS T2 ON T1.transcript_id  =  T2.transcript_id GROUP BY T1.transcript_id HAVING count(*)  >=  2	student_transcripts_tracking
SELECT T2.transcript_date ,  T1.transcript_id FROM Transcript_Contents AS T1 JOIN Transcripts AS T2 ON T1.transcript_id  =  T2.transcript_id GROUP BY T1.transcript_id HAVING count(*)  >=  2	student_transcripts_tracking
select cell_mobile_number from Students where first_name = "Timmothy" and last_name = "Ward"	student_transcripts_tracking
SELECT cell_mobile_number FROM Students WHERE first_name = 'Timmothy' AND last_name = 'Ward'	student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_first_registered asc limit 1	student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_first_registered asc limit 1	student_transcripts_tracking
SELECT first_name ,  middle_name ,  last_name FROM Students ORDER BY date_left ASC LIMIT 1	student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_left asc limit 1	student_transcripts_tracking
SELECT first_name FROM Students WHERE current_address_id != permanent_address_id	student_transcripts_tracking
SELECT first_name FROM Students WHERE current_address_id != permanent_address_id	student_transcripts_tracking
SELECT Addresses.address_id, Addresses.line_1, Addresses.line_2, Addresses.line_3 FROM Addresses JOIN Students ON Students.current_address_id = Addresses.address_id GROUP BY Addresses.address_id, Addresses.line_1, Addresses.line_2, Addresses.line_3 ORDER BY COUNT(*) DESC LIMIT 1	student_transcripts_tracking
SELECT T1.address_id ,  T1.line_1 ,  T1.line_2 FROM Addresses AS T1 JOIN Students AS T2 ON T1.address_id  =  T2.current_address_id GROUP BY T1.address_id ORDER BY count(*) DESC LIMIT 1	student_transcripts_tracking
select avg(transcript_date) from Transcripts	student_transcripts_tracking
select avg(transcript_date) from Transcripts	student_transcripts_tracking
select transcript_date, other_details from Transcripts order by transcript_date asc limit 1	student_transcripts_tracking
select transcript_date, other_details from Transcripts order by transcript_date asc limit 1	student_transcripts_tracking
select count(*) from Transcripts	student_transcripts_tracking
select count(*) from Transcripts	student_transcripts_tracking
select transcript_date from Transcripts order by transcript_date desc limit 1	student_transcripts_tracking
select transcript_date from Transcripts order by transcript_date desc limit 1	student_transcripts_tracking
SELECT COUNT(t2.transcript_id) AS max_count, t2.student_course_id FROM Student_Enrolment_Courses AS t1 JOIN Transcript_Contents AS t2 ON t1.student_course_id = t2.student_course_id GROUP BY t2.student_course_id ORDER BY max_count DESC LIMIT 1	student_transcripts_tracking
SELECT COUNT(*), student_enrolment_id FROM Student_Enrolment_Courses GROUP BY student_enrolment_id ORDER BY COUNT(*) DESC LIMIT 1	student_transcripts_tracking
select T.transcript_date, T.transcript_id from Transcripts as T join Transcript_Contents as TC on T.transcript_id = TC.transcript_id group by T.transcript_id order by count(*) asc limit 1	student_transcripts_tracking
SELECT T.transcript_date, T.transcript_id FROM Transcripts AS T JOIN Transcript_Contents AS TC ON T.transcript_id = TC.transcript_id GROUP BY T.transcript_id ORDER BY COUNT(TC.student_course_id) ASC LIMIT 1	student_transcripts_tracking
SELECT semester_name FROM Semesters WHERE semester_id IN (SELECT semester_id FROM Student_Enrolment WHERE degree_program_id IN (SELECT degree_program_id FROM Degree_Programs WHERE degree_summary_name = 'Master') INTERSECT SELECT semester_id FROM Student_Enrolment WHERE degree_program_id IN (SELECT degree_program_id FROM Degree_Programs WHERE degree_summary_name = 'Bachelor'))	student_transcripts_tracking
select T1.semester_id from Student_Enrolment as T1 inner join Degree_Programs as T2 on T1.degree_program_id = T2.degree_program_id where T2.degree_summary_name = "Master" intersect select T1.semester_id from Student_Enrolment as T1 inner join Degree_Programs as T2 on T1.degree_program_id = T2.degree_program_id where T2.degree_summary_name = "Bachelor"	student_transcripts_tracking
SELECT COUNT(DISTINCT address_id) AS count FROM Addresses JOIN Students ON Addresses.address_id = Students.current_address_id	student_transcripts_tracking
SELECT DISTINCT A.line_1, A.line_2, A.line_3, A.city, A.zip_postcode, A.state_province_county, A.country, A.other_address_details FROM Addresses AS A JOIN Students AS S ON A.address_id = S.current_address_id OR A.address_id = S.permanent_address_id	student_transcripts_tracking
SELECT student_id, current_address_id, permanent_address_id, first_name, middle_name, last_name, cell_mobile_number, email_address, ssn, date_first_registered, date_left, other_student_details FROM Students ORDER BY first_name DESC	student_transcripts_tracking
SELECT student_id, current_address_id, permanent_address_id, first_name, middle_name, last_name, cell_mobile_number, email_address, ssn, date_first_registered, date_left, other_student_details FROM Students ORDER BY last_name DESC	student_transcripts_tracking
SELECT section_name, section_description, other_details FROM Sections WHERE section_name = 'h'	student_transcripts_tracking
select section_description from Sections where section_name = "h"	student_transcripts_tracking
SELECT s.first_name FROM Students AS s INNER JOIN Addresses AS a ON s.permanent_address_id = a.address_id WHERE s.cell_mobile_number = '09700166582' OR a.country = 'Haiti'	student_transcripts_tracking
select t1.first_name from students as t1 join addresses as t2 on t1.permanent_address_id  =  t2.address_id where t2.country  =  'haiti' or t1.cell_mobile_number  =  '09700166582'	student_transcripts_tracking
select Title from Cartoon order by Title asc	tvshow
select Title from Cartoon order by Title asc	tvshow
select Title from Cartoon where Directed_by = "Ben Jones"	tvshow
select Title from Cartoon where Directed_by = "Ben Jones"	tvshow
select count(*) from Cartoon where Written_by = "Joseph Kuhr"	tvshow
select count(*) from Cartoon where Written_by = "Joseph Kuhr"	tvshow
select Title, Directed_by from Cartoon order by Original_air_date asc	tvshow
select Title, Directed_by from Cartoon order by Original_air_date asc	tvshow
SELECT Title FROM Cartoon WHERE Directed_by = "Ben Jones" OR Directed_by = "Brandon Vietti";	tvshow
select Title from Cartoon where Directed_by = "Ben Jones" or Directed_by = "Brandon Vietti"	tvshow
SELECT Country, COUNT(*) FROM TV_Channel GROUP BY Country ORDER BY COUNT(*) DESC LIMIT 1	tvshow
SELECT Country, COUNT(*) FROM TV_Channel GROUP BY Country ORDER BY COUNT(*) DESC LIMIT 1	tvshow
select count(distinct series_name), count(distinct Content) from TV_Channel	tvshow
select count(distinct series_name), count(distinct Content) from TV_Channel	tvshow
select Content from TV_Channel where series_name = "Sky Radio"	tvshow
select Content from TV_Channel where series_name = "Sky Radio"	tvshow
select Package_Option from TV_Channel where series_name = "Sky Radio"	tvshow
select Package_Option from TV_Channel where series_name = "Sky Radio"	tvshow
select count(*) from TV_Channel where Language = "English"	tvshow
select count(*) from TV_Channel where Language = "English"	tvshow
SELECT Language, COUNT(*) FROM TV_Channel GROUP BY Language ORDER BY COUNT(*) ASC LIMIT 1	tvshow
SELECT LANGUAGE ,  count(*) FROM TV_Channel GROUP BY LANGUAGE ORDER BY count(*) ASC LIMIT 1;	tvshow
SELECT LANGUAGE ,  count(*) FROM TV_Channel GROUP BY LANGUAGE	tvshow
select Language, count(*) from TV_Channel group by Language	tvshow
select T1.series_name from TV_Channel as T1 join Cartoon as T2 on T1.id = T2.Channel where T2.Title = "The Rise of the Blue Beetle!"	tvshow
SELECT T1.series_name FROM TV_Channel AS T1 JOIN Cartoon AS T2 ON T1.id = T2.Channel WHERE T2.Title = "The Rise of the Blue Beetle!";	tvshow
select T1.Title from Cartoon as T1 join TV_Channel as T2 on T1.Channel = T2.id where T2.series_name = "Sky Radio"	tvshow
select T1.Title from Cartoon as T1 join TV_Channel as T2 on T1.Channel = T2.id where T2.series_name = "Sky Radio"	tvshow
select Episode from TV_series order by Rating asc	tvshow
SELECT Episode, Rating FROM TV_series ORDER BY Rating DESC	tvshow
select Episode, Rating from TV_series order by Rating desc limit 3	tvshow
select Episode, Rating from TV_series order by Rating desc limit 3	tvshow
select min(Share), max(Share) from TV_series	tvshow
select max(Share), min(Share) from TV_series	tvshow
select Air_Date from TV_series where Episode = "A Love of a Lifetime"	tvshow
SELECT Original_air_date FROM Cartoon WHERE Title = 'A Love of a Lifetime'	tvshow
select Weekly_Rank from TV_series where Episode = "A Love of a Lifetime"	tvshow
select Weekly_Rank from TV_series where Episode = "A Love of a Lifetime"	tvshow
SELECT TV_series.Channel, TV_Channel.series_name FROM TV_series JOIN TV_Channel ON TV_series.Channel = TV_Channel.id WHERE TV_series.Episode = 'A Love of a Lifetime'	tvshow
select T1.series_name from TV_Channel as T1 join TV_series as T2 on T1.id = T2.Channel where T2.Episode = "A Love of a Lifetime"	tvshow
select T1.Episode from TV_series as T1 join TV_Channel as T2 on T1.Channel = T2.id where T2.series_name = "Sky Radio"	tvshow
select Episode from TV_series where Channel = (select id from TV_Channel where series_name = "Sky Radio")	tvshow
select Directed_by, count(*) from Cartoon group by Directed_by	tvshow
select Directed_by, count(*) from Cartoon group by Directed_by	tvshow
select Production_code, Channel from Cartoon order by Original_air_date desc limit 1	tvshow
select Production_code, Channel from Cartoon order by Original_air_date desc limit 1	tvshow
select Package_Option, series_name from TV_Channel where Hight_definition_TV = "yes"	tvshow
select Package_Option, series_name from TV_Channel where Hight_definition_TV = "yes"	tvshow
select TV_Channel.Country from TV_Channel join Cartoon on TV_Channel.id = Cartoon.Channel where Cartoon.Written_by = "Todd Casey"	tvshow
SELECT TV_Channel.Country FROM Cartoon JOIN TV_Channel ON Cartoon.Channel = TV_Channel.id WHERE Cartoon.Written_by = 'Todd Casey'	tvshow
select Country from TV_Channel except select TV_Channel.Country from TV_Channel join Cartoon on TV_Channel.id = Cartoon.Channel where Cartoon.Written_by = "Todd Casey"	tvshow
SELECT Country FROM TV_Channel WHERE NOT id IN (SELECT Channel FROM Cartoon WHERE Written_by = 'Todd Casey')	tvshow
SELECT TV_Channel.series_name, TV_Channel.Country FROM TV_Channel JOIN Cartoon ON TV_Channel.id = Cartoon.Channel WHERE Cartoon.Directed_by = 'Ben Jones' OR Cartoon.Directed_by = 'Michael Chang'	tvshow
select T1.series_name, T1.Country from TV_Channel as T1 join Cartoon as T2 on T1.id = T2.Channel where T2.Directed_by = "Ben Jones" intersect select T1.series_name, T1.Country from TV_Channel as T1 join Cartoon as T2 on T1.id = T2.Channel where T2.Directed_by = "Michael Chang"	tvshow
SELECT Pixel_aspect_ratio_PAR ,  country FROM tv_channel WHERE LANGUAGE != 'English'	tvshow
SELECT Pixel_aspect_ratio_PAR ,  country FROM tv_channel WHERE LANGUAGE != 'English'	tvshow
SELECT id FROM TV_Channel WHERE Country IN (SELECT Country FROM TV_Channel GROUP BY Country HAVING COUNT(*) > 2)	tvshow
SELECT TV_Channel.id FROM TV_Channel JOIN TV_series ON TV_Channel.id = TV_series.Channel GROUP BY TV_Channel.id HAVING COUNT(*) > 2	tvshow
SELECT id FROM TV_Channel EXCEPT SELECT channel FROM cartoon WHERE directed_by  =  'Ben Jones'	tvshow
SELECT id FROM TV_Channel EXCEPT SELECT channel FROM cartoon WHERE directed_by  =  'Ben Jones'	tvshow
SELECT Package_Option FROM TV_Channel WHERE NOT EXISTS(SELECT 1 FROM Cartoon WHERE Directed_by = 'Ben Jones' AND Cartoon.Channel = TV_Channel.id)	tvshow
SELECT TV_Channel.Package_Option FROM TV_Channel WHERE NOT TV_Channel.id IN (SELECT Cartoon.Channel FROM Cartoon WHERE Cartoon.Directed_by = 'Ben Jones')	tvshow
select count(*) from players	wta_1
select count(*) from players	wta_1
select count(*) from matches	wta_1
select count(*) from matches	wta_1
select first_name, birth_date from players where country_code = "USA"	wta_1
select players.first_name, players.birth_date from players where players.country_code = "USA"	wta_1
select avg(winner_age), avg(loser_age) from matches	wta_1
select avg(loser_age), avg(winner_age) from matches	wta_1
select avg(winner_rank) from matches	wta_1
SELECT avg(winner_rank) FROM matches	wta_1
SELECT MAX(loser_rank) FROM matches	wta_1
select loser_rank from matches order by loser_rank asc limit 1	wta_1
select count(distinct country_code) from players	wta_1
select count(distinct country_code) from players	wta_1
select count(distinct loser_name) from matches	wta_1
select count(distinct loser_name) from matches	wta_1
select tourney_name from matches group by tourney_name having count(*) > 10	wta_1
select tourney_name from matches group by tourney_name having count(*) > 10	wta_1
SELECT DISTINCT winner_name FROM matches WHERE year = 2013 AND winner_id IN (SELECT winner_id FROM matches WHERE year = 2016)	wta_1
SELECT DISTINCT winner_name FROM matches WHERE year = 2013 INTERSECT SELECT DISTINCT winner_name FROM matches WHERE year = 2016	wta_1
SELECT count(*) FROM matches WHERE YEAR  =  2013 OR YEAR  =  2016	wta_1
SELECT count(*) FROM matches WHERE YEAR  =  2013 OR YEAR  =  2016	wta_1
select p.country_code, p.first_name from players as p where p.player_id in (select winner_id from matches where tourney_name = "WTA Championships" intersect select winner_id from matches where tourney_name = "Australian Open")	wta_1
select p.first_name, p.country_code from players p join matches m1 on p.player_id = m1.winner_id where m1.tourney_name = "WTA Championships" intersect select p.first_name, p.country_code from players p join matches m2 on p.player_id = m2.winner_id where m2.tourney_name = "Australian Open"	wta_1
select first_name, country_code from players order by birth_date asc limit 1	wta_1
select first_name, country_code from players order by birth_date asc limit 1	wta_1
select first_name, last_name from players order by birth_date asc	wta_1
select first_name, last_name from players order by birth_date asc	wta_1
SELECT first_name ,  last_name FROM players WHERE hand  =  'L' ORDER BY birth_date	wta_1
select first_name, last_name from players where hand = "L" order by birth_date asc	wta_1
SELECT players.first_name, players.country_code FROM players JOIN rankings ON players.player_id = rankings.player_id ORDER BY rankings.tours DESC LIMIT 1	wta_1
SELECT players.first_name, players.country_code FROM players JOIN rankings ON players.player_id = rankings.player_id ORDER BY rankings.tours DESC LIMIT 1	wta_1
select year from matches group by year order by count(*) desc limit 1	wta_1
select year from matches group by year order by count(*) desc limit 1	wta_1
SELECT winner_name, winner_rank_points FROM matches GROUP BY winner_id ORDER BY COUNT(*) DESC LIMIT 1	wta_1
SELECT winner_name, winner_rank_points FROM matches WHERE winner_id = (SELECT winner_id FROM matches GROUP BY winner_id ORDER BY COUNT(*) DESC LIMIT 1) LIMIT 1	wta_1
select winner_name from matches where tourney_name = "Australian Open" order by winner_rank_points desc limit 1	wta_1
select winner_name from matches where tourney_name = "Australian Open" order by winner_rank_points desc limit 1	wta_1
select loser_name, winner_name from matches order by minutes desc limit 1	wta_1
select winner_name, loser_name from matches order by minutes desc limit 1	wta_1
SELECT AVG(rankings.ranking), players.first_name FROM players JOIN rankings ON players.player_id = rankings.player_id GROUP BY players.player_id	wta_1
select players.first_name, avg(rankings.ranking) from players join rankings on players.player_id = rankings.player_id group by players.first_name	wta_1
SELECT players.first_name, SUM(rankings.ranking_points) FROM players JOIN rankings ON players.player_id = rankings.player_id GROUP BY players.player_id	wta_1
SELECT players.first_name, SUM(rankings.ranking_points) FROM players JOIN rankings ON players.player_id = rankings.player_id GROUP BY players.player_id, players.first_name	wta_1
select country_code, count(*) from players group by country_code	wta_1
select country_code, count(*) from players group by country_code	wta_1
select country_code from players group by country_code order by count(*) desc limit 1	wta_1
SELECT country_code FROM players GROUP BY country_code ORDER BY count(*) DESC LIMIT 1	wta_1
select country_code from players group by country_code having count(*) > 50	wta_1
select country_code from players group by country_code having count(*) > 50	wta_1
select ranking_date, sum(tours) from rankings group by ranking_date	wta_1
SELECT SUM(tours), ranking_date FROM rankings GROUP BY ranking_date	wta_1
select year, count(*) from matches group by year	wta_1
SELECT count(*) ,  YEAR FROM matches GROUP BY YEAR	wta_1
select winner_name, winner_rank from matches order by winner_age asc limit 3	wta_1
select winner_name, winner_rank from matches order by winner_age asc limit 3	wta_1
select count(distinct matches.winner_id) from matches join players on matches.winner_id = players.player_id where matches.tourney_name = "WTA Championships" and players.hand = "L"	wta_1
select count(*) from matches where winner_hand = "L" and tourney_name = "WTA Championships"	wta_1
select T1.first_name, T1.country_code, T1.birth_date from players as T1 join matches as T2 on T1.player_id = T2.winner_id order by T2.winner_rank_points desc limit 1	wta_1
select T1.first_name, T1.country_code, T1.birth_date from players as T1 join matches as T2 on T2.winner_id = T1.player_id order by T2.winner_rank_points desc limit 1	wta_1
select hand, count(*) from players group by hand	wta_1
select count(*), hand from players group by hand	wta_1
select count(*) from Highschooler	network_1
select count(*) from Highschooler	network_1
select name, grade from Highschooler	network_1
select name, grade from Highschooler	network_1
select grade from Highschooler	network_1
select grade from Highschooler	network_1
select grade from Highschooler where name = "Kyle"	network_1
select grade from Highschooler where name = "Kyle"	network_1
select name from Highschooler where grade = 10	network_1
select name from Highschooler where grade = 10	network_1
select ID from Highschooler where name = "Kyle"	network_1
select ID from Highschooler where name = "Kyle"	network_1
SELECT count(*) FROM Highschooler WHERE grade  =  9 OR grade  =  10	network_1
SELECT count(*) FROM Highschooler WHERE grade  =  9 OR grade  =  10	network_1
SELECT grade ,  count(*) FROM Highschooler GROUP BY grade	network_1
select grade, count(*) from Highschooler group by grade	network_1
select grade from Highschooler group by grade order by count(*) desc limit 1	network_1
select grade from Highschooler group by grade order by count(*) desc limit 1	network_1
select grade from Highschooler group by grade having count(*) >= 4	network_1
select grade from Highschooler group by grade having count(*) >= 4	network_1
select Highschooler.ID, count(Friend.friend_id) from Highschooler left join Friend on Highschooler.ID = Friend.student_id group by Highschooler.ID	network_1
select T1.name, count(T2.friend_id) from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id group by T1.ID	network_1
select T1.name, count(T2.friend_id) from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id group by T1.ID	network_1
select Highschooler.name, count(Friend.friend_id) from Highschooler left join Friend on Highschooler.ID = Friend.student_id group by Highschooler.ID	network_1
select Highschooler.name from Highschooler join Friend on Highschooler.ID = Friend.student_id group by Highschooler.ID order by count(Friend.friend_id) desc limit 1	network_1
select H.name from Highschooler as H join Friend as F on H.ID = F.student_id group by H.ID order by count(*) desc limit 1	network_1
SELECT T2.name FROM Friend AS T1 JOIN Highschooler AS T2 ON T1.student_id  =  T2.id GROUP BY T1.student_id HAVING count(*)  >=  3	network_1
select Highschooler.name from Highschooler join Friend on Highschooler.ID = Friend.student_id group by Highschooler.ID having count(Friend.friend_id) >= 3	network_1
select T2.name from Highschooler as T1 join Friend as T3 on T1.ID = T3.student_id join Highschooler as T2 on T3.friend_id = T2.ID where T1.name = "Kyle"	network_1
select T2.name from Highschooler as T1 join Friend as T3 on T1.ID = T3.student_id join Highschooler as T2 on T3.friend_id = T2.ID where T1.name = "Kyle"	network_1
select count(*) from Highschooler join Friend on Highschooler.ID = Friend.student_id where Highschooler.name = "Kyle"	network_1
select count(*) from Friend join Highschooler on Highschooler.ID = Friend.student_id where Highschooler.name = "Kyle"	network_1
select T1.ID from Highschooler as T1 left join Friend as T2 on T1.ID = T2.student_id where T2.student_id is null	network_1
select T1.ID from Highschooler as T1 left join Friend as T2 on T1.ID = T2.student_id where T2.student_id is null	network_1
select Highschooler.name from Highschooler left join Friend on Highschooler.ID = Friend.student_id where Friend.student_id is null	network_1
select Highschooler.name from Highschooler left join Friend on Highschooler.ID = Friend.student_id where Friend.student_id is null	network_1
select T1.ID from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id intersect select T1.ID from Highschooler as T1 join Likes as T2 on T1.ID = T2.liked_id	network_1
select student_id from Friend intersect select liked_id from Likes	network_1
select distinct Highschooler.name from Highschooler join Friend on Highschooler.ID = Friend.student_id join Likes on Highschooler.ID = Likes.liked_id	network_1
select name from Highschooler where ID in (select student_id from Friend) intersect select name from Highschooler where ID in (select liked_id from Likes)	network_1
select student_id, count(*) from Likes group by student_id	network_1
select student_id, count(*) from Likes group by student_id	network_1
select Highschooler.name, count(*) from Highschooler join Likes on Highschooler.ID = Likes.student_id group by Highschooler.ID	network_1
select Highschooler.name, count(*) from Highschooler join Likes on Highschooler.ID = Likes.student_id group by Highschooler.ID	network_1
select Highschooler.name from Highschooler join Likes on Highschooler.ID = Likes.student_id group by Highschooler.ID order by count(*) desc limit 1	network_1
select Highschooler.name from Highschooler join Likes on Highschooler.ID = Likes.student_id group by Highschooler.ID order by count(*) desc limit 1	network_1
select Highschooler.name from Highschooler join Likes on Highschooler.ID = Likes.student_id group by Highschooler.ID having count(*) >= 2	network_1
select Highschooler.name from Highschooler join Likes on Highschooler.ID = Likes.student_id group by Highschooler.ID having count(*) >= 2	network_1
SELECT T2.name FROM Friend AS T1 JOIN Highschooler AS T2 ON T1.student_id  =  T2.id WHERE T2.grade  >  5 GROUP BY T1.student_id HAVING count(*)  >=  2	network_1
SELECT T2.name FROM Friend AS T1 JOIN Highschooler AS T2 ON T1.student_id  =  T2.id WHERE T2.grade  >  5 GROUP BY T1.student_id HAVING count(*)  >=  2	network_1
select count(*) from Likes join Highschooler on Highschooler.ID = Likes.student_id where Highschooler.name = "Kyle"	network_1
select count(*) from Likes join Highschooler on Likes.student_id = Highschooler.ID where Highschooler.name = "Kyle"	network_1
select avg(T1.grade) as "average grade" from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id	network_1
select avg(T1.grade) from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id	network_1
select min(T1.grade) from Highschooler as T1 left join Friend as T2 on T1.ID = T2.student_id where T2.student_id is null	network_1
select min(T1.grade) from Highschooler as T1 left join Friend as T2 on T1.ID = T2.student_id where T2.friend_id is null	network_1
select count(*) from singer	concert_singer
select count(*) from singer	concert_singer
select Name, Country, Age from singer order by Age desc	concert_singer
select Name, Country, Age from singer order by Age desc	concert_singer
select avg(Age), min(Age), max(Age) from singer where Country = "France"	concert_singer
select avg(Age), min(Age), max(Age) from singer where Country = "France"	concert_singer
select Name, Song_release_year from singer order by Age asc limit 1	concert_singer
SELECT song_name ,  song_release_year FROM singer ORDER BY age LIMIT 1	concert_singer
select distinct Country from singer where Age > 20	concert_singer
select distinct Country from singer where Age > 20	concert_singer
select Country, count(*) from singer group by Country	concert_singer
select Country, count(*) from singer group by Country	concert_singer
select Song_Name from singer where Age > (select avg(Age) from singer)	concert_singer
select Song_Name from singer where Age > (select avg(Age) from singer)	concert_singer
select Location, Name from stadium where Capacity between 5000 and 10000	concert_singer
select Location, Name from stadium where Capacity between 5000 and 10000	concert_singer
select max(Capacity), avg(Average) from stadium	concert_singer
select avg(Capacity), max(Capacity) from stadium	concert_singer
select Name, Capacity from stadium order by Average desc limit 1	concert_singer
select Name, Capacity from stadium order by Average desc limit 1	concert_singer
SELECT count(*) FROM concert WHERE YEAR  =  2014 OR YEAR  =  2015	concert_singer
SELECT count(*) FROM concert WHERE YEAR  =  2014 OR YEAR  =  2015	concert_singer
select stadium.Name, count(concert.concert_ID) from stadium inner join concert on stadium.Stadium_ID = concert.Stadium_ID group by stadium.Name	concert_singer
SELECT T2.name ,  count(*) FROM concert AS T1 JOIN stadium AS T2 ON T1.stadium_id  =  T2.stadium_id GROUP BY T1.stadium_id	concert_singer
SELECT T2.name ,  T2.capacity FROM concert AS T1 JOIN stadium AS T2 ON T1.stadium_id  =  T2.stadium_id WHERE T1.year  >=  2014 GROUP BY T2.stadium_id ORDER BY count(*) DESC LIMIT 1	concert_singer
select T1.Name, T1.Capacity from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year > 2013 group by T1.Stadium_ID order by count(*) desc limit 1	concert_singer
select Year from concert group by Year order by count(*) desc limit 1	concert_singer
select Year from concert group by Year order by count(*) desc limit 1	concert_singer
select T1.Name from stadium as T1 left join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Stadium_ID is null	concert_singer
select Name from stadium where Stadium_ID not in (select Stadium_ID from concert)	concert_singer
select distinct Country from singer where Age > 40 intersect select distinct Country from singer where Age < 30	concert_singer
select Name from stadium where Stadium_ID not in (select Stadium_ID from concert where Year = "2014")	concert_singer
select Name from stadium where Stadium_ID not in (select Stadium_ID from concert where Year = 2014)	concert_singer
select T1.concert_Name, T1.Theme, count(*) from concert as T1 join singer_in_concert as T2 on T1.concert_ID = T2.concert_ID group by T1.concert_ID	concert_singer
select t2.concert_name ,  t2.theme ,  count(*) from singer_in_concert as t1 join concert as t2 on t1.concert_id  =  t2.concert_id group by t2.concert_id	concert_singer
select singer.Name, count(singer_in_concert.concert_ID) from singer join singer_in_concert on singer.Singer_ID = singer_in_concert.Singer_ID group by singer.Singer_ID	concert_singer
SELECT T2.name ,  count(*) FROM singer_in_concert AS T1 JOIN singer AS T2 ON T1.singer_id  =  T2.singer_id GROUP BY T2.singer_id	concert_singer
select singer.Name from singer join singer_in_concert on singer.Singer_ID = singer_in_concert.Singer_ID join concert on singer_in_concert.concert_ID = concert.concert_ID where concert.Year = 2014	concert_singer
select singer.Name from singer join singer_in_concert on singer.Singer_ID = singer_in_concert.Singer_ID join concert on singer_in_concert.concert_ID = concert.concert_ID where concert.Year = 2014	concert_singer
select Name, Country from singer where Song_Name like "%Hey%"	concert_singer
select Name, Country from singer where Song_Name like "%Hey%"	concert_singer
select T1.Name, T1.Location from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year = "2014" intersect select T1.Name, T1.Location from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year = "2015"	concert_singer
select stadium.Name, stadium.Location from stadium join concert on stadium.Stadium_ID = concert.Stadium_ID where concert.Year = 2014 intersect select stadium.Name, stadium.Location from stadium join concert on stadium.Stadium_ID = concert.Stadium_ID where concert.Year = 2015	concert_singer
select count(*) as "Number of Concerts" from concert join stadium on concert.Stadium_ID = stadium.Stadium_ID where stadium.Capacity = (select max(Capacity) from stadium)	concert_singer
select count(*) from concert join stadium on concert.Stadium_ID = stadium.Stadium_ID where stadium.Capacity = (select max(Capacity) from stadium)	concert_singer
select count(*) from Pets where weight > 10	pets_1
select count(*) from Pets where weight > 10	pets_1
select weight from Pets order by pet_age asc limit 1	pets_1
SELECT weight FROM pets ORDER BY pet_age LIMIT 1	pets_1
select max(weight), PetType from Pets group by PetType	pets_1
select max(weight), PetType from Pets group by PetType	pets_1
SELECT count(*) FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid WHERE T1.age  >  20	pets_1
SELECT count(*) FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid WHERE T1.age  >  20	pets_1
select count(*) from Student join Has_Pet on Student.StuID = Has_Pet.StuID join Pets on Has_Pet.PetID = Pets.PetID where Student.Sex = "F" and Pets.PetType = "dog"	pets_1
SELECT count(*) FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid JOIN pets AS T3 ON T2.petid  =  T3.petid WHERE T1.sex  =  'F' AND T3.pettype  =  'dog'	pets_1
select count(distinct PetType) from Pets	pets_1
select count(distinct PetType) from Pets	pets_1
SELECT DISTINCT T1.Fname FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid JOIN pets AS T3 ON T3.petid  =  T2.petid WHERE T3.pettype  =  'cat' OR T3.pettype  =  'dog'	pets_1
SELECT DISTINCT T1.Fname FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid JOIN pets AS T3 ON T3.petid  =  T2.petid WHERE T3.pettype  =  'cat' OR T3.pettype  =  'dog'	pets_1
select S.Fname from Student S join Has_Pet HP on S.StuID = HP.StuID join Pets P on HP.PetID = P.PetID where P.PetType = "cat" intersect select S.Fname from Student S join Has_Pet HP on S.StuID = HP.StuID join Pets P on HP.PetID = P.PetID where P.PetType = "dog"	pets_1
select Fname from Student join Has_Pet on Student.StuID = Has_Pet.StuID join Pets on Has_Pet.PetID = Pets.PetID where PetType = "cat" intersect select Fname from Student join Has_Pet on Student.StuID = Has_Pet.StuID join Pets on Has_Pet.PetID = Pets.PetID where PetType = "dog"	pets_1
SELECT Major, Age FROM Student WHERE NOT StuID IN (SELECT T1.StuID FROM Has_Pet AS T1 JOIN Pets AS T2 ON T1.PetID = T2.PetID WHERE T2.PetType = 'cat')	pets_1
SELECT Student.Major, Student.Age FROM Student WHERE NOT Student.StuID IN (SELECT Has_Pet.StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat')	pets_1
SELECT stuid FROM student EXCEPT SELECT T1.stuid FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid JOIN pets AS T3 ON T3.petid  =  T2.petid WHERE T3.pettype  =  'cat'	pets_1
SELECT stuid FROM student EXCEPT SELECT T1.stuid FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid JOIN pets AS T3 ON T3.petid  =  T2.petid WHERE T3.pettype  =  'cat'	pets_1
SELECT T1.fname ,  T1.age FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid JOIN pets AS T3 ON T3.petid  =  T2.petid WHERE T3.pettype  =  'dog' AND T1.stuid NOT IN (SELECT T1.stuid FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid JOIN pets AS T3 ON T3.petid  =  T2.petid WHERE T3.pettype  =  'cat')	pets_1
SELECT DISTINCT S.Fname FROM Student AS S JOIN Has_Pet AS HP ON S.StuID = HP.StuID JOIN Pets AS P ON HP.PetID = P.PetID WHERE P.PetType = 'dog' AND NOT S.StuID IN (SELECT HP2.StuID FROM Has_Pet AS HP2 JOIN Pets AS P2 ON HP2.PetID = P2.PetID WHERE P2.PetType = 'cat')	pets_1
select PetType, weight from Pets order by pet_age asc limit 1	pets_1
select PetType, weight from Pets order by pet_age asc limit 1	pets_1
select PetID, weight from Pets where pet_age > 1	pets_1
select PetID , weight from Pets where pet_age > 1	pets_1
select PetType, avg(pet_age), max(pet_age) from Pets group by PetType	pets_1
select PetType, avg(pet_age), max(pet_age) from Pets group by PetType	pets_1
select PetType, avg(weight) from Pets group by PetType	pets_1
select PetType, avg(weight) from Pets group by PetType	pets_1
select T1.Fname, T1.Age from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID	pets_1
select T1.Fname, T1.Age from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID	pets_1
select Pets.PetID from Student join Has_Pet on Student.StuID = Has_Pet.StuID join Pets on Has_Pet.PetID = Pets.PetID where Student.LName = "Smith"	pets_1
SELECT T2.petid FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid WHERE T1.Lname  =  'Smith'	pets_1
select Student.StuID, count(*) from Student join Has_Pet on Student.StuID = Has_Pet.StuID group by Student.StuID	pets_1
select count(*) ,  t1.stuid from student as t1 join has_pet as t2 on t1.stuid  =  t2.stuid group by t1.stuid	pets_1
SELECT T1.fname ,  T1.sex FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid GROUP BY T1.stuid HAVING count(*)  >  1	pets_1
SELECT Student.Fname, Student.Sex FROM Student INNER JOIN Has_Pet ON Student.StuID = Has_Pet.StuID GROUP BY Student.StuID HAVING COUNT(Has_Pet.PetID) > 1	pets_1
select T1.LName from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "cat" and T3.pet_age = 3	pets_1
select T1.LName from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "cat" and T3.pet_age = 3	pets_1
select avg(T1.Age) from Student as T1 left join Has_Pet as T2 on T1.StuID = T2.StuID where T2.StuID is null	pets_1
select avg(T1.Age) from Student as T1 left join Has_Pet as T2 on T1.StuID = T2.StuID where T2.StuID is null	pets_1
select count(*) from conductor	orchestra
select count(*) from conductor	orchestra
select Name from conductor order by Age asc	orchestra
select Name from conductor order by Age asc	orchestra
SELECT Name FROM conductor WHERE Nationality != 'USA'	orchestra
SELECT Name FROM conductor WHERE Nationality != 'USA'	orchestra
select Record_Company from orchestra order by Year_of_Founded desc	orchestra
select Record_Company from orchestra order by Year_of_Founded desc	orchestra
select avg(Attendance) from show	orchestra
select avg(Attendance) from show	orchestra
SELECT max(SHARE) ,  min(SHARE) FROM performance WHERE TYPE != "Live final"	orchestra
SELECT max(SHARE) ,  min(SHARE) FROM performance WHERE TYPE != "Live final"	orchestra
select count(distinct Nationality) from conductor	orchestra
select count(distinct Nationality) from conductor	orchestra
select Name from conductor order by Year_of_Work desc	orchestra
select Name from conductor order by Year_of_Work desc	orchestra
select Name from conductor order by Year_of_Work desc limit 1	orchestra
select Name from conductor order by Year_of_Work desc limit 1	orchestra
select T1.Name, T2.Orchestra from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID	orchestra
select T1.Name, T2.Orchestra from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID	orchestra
SELECT T1.Name FROM conductor AS T1 JOIN orchestra AS T2 ON T1.Conductor_ID  =  T2.Conductor_ID GROUP BY T2.Conductor_ID HAVING COUNT(*)  >  1	orchestra
select T1.Name from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID group by T1.Conductor_ID having count(*) > 1	orchestra
select c.Name from conductor as c join orchestra as o on c.Conductor_ID = o.Conductor_ID group by c.Name order by count(*) desc limit 1	orchestra
select conductor.Name from conductor join orchestra on conductor.Conductor_ID = orchestra.Conductor_ID group by conductor.Conductor_ID order by count(*) desc limit 1	orchestra
select T1.Name from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID where T2.Year_of_Founded > 2008	orchestra
select conductor.Name from conductor join orchestra on conductor.Conductor_ID = orchestra.Conductor_ID where orchestra.Year_of_Founded > 2008	orchestra
select Record_Company, count(*) from orchestra group by Record_Company	orchestra
SELECT Record_Company ,  COUNT(*) FROM orchestra GROUP BY Record_Company	orchestra
select Major_Record_Format from orchestra group by Major_Record_Format order by count(*) asc	orchestra
select Major_Record_Format, count(*) from orchestra group by Major_Record_Format order by frequency desc	orchestra
select Record_Company from orchestra group by Record_Company order by count(*) desc limit 1	orchestra
select Record_Company from orchestra group by Record_Company order by count(*) desc limit 1	orchestra
select orchestra.Orchestra from orchestra left join performance on orchestra.Orchestra_ID = performance.Orchestra_ID where performance.Orchestra_ID is null	orchestra
select o.Orchestra from orchestra as o left join performance as p on o.Orchestra_ID = p.Orchestra_ID where p.Performance_ID is null	orchestra
select Record_Company from orchestra where Year_of_Founded < 2003 intersect select Record_Company from orchestra where Year_of_Founded > 2003	orchestra
select Record_Company from orchestra where Year_of_Founded < 2003 intersect select Record_Company from orchestra where Year_of_Founded > 2003	orchestra
SELECT COUNT(*) FROM orchestra WHERE Major_Record_Format  =  "CD" OR Major_Record_Format  =  "DVD"	orchestra
SELECT COUNT(*) FROM orchestra WHERE Major_Record_Format  =  "CD" OR Major_Record_Format  =  "DVD"	orchestra
select distinct T1.Year_of_Founded from orchestra as T1 join (select Orchestra_ID from performance group by Orchestra_ID having count(Performance_ID) > 1) on T1.Orchestra_ID = T2.Orchestra_ID	orchestra
select distinct T1.Year_of_Founded from orchestra as T1 join (select Orchestra_ID from performance group by Orchestra_ID having count(*) > 1) on T1.Orchestra_ID = T2.Orchestra_ID	orchestra
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
select people.Name from poker_player join people on poker_player.People_ID = people.People_ID	poker_player
select T1.Name from people as T1 join poker_player as T2 on T1.People_ID = T2.People_ID	poker_player
select people.Name from poker_player join people on poker_player.People_ID = people.People_ID where poker_player.Earnings > 300000	poker_player
select T1.Name from people as T1 join poker_player as T2 on T1.People_ID = T2.People_ID where T2.Earnings > 300000	poker_player
select people.Name from poker_player join people on poker_player.People_ID = people.People_ID order by poker_player.Final_Table_Made asc	poker_player
select people.Name from poker_player join people on poker_player.People_ID = people.People_ID order by poker_player.Final_Table_Made asc	poker_player
select people.Birth_Date from poker_player join people on poker_player.People_ID = people.People_ID order by poker_player.Earnings asc limit 1	poker_player
select people.Birth_Date from poker_player join people on poker_player.People_ID = people.People_ID order by poker_player.Earnings asc limit 1	poker_player
select T1.Money_Rank from poker_player as T1 join people as T2 on T1.People_ID = T2.People_ID order by T2.Height desc limit 1	poker_player
select T1.Money_Rank from poker_player as T1 join people as T2 on T1.People_ID = T2.People_ID order by T2.Height desc limit 1	poker_player
select avg(poker_player.Earnings) from poker_player join people on poker_player.People_ID = people.People_ID where people.Height > 200	poker_player
select avg(poker_player.Earnings) from poker_player join people on poker_player.People_ID = people.People_ID where people.Height > 200	poker_player
select people.Name from poker_player join people on poker_player.People_ID = people.People_ID order by poker_player.Earnings desc	poker_player
select people.Name from poker_player join people on poker_player.People_ID = people.People_ID order by poker_player.Earnings desc	poker_player
select Nationality, count(*) from people group by Nationality	poker_player
SELECT Nationality ,  COUNT(*) FROM people GROUP BY Nationality	poker_player
select Nationality from people group by Nationality order by count(*) desc limit 1	poker_player
select Nationality from people group by Nationality order by count(*) desc limit 1	poker_player
select Nationality from people group by Nationality having count(*) >= 2	poker_player
select Nationality from people group by Nationality having count(*) >= 2	poker_player
select Name, Birth_Date from people order by Name asc	poker_player
select Name, Birth_Date from people order by Name asc	poker_player
SELECT Name FROM people WHERE Nationality != "Russia"	poker_player
SELECT Name FROM people WHERE Nationality != "Russia"	poker_player
select people.Name from people left join poker_player on people.People_ID = poker_player.People_ID where poker_player.People_ID is null	poker_player
select people.Name from people left join poker_player on people.People_ID = poker_player.People_ID where poker_player.People_ID is null	poker_player
select count(distinct Nationality) from people	poker_player
select count(distinct Nationality) from people	poker_player
select count(*) from employee	employee_hire_evaluation
select count(*) from employee	employee_hire_evaluation
select Name from employee order by Age asc	employee_hire_evaluation
select Name from employee order by Age asc	employee_hire_evaluation
select count(*), City from employee group by City	employee_hire_evaluation
select City, count(*) from employee group by City	employee_hire_evaluation
select City from employee where Age < 30 group by City having count(*) > 1	employee_hire_evaluation
select City from employee where Age < 30 group by City having count(*) > 1	employee_hire_evaluation
select Location, count(*) from shop group by Location	employee_hire_evaluation
select count(*), Location from shop group by Location	employee_hire_evaluation
select Manager_name, District from shop order by Number_products desc limit 1	employee_hire_evaluation
select Manager_name, District from shop order by Number_products desc limit 1	employee_hire_evaluation
select min(Number_products), max(Number_products) from shop	employee_hire_evaluation
select min(Number_products), max(Number_products) from shop	employee_hire_evaluation
select Name, Location, District from shop order by Number_products desc	employee_hire_evaluation
select Name, Location, District from shop order by Number_products desc	employee_hire_evaluation
select Name from shop where Number_products > (select avg(Number_products) from shop)	employee_hire_evaluation
select Name from shop where Number_products > (select avg(Number_products) from shop)	employee_hire_evaluation
select e.Name from employee as e join evaluation as ev on e.Employee_ID = ev.Employee_ID group by e.Employee_ID order by count(*) desc limit 1	employee_hire_evaluation
select T1.Name from employee as T1 join evaluation as T2 on T1.Employee_ID = T2.Employee_ID group by T1.Employee_ID order by count(*) desc limit 1	employee_hire_evaluation
select employee.Name from employee join evaluation on employee.Employee_ID = evaluation.Employee_ID order by evaluation.Bonus desc limit 1	employee_hire_evaluation
select employee.Name from employee join evaluation on employee.Employee_ID = evaluation.Employee_ID order by evaluation.Bonus desc limit 1	employee_hire_evaluation
select employee.Name from employee left join evaluation on employee.Employee_ID = evaluation.Employee_ID where evaluation.Employee_ID is null	employee_hire_evaluation
select employee.Name from employee left join evaluation on employee.Employee_ID = evaluation.Employee_ID where evaluation.Employee_ID is null	employee_hire_evaluation
SELECT t2.name FROM hiring AS t1 JOIN shop AS t2 ON t1.shop_id  =  t2.shop_id GROUP BY t1.shop_id ORDER BY count(*) DESC LIMIT 1	employee_hire_evaluation
select shop.Name from shop join hiring on shop.Shop_ID = hiring.Shop_ID group by shop.Shop_ID order by count(*) desc limit 1	employee_hire_evaluation
select shop.Name from shop where shop.Shop_ID not in (select Shop_ID from hiring)	employee_hire_evaluation
select T1.Name from shop as T1 left join hiring as T2 on T1.Shop_ID = T2.Shop_ID where T2.Shop_ID is null	employee_hire_evaluation
SELECT count(*) ,  t2.name FROM hiring AS t1 JOIN shop AS t2 ON t1.shop_id  =  t2.shop_id GROUP BY t2.name	employee_hire_evaluation
select shop.Name, count(hiring.Employee_ID) from shop join hiring on shop.Shop_ID = hiring.Shop_ID group by shop.Name	employee_hire_evaluation
select sum(Bonus) from evaluation	employee_hire_evaluation
select sum(Bonus) from evaluation	employee_hire_evaluation
select Employee_ID, Shop_ID, Start_from, Is_full_time from hiring	employee_hire_evaluation
select Shop_ID, Employee_ID, Start_from, Is_full_time from hiring	employee_hire_evaluation
select District from shop where Number_products < 3000 intersect select District from shop where Number_products > 10000	employee_hire_evaluation
select District from shop where Number_products < 3000 intersect select District from shop where Number_products > 10000	employee_hire_evaluation
select count(distinct Location) from shop	employee_hire_evaluation
select count(distinct Location) from shop	employee_hire_evaluation
select count(*) from teacher	course_teach
select count(*) from teacher	course_teach
select Name from teacher order by Age asc	course_teach
select Name from teacher order by Age asc	course_teach
select Age, Hometown from teacher	course_teach
select Age, Hometown from teacher	course_teach
select name from teacher where hometown != "little lever urban district"	course_teach
select name from teacher where hometown != "little lever urban district"	course_teach
SELECT Name FROM teacher WHERE Age  =  32 OR Age  =  33	course_teach
SELECT Name FROM teacher WHERE Age  =  32 OR Age  =  33	course_teach
select Hometown from teacher order by Age asc limit 1	course_teach
select Hometown from teacher order by Age asc limit 1	course_teach
select Hometown, count(*) from teacher group by Hometown	course_teach
SELECT Hometown ,  COUNT(*) FROM teacher GROUP BY Hometown	course_teach
select Hometown from teacher group by Hometown order by count(*) desc limit 1	course_teach
select Hometown from teacher group by Hometown order by count(*) desc	course_teach
select Hometown from teacher group by Hometown having count(*) >= 2	course_teach
select Hometown from teacher group by Hometown having count(*) >= 2	course_teach
select teacher.Name, course.Course from course_arrange join teacher on course_arrange.Teacher_ID = teacher.Teacher_ID join course on course_arrange.Course_ID = course.Course_ID	course_teach
select teacher.Name, course.Course from teacher join course_arrange on teacher.Teacher_ID = course_arrange.Teacher_ID join course on course.Course_ID = course_arrange.Course_ID	course_teach
select T1.Name, T3.Course from teacher as T1 join course_arrange as T2 on T1.Teacher_ID = T2.Teacher_ID join course as T3 on T2.Course_ID = T3.Course_ID order by T1.Name asc	course_teach
select teacher.Name, course.Course from course_arrange join teacher on course_arrange.Teacher_ID = teacher.Teacher_ID join course on course_arrange.Course_ID = course.Course_ID order by teacher.Name asc	course_teach
select teacher.Name from teacher join course_arrange on course_arrange.Teacher_ID = teacher.Teacher_ID join course on course_arrange.Course_ID = course.Course_ID where course.Course = "Math"	course_teach
select T1.Name from course as T2 join course_arrange as T3 on T2.Course_ID = T3.Course_ID join teacher as T1 on T3.Teacher_ID = T1.Teacher_ID where T2.Course = "Math"	course_teach
select teacher.Name, count(course_arrange.Course_ID) from teacher join course_arrange on teacher.Teacher_ID = course_arrange.Teacher_ID group by teacher.Teacher_ID	course_teach
SELECT T2.Name ,  COUNT(*) FROM course_arrange AS T1 JOIN teacher AS T2 ON T1.Teacher_ID  =  T2.Teacher_ID GROUP BY T2.Name	course_teach
SELECT T2.Name FROM course_arrange AS T1 JOIN teacher AS T2 ON T1.Teacher_ID  =  T2.Teacher_ID GROUP BY T2.Name HAVING COUNT(*)  >=  2	course_teach
select teacher.Name from teacher join course_arrange on teacher.Teacher_ID = course_arrange.Teacher_ID group by teacher.Name having count(*) >= 2	course_teach
select Name from teacher where Teacher_ID not in (select Teacher_ID from course_arrange)	course_teach
select teacher.Name from teacher left join course_arrange on teacher.Teacher_ID = course_arrange.Teacher_ID where course_arrange.Course_ID is null	course_teach
select count(*) from singer	singer
select count(*) from singer	singer
select Name from singer order by Net_Worth_Millions asc	singer
select Name from singer order by Net_Worth_Millions asc	singer
select Birth_Year, Citizenship from singer	singer
select Birth_Year, Citizenship from singer	singer
SELECT Name FROM singer WHERE Citizenship != "France"	singer
SELECT Name FROM singer WHERE Citizenship != "France"	singer
SELECT Name FROM singer WHERE Birth_Year  =  1948 OR Birth_Year  =  1949	singer
SELECT Name FROM singer WHERE Birth_Year  =  1948 OR Birth_Year  =  1949	singer
select Name from singer order by Net_Worth_Millions desc limit 1	singer
select Name from singer order by Net_Worth_Millions desc limit 1	singer
SELECT Citizenship ,  COUNT(*) FROM singer GROUP BY Citizenship	singer
select Citizenship, count(*) from singer group by Citizenship	singer
select Citizenship from singer group by Citizenship order by count(*) desc limit 1	singer
select Citizenship from singer group by Citizenship order by count(*) desc limit 1	singer
select Citizenship, max(Net_Worth_Millions) from singer group by Citizenship	singer
select Citizenship, max(Net_Worth_Millions) from singer group by Citizenship	singer
SELECT T2.Title ,  T1.Name FROM singer AS T1 JOIN song AS T2 ON T1.Singer_ID  =  T2.Singer_ID	singer
select song.Title, singer.Name from song join singer on song.Singer_ID = singer.Singer_ID	singer
select distinct T1.Name from singer as T1 join song as T2 on T1.Singer_ID = T2.Singer_ID where T2.Sales > 300000	singer
select distinct singer.Name from singer join song on singer.Singer_ID = song.Singer_ID where song.Sales > 300000	singer
SELECT T1.Name FROM singer AS T1 JOIN song AS T2 ON T1.Singer_ID  =  T2.Singer_ID GROUP BY T1.Name HAVING COUNT(*)  >  1	singer
select s.Name from singer as s join song as sg on s.Singer_ID = sg.Singer_ID group by s.Name having count(*) > 1	singer
select singer.Name, sum(song.Sales) from singer join song on singer.Singer_ID = song.Singer_ID group by singer.Name	singer
select T1.Name, sum(T2.Sales) from singer as T1 join song as T2 on T1.Singer_ID = T2.Singer_ID group by T1.Name	singer
select Name from singer where Singer_ID not in (select Singer_ID from song)	singer
select T1.Name from singer as T1 left join song as T2 on T1.Singer_ID = T2.Singer_ID where T2.Singer_ID is null	singer
select Citizenship from singer where Birth_Year < 1945 intersect select Citizenship from singer where Birth_Year > 1955	singer
select Citizenship from singer where Birth_Year < 1945 intersect select Citizenship from singer where Birth_Year > 1955	singer
select count(*) from visitor where Age < 30	museum_visit
select Name from visitor where Level_of_membership > 4 order by Level_of_membership desc	museum_visit
select avg(Age) from visitor where Level_of_membership <= 4	museum_visit
select Name, Level_of_membership from visitor where Level_of_membership > 4 order by Age desc	museum_visit
select Museum_ID, Name from museum order by Num_of_Staff desc limit 1	museum_visit
select avg(Num_of_Staff) from museum where Open_Year < 2009	museum_visit
select Open_Year, Num_of_Staff from museum where Name = "Plaza Museum"	museum_visit
select Name from museum where Num_of_Staff > (select min(Num_of_Staff) from museum where Open_Year > 2010)	museum_visit
SELECT t1.id ,  t1.name ,  t1.age FROM visitor AS t1 JOIN visit AS t2 ON t1.id  =  t2.visitor_id GROUP BY t1.id HAVING count(*)  >  1	museum_visit
select T1.ID, T1.Name, T1.Level_of_membership from visitor as T1 join visit as T2 on T1.ID = T2.visitor_ID group by T1.ID order by sum(T2.Total_spent) desc limit 1	museum_visit
SELECT t2.Museum_ID ,  t1.name FROM museum AS t1 JOIN visit AS t2 ON t1.Museum_ID  =  t2.Museum_ID GROUP BY t2.Museum_ID ORDER BY count(*) DESC LIMIT 1	museum_visit
select museum.Name from museum left join visit on museum.Museum_ID = visit.Museum_ID where visit.Museum_ID is null	museum_visit
select visitor.Name, visitor.Age from visitor join visit on visitor.ID = visit.visitor_ID order by visit.Num_of_Ticket desc limit 1	museum_visit
select avg(Num_of_Ticket), max(Num_of_Ticket) from visit	museum_visit
select sum(visit.Total_spent) from visit join visitor on visit.visitor_ID = visitor.ID where visitor.Level_of_membership = 1	museum_visit
select visitor.Name from museum join visit on visit.Museum_ID = museum.Museum_ID join visitor on visit.visitor_ID = visitor.ID where museum.Open_Year < 2009 intersect select visitor.Name from museum join visit on visit.Museum_ID = museum.Museum_ID join visitor on visit.visitor_ID = visitor.ID where museum.Open_Year > 2011	museum_visit
select count(*) from (select distinct T1.visitor_ID from visit as T1 join museum as T2 on T1.Museum_ID = T2.Museum_ID where T2.Open_Year <= 2010 except select distinct T1.visitor_ID from visit as T1 join museum as T2 on T1.Museum_ID = T2.Museum_ID where T2.Open_Year > 2010)	museum_visit
select count(*) from museum where Open_Year > 2013 or Open_Year < 2008	museum_visit
select count(*) from ship where disposition_of_ship = "Captured"	battle_death
select name, tonnage from ship order by name desc	battle_death
select name, date, result from battle	battle_death
select max(killed) as "maximum death toll", min(killed) as "minimum death toll" from death	battle_death
select avg(injured) from death	battle_death
select T2.killed, T2.injured from ship as T1 join death as T2 on T1.id = T2.caused_by_ship_id where T1.tonnage = "t"	battle_death
SELECT name ,  RESULT FROM battle WHERE bulgarian_commander != 'Boril'	battle_death
select T1.id, T1.name from battle as T1 join ship as T2 on T1.id = T2.lost_in_battle where T2.ship_type = "Brig"	battle_death
SELECT T1.id ,  T1.name FROM battle AS T1 JOIN ship AS T2 ON T1.id  =  T2.lost_in_battle JOIN death AS T3 ON T2.id  =  T3.caused_by_ship_id GROUP BY T1.id HAVING sum(T3.killed)  >  10	battle_death
select ship.id , ship.name from ship join death on death.caused_by_ship_id = ship.id group by ship.id order by sum(death.injured) desc limit 1	battle_death
select distinct name from battle where bulgarian_commander = "Kaloyan" and latin_commander = "Baldwin I"	battle_death
select count(distinct result) from battle	battle_death
select count(*) from battle where battle.id not in (select lost_in_battle from ship where tonnage = "225")	battle_death
select battle.name, battle.date from battle join ship on battle.id = ship.lost_in_battle where ship.name = "Lettice" intersect select battle.name, battle.date from battle join ship on battle.id = ship.lost_in_battle where ship.name = "HMS Atalanta"	battle_death
select T1.name, T1.result, T1.bulgarian_commander from battle as T1 where not EXISTS (select 1 from ship as T2 where T2.lost_in_battle = T1.id and T2.location = "English Channel")	battle_death
select note from death where note like "%East%"	battle_death
SELECT count(*) FROM area_code_state	voter_1
select contestant_number, contestant_name from CONTESTANTS order by contestant_name desc	voter_1
select vote_id, phone_number, state from VOTES	voter_1
select max(area_code), min(area_code) from AREA_CODE_STATE	voter_1
SELECT max(created) FROM votes WHERE state  =  'CA'	voter_1
SELECT contestant_name FROM contestants WHERE contestant_name != 'Jessie Alloway'	voter_1
select distinct state, created from VOTES	voter_1
select T1.contestant_number, T1.contestant_name from CONTESTANTS as T1 join VOTES as T2 on T2.contestant_number = T1.contestant_number group by T1.contestant_number having count(*) >= 2	voter_1
SELECT T1.contestant_number , T1.contestant_name FROM contestants AS T1 JOIN votes AS T2 ON T1.contestant_number  =  T2.contestant_number GROUP BY T1.contestant_number ORDER BY count(*) ASC LIMIT 1	voter_1
SELECT count(*) FROM votes WHERE state  =  'NY' OR state  =  'CA'	voter_1
select count(*) from CONTESTANTS where contestant_number not in (select contestant_number from VOTES)	voter_1
select T1.area_code from AREA_CODE_STATE as T1 join VOTES as T2 on T1.state = T2.state group by T1.area_code order by count(*) desc limit 1	voter_1
SELECT T2.created ,  T2.state ,  T2.phone_number FROM contestants AS T1 JOIN votes AS T2 ON T1.contestant_number  =  T2.contestant_number WHERE T1.contestant_name  =  'Tabatha Gehling'	voter_1
select distinct A.area_code from VOTES V join CONTESTANTS C on V.contestant_number = C.contestant_number join AREA_CODE_STATE A on V.state = A.state where C.contestant_name = "Tabatha Gehling" intersect select distinct A.area_code from VOTES V join CONTESTANTS C on V.contestant_number = C.contestant_number join AREA_CODE_STATE A on V.state = A.state where C.contestant_name = "Kelly Clauss"	voter_1
select contestant_name from CONTESTANTS where contestant_name like "%Al%"	voter_1
select count(*) from Other_Available_Features	real_estate_properties
select rft.feature_type_name from Ref_Feature_Types as rft join Other_Available_Features as oaf on rft.feature_type_code = oaf.feature_type_code where oaf.feature_name = "AirCon"	real_estate_properties
select T1.property_type_description from Ref_Property_Types as T1 inner join Properties as T2 on T1.property_type_code = T2.property_type_code where T2.property_type_code = "House"	real_estate_properties
select Properties.property_name from Properties join Ref_Property_Types on Properties.property_type_code = Ref_Property_Types.property_type_code where Properties.room_count > 1 and Ref_Property_Types.property_type_description in ("House, Bungalow, etc.","Apartment, Flat, Condo, etc.")	real_estate_properties
