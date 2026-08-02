SELECT COUNT(DISTINCT Continent) FROM continents	car_1
SELECT COUNT(DISTINCT ContId) FROM continents	car_1
SELECT c.ContId, c.Continent, COUNT(*) AS number_of_countries FROM continents c JOIN countries cn ON c.ContId = cn.Continent GROUP BY c.ContId, c.Continent	car_1
SELECT continents.ContId, continents.Continent, COUNT(countries.CountryId) AS CountryCount FROM continents LEFT JOIN countries ON continents.ContId = countries.Continent GROUP BY continents.ContId, continents.Continent	car_1
SELECT COUNT(*) AS count FROM countries	car_1
SELECT COUNT(*) AS num_countries FROM countries	car_1
SELECT car_makers.FullName, car_makers.Id, COUNT(model_list.ModelId) AS count FROM car_makers JOIN model_list ON car_makers.Id = model_list.Maker GROUP BY car_makers.Id, car_makers.FullName	car_1
SELECT T1.FullName, T1.Id, COUNT(T2.ModelId) AS ModelCount FROM car_makers AS T1 LEFT JOIN model_list AS T2 ON T1.Id = T2.Maker GROUP BY T1.FullName, T1.Id	car_1
SELECT T1.Model FROM model_list AS T1 JOIN car_names AS T2 ON T1.Model = T2.Model JOIN cars_data AS T3 ON T2.MakeId = T3.Id ORDER BY T3.Horsepower ASC LIMIT 1	car_1
SELECT T1.Model FROM model_list AS T1 JOIN cars_data AS T2 ON T1.ModelId = T2.Id ORDER BY T2.Horsepower ASC LIMIT 1	car_1
SELECT m.Model FROM model_list m JOIN cars_data c ON m.ModelId = c.Id WHERE c.Weight < (SELECT AVG(Weight) FROM cars_data)	car_1
SELECT model_list.Model FROM cars_data JOIN model_list ON cars_data.Id = model_list.ModelId WHERE cars_data.Weight < (SELECT AVG(Weight) FROM cars_data)	car_1
SELECT DISTINCT car_makers.Maker FROM car_makers JOIN model_list ON car_makers.Id = model_list.Maker JOIN car_names ON model_list.ModelId = car_names.MakeId JOIN cars_data ON car_names.Id = cars_data.Id WHERE cars_data.Year = 1970	car_1
SELECT DISTINCT T4.Maker FROM cars_data AS T1 JOIN car_names AS T2 ON T1.Id = T2.MakeId JOIN model_list AS T3 ON T2.Model = T3.Model JOIN car_makers AS T4 ON T3.Maker = T4.Id WHERE T1.Year = 1970	car_1
SELECT T1.Maker, T4.Year FROM car_makers AS T1 JOIN model_list AS T2 ON T1.Id = T2.Maker JOIN car_names AS T3 ON T2.ModelId = T3.Model JOIN cars_data AS T4 ON T3.MakeId = T4.Id WHERE T4.Year = (SELECT MIN(Year) FROM cars_data)	car_1
SELECT T1.Maker, T4.Year FROM car_makers AS T1 JOIN model_list AS T2 ON T1.Id = T2.Maker JOIN car_names AS T3 ON T2.ModelId = T3.Model JOIN cars_data AS T4 ON T3.MakeId = T4.Id ORDER BY T4.Year ASC LIMIT 1	car_1
SELECT DISTINCT T1.Model FROM model_list AS T1 JOIN car_names AS T2 ON T1.Model = T2.Model JOIN cars_data AS T3 ON T2.MakeId = T3.Id WHERE T3.Year > 1980	car_1
SELECT DISTINCT T1.Model FROM model_list AS T1 JOIN car_names AS T2 ON T1.Model = T2.Model JOIN cars_data AS T3 ON T3.Id = T2.MakeId WHERE T3.Year > 1980	car_1
SELECT T1.Continent, COUNT(T3.Id) AS car_makers_count FROM continents AS T1 JOIN countries AS T2 ON T1.ContId = T2.Continent JOIN car_makers AS T3 ON T2.CountryId = T3.Country GROUP BY T1.Continent	car_1
SELECT c.Continent, COUNT(*) AS CarMakersCount FROM continents AS c JOIN countries AS co ON c.ContId = co.ContinentId JOIN car_makers AS cm ON co.CountryId = cm.Country GROUP BY c.Continent	car_1
SELECT CountryName FROM countries JOIN car_makers ON countries.CountryId = car_makers.Country GROUP BY CountryName ORDER BY COUNT(*) DESC LIMIT 1	car_1
SELECT CountryName FROM countries JOIN car_makers ON countries.CountryId = car_makers.Country GROUP BY CountryName ORDER BY COUNT(*) DESC LIMIT 1	car_1
SELECT COUNT(*), car_makers.FullName FROM car_makers JOIN model_list ON car_makers.Id = model_list.Maker GROUP BY car_makers.FullName	car_1
SELECT COUNT(model_list.ModelId), car_makers.Id, car_makers.FullName FROM car_makers JOIN model_list ON car_makers.Id = model_list.Maker GROUP BY car_makers.Id, car_makers.FullName	car_1
SELECT cars_data.Accelerate FROM car_names JOIN cars_data ON car_names.MakeId = cars_data.Id WHERE car_names.Make = 'amc' AND car_names.Model = 'hornet sportabout (sw)'	car_1
SELECT Accelerate FROM cars_data WHERE Id = (SELECT MakeId FROM car_names WHERE Make = 'amc hornet sportabout (sw)')	car_1
SELECT COUNT(DISTINCT Maker) AS car_makers_count FROM car_makers WHERE Country = 'france'	car_1
SELECT COUNT(DISTINCT Maker) FROM car_makers WHERE Country = 'France'	car_1
SELECT COUNT(*) AS count FROM model_list JOIN car_makers ON model_list.Maker = car_makers.Id WHERE car_makers.Country = 'usa'	car_1
SELECT COUNT(*) FROM model_list JOIN car_makers ON model_list.Maker = car_makers.Id WHERE car_makers.Country = 'usa'	car_1
SELECT AVG(MPG) FROM cars_data WHERE Cylinders = 4	car_1
SELECT AVG(MPG) FROM cars_data WHERE Cylinders = 4	car_1
SELECT MIN(Weight) FROM cars_data WHERE Cylinders = 8 AND Year = 1974	car_1
SELECT MIN(Weight) FROM cars_data WHERE Cylinders = 8 AND Year = 1974	car_1
SELECT car_makers.Maker, model_list.Model FROM model_list JOIN car_makers ON model_list.Maker = car_makers.Maker	car_1
SELECT Maker, Model FROM model_list	car_1
SELECT CountryName, CountryId FROM countries WHERE CountryId IN (SELECT DISTINCT Country FROM car_makers)	car_1
SELECT countries.CountryName, countries.CountryId FROM countries JOIN car_makers ON countries.CountryId = car_makers.Country	car_1
SELECT COUNT(*) AS number_of_cars FROM cars_data WHERE Horsepower > 150	car_1
SELECT COUNT(*) FROM cars_data WHERE Horsepower > 150	car_1
SELECT AVG(Weight) AS average_weight, Year FROM cars_data GROUP BY Year	car_1
SELECT AVG(Weight) AS avg_weight, Year FROM cars_data GROUP BY Year	car_1
SELECT T1.CountryName FROM countries AS T1 JOIN car_makers AS T2 ON T1.CountryId = T2.Country WHERE T1.Continent = 'europe' GROUP BY T1.CountryName HAVING COUNT(*) >= 3	car_1
SELECT T1.CountryName FROM countries AS T1 JOIN continents AS T2 ON T1.Continent = T2.ContId JOIN car_makers AS T3 ON T1.CountryId = T3.Country WHERE T2.Continent = 'europe' GROUP BY T1.CountryName HAVING COUNT(*) >= 3	car_1
SELECT T2.Horsepower, T1.Make FROM car_names AS T1 JOIN cars_data AS T2 ON T1.MakeId = T2.Id WHERE T2.Cylinders = 3 ORDER BY T2.Horsepower DESC LIMIT 1	car_1
SELECT T1.Horsepower, T3.Maker FROM cars_data AS T1 JOIN model_list AS T2 ON T1.Id = T2.ModelId JOIN car_makers AS T3 ON T2.Maker = T3.Id WHERE T1.Cylinders = 3 ORDER BY T1.Horsepower DESC LIMIT 1	car_1
SELECT T1.Model FROM model_list AS T1 JOIN car_names AS T2 ON T1.Model = T2.Model JOIN cars_data AS T3 ON T2.MakeId = T3.Id ORDER BY T3.MPG DESC LIMIT 1	car_1
SELECT T1.Model FROM model_list AS T1 JOIN car_names AS T2 ON T1.ModelId = T2.Model JOIN cars_data AS T3 ON T2.MakeId = T3.Id ORDER BY T3.MPG DESC LIMIT 1	car_1
SELECT AVG(Horsepower) AS average_horsepower FROM cars_data WHERE Year < 1980	car_1
SELECT AVG(Horsepower) FROM cars_data WHERE Year < 1980	car_1
SELECT AVG(T1.Edispl) FROM cars_data AS T1 JOIN car_names AS T2 ON T1.Id = T2.Model JOIN model_list AS T3 ON T2.MakeId = T3.ModelId WHERE T3.Model = 'volvo'	car_1
SELECT AVG(T1.Edispl) FROM cars_data AS T1 INNER JOIN car_names AS T2 ON T1.Id = T2.MakeId INNER JOIN model_list AS T3 ON T2.Model = T3.ModelId INNER JOIN car_makers AS T4 ON T3.Maker = T4.Id WHERE T4.Maker = 'volvo'	car_1
SELECT MAX(Accelerate), Cylinders FROM cars_data GROUP BY Cylinders	car_1
SELECT MAX(Accelerate) FROM cars_data GROUP BY Cylinders	car_1
SELECT m.Model FROM model_list m JOIN car_names c ON m.ModelId = c.Model GROUP BY m.Model ORDER BY COUNT(*) DESC LIMIT 1	car_1
SELECT ml.Model FROM model_list AS ml JOIN car_names AS cn ON ml.Model = cn.Model GROUP BY ml.Model ORDER BY COUNT(DISTINCT cn.MakeId) DESC LIMIT 1	car_1
SELECT COUNT(*) AS count FROM cars_data WHERE Cylinders > 4	car_1
SELECT COUNT(*) FROM cars_data WHERE Cylinders > 4	car_1
SELECT COUNT(*) AS count FROM cars_data WHERE Year = 1980	car_1
SELECT COUNT(*) AS count FROM cars_data WHERE Year = 1980	car_1
SELECT COUNT(*) AS count FROM model_list JOIN car_makers ON model_list.Maker = car_makers.Id WHERE car_makers.FullName = 'American Motor Company'	car_1
SELECT COUNT(*) AS number_of_models FROM model_list AS T1 JOIN car_makers AS T2 ON T1.Maker = T2.Id WHERE T2.Maker = 'amc'	car_1
SELECT car_makers.FullName, car_makers.Id FROM car_makers JOIN model_list ON car_makers.Id = model_list.Maker GROUP BY car_makers.Id HAVING COUNT(model_list.ModelId) > 3	car_1
SELECT T1.Maker, T1.Id FROM car_makers AS T1 JOIN model_list AS T2 ON T1.Id = T2.Maker GROUP BY T1.Maker, T1.Id HAVING COUNT(*) > 3	car_1
SELECT DISTINCT T1.Model FROM model_list AS T1 JOIN car_makers AS T2 ON T1.Maker = T2.Id LEFT JOIN cars_data AS T3 ON T1.ModelId = T3.Id WHERE T2.FullName = 'General Motors' OR T3.Weight > 3500	car_1
SELECT DISTINCT Model FROM model_list WHERE Maker = (SELECT Id FROM car_makers WHERE FullName = 'General Motors') OR ModelId IN (SELECT ModelId FROM cars_data WHERE Weight > 3500)	car_1
SELECT Year FROM cars_data WHERE Weight >= 3000 AND Weight <= 4000	car_1
SELECT DISTINCT Year FROM cars_data WHERE Weight < 4000 INTERSECT SELECT DISTINCT Year FROM cars_data WHERE Weight > 3000	car_1
SELECT Horsepower FROM cars_data ORDER BY Accelerate DESC LIMIT 1	car_1
SELECT Horsepower FROM cars_data ORDER BY Accelerate DESC LIMIT 1	car_1
SELECT cars_data.Cylinders FROM cars_data JOIN model_list ON model_list.ModelId = cars_data.Id WHERE model_list.Maker = 'volvo' ORDER BY cars_data.Accelerate ASC LIMIT 1	car_1
SELECT T3.Cylinders FROM model_list AS T1 JOIN car_names AS T2 ON T1.Model = T2.Model JOIN cars_data AS T3 ON T2.MakeId = T3.Id WHERE T1.Maker = 'volvo' ORDER BY T3.Accelerate ASC LIMIT 1	car_1
SELECT COUNT(*) AS count FROM cars_data WHERE Accelerate > (SELECT MAX(Horsepower) FROM cars_data)	car_1
SELECT COUNT(*) AS "Number of cars" FROM cars_data WHERE Accelerate > (SELECT MAX(CAST(Horsepower AS REAL)) FROM cars_data)	car_1
SELECT COUNT(*) FROM (SELECT Country FROM car_makers GROUP BY Country HAVING COUNT(*) > 2) AS Subquery	car_1
SELECT COUNT(*) FROM (SELECT Country FROM car_makers GROUP BY Country HAVING COUNT(*) > 2) AS subquery	car_1
SELECT COUNT(*) as count FROM cars_data WHERE Cylinders > 6	car_1
SELECT COUNT(*) AS number_of_cars FROM cars_data WHERE Cylinders > 6	car_1
SELECT T1.Model FROM model_list AS T1 JOIN cars_data AS T2 ON T1.ModelId = T2.Id WHERE T2.Cylinders = 4 ORDER BY T2.Horsepower DESC LIMIT 1	car_1
SELECT model_list.Model FROM model_list JOIN cars_data ON model_list.ModelId = cars_data.Id WHERE cars_data.Cylinders = 4 ORDER BY cars_data.Horsepower DESC LIMIT 1	car_1
SELECT T2.MakeId, T4.FullName FROM cars_data AS T1 JOIN car_names AS T2 ON T1.Id = T2.Model JOIN model_list AS T3 ON T2.MakeId = T3.ModelId JOIN car_makers AS T4 ON T3.Maker = T4.Id WHERE T1.Horsepower > (SELECT MIN(Horsepower) FROM cars_data) AND T1.Cylinders <= 3	car_1
SELECT T1.MakeId, T1.Make FROM car_names AS T1 JOIN cars_data AS T2 ON T1.MakeId = T2.Id WHERE T2.Cylinders < 4 AND T2.Horsepower <> (SELECT MIN(Horsepower) FROM cars_data)	car_1
SELECT MAX(MPG) FROM cars_data WHERE Cylinders = 8 OR Year < 1980	car_1
SELECT MAX(MPG) FROM cars_data WHERE Cylinders = 8 OR Year < 1980	car_1
SELECT T1.Model FROM model_list AS T1 JOIN car_makers AS T2 ON T1.Maker = T2.Id JOIN car_names AS T3 ON T1.Model = T3.Model JOIN cars_data AS T4 ON T3.MakeId = T4.Id WHERE T4.Weight < 3500 AND T2.Maker <> 'Ford Motor Company'	car_1
SELECT DISTINCT T1.Model FROM model_list AS T1 JOIN cars_data AS T2 ON T1.ModelId = T2.Id JOIN car_makers AS T3 ON T1.Maker = T3.Id WHERE T2.Weight < 3500 AND T3.FullName <> 'Ford Motor Company'	car_1
SELECT CountryName FROM countries WHERE CountryId NOT IN (SELECT Country FROM car_makers)	car_1
SELECT CountryName FROM countries WHERE CountryId NOT IN (SELECT Country FROM car_makers)	car_1
SELECT c.Id, c.Maker FROM car_makers AS c WHERE (SELECT COUNT(*) FROM model_list AS m WHERE m.Maker = c.Maker) >= 2 HAVING COUNT(DISTINCT c.Maker) > 3	car_1
SELECT T1.Id, T1.Maker FROM car_makers AS T1 WHERE (SELECT COUNT(DISTINCT T2.Model) FROM model_list AS T2 WHERE T2.Maker = T1.Id) >= 2 AND (SELECT COUNT(*) FROM car_names AS T3 WHERE T3.MakeId = T1.Id) > 3	car_1
SELECT T1.CountryId, T1.CountryName FROM countries AS T1 JOIN car_makers AS T2 ON T1.CountryId = T2.Country LEFT JOIN model_list AS T3 ON T2.Id = T3.Maker WHERE T2.Country IN (SELECT Country FROM car_makers GROUP BY Country HAVING COUNT(*) > 3) OR T3.Model = 'fiat'	car_1
SELECT CountryId, CountryName FROM countries WHERE CountryId IN (SELECT Country FROM car_makers GROUP BY Country HAVING COUNT(*) > 3) OR CountryId IN (SELECT Country FROM car_makers INNER JOIN model_list ON car_makers.Maker = model_list.Maker WHERE model_list.Model = 'fiat')	car_1
