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
