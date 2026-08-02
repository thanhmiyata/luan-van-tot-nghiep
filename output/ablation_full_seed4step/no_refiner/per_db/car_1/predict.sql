SELECT COUNT(*) FROM continents
SELECT COUNT(*) FROM continents
SELECT continents.ContId, continents.Continent, COUNT(*) FROM continents JOIN countries ON countries.Continent = continents.ContId GROUP BY continents.ContId, continents.Continent
SELECT continents.ContId, continents.Continent, COUNT(*) FROM continents JOIN countries ON countries.Continent = continents.ContId GROUP BY continents.ContId, continents.Continent
SELECT COUNT(*) FROM countries
SELECT COUNT(*) FROM countries
SELECT car_makers.FullName, car_makers.Id, COUNT(*) FROM car_makers JOIN model_list ON model_list.Maker = car_makers.Id GROUP BY car_makers.FullName, car_makers.Id
SELECT car_makers.FullName, car_makers.Id, COUNT(*) FROM car_makers JOIN model_list ON model_list.Maker = car_makers.Id GROUP BY car_makers.FullName, car_makers.Id
SELECT model_list.Model FROM model_list JOIN car_names ON car_names.Model = model_list.Model JOIN cars_data ON cars_data.Id = car_names.MakeId ORDER BY cars_data.Horsepower ASC LIMIT 1
SELECT model_list.Model FROM model_list JOIN car_names ON car_names.Model = model_list.Model JOIN cars_data ON cars_data.Id = car_names.MakeId ORDER BY cars_data.Horsepower ASC LIMIT 1
SELECT model_list.Model FROM model_list JOIN car_names ON car_names.Model = model_list.Model JOIN cars_data ON cars_data.Id = car_names.MakeId WHERE cars_data.Weight < (SELECT AVG(Weight) FROM cars_data)
SELECT model_list.Model FROM model_list JOIN car_names ON car_names.Model = model_list.Model JOIN cars_data ON cars_data.Id = car_names.MakeId WHERE cars_data.Weight < (SELECT AVG(Weight) FROM cars_data)
SELECT DISTINCT car_makers.Maker, car_makers.FullName FROM car_makers INNER JOIN model_list ON model_list.Maker = car_makers.Id INNER JOIN car_names ON car_names.Model = model_list.Model INNER JOIN cars_data ON cars_data.Id = car_names.MakeId WHERE cars_data.Year = 1970
SELECT DISTINCT car_makers.Maker FROM car_makers INNER JOIN model_list ON model_list.Maker = car_makers.Id INNER JOIN car_names ON car_names.Model = model_list.Model INNER JOIN cars_data ON cars_data.Id = car_names.MakeId WHERE cars_data.Year = 1970
SELECT car_makers.Maker, cars_data.Year FROM cars_data JOIN car_names ON cars_data.Id = car_names.MakeId JOIN model_list ON car_names.Model = model_list.Model JOIN car_makers ON model_list.Maker = car_makers.Id WHERE cars_data.Year = (SELECT MIN(cars_data.Year) FROM cars_data)
SELECT car_makers.Maker, cars_data.Year FROM cars_data JOIN car_names ON cars_data.Id = car_names.MakeId JOIN model_list ON car_names.Model = model_list.Model JOIN car_makers ON model_list.Maker = car_makers.Id ORDER BY cars_data.Year ASC LIMIT 1
SELECT DISTINCT model_list.Model FROM model_list JOIN car_names ON car_names.Model = model_list.Model JOIN cars_data ON cars_data.Id = car_names.MakeId WHERE cars_data.Year > 1980
SELECT DISTINCT model_list.Model FROM model_list INNER JOIN car_names ON car_names.Model = model_list.Model INNER JOIN cars_data ON cars_data.Id = car_names.MakeId WHERE cars_data.Year > 1980
SELECT continents.Continent, COUNT(*) FROM continents JOIN countries ON countries.Continent = continents.ContId JOIN car_makers ON car_makers.Country = countries.CountryId GROUP BY continents.Continent ORDER BY continents.Continent ASC
SELECT continents.Continent, COUNT(*) FROM continents JOIN countries ON countries.Continent = continents.ContId JOIN car_makers ON car_makers.Country = countries.CountryId GROUP BY continents.Continent
SELECT CountryName FROM countries JOIN car_makers ON countries.CountryId = car_makers.Country GROUP BY CountryName ORDER BY COUNT(*) DESC LIMIT 1
SELECT countries.CountryName FROM countries JOIN car_makers ON countries.CountryId = car_makers.Country GROUP BY countries.CountryName ORDER BY COUNT(car_makers.Id) DESC LIMIT 1
SELECT COUNT(*), car_makers.FullName FROM model_list INNER JOIN car_makers ON model_list.Maker = car_makers.Id GROUP BY car_makers.FullName
SELECT car_makers.Id, car_makers.FullName, COUNT(model_list.ModelId) FROM car_makers INNER JOIN model_list ON model_list.Maker = car_makers.Id GROUP BY car_makers.Id, car_makers.FullName
SELECT cars_data.Accelerate FROM car_names INNER JOIN cars_data ON cars_data.Id = car_names.MakeId WHERE car_names.Make = 'amc hornet sportabout (sw)'
SELECT cars_data.Accelerate FROM car_names JOIN cars_data ON cars_data.Id = car_names.MakeId WHERE car_names.Make = 'amc hornet sportabout (sw)'
SELECT COUNT(*) FROM countries JOIN car_makers ON car_makers.Country = countries.CountryId WHERE countries.CountryName = 'france'
SELECT COUNT(*) FROM car_makers JOIN countries ON car_makers.Country = countries.CountryId WHERE countries.CountryName = 'france'
SELECT COUNT(*) FROM model_list JOIN car_makers ON model_list.Maker = car_makers.Id JOIN countries ON car_makers.Country = countries.CountryId WHERE countries.CountryName = 'usa'
SELECT COUNT(*) FROM countries JOIN car_makers ON car_makers.Country = countries.CountryId JOIN model_list ON model_list.Maker = car_makers.Id WHERE countries.CountryName = 'usa'
SELECT AVG(MPG) FROM cars_data WHERE Cylinders = 4
SELECT AVG(cars_data.MPG) FROM cars_data WHERE cars_data.Cylinders = 4
SELECT MIN(Weight) FROM cars_data WHERE Cylinders = 8 AND Year = 1974 LIMIT 1
SELECT MIN(Weight) FROM cars_data WHERE Cylinders = 8 AND Year = 1974
SELECT car_makers.Maker, model_list.Model FROM car_makers JOIN model_list ON model_list.Maker = car_makers.Id
SELECT car_makers.Maker, model_list.Model FROM car_makers INNER JOIN model_list ON model_list.Maker = car_makers.Id
SELECT countries.CountryName, countries.CountryId FROM countries JOIN car_makers ON car_makers.Country = countries.CountryId GROUP BY countries.CountryName, countries.CountryId HAVING COUNT(*) >= 1
SELECT countries.CountryName, countries.CountryId FROM countries INNER JOIN car_makers ON car_makers.Country = countries.CountryId GROUP BY countries.CountryId HAVING COUNT(car_makers.Id) > 0
SELECT COUNT(*) AS number_of_cars FROM cars_data WHERE Horsepower > 150
SELECT COUNT(*) FROM cars_data WHERE Horsepower > 150
SELECT Year, AVG(Weight) AS average_car_weight FROM cars_data GROUP BY Year
SELECT AVG(Weight) AS avg_weight, Year FROM cars_data GROUP BY Year
SELECT countries.CountryName FROM countries JOIN continents ON countries.Continent = continents.ContId JOIN car_makers ON car_makers.Country = countries.CountryId WHERE continents.Continent = 'europe' GROUP BY countries.CountryName HAVING COUNT(car_makers.Id) >= 3
SELECT countries.CountryName FROM countries JOIN continents ON countries.Continent = continents.ContId JOIN car_makers ON car_makers.Country = countries.CountryId WHERE continents.Continent = 'europe' GROUP BY countries.CountryName HAVING COUNT(*) >= 3
SELECT MAX(cars_data.Horsepower), car_names.Make FROM cars_data JOIN car_names ON cars_data.Id = car_names.MakeId WHERE cars_data.Cylinders = 3
SELECT MAX(cars_data.Horsepower), car_makers.Maker FROM cars_data INNER JOIN car_names ON cars_data.Id = car_names.MakeId INNER JOIN model_list ON car_names.Model = model_list.Model INNER JOIN car_makers ON model_list.Maker = car_makers.Id WHERE cars_data.Cylinders = 3 ORDER BY cars_data.Horsepower DESC LIMIT 1
SELECT car_names.Model FROM car_names JOIN cars_data ON cars_data.Id = car_names.MakeId ORDER BY cars_data.MPG DESC LIMIT 1
SELECT model_list.Model FROM model_list JOIN car_names ON car_names.Model = model_list.Model JOIN cars_data ON cars_data.Id = car_names.MakeId ORDER BY cars_data.MPG DESC LIMIT 1
SELECT AVG(Horsepower) FROM cars_data WHERE Year < 1980
SELECT AVG(Horsepower) FROM cars_data WHERE Year < 1980
SELECT AVG(cars_data.Edispl) FROM model_list JOIN car_names ON model_list.Model = car_names.Model JOIN cars_data ON car_names.MakeId = cars_data.Id WHERE model_list.Model = 'volvo'
SELECT AVG(cars_data.Edispl) FROM car_makers INNER JOIN model_list ON model_list.Maker = car_makers.Id INNER JOIN car_names ON car_names.Model = model_list.Model INNER JOIN cars_data ON cars_data.Id = car_names.MakeId WHERE car_makers.Maker = 'volvo'
SELECT Cylinders, MAX(Accelerate) FROM cars_data GROUP BY Cylinders
SELECT Cylinders, MAX(Accelerate) FROM cars_data GROUP BY Cylinders
SELECT model_list.Model, COUNT(car_names.Make) FROM model_list JOIN car_names ON model_list.Model = car_names.Model GROUP BY model_list.Model ORDER BY COUNT(car_names.Make) DESC LIMIT 1
SELECT model_list.Model FROM model_list JOIN car_names ON model_list.Model = car_names.Model GROUP BY model_list.Model ORDER BY COUNT(DISTINCT car_names.MakeId) DESC LIMIT 1
SELECT COUNT(*) FROM cars_data WHERE Cylinders > 4
SELECT COUNT(*) FROM cars_data WHERE Cylinders > 4
SELECT COUNT(*) FROM cars_data WHERE Year = 1980
SELECT COUNT(*) FROM cars_data WHERE Year = 1980
SELECT COUNT(*) FROM car_makers JOIN model_list ON model_list.Maker = car_makers.Id WHERE car_makers.FullName = 'American Motor Company'
SELECT COUNT(*) FROM car_makers INNER JOIN model_list ON model_list.Maker = car_makers.Id WHERE car_makers.FullName = 'American Motor Company'
SELECT car_makers.FullName, car_makers.Id FROM car_makers JOIN model_list ON car_makers.Id = model_list.Maker GROUP BY car_makers.Id HAVING COUNT(model_list.Model) > 3
SELECT car_makers.Maker, car_makers.Id FROM car_makers JOIN model_list ON car_makers.Id = model_list.Maker GROUP BY car_makers.Maker, car_makers.Id HAVING COUNT(model_list.ModelId) > 3
SELECT DISTINCT model_list.Model FROM model_list JOIN car_makers ON model_list.Maker = car_makers.Id JOIN cars_data ON cars_data.Id = model_list.ModelId WHERE car_makers.FullName = 'General Motors' OR cars_data.Weight > 3500
SELECT DISTINCT model_list.Model FROM model_list INNER JOIN car_makers ON model_list.Maker = car_makers.Id WHERE car_makers.FullName = 'General Motors' UNION SELECT DISTINCT model_list.Model FROM model_list INNER JOIN car_names ON car_names.Model = model_list.Model INNER JOIN cars_data ON cars_data.Id = car_names.MakeId WHERE cars_data.Weight > 3500
SELECT Year FROM cars_data WHERE Weight >= 3000 AND Weight <= 4000
SELECT Year FROM cars_data WHERE Weight < 4000 INTERSECT SELECT Year FROM cars_data WHERE Weight > 3000
SELECT Horsepower FROM cars_data ORDER BY Accelerate DESC LIMIT 1
SELECT Horsepower FROM cars_data ORDER BY Accelerate DESC LIMIT 1
SELECT cars_data.Cylinders FROM car_makers INNER JOIN model_list ON model_list.Maker = car_makers.Id INNER JOIN car_names ON car_names.Model = model_list.Model INNER JOIN cars_data ON cars_data.Id = car_names.MakeId WHERE car_makers.Maker = 'volvo' ORDER BY cars_data.Accelerate ASC LIMIT 1
SELECT cars_data.Cylinders FROM car_makers INNER JOIN model_list ON model_list.Maker = car_makers.Id INNER JOIN car_names ON car_names.Model = model_list.Model INNER JOIN cars_data ON cars_data.Id = car_names.MakeId WHERE car_makers.Maker = 'volvo' ORDER BY cars_data.Accelerate ASC LIMIT 1
SELECT COUNT(*) FROM cars_data WHERE Accelerate > (SELECT MAX(Horsepower) FROM cars_data)
SELECT COUNT(*) FROM cars_data WHERE Accelerate > (SELECT MAX(Horsepower) FROM cars_data)
SELECT COUNT(*) FROM countries INNER JOIN car_makers ON car_makers.Country = countries.CountryId GROUP BY countries.CountryId HAVING COUNT(car_makers.Id) > 2
SELECT COUNT(*) FROM countries JOIN car_makers ON car_makers.Country = countries.CountryId GROUP BY countries.CountryId HAVING COUNT(car_makers.Id) > 2
SELECT COUNT(*) FROM cars_data WHERE Cylinders > 6
SELECT COUNT(*) FROM cars_data WHERE Cylinders > 6
SELECT car_names.Model FROM cars_data INNER JOIN car_names ON cars_data.Id = car_names.MakeId WHERE cars_data.Cylinders = 4 ORDER BY cars_data.Horsepower DESC LIMIT 1
SELECT car_names.Model FROM cars_data JOIN car_names ON cars_data.Id = car_names.MakeId WHERE cars_data.Cylinders = 4 ORDER BY cars_data.Horsepower DESC LIMIT 1
SELECT DISTINCT car_makers.Id, car_makers.FullName FROM car_makers WHERE EXISTS(SELECT 1 FROM model_list JOIN car_names ON car_names.Model = model_list.Model JOIN cars_data ON cars_data.Id = car_names.MakeId WHERE model_list.Maker = car_makers.Id AND cars_data.Horsepower > (SELECT MIN(Horsepower) FROM cars_data) AND cars_data.Cylinders <= 3)
SELECT car_makers.Id, car_makers.FullName FROM car_makers JOIN model_list ON model_list.Maker = car_makers.Id JOIN car_names ON car_names.Model = model_list.Model JOIN cars_data ON cars_data.Id = car_names.MakeId WHERE NOT EXISTS(SELECT 1 FROM cars_data AS cd WHERE cd.Horsepower = cars_data.Horsepower AND cd.Horsepower = (SELECT MIN(Horsepower) FROM cars_data)) AND cars_data.Cylinders < 4
SELECT MAX(MPG) FROM cars_data WHERE (Cylinders = 8) OR (Year < 1980)
SELECT MAX(MPG) FROM cars_data WHERE Cylinders = 8 OR Year < 1980
SELECT model_list.Model FROM model_list JOIN car_makers ON model_list.Maker = car_makers.Id JOIN car_names ON car_names.Model = model_list.Model JOIN cars_data ON cars_data.Id = car_names.MakeId WHERE cars_data.Weight < 3500 AND NOT EXISTS(SELECT 1 FROM car_makers AS cm WHERE cm.Id = model_list.Maker AND cm.FullName = 'Ford Motor Company')
SELECT DISTINCT model_list.Model FROM model_list INNER JOIN car_makers ON model_list.Maker = car_makers.Id INNER JOIN cars_data ON cars_data.Id = model_list.ModelId WHERE cars_data.Weight < 3500 AND car_makers.FullName <> 'Ford Motor Company'
SELECT DISTINCT countries.CountryName FROM countries WHERE NOT EXISTS(SELECT 1 FROM car_makers WHERE car_makers.Country = countries.CountryId)
SELECT countries.CountryName FROM countries WHERE NOT EXISTS(SELECT 1 FROM car_makers WHERE car_makers.Country = countries.CountryId)
SELECT car_makers.Id, car_makers.Maker FROM car_makers JOIN model_list ON model_list.Maker = car_makers.Id GROUP BY car_makers.Id, car_makers.Maker HAVING COUNT(model_list.ModelId) >= 2 AND (SELECT COUNT(DISTINCT car_makers.Id) FROM car_makers) > 3
SELECT car_makers.Id, car_makers.Maker FROM car_makers JOIN model_list ON model_list.Maker = car_makers.Id JOIN car_names ON car_names.Model = model_list.Model GROUP BY car_makers.Id, car_makers.Maker HAVING COUNT(DISTINCT model_list.ModelId) >= 2 AND COUNT(car_names.MakeId) > 3
SELECT countries.CountryId, countries.CountryName FROM countries JOIN car_makers ON car_makers.Country = countries.CountryId WHERE car_makers.Id IN (SELECT Maker FROM model_list WHERE model_list.Model = 'fiat') UNION SELECT countries.CountryId, countries.CountryName FROM countries JOIN car_makers ON car_makers.Country = countries.CountryId GROUP BY countries.CountryId, countries.CountryName HAVING COUNT(*) > 3
SELECT countries.CountryId, countries.CountryName FROM countries WHERE countries.CountryId IN (SELECT car_makers.Country FROM car_makers GROUP BY car_makers.Country HAVING COUNT(*) > 3) OR countries.CountryId IN (SELECT car_makers.Country FROM car_makers JOIN model_list ON model_list.Maker = car_makers.Id WHERE model_list.Model = 'fiat')
