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
