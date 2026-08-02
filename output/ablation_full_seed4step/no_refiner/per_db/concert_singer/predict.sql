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
