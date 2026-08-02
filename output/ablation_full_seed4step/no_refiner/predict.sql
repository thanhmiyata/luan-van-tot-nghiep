SELECT Name FROM country WHERE IndepYear > 1950
SELECT Name FROM country WHERE IndepYear > 1950
SELECT COUNT(*) FROM country WHERE GovernmentForm = 'Republic'
SELECT COUNT(*) FROM country WHERE GovernmentForm = 'Republic'
SELECT SUM(SurfaceArea) FROM country WHERE Region = 'Caribbean'
SELECT SUM(SurfaceArea) FROM country WHERE Region = 'Caribbean'
SELECT Continent FROM country WHERE Name = 'Anguilla'
SELECT Continent FROM country WHERE Name = 'Anguilla'
SELECT country.Region FROM city JOIN country ON city.CountryCode = country.Code WHERE city.Name = 'Kabul'
SELECT country.Region FROM city INNER JOIN country ON city.CountryCode = country.Code WHERE city.Name = 'Kabul'
SELECT countrylanguage.Language FROM country INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE country.Name = 'Aruba' ORDER BY countrylanguage.Percentage DESC LIMIT 1
SELECT countrylanguage.Language FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE country.Name = 'Aruba'
SELECT Population, LifeExpectancy FROM country WHERE Name = 'Brazil'
SELECT Population, LifeExpectancy FROM country WHERE Name = 'Brazil'
SELECT Region, Population FROM country WHERE Name = 'Angola'
SELECT Region, Population FROM country WHERE Name = 'Angola'
SELECT AVG(LifeExpectancy) FROM country WHERE Region = 'Central Africa'
SELECT AVG(LifeExpectancy) FROM country WHERE Region = 'Central Africa'
SELECT Name FROM country WHERE Continent = 'Asia' ORDER BY LifeExpectancy ASC LIMIT 1
SELECT Name FROM country WHERE Continent = 'Asia' ORDER BY LifeExpectancy ASC LIMIT 1
SELECT SUM(Population) AS total_population, MAX(GNP) AS maximum_gnp FROM country WHERE Continent = 'Asia'
SELECT COUNT(*), MAX(GNP) FROM country WHERE Continent = 'Asia'
SELECT AVG(LifeExpectancy) FROM country WHERE Continent = 'Africa' AND GovernmentForm = 'Republic'
SELECT AVG(LifeExpectancy) FROM country WHERE Continent = 'Africa' AND GovernmentForm = 'Republic'
SELECT SUM(SurfaceArea) FROM country WHERE Continent = 'Asia' OR Continent = 'Europe'
SELECT SUM(SurfaceArea) FROM country WHERE Continent = 'Asia' OR Continent = 'Europe'
SELECT COUNT(*) FROM city WHERE District = 'Gelderland'
SELECT SUM(Population) FROM city WHERE District = 'Gelderland'
SELECT AVG(GNP), SUM(Population) FROM country WHERE GovernmentForm = 'US Territory'
SELECT AVG(GNP) AS AVG_GNP, SUM(Population) AS SUM_Population FROM country WHERE GovernmentForm = 'US Territory'
SELECT COUNT(DISTINCT Language) FROM countrylanguage
SELECT COUNT(DISTINCT Language) FROM countrylanguage
SELECT COUNT(DISTINCT GovernmentForm) FROM country WHERE Continent = 'Africa'
SELECT COUNT(DISTINCT GovernmentForm) FROM country WHERE Continent = 'Africa'
SELECT COUNT(*) FROM country INNER JOIN countrylanguage ON countrylanguage.CountryCode = country.Code WHERE country.Name = 'Aruba'
SELECT COUNT(*) FROM country INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE country.Name = 'Aruba'
SELECT COUNT(*) FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE country.Name = 'Afghanistan' AND countrylanguage.IsOfficial = 'T'
SELECT COUNT(*) FROM countrylanguage INNER JOIN country ON countrylanguage.CountryCode = country.Code WHERE country.Name = 'Afghanistan' AND countrylanguage.IsOfficial = 'T'
SELECT country.Name FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode GROUP BY country.Code, country.Name HAVING COUNT(countrylanguage.Language) = (SELECT MAX(lang_count) FROM (SELECT COUNT(*) AS lang_count FROM countrylanguage GROUP BY countrylanguage.CountryCode)) ORDER BY COUNT(countrylanguage.Language) DESC LIMIT 1
SELECT country.Name FROM country INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode GROUP BY country.Code, country.Name HAVING COUNT(DISTINCT countrylanguage.Language) = (SELECT MAX(language_count) FROM (SELECT COUNT(DISTINCT Language) AS language_count FROM countrylanguage GROUP BY CountryCode) AS LanguageCounts)
SELECT country.Continent FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode GROUP BY country.Continent HAVING COUNT(DISTINCT countrylanguage.Language) > 0 ORDER BY COUNT(DISTINCT countrylanguage.Language) DESC LIMIT 1
SELECT country.Continent FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode GROUP BY country.Continent ORDER BY COUNT(DISTINCT countrylanguage.Language) DESC LIMIT 1
SELECT COUNT(*) FROM countrylanguage WHERE Language IN ('English', 'Dutch') GROUP BY CountryCode HAVING COUNT(DISTINCT Language) = 2
SELECT COUNT(*) FROM (SELECT CountryCode FROM countrylanguage WHERE Language = 'English' INTERSECT SELECT CountryCode FROM countrylanguage WHERE Language = 'Dutch')
SELECT country.Name FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.Language = 'English' INTERSECT SELECT country.Name FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.Language = 'French'
SELECT Name FROM country WHERE Code IN (SELECT CountryCode FROM countrylanguage WHERE Language = 'English' INTERSECT SELECT CountryCode FROM countrylanguage WHERE Language = 'French')
SELECT DISTINCT country.Name FROM country INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.Language = 'English' AND countrylanguage.IsOfficial = 'T' INTERSECT SELECT DISTINCT country.Name FROM country INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.Language = 'French' AND countrylanguage.IsOfficial = 'T'
SELECT DISTINCT country.Name FROM country JOIN countrylanguage ON countrylanguage.CountryCode = country.Code WHERE countrylanguage.Language = 'English' INTERSECT SELECT DISTINCT country.Name FROM country JOIN countrylanguage ON countrylanguage.CountryCode = country.Code WHERE countrylanguage.Language = 'French'
SELECT COUNT(DISTINCT country.Continent) FROM country JOIN countrylanguage ON countrylanguage.CountryCode = country.Code WHERE countrylanguage.Language = 'Chinese'
SELECT COUNT(*) FROM (SELECT DISTINCT country.Continent FROM country INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.Language = 'Chinese')
SELECT DISTINCT country.Region FROM country JOIN countrylanguage ON countrylanguage.CountryCode = country.Code WHERE countrylanguage.Language = 'English' OR countrylanguage.Language = 'Dutch'
SELECT DISTINCT country.Region FROM country JOIN countrylanguage ON countrylanguage.CountryCode = country.Code WHERE countrylanguage.Language = 'Dutch' OR countrylanguage.Language = 'English'
SELECT DISTINCT country.Name FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE (countrylanguage.Language = 'English' AND countrylanguage.IsOfficial = 'T') UNION SELECT DISTINCT country.Name FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE (countrylanguage.Language = 'Dutch' AND countrylanguage.IsOfficial = 'T')
SELECT DISTINCT country.Name FROM country INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE (countrylanguage.Language = 'English' AND countrylanguage.IsOfficial = 'T') UNION SELECT DISTINCT country.Name FROM country INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE (countrylanguage.Language = 'Dutch' AND countrylanguage.IsOfficial = 'T')
SELECT countrylanguage.Language FROM countrylanguage JOIN country ON countrylanguage.CountryCode = country.Code WHERE country.Continent = 'Asia' ORDER BY countrylanguage.Percentage DESC LIMIT 1
SELECT countrylanguage.Language FROM countrylanguage INNER JOIN country ON countrylanguage.CountryCode = country.Code WHERE country.Continent = 'Asia' GROUP BY countrylanguage.Language HAVING COUNT(*) = (SELECT MAX(language_count) FROM (SELECT COUNT(*) AS language_count FROM countrylanguage INNER JOIN country ON countrylanguage.CountryCode = country.Code WHERE country.Continent = 'Asia' GROUP BY countrylanguage.Language))
SELECT countrylanguage.Language FROM countrylanguage JOIN country ON countrylanguage.CountryCode = country.Code WHERE country.GovernmentForm = 'Republic' GROUP BY countrylanguage.Language HAVING COUNT(DISTINCT countrylanguage.CountryCode) = 1
SELECT Language FROM countrylanguage JOIN country ON countrylanguage.CountryCode = country.Code WHERE country.GovernmentForm = 'Republic' GROUP BY Language HAVING COUNT(countrylanguage.CountryCode) = 1
SELECT city.Name FROM city JOIN countrylanguage ON city.CountryCode = countrylanguage.CountryCode WHERE countrylanguage.Language = 'English' ORDER BY city.Population DESC LIMIT 1
SELECT city.Name FROM city JOIN countrylanguage ON city.CountryCode = countrylanguage.CountryCode WHERE countrylanguage.Language = 'English' ORDER BY city.Population DESC LIMIT 1
SELECT Name, Population, LifeExpectancy FROM country WHERE Continent = 'Asia' ORDER BY SurfaceArea DESC LIMIT 1
SELECT Name, Population, LifeExpectancy FROM country WHERE Continent = 'Asia' ORDER BY SurfaceArea DESC LIMIT 1
SELECT AVG(country.LifeExpectancy) FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.Language <> 'English' AND countrylanguage.IsOfficial = 'T'
SELECT AVG(country.LifeExpectancy) AS LifeExpectancy FROM country WHERE NOT EXISTS(SELECT 1 FROM countrylanguage WHERE countrylanguage.CountryCode = country.Code AND countrylanguage.Language = 'English' AND countrylanguage.IsOfficial = 'T')
SELECT SUM(country.Population) AS total_population FROM country WHERE NOT EXISTS(SELECT 1 FROM countrylanguage WHERE country.Code = countrylanguage.CountryCode AND countrylanguage.Language = 'English')
SELECT SUM(Population) FROM country WHERE NOT EXISTS(SELECT 1 FROM countrylanguage WHERE country.Code = countrylanguage.CountryCode AND countrylanguage.Language = 'English')
SELECT countrylanguage.Language FROM country INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE country.HeadOfState = 'Beatrix'
SELECT countrylanguage.Language FROM country JOIN countrylanguage ON countrylanguage.CountryCode = country.Code WHERE country.HeadOfState = 'Beatrix' AND countrylanguage.IsOfficial = 'T'
SELECT COUNT(DISTINCT countrylanguage.Language) AS count FROM country INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE country.IndepYear < 1930 AND countrylanguage.IsOfficial = 'T'
SELECT COUNT(DISTINCT countrylanguage.Language) FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE country.IndepYear < 1930
SELECT country.Name FROM country WHERE country.SurfaceArea > (SELECT MAX(SurfaceArea) FROM country WHERE Continent = 'Europe')
SELECT Name FROM country WHERE SurfaceArea > (SELECT MAX(SurfaceArea) FROM country WHERE Continent = 'Europe')
SELECT Name FROM country WHERE Continent = 'Africa' AND Population < (SELECT MIN(Population) FROM country WHERE Continent = 'Asia')
SELECT Name FROM country WHERE Continent = 'Africa' AND Population < (SELECT MIN(Population) FROM country WHERE Continent = 'Asia')
SELECT Name FROM country WHERE Continent = 'Asia' AND Population > (SELECT MAX(Population) FROM country WHERE Continent = 'Africa')
SELECT Name FROM country WHERE Continent = 'Asia' AND Population > (SELECT MAX(Population) FROM country WHERE Continent = 'Africa')
SELECT DISTINCT country.Code FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.Language <> 'English'
SELECT Code FROM country WHERE NOT EXISTS(SELECT 1 FROM countrylanguage WHERE countrylanguage.CountryCode = country.Code AND countrylanguage.Language = 'English')
SELECT country.Code FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.Language <> 'English'
SELECT DISTINCT country.Code FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.Language <> 'English'
SELECT country.Code FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.Language <> 'English' AND country.GovernmentForm <> 'Republic'
SELECT country.Code FROM country WHERE country.GovernmentForm <> 'Republic' AND NOT EXISTS(SELECT 1 FROM countrylanguage WHERE countrylanguage.CountryCode = country.Code AND countrylanguage.Language = 'English')
SELECT city.Name FROM city JOIN country ON city.CountryCode = country.Code JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE country.Continent = 'Europe' AND countrylanguage.Language = 'English' AND countrylanguage.IsOfficial <> 'T'
SELECT city.Name FROM city JOIN country ON city.CountryCode = country.Code JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE country.Continent = 'Europe' AND countrylanguage.IsOfficial = 'T' AND countrylanguage.Language <> 'English'
SELECT DISTINCT city.Name FROM city JOIN country ON city.CountryCode = country.Code JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE country.Continent = 'Asia' AND countrylanguage.Language = 'Chinese' AND countrylanguage.IsOfficial = 'T'
SELECT DISTINCT city.Name FROM city INNER JOIN country ON city.CountryCode = country.Code INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE country.Continent = 'Asia' AND countrylanguage.Language = 'Chinese' AND countrylanguage.IsOfficial = 'T'
SELECT Name, IndepYear, SurfaceArea FROM country ORDER BY Population ASC LIMIT 1
SELECT Name, IndepYear, SurfaceArea FROM country ORDER BY Population ASC LIMIT 1
SELECT Population, Name, HeadOfState FROM country ORDER BY SurfaceArea DESC LIMIT 1
SELECT Name, Population, HeadOfState FROM country ORDER BY SurfaceArea DESC LIMIT 1
SELECT country.Name, COUNT(countrylanguage.Language) AS LanguageCount FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode GROUP BY country.Code HAVING COUNT(countrylanguage.Language) >= 3
SELECT country.Name, COUNT(*) AS language_count FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode GROUP BY country.Name HAVING COUNT(*) > 2
SELECT District, COUNT(*) AS count FROM city GROUP BY District HAVING SUM(Population) > (SELECT AVG(Population) FROM city)
SELECT District, COUNT(*) FROM city WHERE Population > (SELECT AVG(Population) FROM city) GROUP BY District
SELECT GovernmentForm, SUM(Population) FROM country GROUP BY GovernmentForm HAVING AVG(LifeExpectancy) > 72
SELECT GovernmentForm, SUM(Population) AS total_population FROM country WHERE LifeExpectancy > 72 GROUP BY GovernmentForm
SELECT AVG(LifeExpectancy), SUM(Population) FROM country GROUP BY Continent HAVING AVG(LifeExpectancy) < 72
SELECT Continent, SUM(Population) AS total_population, AVG(LifeExpectancy) AS average_life_expectancy FROM country GROUP BY Continent HAVING AVG(LifeExpectancy) < 72
SELECT Name, SurfaceArea FROM country ORDER BY SurfaceArea DESC LIMIT 5
SELECT Name, SurfaceArea FROM country ORDER BY SurfaceArea DESC LIMIT 5
SELECT Name FROM country ORDER BY Population DESC LIMIT 3
SELECT Name FROM country ORDER BY Population DESC LIMIT 3
SELECT Name FROM country ORDER BY Population ASC LIMIT 3
SELECT Name FROM country ORDER BY Population ASC LIMIT 3
SELECT COUNT(*) FROM country WHERE Continent = 'Asia'
SELECT COUNT(*) FROM country WHERE Continent = 'Asia'
SELECT Name FROM country WHERE Continent = 'Europe' AND Population = 80000
SELECT Name FROM country WHERE Continent = 'Europe' AND Population = 80000
SELECT SUM(Population) AS total_population, AVG(SurfaceArea) AS average_area FROM country WHERE Continent = 'North America' AND SurfaceArea > 3000
SELECT SUM(Population), AVG(SurfaceArea) FROM country WHERE Continent = 'North America' AND SurfaceArea > 3000
SELECT Name FROM city WHERE Population BETWEEN 160000 AND 900000
SELECT Name FROM city WHERE Population BETWEEN 160000 AND 900000
SELECT Language FROM countrylanguage GROUP BY Language HAVING COUNT(*) = (SELECT MAX(language_count) FROM (SELECT COUNT(*) AS language_count FROM countrylanguage GROUP BY Language))
SELECT Language FROM countrylanguage GROUP BY Language HAVING COUNT(*) = (SELECT MAX(country_count) FROM (SELECT Language, COUNT(*) AS country_count FROM countrylanguage GROUP BY Language) AS subquery)
SELECT T1.Language, T1.CountryCode FROM countrylanguage AS T1 WHERE T1.Percentage = (SELECT MAX(T2.Percentage) FROM countrylanguage AS T2 WHERE T2.CountryCode = T1.CountryCode) ORDER BY T1.CountryCode
SELECT country.Code, countrylanguage.Language FROM country INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.Percentage = (SELECT MAX(cl2.Percentage) FROM countrylanguage AS cl2 WHERE cl2.CountryCode = country.Code) GROUP BY country.Code HAVING countrylanguage.Percentage = MAX(countrylanguage.Percentage)
SELECT COUNT(*) AS total_number_of_countries FROM (SELECT CountryCode FROM countrylanguage WHERE Language = 'Spanish' ORDER BY Percentage DESC LIMIT 1) AS top_country
SELECT COUNT(*) FROM country INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.Language = 'Spanish'
SELECT country.Code FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.Language = 'Spanish' ORDER BY countrylanguage.Percentage DESC LIMIT 1
SELECT country.Code FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.Language = 'Spanish'
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
SELECT COUNT(*) AS COUNT_Documents FROM Documents
SELECT COUNT(*) AS count FROM Documents
SELECT Document_ID, Document_Name, Document_Description FROM Documents
SELECT Document_ID, Document_Name, Document_Description FROM Documents
SELECT Document_Name, Template_ID FROM Documents WHERE Document_Description LIKE '%w%'
SELECT Document_Name, Template_ID FROM Documents WHERE Document_Description LIKE '%w%'
SELECT Document_ID, Template_ID, Document_Description FROM Documents WHERE Document_Name = 'Robbin CV'
SELECT Document_ID, Template_ID, Document_Description FROM Documents WHERE Document_Name = 'Robbin CV'
SELECT COUNT(DISTINCT Templates.Template_ID) AS number_of_templates FROM Documents JOIN Templates ON Documents.Template_ID = Templates.Template_ID
SELECT COUNT(DISTINCT Template_Type_Code) FROM Templates
SELECT COUNT(*) FROM Documents JOIN Templates ON Documents.Template_ID = Templates.Template_ID WHERE Templates.Template_Type_Code = 'PPT'
SELECT COUNT(*) AS count FROM Documents JOIN Templates ON Documents.Template_ID = Templates.Template_ID WHERE Templates.Template_Type_Code = 'PPT'
SELECT Templates.Template_ID, COUNT(*) AS count_of_documents FROM Templates JOIN Documents ON Templates.Template_ID = Documents.Template_ID GROUP BY Templates.Template_ID
SELECT Template_ID, COUNT(*) FROM Documents GROUP BY Template_ID
SELECT Templates.Template_ID, Templates.Template_Type_Code FROM Templates JOIN Documents ON Templates.Template_ID = Documents.Template_ID GROUP BY Templates.Template_ID, Templates.Template_Type_Code ORDER BY COUNT(*) DESC LIMIT 1
SELECT Templates.Template_ID, Templates.Template_Type_Code FROM Templates JOIN Documents ON Templates.Template_ID = Documents.Template_ID GROUP BY Templates.Template_ID, Templates.Template_Type_Code ORDER BY COUNT(*) DESC LIMIT 1
SELECT Documents.Template_ID FROM Documents JOIN Templates ON Documents.Template_ID = Templates.Template_ID GROUP BY Documents.Template_ID HAVING COUNT(*) > 1
SELECT d.Template_ID FROM Documents AS d INNER JOIN Templates AS t ON d.Template_ID = t.Template_ID GROUP BY d.Template_ID HAVING COUNT(*) > 1
SELECT Template_ID FROM Templates WHERE NOT Template_ID IN (SELECT Template_ID FROM Documents)
SELECT Template_ID FROM Templates WHERE NOT Template_ID IN (SELECT Template_ID FROM Documents)
SELECT COUNT(Template_ID) FROM Templates
SELECT COUNT(*) AS count FROM Templates
SELECT Template_ID, Version_Number, Template_Type_Code FROM Templates
SELECT Template_ID, Version_Number, Template_Type_Code FROM Templates
SELECT DISTINCT Template_Type_Code FROM Ref_Template_Types
SELECT Template_Type_Code FROM Ref_Template_Types
SELECT Template_ID FROM Templates WHERE Template_Type_Code IN ('PP', 'PPT')
SELECT Template_ID FROM Templates WHERE Template_Type_Code IN ('PP', 'PPT')
SELECT COUNT(*) AS count FROM Templates WHERE Template_Type_Code = 'CV'
SELECT COUNT(*) FROM Templates WHERE Template_Type_Code = 'CV'
SELECT Version_Number, Template_Type_Code FROM Templates WHERE Version_Number > 5
SELECT Version_Number, Template_Type_Code FROM Templates WHERE Version_Number > 5
SELECT Ref_Template_Types.Template_Type_Code, COUNT(*) AS count FROM Templates INNER JOIN Ref_Template_Types ON Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code GROUP BY Ref_Template_Types.Template_Type_Code
SELECT Ref_Template_Types.Template_Type_Code, COUNT(Templates.Template_ID) AS "Count of Templates" FROM Ref_Template_Types INNER JOIN Templates ON Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code GROUP BY Ref_Template_Types.Template_Type_Code
SELECT Templates.Template_Type_Code FROM Templates INNER JOIN Ref_Template_Types ON Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code GROUP BY Templates.Template_Type_Code ORDER BY COUNT(Templates.Template_ID) DESC LIMIT 1
SELECT Template_Type_Code FROM Templates GROUP BY Template_Type_Code ORDER BY COUNT(*) DESC LIMIT 1
SELECT Ref_Template_Types.Template_Type_Code FROM Ref_Template_Types JOIN Templates ON Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code GROUP BY Ref_Template_Types.Template_Type_Code HAVING COUNT(*) < 3
SELECT Ref_Template_Types.Template_Type_Code FROM Ref_Template_Types JOIN Templates ON Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code GROUP BY Ref_Template_Types.Template_Type_Code HAVING COUNT(Templates.Template_ID) < 3
SELECT MIN(Version_Number), Template_Type_Code FROM Templates GROUP BY Template_Type_Code ORDER BY MIN(Version_Number) ASC
SELECT MIN(Version_Number) AS Version_Number, Template_Type_Code FROM Templates GROUP BY Template_Type_Code
SELECT r.Template_Type_Code FROM Documents AS d JOIN Templates AS t ON d.Template_ID = t.Template_ID JOIN Ref_Template_Types AS r ON t.Template_Type_Code = r.Template_Type_Code WHERE d.Document_Name = 'Data base'
SELECT rt.Template_Type_Code FROM Documents AS d JOIN Templates AS t ON d.Template_ID = t.Template_ID JOIN Ref_Template_Types AS rt ON t.Template_Type_Code = rt.Template_Type_Code WHERE d.Document_Name = 'Data base'
SELECT Document_Name FROM Documents JOIN Templates ON Documents.Template_ID = Templates.Template_ID WHERE Templates.Template_Type_Code = 'BK'
SELECT Document_Name FROM Documents JOIN Templates ON Documents.Template_ID = Templates.Template_ID WHERE Templates.Template_Type_Code = 'BK'
SELECT Ref_Template_Types.Template_Type_Code, COUNT(*) AS number_of_documents FROM Ref_Template_Types JOIN Templates ON Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code JOIN Documents ON Templates.Template_ID = Documents.Template_ID GROUP BY Ref_Template_Types.Template_Type_Code
SELECT Ref_Template_Types.Template_Type_Code, COUNT(*) AS Document_Count FROM Ref_Template_Types JOIN Templates ON Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code JOIN Documents ON Templates.Template_ID = Documents.Template_ID GROUP BY Ref_Template_Types.Template_Type_Code
SELECT Ref_Template_Types.Template_Type_Code FROM Ref_Template_Types JOIN Templates ON Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code JOIN Documents ON Documents.Template_ID = Templates.Template_ID GROUP BY Ref_Template_Types.Template_Type_Code ORDER BY COUNT(*) DESC LIMIT 1
SELECT Ref_Template_Types.Template_Type_Code FROM Ref_Template_Types JOIN Templates ON Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code GROUP BY Ref_Template_Types.Template_Type_Code ORDER BY COUNT(*) DESC LIMIT 1
SELECT Template_Type_Code FROM Ref_Template_Types WHERE NOT Template_Type_Code IN (SELECT Template_Type_Code FROM Templates WHERE Template_ID IN (SELECT Template_ID FROM Documents))
SELECT Template_Type_Code FROM Ref_Template_Types WHERE NOT Template_Type_Code IN (SELECT T.Template_Type_Code FROM Documents AS D JOIN Templates AS T ON D.Template_ID = T.Template_ID)
SELECT Template_Type_Code, Template_Type_Description FROM Ref_Template_Types
SELECT Template_Type_Code, Template_Type_Description FROM Ref_Template_Types
SELECT Template_Type_Description FROM Ref_Template_Types WHERE Template_Type_Code = 'AD'
SELECT Template_Type_Description FROM Ref_Template_Types WHERE Template_Type_Code = 'AD'
SELECT Template_Type_Code FROM Ref_Template_Types WHERE Template_Type_Description = 'Book'
SELECT Template_Type_Code FROM Ref_Template_Types WHERE Template_Type_Description = 'Book'
SELECT DISTINCT Ref_Template_Types.Template_Type_Description FROM Ref_Template_Types JOIN Templates ON Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code JOIN Documents ON Templates.Template_ID = Documents.Template_ID
SELECT DISTINCT Ref_Template_Types.Template_Type_Description FROM Ref_Template_Types JOIN Templates ON Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code JOIN Documents ON Templates.Template_ID = Documents.Template_ID
SELECT Templates.Template_ID FROM Templates JOIN Ref_Template_Types ON Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code WHERE Ref_Template_Types.Template_Type_Description = 'Presentation'
SELECT Templates.Template_ID FROM Templates JOIN Ref_Template_Types ON Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code WHERE Ref_Template_Types.Template_Type_Description = 'Presentation'
SELECT COUNT(*) AS count FROM Paragraphs
SELECT COUNT(*) FROM Paragraphs
SELECT COUNT(*) AS paragraph_count FROM Paragraphs JOIN Documents ON Paragraphs.Document_ID = Documents.Document_ID WHERE Documents.Document_Name = 'Summer Show'
SELECT COUNT(*) AS count FROM Paragraphs INNER JOIN Documents ON Paragraphs.Document_ID = Documents.Document_ID WHERE Documents.Document_Name = 'Summer Show'
SELECT Paragraph_ID, Document_ID, Paragraph_Text, Other_Details FROM Paragraphs WHERE Paragraph_Text = 'Korea'
SELECT Paragraph_ID, Document_ID, Paragraph_Text, Other_Details FROM Paragraphs WHERE Paragraph_Text LIKE '%Korea%'
SELECT Paragraphs.Paragraph_ID, Paragraphs.Paragraph_Text FROM Paragraphs JOIN Documents ON Paragraphs.Document_ID = Documents.Document_ID WHERE Documents.Document_Name = 'Welcome to NY'
SELECT Paragraphs.Paragraph_ID, Paragraphs.Paragraph_Text FROM Paragraphs JOIN Documents ON Paragraphs.Document_ID = Documents.Document_ID WHERE Documents.Document_Name = 'Welcome to NY'
SELECT Paragraph_Text FROM Paragraphs JOIN Documents ON Paragraphs.Document_ID = Documents.Document_ID WHERE Document_Name = 'Customer reviews'
SELECT Paragraphs.Paragraph_Text FROM Documents JOIN Paragraphs ON Documents.Document_ID = Paragraphs.Document_ID WHERE Documents.Document_Name = 'Customer reviews'
SELECT Documents.Document_ID, COUNT(*) AS Paragraph_count FROM Documents JOIN Paragraphs ON Documents.Document_ID = Paragraphs.Document_ID GROUP BY Documents.Document_ID ORDER BY Documents.Document_ID ASC
SELECT Documents.Document_ID, COUNT(*) AS number_of_paragraphs FROM Documents JOIN Paragraphs ON Paragraphs.Document_ID = Documents.Document_ID GROUP BY Paragraphs.Document_ID ORDER BY Documents.Document_ID ASC
SELECT Documents.Document_ID, Documents.Document_Name, COUNT(Paragraphs.Paragraph_ID) FROM Documents INNER JOIN Paragraphs ON Documents.Document_ID = Paragraphs.Document_ID GROUP BY Documents.Document_ID, Documents.Document_Name
SELECT Documents.Document_ID, Documents.Document_Name, COUNT(Paragraphs.Paragraph_ID) AS Paragraph_Count FROM Documents INNER JOIN Paragraphs ON Documents.Document_ID = Paragraphs.Document_ID GROUP BY Documents.Document_ID, Documents.Document_Name
SELECT Documents.Document_ID FROM Documents INNER JOIN Paragraphs ON Paragraphs.Document_ID = Documents.Document_ID GROUP BY Documents.Document_ID HAVING COUNT(Paragraphs.Paragraph_ID) >= 2
SELECT Documents.Document_ID FROM Documents JOIN Paragraphs ON Documents.Document_ID = Paragraphs.Document_ID GROUP BY Documents.Document_ID HAVING COUNT(*) >= 2
SELECT Documents.Document_ID, Documents.Document_Name FROM Documents JOIN Paragraphs ON Documents.Document_ID = Paragraphs.Document_ID GROUP BY Documents.Document_ID, Documents.Document_Name ORDER BY COUNT(*) DESC LIMIT 1
SELECT d.Document_ID, d.Document_Name FROM Documents AS d INNER JOIN Paragraphs AS p ON d.Document_ID = p.Document_ID GROUP BY d.Document_ID, d.Document_Name ORDER BY COUNT(*) DESC LIMIT 1
SELECT Paragraphs.Document_ID FROM Paragraphs INNER JOIN Documents ON Paragraphs.Document_ID = Documents.Document_ID GROUP BY Paragraphs.Document_ID ORDER BY COUNT(Paragraphs.Paragraph_ID) ASC LIMIT 1
SELECT d.Document_ID FROM Documents AS d JOIN Paragraphs AS p ON d.Document_ID = p.Document_ID GROUP BY d.Document_ID ORDER BY COUNT(*) ASC LIMIT 1
SELECT Documents.Document_ID FROM Documents JOIN Paragraphs ON Documents.Document_ID = Paragraphs.Document_ID GROUP BY Documents.Document_ID HAVING COUNT(*) BETWEEN 1 AND 2
SELECT Documents.Document_ID FROM Documents INNER JOIN Paragraphs ON Documents.Document_ID = Paragraphs.Document_ID GROUP BY Documents.Document_ID HAVING COUNT(Paragraphs.Paragraph_ID) BETWEEN 1 AND 2
SELECT DISTINCT p.Document_ID FROM Paragraphs AS p JOIN Documents AS d ON p.Document_ID = d.Document_ID WHERE p.Paragraph_Text LIKE '%Brazil%' AND p.Paragraph_Text LIKE '%Ireland%'
SELECT Documents.Document_ID FROM Documents INNER JOIN Paragraphs ON Documents.Document_ID = Paragraphs.Document_ID WHERE Paragraphs.Paragraph_Text LIKE '%Brazil%' INTERSECT SELECT Documents.Document_ID FROM Documents INNER JOIN Paragraphs ON Documents.Document_ID = Paragraphs.Document_ID WHERE Paragraphs.Paragraph_Text LIKE '%Ireland%'
SELECT state FROM Owners INTERSECT SELECT state FROM Professionals
SELECT state FROM Owners INTERSECT SELECT state FROM Professionals
SELECT AVG(Dogs.age) FROM Dogs JOIN Treatments ON Dogs.dog_id = Treatments.dog_id
SELECT AVG(Dogs.age) AS average_age FROM Dogs JOIN Treatments ON Dogs.dog_id = Treatments.dog_id
SELECT P.professional_id, P.last_name, P.cell_number FROM Professionals AS P INNER JOIN Treatments AS T ON P.professional_id = T.professional_id WHERE P.state = 'Indiana' OR (SELECT COUNT(*) FROM Treatments WHERE professional_id = P.professional_id) > 2
SELECT professional_id, last_name, cell_number FROM Professionals WHERE state = 'Indiana' OR professional_id IN (SELECT professional_id FROM Treatments GROUP BY professional_id HAVING COUNT(*) > 2)
SELECT name FROM Dogs WHERE NOT dog_id IN (SELECT dog_id FROM Treatments WHERE cost_of_treatment > 1000)
SELECT Dogs.name FROM Dogs WHERE NOT Dogs.dog_id IN (SELECT dog_id FROM Treatments GROUP BY dog_id HAVING SUM(cost_of_treatment) > 1000)
SELECT first_name FROM (SELECT DISTINCT first_name FROM Owners UNION SELECT DISTINCT first_name FROM Professionals) AS combined WHERE NOT first_name IN (SELECT DISTINCT name FROM Dogs)
SELECT 1
SELECT professional_id, role_code, email_address FROM Professionals WHERE NOT professional_id IN (SELECT professional_id FROM Treatments WHERE NOT professional_id IS NULL)
SELECT professional_id, role_code, email_address FROM Professionals WHERE NOT professional_id IN (SELECT professional_id FROM Treatments)
SELECT o.owner_id, o.first_name, o.last_name FROM Owners AS o JOIN Dogs AS d ON o.owner_id = d.owner_id GROUP BY o.owner_id ORDER BY COUNT(*) DESC LIMIT 1
SELECT Owners.owner_id, Owners.first_name, Owners.last_name FROM Owners JOIN Dogs ON Owners.owner_id = Dogs.owner_id GROUP BY Owners.owner_id, Owners.first_name, Owners.last_name ORDER BY COUNT(Dogs.dog_id) DESC LIMIT 1
SELECT Professionals.professional_id, Professionals.role_code, Professionals.first_name FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id GROUP BY Professionals.professional_id, Professionals.role_code, Professionals.first_name HAVING COUNT(*) >= 2
SELECT P.professional_id, P.role_code, P.first_name FROM Professionals AS P JOIN Treatments AS T ON P.professional_id = T.professional_id GROUP BY P.professional_id, P.role_code, P.first_name HAVING COUNT(*) >= 2
SELECT b.breed_name FROM Breeds AS b JOIN Dogs AS d ON b.breed_code = d.breed_code GROUP BY d.breed_code ORDER BY COUNT(*) DESC LIMIT 1
SELECT b.breed_name FROM Breeds AS b JOIN Dogs AS d ON b.breed_code = d.breed_code GROUP BY b.breed_name ORDER BY COUNT(*) DESC LIMIT 1
SELECT o.owner_id, o.last_name FROM Owners AS o JOIN Dogs AS d ON o.owner_id = d.owner_id JOIN Treatments AS t ON d.dog_id = t.dog_id GROUP BY o.owner_id, o.last_name ORDER BY COUNT(*) DESC LIMIT 1
SELECT O.owner_id, O.last_name FROM Owners AS O JOIN Dogs AS D ON O.owner_id = D.owner_id JOIN Treatments AS T ON D.dog_id = T.dog_id GROUP BY O.owner_id ORDER BY SUM(T.cost_of_treatment) DESC LIMIT 1
SELECT treatment_type_description FROM Treatment_Types JOIN Treatments ON Treatment_Types.treatment_type_code = Treatments.treatment_type_code GROUP BY treatment_type_description ORDER BY SUM(cost_of_treatment) ASC LIMIT 1
SELECT Treatment_Types.treatment_type_description FROM Treatment_Types JOIN Treatments ON Treatments.treatment_type_code = Treatment_Types.treatment_type_code GROUP BY Treatments.treatment_type_code ORDER BY SUM(Treatments.cost_of_treatment) ASC LIMIT 1
SELECT O.owner_id, O.zip_code FROM Owners AS O JOIN Dogs AS D ON O.owner_id = D.owner_id JOIN Treatments AS T ON D.dog_id = T.dog_id GROUP BY O.owner_id, O.zip_code ORDER BY SUM(T.cost_of_treatment) DESC LIMIT 1
SELECT o.owner_id, o.zip_code FROM Owners AS o JOIN Dogs AS d ON o.owner_id = d.owner_id JOIN Charges AS c ON d.dog_id = c.charge_id GROUP BY o.owner_id, o.zip_code ORDER BY SUM(c.charge_amount) DESC LIMIT 1
SELECT Professionals.professional_id, Professionals.cell_number FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id GROUP BY Professionals.professional_id, Professionals.cell_number HAVING COUNT(DISTINCT Treatments.treatment_type_code) >= 2
SELECT Professionals.professional_id, Professionals.cell_number FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id GROUP BY Professionals.professional_id, Professionals.cell_number HAVING COUNT(DISTINCT Treatments.treatment_type_code) >= 2
SELECT Professionals.first_name, Professionals.last_name FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id WHERE Treatments.cost_of_treatment < (SELECT AVG(cost_of_treatment) FROM Treatments)
SELECT DISTINCT Professionals.first_name, Professionals.last_name FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id WHERE Treatments.cost_of_treatment < (SELECT AVG(cost_of_treatment) FROM Treatments)
SELECT Treatments.date_of_treatment, Professionals.first_name FROM Treatments JOIN Professionals ON Treatments.professional_id = Professionals.professional_id
SELECT Treatments.date_of_treatment, Professionals.first_name FROM Treatments JOIN Professionals ON Treatments.professional_id = Professionals.professional_id
SELECT Treatments.cost_of_treatment, Treatment_Types.treatment_type_description FROM Treatments JOIN Treatment_Types ON Treatments.treatment_type_code = Treatment_Types.treatment_type_code
SELECT Treatments.cost_of_treatment, Treatment_Types.treatment_type_description FROM Treatments JOIN Treatment_Types ON Treatments.treatment_type_code = Treatment_Types.treatment_type_code
SELECT Owners.first_name, Owners.last_name, Sizes.size_description FROM Owners JOIN Dogs ON Owners.owner_id = Dogs.owner_id JOIN Sizes ON Dogs.size_code = Sizes.size_code
SELECT Owners.first_name, Owners.last_name, Sizes.size_description FROM Owners JOIN Dogs ON Owners.owner_id = Dogs.owner_id JOIN Sizes ON Dogs.size_code = Sizes.size_code
SELECT Owners.first_name, Dogs.name FROM Dogs JOIN Owners ON Dogs.owner_id = Owners.owner_id
SELECT Owners.first_name, Dogs.name FROM Owners JOIN Dogs ON Owners.owner_id = Dogs.owner_id
SELECT 1
SELECT Dogs.name, Treatments.date_of_treatment FROM Dogs INNER JOIN Breeds ON Dogs.breed_code = Breeds.breed_code INNER JOIN Treatments ON Treatments.dog_id = Dogs.dog_id WHERE Dogs.breed_code = (SELECT Breeds.breed_code FROM Dogs INNER JOIN Breeds ON Dogs.breed_code = Breeds.breed_code GROUP BY Dogs.breed_code ORDER BY COUNT(*) ASC LIMIT 1)
SELECT Owners.first_name, Dogs.name FROM Owners JOIN Dogs ON Owners.owner_id = Dogs.owner_id WHERE Owners.state = 'Virginia'
SELECT Owners.first_name, Dogs.name FROM Owners JOIN Dogs ON Owners.owner_id = Dogs.owner_id WHERE Owners.state = 'Virginia'
SELECT date_arrived, date_departed FROM Dogs WHERE dog_id IN (SELECT dog_id FROM Treatments)
SELECT date_arrived, date_departed FROM Dogs WHERE dog_id IN (SELECT dog_id FROM Treatments)
SELECT last_name FROM Owners JOIN Dogs ON Owners.owner_id = Dogs.owner_id ORDER BY Dogs.age ASC LIMIT 1
SELECT Owners.last_name FROM Dogs JOIN Owners ON Dogs.owner_id = Owners.owner_id ORDER BY Dogs.age ASC LIMIT 1
SELECT email_address FROM Professionals WHERE state = 'Hawaii' OR state = 'Wisconsin'
SELECT email_address FROM Professionals WHERE state = 'Hawaii' OR state = 'Wisconsin'
SELECT date_arrived, date_departed FROM Dogs
SELECT date_arrived, date_departed FROM Dogs
SELECT COUNT(DISTINCT Treatments.dog_id) FROM Treatments
SELECT COUNT(*) FROM Treatments
SELECT COUNT(DISTINCT professional_id) AS count FROM Treatments JOIN Dogs ON Treatments.dog_id = Dogs.dog_id
SELECT COUNT(DISTINCT Professionals.professional_id) FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id
SELECT role_code, street, city, state FROM Professionals WHERE city LIKE '%West%'
SELECT role_code, street, city, state FROM Professionals WHERE city LIKE '%West%'
SELECT first_name, last_name, email_address FROM Owners WHERE state LIKE '%North%'
SELECT first_name, last_name, email_address FROM Owners WHERE state LIKE '%North%'
SELECT COUNT(*) AS count FROM Dogs WHERE age < (SELECT AVG(age) FROM Dogs)
SELECT COUNT(*) AS count FROM Dogs WHERE age < (SELECT AVG(age) FROM Dogs)
SELECT cost_of_treatment FROM Treatments ORDER BY date_of_treatment DESC LIMIT 1
SELECT cost_of_treatment FROM Treatments ORDER BY date_of_treatment DESC LIMIT 1
SELECT COUNT(*) AS count FROM Dogs WHERE NOT dog_id IN (SELECT dog_id FROM Treatments)
SELECT COUNT(*) AS number_of_dogs FROM Dogs WHERE NOT dog_id IN (SELECT dog_id FROM Treatments)
SELECT COUNT(*) FROM Owners WHERE NOT owner_id IN (SELECT owner_id FROM Dogs)
SELECT COUNT(owner_id) FROM Owners WHERE NOT owner_id IN (SELECT owner_id FROM Dogs)
SELECT COUNT(professional_id) FROM Professionals WHERE NOT professional_id IN (SELECT professional_id FROM Treatments WHERE NOT dog_id IS NULL)
SELECT COUNT(*) AS number_of_professionals FROM Professionals WHERE NOT professional_id IN (SELECT professional_id FROM Treatments)
SELECT name, age, weight FROM Dogs WHERE abandoned_yn = '1'
SELECT name, age, weight FROM Dogs WHERE abandoned_yn = '1'
SELECT AVG(age) AS average_age FROM Dogs
SELECT AVG(age) AS average_age FROM Dogs
SELECT MAX(age) AS age FROM Dogs
SELECT MAX(age) FROM Dogs
SELECT charge_type, charge_amount FROM Charges
SELECT charge_type, charge_amount FROM Charges
SELECT MAX(charge_amount) FROM Charges ORDER BY charge_amount DESC
SELECT MAX(charge_amount) FROM Charges ORDER BY charge_amount DESC
SELECT email_address, cell_number, home_phone FROM Professionals
SELECT email_address, cell_number, home_phone FROM Professionals
SELECT Breeds.breed_name, Sizes.size_description FROM Dogs JOIN Breeds ON Dogs.breed_code = Breeds.breed_code JOIN Sizes ON Dogs.size_code = Sizes.size_code
SELECT Breeds.breed_name, Sizes.size_description FROM Dogs JOIN Breeds ON Dogs.breed_code = Breeds.breed_code JOIN Sizes ON Dogs.size_code = Sizes.size_code GROUP BY Breeds.breed_name, Sizes.size_description
SELECT Professionals.first_name, Treatment_Types.treatment_type_description FROM Treatments JOIN Professionals ON Treatments.professional_id = Professionals.professional_id JOIN Treatment_Types ON Treatments.treatment_type_code = Treatment_Types.treatment_type_code
SELECT Professionals.first_name, Treatment_Types.treatment_type_description FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id JOIN Treatment_Types ON Treatments.treatment_type_code = Treatment_Types.treatment_type_code
SELECT Country FROM airlines WHERE Airline = 'JetBlue Airways'
SELECT Country FROM airlines WHERE Airline = 'Jetblue Airways'
SELECT Abbreviation FROM airlines WHERE Airline = 'JetBlue Airways'
SELECT Abbreviation FROM airlines WHERE Airline = 'Jetblue Airways'
SELECT Airline, Abbreviation FROM airlines WHERE Country = 'USA'
SELECT Airline, Abbreviation FROM airlines WHERE Country = 'USA'
SELECT AirportCode, AirportName FROM airports WHERE City = 'Anthony'
SELECT AirportCode, AirportName FROM airports WHERE City = 'Anthony'
SELECT COUNT(DISTINCT Airline) FROM airlines
SELECT COUNT(*) AS count FROM airlines
SELECT COUNT(*) AS number_of_airports FROM airports
SELECT COUNT(*) FROM airports
SELECT COUNT(*) FROM flights
SELECT COUNT(*) AS number_of_flights FROM flights
SELECT Airline FROM airlines WHERE Abbreviation = 'UAL'
SELECT Airline FROM airlines WHERE Abbreviation = 'UAL'
SELECT COUNT(*) AS count FROM airlines WHERE Country = 'USA'
SELECT COUNT(uid) FROM airlines WHERE Country = 'USA'
SELECT City, Country FROM airports WHERE AirportName = 'Alton'
SELECT City, Country FROM airports WHERE AirportName = 'Alton'
SELECT AirportName FROM airports WHERE AirportCode = 'AKO'
SELECT AirportName FROM airports WHERE AirportCode = 'AKO'
SELECT AirportName FROM airports WHERE City = 'Aberdeen'
SELECT AirportName FROM airports WHERE City = 'Aberdeen'
SELECT COUNT(*) AS flights_count FROM flights WHERE SourceAirport = ' APG'
SELECT COUNT(*) FROM flights WHERE SourceAirport = ' APG'
SELECT COUNT(*) FROM flights WHERE DestAirport = 'ATO'
SELECT COUNT(*) FROM flights WHERE DestAirport = 'ATO'
SELECT COUNT(*) FROM flights JOIN airports ON flights.SourceAirport = airports.AirportCode WHERE airports.City = 'Aberdeen'
SELECT COUNT(*) FROM flights JOIN airports ON flights.SourceAirport = airports.AirportCode WHERE airports.City = 'Aberdeen'
SELECT COUNT(*) AS count FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City = 'Aberdeen'
SELECT COUNT(*) AS number_of_flights FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City = 'Aberdeen'
SELECT COUNT(*) FROM flights JOIN airports AS source_airport ON flights.SourceAirport = source_airport.AirportCode JOIN airports AS dest_airport ON flights.DestAirport = dest_airport.AirportCode WHERE source_airport.City = 'Aberdeen' AND dest_airport.City = 'Ashley'
SELECT COUNT(*) FROM flights WHERE SourceAirport = 'ABERDEEN' AND DestAirport = 'ASHLEY'
SELECT COUNT(*) FROM flights WHERE Airline = 'JetBlue Airways'
SELECT COUNT(*) FROM flights WHERE Airline = 'Jetblue Airways'
SELECT COUNT(*) FROM flights JOIN airlines ON flights.Airline = airlines.uid WHERE airlines.Airline = 'United Airlines' AND flights.DestAirport = 'ASY'
SELECT COUNT(*) AS count FROM flights WHERE Airline = 'United Airlines' AND DestAirport = ' ASY'
SELECT COUNT(*) FROM flights JOIN airlines ON flights.Airline = airlines.Airline WHERE airlines.Airline = 'United Airlines' AND flights.SourceAirport = 'AHD'
SELECT COUNT(*) FROM flights JOIN airlines ON flights.Airline = airlines.uid WHERE flights.SourceAirport = 'AHD' AND airlines.Airline = 'United Airlines'
SELECT COUNT(*) FROM flights JOIN airlines ON flights.Airline = airlines.uid JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airlines.Airline = 'United Airlines' AND airports.City = 'Aberdeen'
SELECT COUNT(*) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE flights.Airline = 'United Airlines' AND airports.City = 'Aberdeen'
SELECT airports.City, COUNT(*) FROM airports INNER JOIN flights ON flights.DestAirport = airports.AirportCode GROUP BY airports.City ORDER BY COUNT(*) DESC LIMIT 1
SELECT a.City FROM flights AS f JOIN airports AS a ON f.DestAirport = a.AirportCode GROUP BY a.City ORDER BY COUNT(*) DESC LIMIT 1
SELECT a.City FROM airports AS a JOIN flights AS f ON f.SourceAirport = a.AirportCode GROUP BY a.City ORDER BY COUNT(*) DESC LIMIT 1
SELECT City FROM airports JOIN flights ON airports.AirportCode = flights.SourceAirport GROUP BY City ORDER BY COUNT(*) DESC LIMIT 1
SELECT airports.AirportCode FROM airports INNER JOIN flights ON airports.AirportCode = flights.SourceAirport GROUP BY airports.AirportCode ORDER BY COUNT(*) DESC LIMIT 1
SELECT airports.AirportCode FROM flights INNER JOIN airports ON flights.SourceAirport = airports.AirportCode GROUP BY airports.AirportCode ORDER BY COUNT(*) DESC LIMIT 1
SELECT airports.AirportCode FROM airports JOIN flights ON flights.SourceAirport = airports.AirportCode GROUP BY flights.SourceAirport ORDER BY COUNT(*) ASC LIMIT 1
SELECT AirportCode FROM airports WHERE AirportCode = (SELECT SourceAirport FROM flights GROUP BY SourceAirport ORDER BY COUNT(*) ASC LIMIT 1)
SELECT airlines.Airline FROM flights INNER JOIN airlines ON flights.Airline = airlines.uid GROUP BY airlines.Airline ORDER BY COUNT(*) DESC LIMIT 1
SELECT airlines."Airline" FROM flights JOIN airlines ON flights."Airline" = airlines."Airline" GROUP BY airlines."Airline" ORDER BY COUNT(*) DESC LIMIT 1
SELECT a.Abbreviation, a.Country FROM airlines AS a JOIN flights AS f ON a.Airline = f.Airline GROUP BY a.Abbreviation, a.Country ORDER BY COUNT(*) ASC LIMIT 1
SELECT a.Abbreviation, a.Country FROM airlines AS a JOIN flights AS f ON a.Airline = f.Airline GROUP BY a.Abbreviation, a.Country ORDER BY COUNT(*) ASC LIMIT 1
SELECT airlines.Airline FROM airlines JOIN flights ON airlines.Airline = flights.Airline WHERE flights.SourceAirport = 'AHD'
SELECT airlines.Airline FROM airlines JOIN flights ON airlines.Airline = flights.Airline WHERE flights.SourceAirport = 'AHD'
SELECT airlines.Airline FROM airlines JOIN flights ON airlines.Airline = flights.Airline WHERE flights.DestAirport = 'AHD'
SELECT Airline FROM airlines WHERE uid IN (SELECT Airline FROM flights WHERE DestAirport = 'AHD')
SELECT DISTINCT airlines.Airline FROM flights INNER JOIN airlines ON flights.Airline = airlines.uid WHERE flights.SourceAirport = 'APG' INTERSECT SELECT DISTINCT airlines.Airline FROM flights INNER JOIN airlines ON flights.Airline = airlines.uid WHERE flights.SourceAirport = 'CVO'
SELECT a.Airline FROM airlines AS a JOIN flights AS f ON a.Airline = f.Airline WHERE f.SourceAirport = 'APG' INTERSECT SELECT a.Airline FROM airlines AS a JOIN flights AS f ON a.Airline = f.Airline WHERE f.SourceAirport = 'CVO'
SELECT DISTINCT airlines.Airline FROM flights INNER JOIN airlines ON flights.Airline = airlines.Airline WHERE flights.SourceAirport = 'CVO' EXCEPT SELECT DISTINCT airlines.Airline FROM flights INNER JOIN airlines ON flights.Airline = airlines.Airline WHERE flights.SourceAirport = 'APG'
SELECT a.Airline FROM airlines AS a WHERE a.Airline IN (SELECT Airline FROM flights WHERE SourceAirport = 'CVO') AND NOT a.Airline IN (SELECT Airline FROM flights WHERE SourceAirport = 'APG')
SELECT a.Airline FROM airlines AS a JOIN flights AS f ON a.Airline = f.Airline GROUP BY a.Airline HAVING COUNT(*) >= 10
SELECT a.Airline FROM airlines AS a JOIN flights AS f ON a.Airline = f.Airline GROUP BY a.Airline HAVING COUNT(*) >= 10
SELECT airlines.Airline FROM airlines JOIN flights ON airlines.uid = flights.Airline GROUP BY airlines.Airline HAVING COUNT(*) < 200
SELECT a.Airline FROM airlines AS a JOIN flights AS f ON a.Airline = f.Airline GROUP BY a.Airline HAVING COUNT(f.FlightNo) < 200
SELECT FlightNo FROM flights WHERE Airline = 'United Airlines'
SELECT flights.FlightNo FROM flights JOIN airlines ON flights.Airline = airlines.Airline WHERE airlines.Airline = 'United Airlines'
SELECT FlightNo FROM flights WHERE SourceAirport = 'APG'
SELECT FlightNo FROM flights WHERE SourceAirport = 'APG'
SELECT FlightNo FROM flights WHERE DestAirport = 'APG'
SELECT FlightNo FROM flights WHERE DestAirport = 'APG'
SELECT FlightNo FROM flights WHERE SourceAirport IN (SELECT AirportCode FROM airports WHERE City = 'Aberdeen ')
SELECT FlightNo FROM flights INNER JOIN airports ON flights.SourceAirport = airports.AirportCode WHERE airports.City = 'Aberdeen'
SELECT f.FlightNo FROM flights AS f JOIN airports AS a ON f.DestAirport = a.AirportCode WHERE a.City = 'Aberdeen'
SELECT FlightNo FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City = 'Aberdeen'
SELECT COUNT(*) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City = 'Aberdeen' OR airports.City = 'Abilene'
SELECT COUNT(*) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City = 'Aberdeen ' OR airports.City = 'Abilene '
SELECT AirportName FROM airports WHERE NOT AirportCode IN (SELECT SourceAirport FROM flights UNION SELECT DestAirport FROM flights)
SELECT AirportName FROM airports WHERE NOT AirportCode IN (SELECT SourceAirport FROM flights UNION SELECT DestAirport FROM flights)
SELECT line_1, line_2 FROM Addresses
SELECT line_1, line_2 FROM Addresses
SELECT COUNT(*) FROM Courses
SELECT COUNT(course_id) FROM Courses
SELECT course_description FROM Courses WHERE course_name = 'math'
SELECT course_description FROM Courses WHERE course_name LIKE '%math%'
SELECT zip_postcode FROM Addresses WHERE city = 'Port Chelsea'
SELECT zip_postcode FROM Addresses WHERE city = 'Port Chelsea'
SELECT D.department_name, D.department_id FROM Departments AS D JOIN Degree_Programs AS DP ON D.department_id = DP.department_id GROUP BY D.department_id ORDER BY COUNT(*) DESC LIMIT 1
SELECT d.department_name, d.department_id FROM Departments AS d JOIN Degree_Programs AS dp ON d.department_id = dp.department_id GROUP BY d.department_id ORDER BY COUNT(dp.degree_program_id) DESC LIMIT 1
SELECT COUNT(DISTINCT Departments.department_id) AS COUNT FROM Departments JOIN Degree_Programs ON Departments.department_id = Degree_Programs.department_id
SELECT COUNT(DISTINCT department_id) FROM Degree_Programs
SELECT COUNT(DISTINCT degree_summary_name) FROM Degree_Programs
SELECT COUNT(DISTINCT degree_summary_name) FROM Degree_Programs
SELECT COUNT(*) FROM Degree_Programs JOIN Departments ON Degree_Programs.department_id = Departments.department_id WHERE Departments.department_name = 'engineering'
SELECT COUNT(*) FROM Degree_Programs JOIN Departments ON Degree_Programs.department_id = Departments.department_id WHERE Departments.department_name = 'engineering'
SELECT section_name, section_description FROM Sections
SELECT section_name, section_description FROM Sections
SELECT Courses.course_name, Courses.course_id FROM Courses JOIN Sections ON Courses.course_id = Sections.course_id GROUP BY Courses.course_id HAVING COUNT(Sections.section_id) <= 2
SELECT course_name, course_id FROM Courses WHERE NOT course_id IN (SELECT course_id FROM Sections GROUP BY course_id HAVING COUNT(section_id) >= 2)
SELECT section_name FROM Sections ORDER BY section_name DESC
SELECT section_name FROM Sections ORDER BY section_name DESC
SELECT Semesters.semester_name, Semesters.semester_id FROM Semesters JOIN Student_Enrolment ON Semesters.semester_id = Student_Enrolment.semester_id GROUP BY Student_Enrolment.semester_id ORDER BY COUNT(Student_Enrolment.student_id) DESC LIMIT 1
SELECT s.semester_name, s.semester_id FROM Semesters AS s JOIN Student_Enrolment AS se ON s.semester_id = se.semester_id GROUP BY s.semester_id, s.semester_name ORDER BY COUNT(se.student_id) DESC LIMIT 1
SELECT department_description FROM Departments WHERE department_name LIKE '%the computer%'
SELECT department_description FROM Departments WHERE department_name LIKE '%computer%'
SELECT s.first_name, s.middle_name, s.last_name, s.student_id FROM Students AS s JOIN Student_Enrolment AS se ON s.student_id = se.student_id GROUP BY s.first_name, s.middle_name, s.last_name, s.student_id HAVING COUNT(DISTINCT se.degree_program_id) = 2
SELECT Students.first_name, Students.middle_name, Students.last_name, Students.student_id FROM Students JOIN Student_Enrolment ON Students.student_id = Student_Enrolment.student_id JOIN (SELECT student_id, semester_id FROM Student_Enrolment GROUP BY student_id, semester_id HAVING COUNT(DISTINCT degree_program_id) = 2) AS EnrolledTwice ON Students.student_id = EnrolledTwice.student_id AND Student_Enrolment.semester_id = EnrolledTwice.semester_id
SELECT Students.first_name, Students.middle_name, Students.last_name FROM Students JOIN Student_Enrolment ON Students.student_id = Student_Enrolment.student_id JOIN Degree_Programs ON Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id WHERE Degree_Programs.degree_summary_name = 'Bachelor'
SELECT first_name, middle_name, last_name FROM Students JOIN Student_Enrolment ON Students.student_id = Student_Enrolment.student_id JOIN Degree_Programs ON Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id WHERE degree_summary_name = 'Bachelor'
SELECT degree_summary_name FROM Degree_Programs JOIN Student_Enrolment ON Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id GROUP BY degree_summary_name ORDER BY COUNT(Student_Enrolment.student_id) DESC LIMIT 1
SELECT degree_summary_name FROM Degree_Programs JOIN Student_Enrolment ON Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id GROUP BY degree_summary_name ORDER BY COUNT(*) DESC LIMIT 1
SELECT Degree_Programs.degree_program_id, Degree_Programs.degree_summary_description FROM Degree_Programs JOIN Student_Enrolment ON Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id GROUP BY Student_Enrolment.degree_program_id, Degree_Programs.degree_summary_description ORDER BY COUNT(Student_Enrolment.student_id) DESC LIMIT 1
SELECT Degree_Programs.degree_program_id, Degree_Programs.degree_summary_name FROM Degree_Programs JOIN Student_Enrolment ON Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id GROUP BY Degree_Programs.degree_program_id, Degree_Programs.degree_summary_name ORDER BY COUNT(*) DESC LIMIT 1
SELECT Students.student_id, Students.first_name, Students.middle_name, Students.last_name, COUNT(Student_Enrolment.student_id) AS number_of_enrollments, Students.student_id AS student_id_duplicate FROM Students JOIN Student_Enrolment ON Students.student_id = Student_Enrolment.student_id GROUP BY Students.student_id, Students.first_name, Students.middle_name, Students.last_name ORDER BY number_of_enrollments DESC LIMIT 1
SELECT S.first_name, S.middle_name, S.last_name, S.student_id, COUNT(SE.student_enrolment_id) AS number_of_enrollments FROM Students AS S JOIN Student_Enrolment AS SE ON S.student_id = SE.student_id GROUP BY S.student_id, S.first_name, S.middle_name, S.last_name ORDER BY COUNT(SE.student_enrolment_id) DESC LIMIT 1
SELECT semester_name FROM Semesters WHERE NOT EXISTS(SELECT 1 FROM Student_Enrolment WHERE Student_Enrolment.semester_id = Semesters.semester_id)
SELECT semester_name FROM Semesters WHERE NOT semester_id IN (SELECT semester_id FROM Student_Enrolment)
SELECT course_name FROM Courses WHERE course_id IN (SELECT DISTINCT course_id FROM Student_Enrolment_Courses)
SELECT course_name FROM Courses WHERE course_id IN (SELECT DISTINCT course_id FROM Student_Enrolment_Courses)
SELECT course_name FROM Courses JOIN Student_Enrolment_Courses ON Courses.course_id = Student_Enrolment_Courses.course_id GROUP BY Student_Enrolment_Courses.course_id ORDER BY COUNT(*) DESC LIMIT 1
SELECT course_name FROM Courses JOIN Student_Enrolment_Courses ON Courses.course_id = Student_Enrolment_Courses.course_id GROUP BY Courses.course_id ORDER BY COUNT(*) DESC LIMIT 1
SELECT Students.last_name FROM Students WHERE Students.current_address_id IN (SELECT address_id FROM Addresses WHERE state_province_county = 'North Carolina') AND NOT Students.student_id IN (SELECT student_id FROM Student_Enrolment)
SELECT S.last_name FROM Students AS S JOIN Addresses AS A ON S.current_address_id = A.address_id WHERE A.state_province_county = 'NorthCarolina' AND NOT S.student_id IN (SELECT student_id FROM Student_Enrolment)
SELECT Transcripts.transcript_date, Transcripts.transcript_id FROM Transcripts JOIN Transcript_Contents ON Transcripts.transcript_id = Transcript_Contents.transcript_id GROUP BY Transcripts.transcript_id, Transcripts.transcript_date HAVING COUNT(*) >= 2
SELECT T.transcript_date, T.transcript_id FROM Transcripts AS T JOIN Transcript_Contents AS TC ON T.transcript_id = TC.transcript_id GROUP BY T.transcript_id, T.transcript_date HAVING COUNT(*) >= 2
SELECT cell_mobile_number FROM Students WHERE first_name = 'Timmothy' AND last_name = 'Ward'
SELECT cell_mobile_number FROM Students WHERE first_name = 'Timmothy' AND last_name = 'Ward'
SELECT first_name, middle_name, last_name FROM Students ORDER BY date_first_registered ASC LIMIT 1
SELECT first_name, middle_name, last_name FROM Students ORDER BY date_first_registered ASC LIMIT 1
SELECT first_name, middle_name, last_name FROM Students ORDER BY date_first_registered ASC LIMIT 1
SELECT s.first_name, s.middle_name, s.last_name FROM Students AS s JOIN Transcripts AS t ON s.student_id = t.transcript_id ORDER BY t.transcript_date ASC LIMIT 1
SELECT first_name FROM Students WHERE current_address_id <> permanent_address_id
SELECT first_name FROM Students WHERE current_address_id <> permanent_address_id
SELECT Addresses.address_id, Addresses.line_1, Addresses.line_2, Addresses.line_3 FROM Addresses JOIN Students ON Students.current_address_id = Addresses.address_id GROUP BY Addresses.address_id ORDER BY COUNT(Students.student_id) DESC LIMIT 1
SELECT Addresses.address_id, Addresses.line_1, Addresses.line_2 FROM Addresses JOIN Students ON Addresses.address_id = Students.current_address_id GROUP BY Addresses.address_id ORDER BY COUNT(*) DESC LIMIT 1
SELECT AVG(transcript_date) FROM Transcripts
SELECT AVG(transcript_date) AS average_transcript_date FROM Transcripts
SELECT transcript_date, other_details FROM Transcripts ORDER BY transcript_date ASC LIMIT 1
SELECT MIN(transcript_date) AS transcript_date, other_details FROM Transcripts ORDER BY transcript_date ASC LIMIT 1
SELECT COUNT(transcript_id) FROM Transcripts
SELECT COUNT(*) AS count FROM Transcripts
SELECT MAX(transcript_date) FROM Transcripts ORDER BY transcript_date DESC
SELECT MAX(transcript_date) FROM Transcripts
SELECT COUNT(t2.transcript_id) AS max_count, t1.student_course_id FROM Student_Enrolment_Courses AS t1 JOIN Transcript_Contents AS t2 ON t1.student_course_id = t2.student_course_id GROUP BY t1.student_course_id ORDER BY max_count DESC LIMIT 1
SELECT COUNT(*), student_enrolment_id FROM Student_Enrolment_Courses GROUP BY student_enrolment_id ORDER BY COUNT(*) DESC LIMIT 1
SELECT T.transcript_date, T.transcript_id FROM Transcripts AS T JOIN Transcript_Contents AS TC ON T.transcript_id = TC.transcript_id GROUP BY T.transcript_id ORDER BY COUNT(*) ASC LIMIT 1
SELECT T.transcript_date, T.transcript_id FROM Transcripts AS T JOIN Transcript_Contents AS TC ON T.transcript_id = TC.transcript_id GROUP BY T.transcript_id ORDER BY COUNT(TC.student_course_id) ASC LIMIT 1
SELECT semester_name FROM Semesters WHERE semester_id IN (SELECT semester_id FROM Student_Enrolment WHERE degree_program_id IN (SELECT degree_program_id FROM Degree_Programs WHERE degree_summary_name = 'Master') INTERSECT SELECT semester_id FROM Student_Enrolment WHERE degree_program_id IN (SELECT degree_program_id FROM Degree_Programs WHERE degree_summary_name = 'Bachelor'))
SELECT semester_id FROM Student_Enrolment JOIN Degree_Programs ON Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id WHERE degree_summary_name = 'Master' INTERSECT SELECT semester_id FROM Student_Enrolment JOIN Degree_Programs ON Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id WHERE degree_summary_name = 'Bachelor'
SELECT COUNT(DISTINCT address_id) AS count FROM Addresses JOIN Students ON Addresses.address_id = Students.current_address_id
SELECT DISTINCT A.line_1, A.line_2, A.line_3, A.city, A.zip_postcode, A.state_province_county, A.country, A.other_address_details FROM Addresses AS A JOIN Students AS S ON A.address_id = S.current_address_id OR A.address_id = S.permanent_address_id
SELECT student_id, current_address_id, permanent_address_id, first_name, middle_name, last_name, cell_mobile_number, email_address, ssn, date_first_registered, date_left, other_student_details FROM Students ORDER BY first_name DESC
SELECT student_id, current_address_id, permanent_address_id, first_name, middle_name, last_name, cell_mobile_number, email_address, ssn, date_first_registered, date_left, other_student_details FROM Students ORDER BY last_name DESC
SELECT section_name, section_description, other_details FROM Sections WHERE section_name = 'h'
SELECT section_description FROM Sections WHERE section_name = 'h'
SELECT Students.first_name FROM Students JOIN Addresses ON Students.permanent_address_id = Addresses.address_id WHERE Addresses.country = 'Haiti' OR Students.cell_mobile_number = '09700166582'
SELECT first_name FROM Students WHERE permanent_address_id IN (SELECT address_id FROM Addresses WHERE country = 'Haiti') OR cell_mobile_number = '09700166582'
SELECT Title FROM Cartoon ORDER BY Title ASC
SELECT Title FROM Cartoon ORDER BY Title ASC
SELECT Title FROM Cartoon WHERE Directed_by = 'Ben Jones'
SELECT Title FROM Cartoon WHERE Directed_by = 'Ben Jones'
SELECT COUNT(id) AS COUNT FROM Cartoon WHERE Written_by = 'Joseph Kuhr'
SELECT COUNT(*) AS number_of_cartoons FROM Cartoon WHERE Written_by = 'Joseph Kuhr'
SELECT Title, Directed_by FROM Cartoon ORDER BY Original_air_date ASC
SELECT Title, Directed_by FROM Cartoon ORDER BY Original_air_date ASC
SELECT Title FROM Cartoon WHERE Directed_by = 'Ben Jones' OR Directed_by = 'Brandon Vietti'
SELECT Title FROM Cartoon WHERE Directed_by = 'Ben Jones' OR Directed_by = 'Brandon Vietti'
SELECT Country, COUNT(id) AS number_of_TV_Channels FROM TV_Channel GROUP BY Country ORDER BY number_of_TV_Channels DESC LIMIT 1
SELECT Country, COUNT(*) AS count FROM TV_Channel GROUP BY Country ORDER BY count DESC LIMIT 1
SELECT COUNT(DISTINCT series_name), COUNT(DISTINCT Content) FROM TV_Channel
SELECT COUNT(DISTINCT series_name), COUNT(DISTINCT Content) FROM TV_Channel
SELECT Content FROM TV_Channel WHERE series_name = 'Sky Radio'
SELECT Content FROM TV_Channel WHERE series_name = 'Sky Radio'
SELECT Package_Option FROM TV_Channel WHERE series_name = 'Sky Radio'
SELECT Package_Option FROM TV_Channel WHERE series_name = 'Sky Radio'
SELECT COUNT(Language) FROM TV_Channel WHERE Language = 'English'
SELECT COUNT(*) FROM TV_Channel WHERE Language = 'English'
SELECT Language, COUNT(*) AS "TV Channel Count" FROM TV_Channel GROUP BY Language ORDER BY COUNT(*) ASC LIMIT 1
SELECT Language, COUNT(*) AS channel_count FROM TV_Channel GROUP BY Language ORDER BY channel_count ASC LIMIT 1
SELECT Language, COUNT(*) AS "number of TV Channels" FROM TV_Channel GROUP BY Language
SELECT Language, COUNT(*) AS number_of_TV_Channels FROM TV_Channel GROUP BY Language
SELECT Cartoon.Channel, TV_Channel.series_name FROM Cartoon JOIN TV_Channel ON Cartoon.Channel = TV_Channel.id WHERE Cartoon.Title = 'The Rise of the Blue Beetle!'
SELECT series_name FROM TV_Channel WHERE id = (SELECT Channel FROM Cartoon WHERE Title = 'The Rise of the Blue Beetle!')
SELECT Cartoon.Title FROM Cartoon JOIN TV_Channel ON Cartoon.Channel = TV_Channel.id WHERE TV_Channel.series_name = 'Sky Radio'
SELECT Cartoon.Title FROM Cartoon JOIN TV_Channel ON Cartoon.Channel = TV_Channel.id WHERE TV_Channel.series_name = 'Sky Radio'
SELECT Episode FROM TV_series ORDER BY Rating ASC
SELECT Episode, Rating FROM TV_series ORDER BY Rating DESC
SELECT Episode, Rating FROM TV_series ORDER BY Rating DESC LIMIT 3
SELECT Episode, Rating FROM TV_series ORDER BY Rating DESC LIMIT 3
SELECT MIN(Share) AS minimum_share, MAX(Share) AS maximum_share FROM TV_series
SELECT MAX(Share), MIN(Share) FROM TV_series
SELECT Air_Date FROM TV_series WHERE Episode = 'A Love of a Lifetime'
SELECT Original_air_date FROM Cartoon WHERE Title = 'A Love of a Lifetime'
SELECT Weekly_Rank FROM TV_series WHERE Episode = 'A Love of a Lifetime'
SELECT Weekly_Rank FROM TV_series WHERE Episode = 'A Love of a Lifetime'
SELECT TV_series.Channel, TV_Channel.series_name FROM TV_series JOIN TV_Channel ON TV_series.Channel = TV_Channel.id WHERE TV_series.Episode = 'A Love of a Lifetime'
SELECT series_name FROM TV_Channel WHERE id = (SELECT Channel FROM TV_series WHERE Episode = 'A Love of a Lifetime')
SELECT TV_series.Episode FROM TV_series JOIN TV_Channel ON TV_series.Channel = TV_Channel.id WHERE TV_Channel.series_name = 'Sky Radio'
SELECT Episode FROM TV_series JOIN TV_Channel ON TV_series.Channel = TV_Channel.id WHERE TV_Channel.series_name = 'Sky Radio'
SELECT Directed_by, COUNT(id) FROM Cartoon GROUP BY Directed_by
SELECT Directed_by, COUNT(id) AS cartoon_count FROM Cartoon GROUP BY Directed_by
SELECT Production_code, Channel FROM Cartoon ORDER BY Original_air_date DESC LIMIT 1
SELECT Production_code, Channel FROM Cartoon ORDER BY Original_air_date DESC LIMIT 1
SELECT Package_Option, series_name FROM TV_Channel WHERE Hight_definition_TV = 'yes'
SELECT Package_Option, series_name FROM TV_Channel WHERE Hight_definition_TV = 'yes'
SELECT TV_Channel.Country FROM TV_Channel JOIN Cartoon ON TV_Channel.id = Cartoon.Channel WHERE Cartoon.Written_by = 'Todd Casey'
SELECT TV_Channel.Country FROM Cartoon JOIN TV_Channel ON Cartoon.Channel = TV_Channel.id WHERE Cartoon.Written_by = 'Todd Casey'
SELECT TV_Channel.Country FROM TV_Channel WHERE NOT TV_Channel.id IN (SELECT Cartoon.Channel FROM Cartoon WHERE Cartoon.Written_by = 'Todd Casey')
SELECT Country FROM TV_Channel WHERE NOT id IN (SELECT Channel FROM Cartoon WHERE Written_by = 'Todd Casey')
SELECT TV_Channel.series_name, TV_Channel.Country FROM TV_Channel JOIN Cartoon ON TV_Channel.id = Cartoon.Channel WHERE Cartoon.Directed_by = 'Ben Jones' OR Cartoon.Directed_by = 'Michael Chang'
SELECT TV_Channel.series_name, TV_Channel.Country FROM TV_Channel JOIN Cartoon ON TV_Channel.id = Cartoon.Channel WHERE Cartoon.Directed_by = 'Ben Jones' OR Cartoon.Directed_by = 'Michael Chang'
SELECT Pixel_aspect_ratio_PAR, Country FROM TV_Channel WHERE Language <> 'English'
SELECT Pixel_aspect_ratio_PAR, Country FROM TV_Channel WHERE Language <> 'English'
SELECT id FROM TV_Channel WHERE Country IN (SELECT Country FROM TV_Channel GROUP BY Country HAVING COUNT(*) > 2)
SELECT TV_Channel.id FROM TV_Channel JOIN TV_series ON TV_Channel.id = TV_series.Channel GROUP BY TV_Channel.id HAVING COUNT(*) > 2
SELECT id FROM TV_Channel WHERE NOT id IN (SELECT Channel FROM Cartoon WHERE Directed_by = 'Ben Jones')
SELECT id FROM TV_Channel WHERE NOT EXISTS(SELECT 1 FROM Cartoon WHERE Cartoon.Channel = TV_Channel.id AND Directed_by = 'Ben Jones')
SELECT Package_Option FROM TV_Channel WHERE NOT id IN (SELECT Channel FROM Cartoon WHERE Directed_by = 'Ben Jones')
SELECT TV_Channel.Package_Option FROM TV_Channel WHERE NOT TV_Channel.id IN (SELECT Cartoon.Channel FROM Cartoon WHERE Cartoon.Directed_by = 'Ben Jones')
SELECT COUNT(*) AS total_number_of_players FROM players
SELECT COUNT(*) AS count FROM players
SELECT COUNT(*) AS total_number_of_matches FROM matches
SELECT COUNT(*) AS count FROM matches
SELECT first_name, birth_date FROM players WHERE country_code = 'USA'
SELECT first_name, birth_date FROM players WHERE country_code = 'USA'
SELECT AVG(winner_age), AVG(loser_age) FROM matches
SELECT AVG(loser_age) AS average_loser_age, AVG(winner_age) AS average_winner_age FROM matches
SELECT AVG(winner_rank) FROM matches
SELECT AVG(winner_rank) AS "average rank" FROM matches
SELECT MAX(loser_rank) FROM matches
SELECT MIN(loser_rank) FROM matches
SELECT COUNT(DISTINCT country_code) FROM players
SELECT COUNT(DISTINCT country_code) AS count_distinct_countries FROM players
SELECT COUNT(DISTINCT loser_name) AS distinct_name_count FROM matches
SELECT COUNT(DISTINCT loser_name) FROM matches
SELECT tourney_name FROM matches GROUP BY tourney_id, tourney_name HAVING COUNT(*) > 10
SELECT tourney_name FROM matches WHERE match_num > 10 GROUP BY tourney_name
SELECT winner_name FROM matches WHERE year = 2013 INTERSECT SELECT winner_name FROM matches WHERE year = 2016
SELECT winner_name FROM matches WHERE year = 2013 INTERSECT SELECT winner_name FROM matches WHERE year = 2016
SELECT COUNT(*) AS number_of_matches FROM matches WHERE year IN (2013, 2016)
SELECT COUNT(*) AS count FROM matches WHERE year IN (2013, 2016)
SELECT players.country_code, players.first_name FROM players JOIN matches ON players.player_id = matches.winner_id WHERE matches.tourney_name = 'WTA Championships' INTERSECT SELECT players.country_code, players.first_name FROM players JOIN matches ON players.player_id = matches.winner_id WHERE matches.tourney_name = 'Australian Open'
SELECT DISTINCT players.first_name, players.country_code FROM players INNER JOIN matches ON matches.winner_id = players.player_id WHERE matches.tourney_name = 'WTA Championships' INTERSECT SELECT DISTINCT players.first_name, players.country_code FROM players INNER JOIN matches ON matches.winner_id = players.player_id WHERE matches.tourney_name = 'Australian Open'
SELECT first_name, country_code FROM players ORDER BY birth_date ASC LIMIT 1
SELECT first_name, country_code FROM players ORDER BY birth_date ASC LIMIT 1
SELECT first_name, last_name FROM players ORDER BY birth_date ASC
SELECT first_name, last_name FROM players ORDER BY birth_date ASC
SELECT first_name, last_name FROM players WHERE hand = 'L' ORDER BY birth_date ASC
SELECT first_name, last_name FROM players WHERE hand = 'L' ORDER BY birth_date ASC
SELECT p.first_name, p.country_code FROM players AS p JOIN rankings AS r ON p.player_id = r.player_id ORDER BY r.tours DESC LIMIT 1
SELECT p.first_name, p.country_code FROM players AS p JOIN rankings AS r ON p.player_id = r.player_id ORDER BY r.tours DESC LIMIT 1
SELECT year FROM matches GROUP BY year ORDER BY COUNT(*) DESC LIMIT 1
SELECT year FROM matches GROUP BY year ORDER BY COUNT(*) DESC LIMIT 1
SELECT winner_name, winner_rank_points FROM matches GROUP BY winner_name ORDER BY COUNT(*) DESC LIMIT 1
SELECT m.winner_name, r.ranking_points FROM matches AS m JOIN rankings AS r ON m.winner_id = r.player_id GROUP BY m.winner_name ORDER BY COUNT(*) DESC LIMIT 1
SELECT winner_name FROM matches WHERE tourney_name = 'Australian Open' ORDER BY winner_rank_points DESC LIMIT 1
SELECT winner_name FROM matches WHERE tourney_name = 'Australian Open' ORDER BY winner_rank_points DESC LIMIT 1
SELECT loser_name, winner_name FROM matches ORDER BY minutes DESC LIMIT 1
SELECT winner_name, loser_name FROM matches ORDER BY minutes DESC LIMIT 1
SELECT AVG(rankings.ranking), players.first_name FROM players JOIN rankings ON players.player_id = rankings.player_id GROUP BY players.player_id
SELECT players.first_name, AVG(rankings.ranking) AS average_ranking FROM players JOIN rankings ON players.player_id = rankings.player_id GROUP BY players.first_name
SELECT players.first_name, SUM(rankings.ranking_points) AS total_ranking_points FROM players JOIN rankings ON players.player_id = rankings.player_id GROUP BY players.first_name
SELECT players.first_name, SUM(rankings.ranking_points) AS total_ranking_points FROM players JOIN rankings ON players.player_id = rankings.player_id GROUP BY players.first_name
SELECT country_code, COUNT(*) AS player_count FROM players GROUP BY country_code
SELECT country_code, COUNT(player_id) AS count FROM players GROUP BY country_code
SELECT country_code FROM players GROUP BY country_code ORDER BY COUNT(*) DESC LIMIT 1
SELECT country_code FROM players GROUP BY country_code ORDER BY COUNT(*) DESC LIMIT 1
SELECT country_code FROM players GROUP BY country_code HAVING COUNT(*) > 50
SELECT country_code FROM players GROUP BY country_code HAVING COUNT(player_id) > 50
SELECT COUNT(*) AS total_number_of_tours, ranking_date FROM rankings GROUP BY ranking_date ORDER BY ranking_date ASC
SELECT SUM(tours) AS "Total Tours", ranking_date FROM rankings GROUP BY ranking_date
SELECT year, COUNT(*) AS number_of_matches FROM matches GROUP BY year
SELECT year, COUNT(*) AS count FROM matches GROUP BY year
SELECT winner_name, winner_rank FROM matches ORDER BY winner_age ASC LIMIT 3
SELECT winner_name, winner_rank FROM matches ORDER BY winner_age ASC LIMIT 3
SELECT COUNT(DISTINCT winner_id) FROM matches WHERE tourney_name = 'WTA Championships' AND winner_hand = 'L'
SELECT COUNT(*) AS count FROM matches WHERE winner_hand = 'L' AND tourney_name = 'WTA Championships'
SELECT p.first_name, p.country_code, p.birth_date FROM players AS p JOIN matches AS m ON p.player_id = m.winner_id ORDER BY m.winner_rank_points DESC LIMIT 1
SELECT p.first_name, p.country_code, p.birth_date FROM players AS p JOIN matches AS m ON p.player_id = m.winner_id ORDER BY m.winner_rank_points DESC LIMIT 1
SELECT hand, COUNT(player_id) FROM players GROUP BY hand
SELECT hand AS hands, COUNT(*) AS player_count FROM players GROUP BY hand
SELECT COUNT(ID) FROM Highschooler
SELECT COUNT(*) AS COUNT FROM Highschooler
SELECT name, grade FROM Highschooler
SELECT name, grade FROM Highschooler
SELECT grade FROM Highschooler
SELECT grade FROM Highschooler
SELECT grade FROM Highschooler WHERE name = 'Kyle'
SELECT grade FROM Highschooler WHERE name = 'Kyle'
SELECT name FROM Highschooler WHERE grade = 10
SELECT name FROM Highschooler WHERE grade = 10
SELECT ID FROM Highschooler WHERE name = 'Kyle'
SELECT ID FROM Highschooler WHERE name = 'Kyle'
SELECT COUNT(*) FROM Highschooler WHERE grade IN (9, 10)
SELECT COUNT(*) FROM Highschooler WHERE grade IN (9, 10)
SELECT grade, COUNT(*) AS number_of_high_schoolers FROM Highschooler GROUP BY grade
SELECT grade, COUNT(*) AS count FROM Highschooler GROUP BY grade
SELECT grade FROM Highschooler GROUP BY grade ORDER BY COUNT(*) DESC LIMIT 1
SELECT grade FROM Highschooler GROUP BY grade ORDER BY COUNT(*) DESC LIMIT 1
SELECT grade FROM Highschooler GROUP BY grade HAVING COUNT(*) >= 4
SELECT grade FROM Highschooler GROUP BY grade HAVING COUNT(*) >= 4
SELECT Highschooler.ID, COUNT(Friend.friend_id) AS number_of_friends FROM Highschooler JOIN Friend ON Highschooler.ID = Friend.student_id GROUP BY Highschooler.ID
SELECT Highschooler.name, COUNT(Friend.friend_id) AS number_of_friends FROM Highschooler LEFT JOIN Friend ON Highschooler.ID = Friend.student_id GROUP BY Highschooler.name
SELECT Highschooler.name, COUNT(Friend.student_id) FROM Highschooler JOIN Friend ON Highschooler.ID = Friend.student_id GROUP BY Highschooler.name
SELECT Highschooler.name, COUNT(Friend.friend_id) AS friend_count FROM Highschooler LEFT JOIN Friend ON Highschooler.ID = Friend.student_id GROUP BY Highschooler.name
SELECT H.name FROM Highschooler AS H JOIN Friend AS F ON H.ID = F.student_id GROUP BY H.ID ORDER BY COUNT(*) DESC LIMIT 1
SELECT Highschooler.name FROM Highschooler JOIN Friend ON Highschooler.ID = Friend.student_id GROUP BY Highschooler.ID, Highschooler.name ORDER BY COUNT(*) DESC LIMIT 1
SELECT Highschooler.name FROM Highschooler JOIN Friend ON Highschooler.ID = Friend.student_id GROUP BY Highschooler.ID HAVING COUNT(*) >= 3
SELECT name FROM Highschooler WHERE ID IN (SELECT student_id FROM Friend GROUP BY student_id HAVING COUNT(*) >= 3)
SELECT H2.name FROM Highschooler AS H1 JOIN Friend AS F ON H1.ID = F.student_id JOIN Highschooler AS H2 ON F.friend_id = H2.ID WHERE H1.name = 'Kyle'
SELECT H2.name FROM Highschooler AS H1 JOIN Friend AS F ON H1.ID = F.student_id JOIN Highschooler AS H2 ON F.friend_id = H2.ID WHERE H1.name = 'Kyle'
SELECT COUNT(*) AS count FROM Friend JOIN Highschooler ON Highschooler.ID = Friend.student_id WHERE Highschooler.name = 'Kyle'
SELECT COUNT(*) AS count FROM Friend JOIN Highschooler ON Friend.student_id = Highschooler.ID WHERE Highschooler.name = 'Kyle'
SELECT Highschooler.ID FROM Highschooler WHERE NOT Highschooler.ID IN (SELECT student_id FROM Friend)
SELECT ID FROM Highschooler EXCEPT SELECT student_id FROM Friend
SELECT name FROM Highschooler WHERE NOT ID IN (SELECT student_id FROM Friend)
SELECT name FROM Highschooler WHERE NOT ID IN (SELECT student_id FROM Friend)
SELECT H.ID FROM Highschooler AS H WHERE EXISTS(SELECT 1 FROM Friend AS F WHERE F.student_id = H.ID) AND EXISTS(SELECT 1 FROM Likes AS L WHERE L.liked_id = H.ID)
SELECT Highschooler.ID FROM Highschooler WHERE Highschooler.ID IN (SELECT student_id FROM Friend) AND Highschooler.ID IN (SELECT liked_id FROM Likes)
SELECT DISTINCT Highschooler.name FROM Highschooler JOIN Friend ON Highschooler.ID = Friend.student_id JOIN Likes ON Highschooler.ID = Likes.liked_id
SELECT name FROM Highschooler WHERE ID IN (SELECT student_id FROM Friend) AND ID IN (SELECT liked_id FROM Likes)
SELECT student_id, COUNT(*) FROM Likes GROUP BY student_id
SELECT student_id, COUNT(*) AS likes_count FROM Likes GROUP BY student_id
SELECT Highschooler.name, COUNT(Likes.liked_id) AS number_of_likes FROM Highschooler JOIN Likes ON Highschooler.ID = Likes.student_id GROUP BY Highschooler.name
SELECT Highschooler.name, COUNT(Likes.student_id) AS like_count FROM Highschooler JOIN Likes ON Highschooler.ID = Likes.student_id GROUP BY Highschooler.ID
SELECT Highschooler.name FROM Highschooler JOIN Likes ON Highschooler.ID = Likes.student_id GROUP BY Highschooler.ID ORDER BY COUNT(*) DESC LIMIT 1
SELECT name FROM Highschooler JOIN Likes ON ID = liked_id GROUP BY name ORDER BY COUNT(*) DESC LIMIT 1
SELECT Highschooler.name FROM Highschooler JOIN Likes ON Highschooler.ID = Likes.student_id GROUP BY Highschooler.ID HAVING COUNT(*) >= 2
SELECT Highschooler.name FROM Highschooler JOIN Likes ON Highschooler.ID = Likes.student_id GROUP BY Highschooler.ID, Highschooler.name HAVING COUNT(*) >= 2
SELECT name FROM Highschooler WHERE grade > 5 AND ID IN (SELECT student_id FROM Friend GROUP BY student_id HAVING COUNT(friend_id) >= 2)
SELECT name FROM Highschooler WHERE grade > 5 AND ID IN (SELECT student_id FROM Friend GROUP BY student_id HAVING COUNT(friend_id) >= 2)
SELECT COUNT(*) FROM Likes JOIN Highschooler ON Likes.liked_id = Highschooler.ID WHERE Highschooler.name = 'Kyle'
SELECT COUNT(*) AS count FROM Likes JOIN Highschooler ON Likes.student_id = Highschooler.ID WHERE Highschooler.name = 'Kyle'
SELECT AVG(grade) FROM Highschooler WHERE ID IN (SELECT student_id FROM Friend UNION SELECT friend_id FROM Friend)
SELECT AVG(grade) FROM Highschooler WHERE ID IN (SELECT student_id FROM Friend) OR ID IN (SELECT friend_id FROM Friend)
SELECT MIN(grade) FROM Highschooler WHERE NOT ID IN (SELECT student_id FROM Friend)
SELECT MIN(grade) FROM Highschooler WHERE NOT ID IN (SELECT student_id FROM Friend)
SELECT COUNT(Singer_ID) FROM singer
SELECT COUNT(Singer_ID) AS total_number_of_singers FROM singer
SELECT Name, Country, Age FROM singer ORDER BY Age DESC
SELECT Name, Country, Age FROM singer ORDER BY Age DESC
SELECT AVG(Age) AS average_age, MIN(Age) AS minimum_age, MAX(Age) AS maximum_age FROM singer WHERE Country = 'France'
SELECT AVG(Age), MIN(Age), MAX(Age) FROM singer WHERE Country = 'France'
SELECT Name, Song_release_year FROM singer ORDER BY Age ASC LIMIT 1
SELECT Song_Name, Song_release_year FROM singer ORDER BY Age ASC LIMIT 1
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT Country, COUNT(Singer_ID) AS number_of_singers FROM singer GROUP BY Country
SELECT Country, COUNT(Singer_ID) FROM singer GROUP BY Country
SELECT Song_Name FROM singer WHERE Age > (SELECT AVG(Age) FROM singer)
SELECT Song_Name FROM singer WHERE Age > (SELECT AVG(Age) FROM singer)
SELECT Location, Name FROM stadium WHERE Capacity BETWEEN 5000 AND 10000
SELECT Location, Name FROM stadium WHERE Capacity BETWEEN 5000 AND 10000
SELECT MAX(Capacity), AVG(Average) FROM stadium
SELECT AVG(Capacity) AS average_capacity, MAX(Capacity) AS maximum_capacity FROM stadium
SELECT Name, Capacity FROM stadium ORDER BY Average DESC LIMIT 1
SELECT Name, Capacity FROM stadium ORDER BY Average DESC LIMIT 1
SELECT COUNT(*) AS concert_count FROM concert WHERE Year = '2014' OR Year = '2015'
SELECT COUNT(*) AS num_concerts FROM concert WHERE Year IN ('2014', '2015')
SELECT stadium.Name, COUNT(concert.concert_ID) AS "Number of Concerts" FROM stadium JOIN concert ON stadium.Stadium_ID = concert.Stadium_ID GROUP BY stadium.Name
SELECT stadium.Name, COUNT(concert.concert_ID) AS concert_count FROM stadium JOIN concert ON stadium.Stadium_ID = concert.Stadium_ID GROUP BY stadium.Name
SELECT stadium.Name, stadium.Capacity FROM stadium JOIN concert ON stadium.Stadium_ID = concert.Stadium_ID WHERE concert.Year >= 2014 GROUP BY stadium.Stadium_ID ORDER BY COUNT(*) DESC LIMIT 1
SELECT stadium.Name, stadium.Capacity FROM stadium JOIN concert ON concert.Stadium_ID = stadium.Stadium_ID WHERE concert.Year > 2013 GROUP BY stadium.Name, stadium.Capacity ORDER BY COUNT(*) DESC LIMIT 1
SELECT Year FROM concert GROUP BY Year ORDER BY COUNT(*) DESC LIMIT 1
SELECT Year FROM concert GROUP BY Year ORDER BY COUNT(*) DESC LIMIT 1
SELECT Name FROM stadium WHERE NOT Stadium_ID IN (SELECT Stadium_ID FROM concert)
SELECT Name FROM stadium WHERE NOT Stadium_ID IN (SELECT Stadium_ID FROM concert)
SELECT Country FROM singer WHERE Age > 40 UNION SELECT Country FROM singer WHERE Age < 30
SELECT Name FROM stadium WHERE NOT Stadium_ID IN (SELECT Stadium_ID FROM concert WHERE Year = '2014')
SELECT Name FROM stadium WHERE NOT Stadium_ID IN (SELECT Stadium_ID FROM concert WHERE Year = '2014')
SELECT concert.concert_Name, concert.Theme, COUNT(singer_in_concert.Singer_ID) AS number_of_singers FROM concert JOIN singer_in_concert ON concert.concert_ID = singer_in_concert.concert_ID GROUP BY concert.concert_Name, concert.Theme
SELECT concert.concert_Name, concert.Theme, COUNT(DISTINCT singer_in_concert.Singer_ID) AS number_of_singers FROM concert JOIN singer_in_concert ON concert.concert_ID = singer_in_concert.concert_ID GROUP BY concert.concert_Name, concert.Theme
SELECT singer.Name, COUNT(singer_in_concert.concert_ID) AS "number of concerts" FROM singer JOIN singer_in_concert ON singer.Singer_ID = singer_in_concert.Singer_ID GROUP BY singer.Name
SELECT s.Name, COUNT(c.concert_ID) AS "number of concerts" FROM singer AS s JOIN singer_in_concert AS sic ON s.Singer_ID = sic.Singer_ID JOIN concert AS c ON sic.concert_ID = c.concert_ID GROUP BY s.Name
SELECT Name FROM singer JOIN singer_in_concert ON singer.Singer_ID = singer_in_concert.Singer_ID JOIN concert ON singer_in_concert.concert_ID = concert.concert_ID WHERE Year = 2014
SELECT Name FROM singer JOIN singer_in_concert ON singer.Singer_ID = singer_in_concert.Singer_ID JOIN concert ON singer_in_concert.concert_ID = concert.concert_ID WHERE concert.Year = 2014
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%'
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%'
SELECT s.Name, s.Location FROM stadium AS s JOIN concert AS c ON s.Stadium_ID = c.Stadium_ID WHERE c.Year = '2014' INTERSECT SELECT s.Name, s.Location FROM stadium AS s JOIN concert AS c ON s.Stadium_ID = c.Stadium_ID WHERE c.Year = '2015'
SELECT s.Name, s.Location FROM stadium AS s JOIN concert AS c ON s.Stadium_ID = c.Stadium_ID WHERE c.Year = '2014' INTERSECT SELECT s.Name, s.Location FROM stadium AS s JOIN concert AS c ON s.Stadium_ID = c.Stadium_ID WHERE c.Year = '2015'
SELECT COUNT(*) FROM concert INNER JOIN stadium ON concert.Stadium_ID = stadium.Stadium_ID GROUP BY stadium.Stadium_ID ORDER BY stadium.Capacity DESC LIMIT 1
SELECT COUNT(*) AS number_of_concerts FROM concert WHERE Stadium_ID = (SELECT Stadium_ID FROM stadium WHERE Capacity = (SELECT MAX(Capacity) FROM stadium))
SELECT COUNT(PetID) FROM Pets WHERE weight > 10
SELECT COUNT(*) FROM Pets WHERE weight > 10
SELECT weight FROM Pets WHERE PetType = 'dog' ORDER BY pet_age ASC LIMIT 1
SELECT weight FROM Pets WHERE PetType = 'dog' ORDER BY pet_age ASC LIMIT 1
SELECT MAX(weight), PetType FROM Pets GROUP BY PetType
SELECT MAX(weight), PetType FROM Pets GROUP BY PetType
SELECT COUNT(PetID) FROM Has_Pet WHERE StuID IN (SELECT StuID FROM Student WHERE Age > 20)
SELECT COUNT(*) FROM Has_Pet WHERE StuID IN (SELECT StuID FROM Student WHERE Age > 20)
SELECT COUNT(*) AS pet_count FROM Has_Pet JOIN Student ON Has_Pet.StuID = Student.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Student.Sex = 'F' AND Pets.PetType = 'dog'
SELECT COUNT(*) FROM Has_Pet JOIN Student ON Has_Pet.StuID = Student.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Student.Sex = 'F' AND Pets.PetType = 'dog'
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT COUNT(DISTINCT PetType) AS pet_type_count FROM Pets
SELECT Student.Fname FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat' OR Pets.PetType = 'dog'
SELECT Student.Fname FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType IN ('cat', 'dog')
SELECT s.Fname FROM Student AS s JOIN Has_Pet AS hp ON s.StuID = hp.StuID JOIN Pets AS p ON hp.PetID = p.PetID WHERE p.PetType = 'cat' INTERSECT SELECT s.Fname FROM Student AS s JOIN Has_Pet AS hp ON s.StuID = hp.StuID JOIN Pets AS p ON hp.PetID = p.PetID WHERE p.PetType = 'dog'
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat') AND StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'dog')
SELECT Major, Age FROM Student WHERE NOT StuID IN (SELECT T1.StuID FROM Has_Pet AS T1 JOIN Pets AS T2 ON T1.PetID = T2.PetID WHERE T2.PetType = 'cat')
SELECT Student.Major, Student.Age FROM Student WHERE NOT Student.StuID IN (SELECT Has_Pet.StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat')
SELECT StuID FROM Student WHERE NOT StuID IN (SELECT Has_Pet.StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat')
SELECT StuID FROM Student WHERE NOT StuID IN (SELECT H.StuID FROM Has_Pet AS H JOIN Pets AS P ON H.PetID = P.PetID WHERE P.PetType = 'cat')
SELECT Student.Fname, Student.Age FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'dog' AND NOT Student.StuID IN (SELECT Has_Pet.StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat')
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'dog')) AND NOT StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat'))
SELECT PetType, weight FROM Pets WHERE pet_age = (SELECT MIN(pet_age) FROM Pets)
SELECT PetType, weight FROM Pets ORDER BY pet_age ASC LIMIT 1
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetType, AVG(pet_age) AS average_pet_age, MAX(pet_age) AS maximum_pet_age FROM Pets GROUP BY PetType
SELECT PetType, AVG(pet_age) AS AverageAge, MAX(pet_age) AS MaximumAge FROM Pets GROUP BY PetType
SELECT PetType, AVG(weight) AS average_weight FROM Pets GROUP BY PetType
SELECT PetType, AVG(weight) AS average_weight FROM Pets GROUP BY PetType
SELECT Student.Fname, Student.Age FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID
SELECT DISTINCT Student.Fname, Student.Age FROM Student INNER JOIN Has_Pet ON Student.StuID = Has_Pet.StuID
SELECT Has_Pet.PetID FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID WHERE Student.LName = 'Smith'
SELECT Has_Pet.PetID FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Student.LName = 'Smith'
SELECT Student.StuID, COUNT(Has_Pet.PetID) AS number_of_pets FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID GROUP BY Student.StuID
SELECT Student.StuID, COUNT(Has_Pet.PetID) FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID GROUP BY Student.StuID
SELECT Student.Fname, Student.Sex FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID GROUP BY Student.StuID, Student.Fname, Student.Sex HAVING COUNT(*) > 1
SELECT Student.Fname, Student.Sex FROM Student WHERE Student.StuID IN (SELECT StuID FROM Has_Pet GROUP BY StuID HAVING COUNT(PetID) > 1)
SELECT Student.LName FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat' AND Pets.pet_age = 3
SELECT Student.LName FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.pet_age = 3 AND Pets.PetType = 'cat'
SELECT AVG(Age) FROM Student WHERE NOT StuID IN (SELECT StuID FROM Has_Pet)
SELECT AVG(Student.Age) FROM Student WHERE NOT Student.StuID IN (SELECT StuID FROM Has_Pet)
SELECT COUNT(*) FROM conductor
SELECT COUNT(*) AS count FROM conductor
SELECT Name FROM conductor ORDER BY Age ASC
SELECT Name FROM conductor ORDER BY Age ASC
SELECT Name FROM conductor WHERE Nationality <> 'USA'
SELECT Name FROM conductor WHERE Nationality <> 'USA'
SELECT Record_Company, Year_of_Founded FROM orchestra ORDER BY Year_of_Founded DESC
SELECT Record_Company FROM orchestra ORDER BY Year_of_Founded DESC
SELECT AVG(Attendance) AS average_attendance FROM show
SELECT AVG(Attendance) FROM show
SELECT MAX(Share), MIN(Share) FROM performance WHERE Type <> 'Live final'
SELECT MAX(Share), MIN(Share) FROM performance WHERE Type <> 'Live final'
SELECT COUNT(DISTINCT Nationality) FROM conductor
SELECT COUNT(DISTINCT Nationality) FROM conductor
SELECT Name, Year_of_Work FROM conductor ORDER BY Year_of_Work DESC
SELECT Name FROM conductor ORDER BY Year_of_Work DESC
SELECT Name FROM conductor ORDER BY Year_of_Work DESC LIMIT 1
SELECT Name FROM conductor ORDER BY Year_of_Work DESC LIMIT 1
SELECT conductor.Name, orchestra.Orchestra FROM conductor JOIN orchestra ON conductor.Conductor_ID = orchestra.Conductor_ID
SELECT conductor.Name, orchestra.Orchestra FROM conductor JOIN orchestra ON conductor.Conductor_ID = orchestra.Conductor_ID
SELECT Name FROM conductor WHERE Conductor_ID IN (SELECT Conductor_ID FROM orchestra GROUP BY Conductor_ID HAVING COUNT(DISTINCT Orchestra_ID) > 1)
SELECT Name FROM conductor WHERE Conductor_ID IN (SELECT Conductor_ID FROM orchestra GROUP BY Conductor_ID HAVING COUNT(DISTINCT Orchestra_ID) > 1)
SELECT Name FROM conductor JOIN orchestra ON conductor.Conductor_ID = orchestra.Conductor_ID GROUP BY conductor.Conductor_ID, Name ORDER BY COUNT(orchestra.Orchestra_ID) DESC LIMIT 1
SELECT T1.Name FROM conductor AS T1 JOIN orchestra AS T2 ON T1.Conductor_ID = T2.Conductor_ID GROUP BY T1.Conductor_ID ORDER BY COUNT(*) DESC LIMIT 1
SELECT conductor.Name FROM conductor JOIN orchestra ON conductor.Conductor_ID = orchestra.Conductor_ID WHERE orchestra.Year_of_Founded > 2008
SELECT Name FROM conductor JOIN orchestra ON conductor.Conductor_ID = orchestra.Conductor_ID WHERE Year_of_Founded > 2008
SELECT Record_Company, COUNT(Orchestra) AS number_of_orchestras FROM orchestra GROUP BY Record_Company
SELECT Record_Company, COUNT(Orchestra_ID) AS number_of_orchestras FROM orchestra GROUP BY Record_Company
SELECT Major_Record_Format, COUNT(*) FROM orchestra GROUP BY Major_Record_Format ORDER BY COUNT(*) ASC
SELECT Major_Record_Format, COUNT(*) AS frequency FROM orchestra GROUP BY Major_Record_Format ORDER BY frequency DESC
SELECT Record_Company FROM orchestra GROUP BY Record_Company ORDER BY COUNT(*) DESC LIMIT 1
SELECT Record_Company FROM orchestra GROUP BY Record_Company ORDER BY COUNT(*) DESC LIMIT 1
SELECT Orchestra FROM orchestra WHERE NOT Orchestra_ID IN (SELECT Orchestra_ID FROM performance)
SELECT Orchestra FROM orchestra WHERE NOT Orchestra_ID IN (SELECT Orchestra_ID FROM performance)
SELECT Record_Company FROM orchestra WHERE Year_of_Founded < 2003 INTERSECT SELECT Record_Company FROM orchestra WHERE Year_of_Founded > 2003
SELECT Record_Company FROM orchestra WHERE Year_of_Founded < 2003 INTERSECT SELECT Record_Company FROM orchestra WHERE Year_of_Founded > 2003
SELECT COUNT(*) FROM orchestra WHERE Major_Record_Format = 'CD' OR Major_Record_Format = 'DVD'
SELECT COUNT(*) FROM orchestra WHERE Major_Record_Format = 'CD' OR Major_Record_Format = 'DVD'
SELECT Year_of_Founded FROM orchestra WHERE Orchestra_ID IN (SELECT Orchestra_ID FROM performance GROUP BY Orchestra_ID HAVING COUNT(*) > 1)
SELECT Year_of_Founded FROM orchestra WHERE Orchestra_ID IN (SELECT Orchestra_ID FROM performance GROUP BY Orchestra_ID HAVING COUNT(*) > 1)
SELECT COUNT(Poker_Player_ID) FROM poker_player
SELECT COUNT(*) FROM poker_player
SELECT Earnings FROM poker_player ORDER BY Earnings DESC
SELECT Earnings FROM poker_player ORDER BY Earnings DESC
SELECT Final_Table_Made, Best_Finish FROM poker_player
SELECT Final_Table_Made, Best_Finish FROM poker_player
SELECT AVG(Earnings) FROM poker_player
SELECT AVG(Earnings) FROM poker_player
SELECT Money_Rank FROM poker_player ORDER BY Earnings DESC LIMIT 1
SELECT Money_Rank FROM poker_player ORDER BY Earnings DESC LIMIT 1
SELECT MAX(Final_Table_Made) AS MaxFinalTableMade FROM poker_player WHERE Earnings < 200000
SELECT MAX(Final_Table_Made) FROM poker_player WHERE Earnings < 200000
SELECT Name FROM people
SELECT Name FROM people JOIN poker_player ON people.People_ID = poker_player.People_ID
SELECT Name FROM people INNER JOIN poker_player ON people.People_ID = poker_player.People_ID WHERE poker_player.Earnings > 300000
SELECT people.Name FROM poker_player INNER JOIN people ON poker_player.People_ID = people.People_ID WHERE poker_player.Earnings > 300000
SELECT people.Name FROM poker_player JOIN people ON poker_player.People_ID = people.People_ID ORDER BY poker_player.Final_Table_Made ASC
SELECT Name FROM people JOIN poker_player ON people.People_ID = poker_player.People_ID ORDER BY Final_Table_Made ASC
SELECT people.Birth_Date FROM poker_player JOIN people ON poker_player.People_ID = people.People_ID ORDER BY poker_player.Earnings ASC LIMIT 1
SELECT Birth_Date FROM people JOIN poker_player ON people.People_ID = poker_player.People_ID ORDER BY Earnings ASC LIMIT 1
SELECT po.Money_Rank FROM poker_player AS po JOIN people AS pe ON po.People_ID = pe.People_ID ORDER BY pe.Height DESC LIMIT 1
SELECT p.Money_Rank FROM poker_player AS p JOIN people AS pe ON p.People_ID = pe.People_ID ORDER BY pe.Height DESC LIMIT 1
SELECT AVG(poker_player.Earnings) AS average_earnings FROM poker_player JOIN people ON poker_player.People_ID = people.People_ID WHERE people.Height > 200
SELECT AVG(Earnings) FROM poker_player JOIN people ON poker_player.People_ID = people.People_ID WHERE Height > 200
SELECT people.Name FROM poker_player JOIN people ON poker_player.People_ID = people.People_ID ORDER BY poker_player.Earnings DESC
SELECT Name FROM people JOIN poker_player ON people.People_ID = poker_player.People_ID ORDER BY Earnings DESC
SELECT Nationality, COUNT(People_ID) AS number_of_people FROM people GROUP BY Nationality
SELECT Nationality, COUNT(*) AS Count FROM people GROUP BY Nationality
SELECT Nationality FROM people GROUP BY Nationality ORDER BY COUNT(*) DESC LIMIT 1
SELECT Nationality FROM people GROUP BY Nationality ORDER BY COUNT(*) DESC LIMIT 1
SELECT Nationality FROM people GROUP BY Nationality HAVING COUNT(*) >= 2
SELECT Nationality FROM people GROUP BY Nationality HAVING COUNT(*) >= 2
SELECT Name, Birth_Date FROM people ORDER BY Name ASC
SELECT Name, Birth_Date FROM people ORDER BY Name ASC
SELECT Name FROM people WHERE Nationality <> 'Russia'
SELECT Name FROM people WHERE Nationality <> 'Russia'
SELECT Name FROM people WHERE NOT People_ID IN (SELECT People_ID FROM poker_player)
SELECT Name FROM people WHERE NOT People_ID IN (SELECT People_ID FROM poker_player)
SELECT COUNT(DISTINCT Nationality) FROM people
SELECT COUNT(DISTINCT Nationality) FROM people
SELECT COUNT(Employee_ID) FROM employee
SELECT COUNT(*) AS count FROM employee
SELECT Name FROM employee ORDER BY Age ASC
SELECT Name, Age FROM employee ORDER BY Age ASC
SELECT City, COUNT(Employee_ID) AS employee_count FROM employee GROUP BY City
SELECT City, COUNT(Employee_ID) FROM employee GROUP BY City
SELECT City FROM employee WHERE Age < 30 GROUP BY City HAVING COUNT(*) > 1
SELECT City FROM employee WHERE Age < 30 GROUP BY City HAVING COUNT(*) > 1
SELECT Location, COUNT(Shop_ID) AS number_of_shops FROM shop GROUP BY Location
SELECT COUNT(Shop_ID) AS "Number of shops", Location FROM shop GROUP BY Location
SELECT Manager_name, District FROM shop ORDER BY Number_products DESC LIMIT 1
SELECT Manager_name, District FROM shop ORDER BY Number_products DESC LIMIT 1
SELECT MIN(Number_products) AS min_number_products, MAX(Number_products) AS max_number_products FROM shop
SELECT MIN(Number_products), MAX(Number_products) FROM shop
SELECT Name, Location, District FROM shop ORDER BY Number_products DESC
SELECT Name, Location, District FROM shop ORDER BY Number_products DESC
SELECT Name FROM shop WHERE Number_products > (SELECT AVG(Number_products) FROM shop)
SELECT Name FROM shop WHERE Number_products > (SELECT AVG(Number_products) FROM shop)
SELECT employee.Name FROM employee JOIN evaluation ON employee.Employee_ID = evaluation.Employee_ID GROUP BY employee.Employee_ID ORDER BY COUNT(evaluation.Employee_ID) DESC LIMIT 1
SELECT e.Name FROM employee AS e JOIN evaluation AS ev ON e.Employee_ID = ev.Employee_ID GROUP BY e.Employee_ID ORDER BY COUNT(*) DESC LIMIT 1
SELECT employee.Name FROM employee JOIN evaluation ON employee.Employee_ID = evaluation.Employee_ID ORDER BY evaluation.Bonus DESC LIMIT 1
SELECT Name FROM employee JOIN evaluation ON employee.Employee_ID = evaluation.Employee_ID ORDER BY Bonus DESC LIMIT 1
SELECT Name FROM employee WHERE NOT Employee_ID IN (SELECT Employee_ID FROM evaluation)
SELECT Name FROM employee WHERE NOT Employee_ID IN (SELECT Employee_ID FROM evaluation)
SELECT shop.Name FROM shop JOIN hiring ON shop.Shop_ID = hiring.Shop_ID GROUP BY shop.Shop_ID ORDER BY COUNT(hiring.Employee_ID) DESC LIMIT 1
SELECT shop.Name FROM shop JOIN hiring ON shop.Shop_ID = hiring.Shop_ID GROUP BY shop.Shop_ID ORDER BY COUNT(*) DESC LIMIT 1
SELECT Name FROM shop WHERE NOT Shop_ID IN (SELECT Shop_ID FROM hiring)
SELECT Name FROM shop WHERE NOT Shop_ID IN (SELECT Shop_ID FROM hiring)
SELECT shop.Name, COUNT(*) AS number_of_employees FROM shop JOIN hiring ON shop.Shop_ID = hiring.Shop_ID GROUP BY shop.Name
SELECT shop.Name, COUNT(hiring.Employee_ID) FROM shop JOIN hiring ON shop.Shop_ID = hiring.Shop_ID GROUP BY shop.Name
SELECT SUM(Bonus) AS total_bonus FROM evaluation
SELECT SUM(Bonus) FROM evaluation
SELECT Shop_ID, Employee_ID, Start_from, Is_full_time FROM hiring
SELECT Shop_ID, Employee_ID, Start_from, Is_full_time FROM hiring
SELECT District FROM shop WHERE Number_products < 3000 INTERSECT SELECT District FROM shop WHERE Number_products > 10000
SELECT District FROM shop WHERE Number_products < 3000 INTERSECT SELECT District FROM shop WHERE Number_products > 10000
SELECT COUNT(DISTINCT Location) FROM shop
SELECT COUNT(DISTINCT Location) AS count FROM shop
SELECT COUNT(Teacher_ID) FROM teacher
SELECT COUNT(Teacher_ID) FROM teacher
SELECT Name FROM teacher ORDER BY Age ASC
SELECT Name FROM teacher ORDER BY Age ASC
SELECT Age, Hometown FROM teacher
SELECT Age, Hometown FROM teacher
SELECT Name FROM teacher WHERE Hometown <> 'Little Lever Urban District'
SELECT Name FROM teacher WHERE Hometown <> 'Little Lever Urban District'
SELECT Name FROM teacher WHERE Age IN (32, 33)
SELECT Name FROM teacher WHERE Age = '32' OR Age = '33'
SELECT Hometown FROM teacher ORDER BY Age ASC LIMIT 1
SELECT Hometown FROM teacher ORDER BY Age ASC LIMIT 1
SELECT Hometown, COUNT(*) FROM teacher GROUP BY Hometown
SELECT Hometown, COUNT(Teacher_ID) FROM teacher GROUP BY Hometown
SELECT Hometown FROM teacher GROUP BY Hometown ORDER BY COUNT(*) DESC LIMIT 1
SELECT Hometown FROM teacher GROUP BY Hometown ORDER BY COUNT(*) DESC LIMIT 1
SELECT Hometown FROM teacher GROUP BY Hometown HAVING COUNT(*) >= 2
SELECT Hometown FROM teacher GROUP BY Hometown HAVING COUNT(*) >= 2
SELECT teacher.Name, course.Course FROM teacher JOIN course_arrange ON teacher.Teacher_ID = course_arrange.Teacher_ID JOIN course ON course_arrange.Course_ID = course.Course_ID
SELECT teacher.Name, course.Course FROM teacher JOIN course_arrange ON teacher.Teacher_ID = course_arrange.Teacher_ID JOIN course ON course_arrange.Course_ID = course.Course_ID
SELECT t.Name, c.Course FROM teacher AS t JOIN course_arrange AS ca ON t.Teacher_ID = ca.Teacher_ID JOIN course AS c ON ca.Course_ID = c.Course_ID ORDER BY t.Name ASC
SELECT teacher.Name, course.Course FROM teacher JOIN course_arrange ON teacher.Teacher_ID = course_arrange.Teacher_ID JOIN course ON course.Course_ID = course_arrange.Course_ID ORDER BY teacher.Name ASC
SELECT teacher.Name FROM course JOIN course_arrange ON course.Course_ID = course_arrange.Course_ID JOIN teacher ON course_arrange.Teacher_ID = teacher.Teacher_ID WHERE course.Course = 'Math'
SELECT teacher.Name FROM course JOIN course_arrange ON course.Course_ID = course_arrange.Course_ID JOIN teacher ON course_arrange.Teacher_ID = teacher.Teacher_ID WHERE course.Course = 'Math'
SELECT teacher.Name, COUNT(course_arrange.Course_ID) AS number_of_courses FROM teacher JOIN course_arrange ON teacher.Teacher_ID = course_arrange.Teacher_ID GROUP BY teacher.Name
SELECT teacher.Name, COUNT(course_arrange.Course_ID) AS course_count FROM teacher JOIN course_arrange ON teacher.Teacher_ID = course_arrange.Teacher_ID GROUP BY teacher.Name
SELECT teacher.Name FROM teacher JOIN course_arrange ON teacher.Teacher_ID = course_arrange.Teacher_ID GROUP BY teacher.Teacher_ID, teacher.Name HAVING COUNT(course_arrange.Course_ID) >= 2
SELECT teacher.Name FROM teacher JOIN course_arrange ON teacher.Teacher_ID = course_arrange.Teacher_ID GROUP BY course_arrange.Teacher_ID HAVING COUNT(course_arrange.Course_ID) >= 2
SELECT Name FROM teacher WHERE NOT Teacher_ID IN (SELECT Teacher_ID FROM course_arrange)
SELECT Name FROM teacher WHERE NOT Teacher_ID IN (SELECT Teacher_ID FROM course_arrange)
SELECT COUNT(*) FROM singer
SELECT COUNT(Singer_ID) AS count FROM singer
SELECT Name FROM singer ORDER BY Net_Worth_Millions ASC
SELECT Name FROM singer ORDER BY Net_Worth_Millions ASC
SELECT Birth_Year, Citizenship FROM singer
SELECT Birth_Year, Citizenship FROM singer
SELECT Name FROM singer WHERE Citizenship <> 'France'
SELECT Name FROM singer WHERE Citizenship <> 'France'
SELECT Name FROM singer WHERE Birth_Year = 1948 OR Birth_Year = 1949
SELECT Name FROM singer WHERE Birth_Year = 1948 OR Birth_Year = 1949
SELECT Name FROM singer ORDER BY Net_Worth_Millions DESC LIMIT 1
SELECT Name FROM singer ORDER BY Net_Worth_Millions DESC LIMIT 1
SELECT Citizenship, COUNT(Singer_ID) AS number_of_singers FROM singer GROUP BY Citizenship
SELECT Citizenship, COUNT(Singer_ID) AS count FROM singer GROUP BY Citizenship
SELECT Citizenship FROM singer GROUP BY Citizenship ORDER BY COUNT(*) DESC LIMIT 1
SELECT Citizenship, COUNT(Singer_ID) FROM singer GROUP BY Citizenship ORDER BY COUNT(Singer_ID) DESC LIMIT 1
SELECT Citizenship, MAX(Net_Worth_Millions) FROM singer GROUP BY Citizenship
SELECT Citizenship, MAX(Net_Worth_Millions) FROM singer GROUP BY Citizenship
SELECT song.Title, singer.Name FROM song JOIN singer ON song.Singer_ID = singer.Singer_ID
SELECT song.Title, singer.Name FROM song JOIN singer ON song.Singer_ID = singer.Singer_ID
SELECT DISTINCT singer.Name FROM singer JOIN song ON singer.Singer_ID = song.Singer_ID WHERE song.Sales > 300000
SELECT DISTINCT singer.Name FROM singer JOIN song ON singer.Singer_ID = song.Singer_ID WHERE song.Sales > 300000
SELECT singer.Name FROM singer JOIN song ON singer.Singer_ID = song.Singer_ID GROUP BY singer.Name HAVING COUNT(*) > 1
SELECT Name FROM singer JOIN song ON singer.Singer_ID = song.Singer_ID GROUP BY singer.Singer_ID, Name HAVING COUNT(*) > 1
SELECT singer.Name, SUM(song.Sales) AS Total_Sales FROM singer JOIN song ON singer.Singer_ID = song.Singer_ID GROUP BY singer.Name
SELECT singer.Name, SUM(song.Sales) AS total_sales FROM singer JOIN song ON singer.Singer_ID = song.Singer_ID GROUP BY singer.Name
SELECT Name FROM singer WHERE NOT Singer_ID IN (SELECT Singer_ID FROM song)
SELECT Name FROM singer WHERE NOT Singer_ID IN (SELECT Singer_ID FROM song)
SELECT Citizenship FROM singer WHERE Birth_Year < 1945 OR Birth_Year > 1955 GROUP BY Citizenship
SELECT Citizenship FROM singer WHERE (Birth_Year < 1945) INTERSECT SELECT Citizenship FROM singer WHERE (Birth_Year > 1955)
SELECT COUNT(*) FROM visitor WHERE Age < 30
SELECT Name FROM visitor WHERE Level_of_membership > 4 ORDER BY Level_of_membership DESC
SELECT AVG(Age) AS average_age FROM visitor WHERE Level_of_membership <= 4
SELECT Name, Level_of_membership FROM visitor WHERE Level_of_membership > 4 ORDER BY Age DESC
SELECT Museum_ID, Name FROM museum ORDER BY Num_of_Staff DESC LIMIT 1
SELECT AVG(Num_of_Staff) FROM museum WHERE Open_Year < 2009
SELECT Open_Year, Num_of_Staff FROM museum WHERE Name = 'Plaza Museum'
SELECT Name FROM museum WHERE Num_of_Staff > (SELECT MIN(Num_of_Staff) FROM museum WHERE Open_Year > 2010)
SELECT visitor.ID, visitor.Name, visitor.Age FROM visitor JOIN visit ON visitor.ID = visit.visitor_ID GROUP BY visit.visitor_ID, visitor.ID, visitor.Name, visitor.Age HAVING COUNT(*) > 1
SELECT visitor.ID, visitor.Name, visitor.Level_of_membership FROM visitor JOIN visit ON visitor.ID = visit.visitor_ID GROUP BY visitor.ID, visitor.Name, visitor.Level_of_membership ORDER BY SUM(visit.Total_spent) DESC LIMIT 1
SELECT museum.Museum_ID, museum.Name FROM museum JOIN visit ON museum.Museum_ID = visit.Museum_ID GROUP BY museum.Museum_ID, museum.Name ORDER BY COUNT(*) DESC LIMIT 1
SELECT Name FROM museum WHERE NOT Museum_ID IN (SELECT Museum_ID FROM visit)
SELECT visitor.Name, visitor.Age FROM visit JOIN visitor ON visit.visitor_ID = visitor.ID ORDER BY visit.Num_of_Ticket DESC LIMIT 1
SELECT AVG(Num_of_Ticket) AS average_num_of_ticket, MAX(Num_of_Ticket) AS maximum_num_of_ticket FROM visit
SELECT SUM(visit.Total_spent) AS SUM_Total_spent FROM visit JOIN visitor ON visit.visitor_ID = visitor.ID WHERE visitor.Level_of_membership = 1
SELECT DISTINCT visitor.Name FROM visitor INNER JOIN visit ON visitor.ID = visit.visitor_ID INNER JOIN museum ON visit.Museum_ID = museum.Museum_ID WHERE museum.Open_Year < 2009 INTERSECT SELECT DISTINCT visitor.Name FROM visitor INNER JOIN visit ON visitor.ID = visit.visitor_ID INNER JOIN museum ON visit.Museum_ID = museum.Museum_ID WHERE museum.Open_Year > 2011
SELECT COUNT(visitor.ID) FROM visitor WHERE NOT visitor.ID IN (SELECT DISTINCT visit.visitor_ID FROM visit JOIN museum ON visit.Museum_ID = museum.Museum_ID WHERE museum.Open_Year > 2010)
SELECT COUNT(*) FROM museum WHERE Open_Year > 2013 OR Open_Year < 2008
SELECT COUNT(id) FROM ship WHERE disposition_of_ship = 'Captured'
SELECT name, tonnage FROM ship ORDER BY name DESC
SELECT name, date, result FROM battle
SELECT MAX(killed) AS maximum_death_toll, MIN(killed) AS minimum_death_toll FROM death
SELECT AVG(injured) AS average_injuries FROM death
SELECT death.killed, death.injured FROM ship JOIN death ON ship.id = death.caused_by_ship_id WHERE ship.tonnage = 't'
SELECT name, result FROM battle WHERE bulgarian_commander <> 'Boril'
SELECT battle.id, battle.name FROM battle JOIN ship ON battle.id = ship.lost_in_battle WHERE ship.ship_type = 'Brig'
SELECT battle.id, battle.name FROM battle JOIN death ON battle.id = death.id GROUP BY battle.id, battle.name HAVING SUM(death.killed) > 10
SELECT ship.id, ship.name FROM ship JOIN death ON ship.id = death.caused_by_ship_id GROUP BY ship.id, ship.name ORDER BY SUM(death.injured) DESC LIMIT 1
SELECT DISTINCT name FROM battle WHERE bulgarian_commander = 'Kaloyan' AND latin_commander = 'Baldwin I'
SELECT COUNT(DISTINCT result) FROM battle
SELECT COUNT(*) FROM battle WHERE NOT id IN (SELECT lost_in_battle FROM ship WHERE tonnage = '225')
SELECT b.name, b.date FROM battle AS b JOIN ship AS s ON b.id = s.lost_in_battle WHERE s.name = 'Lettice' OR s.name = 'HMS Atalanta' GROUP BY b.name, b.date HAVING COUNT(DISTINCT s.id) = 2
SELECT battle.name, battle.result, battle.bulgarian_commander FROM battle JOIN ship ON battle.id = ship.lost_in_battle WHERE ship.lost_in_battle = 0 AND ship.location = 'English Channel'
SELECT note FROM death WHERE note LIKE '%East%'
SELECT COUNT(DISTINCT state) AS state_count FROM AREA_CODE_STATE
SELECT contestant_number, contestant_name FROM CONTESTANTS ORDER BY contestant_name DESC
SELECT vote_id, phone_number, state FROM VOTES
SELECT MAX(area_code) AS max_area_code, MIN(area_code) AS min_area_code FROM AREA_CODE_STATE
SELECT MAX(created) FROM VOTES WHERE state = 'CA'
SELECT contestant_name FROM CONTESTANTS WHERE contestant_name <> 'Jessie Alloway'
SELECT DISTINCT state, created FROM VOTES
SELECT CONTESTANTS.contestant_number, CONTESTANTS.contestant_name FROM CONTESTANTS JOIN VOTES ON CONTESTANTS.contestant_number = VOTES.contestant_number GROUP BY CONTESTANTS.contestant_number, CONTESTANTS.contestant_name HAVING COUNT(*) >= 2
SELECT c.contestant_number, c.contestant_name FROM CONTESTANTS AS c JOIN VOTES AS v ON c.contestant_number = v.contestant_number GROUP BY c.contestant_number, c.contestant_name ORDER BY COUNT(*) ASC LIMIT 1
SELECT COUNT(vote_id) FROM VOTES WHERE state IN ('NY', 'CA')
SELECT COUNT(*) AS count FROM CONTESTANTS WHERE NOT contestant_number IN (SELECT contestant_number FROM VOTES)
SELECT area_code FROM AREA_CODE_STATE JOIN VOTES ON AREA_CODE_STATE.state = VOTES.state GROUP BY area_code ORDER BY COUNT(*) DESC LIMIT 1
SELECT VOTES.created, VOTES.state, VOTES.phone_number FROM VOTES JOIN CONTESTANTS ON VOTES.contestant_number = CONTESTANTS.contestant_number WHERE CONTESTANTS.contestant_name = 'Tabatha Gehling'
SELECT area_code FROM AREA_CODE_STATE JOIN VOTES ON AREA_CODE_STATE.state = VOTES.state JOIN CONTESTANTS ON VOTES.contestant_number = CONTESTANTS.contestant_number WHERE CONTESTANTS.contestant_name = 'Tabatha Gehling' INTERSECT SELECT area_code FROM AREA_CODE_STATE JOIN VOTES ON AREA_CODE_STATE.state = VOTES.state JOIN CONTESTANTS ON VOTES.contestant_number = CONTESTANTS.contestant_number WHERE CONTESTANTS.contestant_name = 'Kelly Clauss'
SELECT contestant_name FROM CONTESTANTS WHERE contestant_name LIKE '%Al%'
SELECT COUNT(feature_id) FROM Other_Available_Features
SELECT Ref_Feature_Types.feature_type_name FROM Ref_Feature_Types JOIN Other_Available_Features ON Ref_Feature_Types.feature_type_code = Other_Available_Features.feature_type_code WHERE Other_Available_Features.feature_name = 'AirCon'
SELECT Ref_Property_Types.property_type_description FROM Ref_Property_Types JOIN Properties ON Ref_Property_Types.property_type_code = Properties.property_type_code WHERE Properties.property_type_code = 'that code'
SELECT P.property_name FROM Properties AS P JOIN Ref_Property_Types AS R ON P.property_type_code = R.property_type_code WHERE P.room_count > 1 AND R.property_type_description IN ('House', 'Apartment')
