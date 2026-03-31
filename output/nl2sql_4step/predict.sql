SELECT mID FROM Movie EXCEPT SELECT mID FROM Rating WHERE rID IN (SELECT rID FROM Reviewer WHERE name = 'Britanny Harris');	movie_1
SELECT director FROM Movie GROUP BY director HAVING COUNT(*) = 1;	movie_1
SELECT T1.rID FROM Reviewer AS T1 JOIN Rating AS T2 ON T1.rID = T2.rID WHERE T2.stars <> 4;	movie_1
SELECT rID FROM Rating EXCEPT SELECT rID FROM Rating WHERE stars = 4;	movie_1
SELECT count(*) FROM Movie WHERE year < 2000;	movie_1
SELECT T1.title, MIN(T2.stars) FROM Movie AS T1 JOIN Rating AS T2 ON T1.mID = T2.mID GROUP BY T1.director;	movie_1
SELECT MAX(stars), ratingDate FROM Rating ORDER BY ratingDate DESC LIMIT 1;	movie_1
SELECT director, count(*) FROM Movie GROUP BY director;	movie_1
SELECT DISTINCT director FROM Movie JOIN Rating ON Movie.mID = Rating.mID JOIN Reviewer ON Rating.rID = Rating.rID WHERE Reviewer.name = 'Sarah Martinez';	movie_1
SELECT title FROM Movie WHERE mID IN (SELECT mID FROM Rating WHERE stars = 3 INTERSECT SELECT mID FROM Rating WHERE stars = 4);	movie_1
SELECT AVG(stars), rID FROM Rating GROUP BY rID;	movie_1
SELECT title FROM Movie EXCEPT SELECT T1.title FROM Movie AS T1 JOIN Rating AS T2 ON T1.mID = T2.mID JOIN Reviewer AS T3 ON T2.rID = T3.rID WHERE T3.name = 'Chris Jackson';	movie_1
SELECT T1.title, AVG(T2.stars) AS average_rating FROM Movie AS T1 JOIN Rating AS T2 ON T1.mID = T2.mID GROUP BY T1.mID, T1.title ORDER BY average_rating DESC;	movie_1
SELECT T1.name, T2.title, T3.stars FROM Reviewer AS T1 INNER JOIN Movie AS T2 ON T1.name = T2.director INNER JOIN Rating AS T3 ON T2.mID = T3.mID WHERE T1.rID = T3.rID;	movie_1
SELECT T1.title FROM Movie AS T1 JOIN Rating AS T2 ON T1.mID = T2.mID WHERE T2.stars BETWEEN 3 AND 5;	movie_1
SELECT T1.name, T2.title, T3.stars FROM Reviewer AS T1 INNER JOIN Rating AS T3 ON T1.rID = T3.rID INNER JOIN Movie AS T2 ON T3.mID = T2.mID WHERE T1.name = T2.director;	movie_1
SELECT avg(T1.stars), T2.title FROM Rating AS T1 JOIN Movie AS T2 ON T1.mID = T2.mID WHERE T2.year = (SELECT min(year) FROM Movie);	movie_1
SELECT T1.name FROM Reviewer AS T1 INNER JOIN Rating AS T2 ON T1.rID = T2.rID WHERE T2.ratingDate IS NULL;	movie_1
SELECT title FROM Movie WHERE year > 2000 AND director = 'James Cameron';	movie_1
SELECT mID FROM Movie EXCEPT SELECT mID FROM Rating WHERE rID IN (SELECT rID FROM Reviewer WHERE name = 'Brittany Harris');	movie_1
SELECT title FROM Movie WHERE year > 2000 UNION SELECT T1.title FROM Movie AS T1 INNER JOIN Rating AS T2 ON T1.mID = T2.mID INNER JOIN Reviewer AS T3 ON T2.rID = T3.rID WHERE T3.name = 'Brittany Harris';	movie_1
SELECT rID, AVG(stars) FROM Rating GROUP BY rID;	movie_1
SELECT title FROM Movie WHERE mID NOT IN (SELECT mID FROM Rating);	movie_1
SELECT title, director FROM Movie WHERE director IN (SELECT director FROM Movie GROUP BY director HAVING count(*) > 1) ORDER BY director, title;	movie_1
SELECT T1.name FROM Reviewer AS T1 JOIN Rating AS T2 ON T1.rID = T2.rID GROUP BY T1.rID HAVING count(*) >= 3;	movie_1
SELECT rID FROM Reviewer WHERE name = 'Daniel Lewis';	movie_1
SELECT T2.stars, T1.year FROM Movie AS T1 JOIN Rating AS T2 ON T1.mID = T2.mID ORDER BY T1.year DESC LIMIT 1;	movie_1
SELECT T1.name, T2.title, T3.stars, T3.ratingDate FROM Reviewer AS T1 JOIN Rating AS T3 ON T1.rID = T3.rID JOIN Movie AS T2 ON T2.mID = T3.mID ORDER BY T1.name, T2.title, T3.stars;	movie_1
SELECT name FROM Reviewer UNION SELECT title FROM Movie;	movie_1
SELECT T1.title FROM Movie AS T1 JOIN Rating AS T2 ON T1.mID = T2.mID WHERE T2.stars = 3 OR T2.stars = 4;	movie_1
SELECT T1.title, avg(T2.stars) FROM Movie AS T1 JOIN Rating AS T2 ON T1.mID = T2.mID GROUP BY T1.mID, T1.title ORDER BY avg(T2.stars) ASC LIMIT 1;	movie_1
SELECT T1.title, T2.stars FROM Movie AS T1 INNER JOIN Rating AS T2 ON T1.mID = T2.mID WHERE (T2.rID, T2.stars) IN (SELECT rID, MIN(stars) FROM Rating GROUP BY rID);	movie_1
SELECT rID FROM Reviewer WHERE name LIKE '%Mike%';	movie_1
SELECT DISTINCT T1.director, T1.title FROM Movie AS T1 JOIN Rating AS T2 ON T1.mID = T2.mID WHERE T2.stars = 5;	movie_1
SELECT T1.title, T1.year FROM Movie AS T1 JOIN Rating AS T2 ON T1.mID = T2.mID ORDER BY T2.stars DESC LIMIT 3;	movie_1
SELECT T1.name, T3.title FROM Reviewer AS T1 JOIN Rating AS T2 ON T1.rID = T2.rID JOIN Movie AS T3 ON T2.mID = T3.mID;	movie_1
SELECT director FROM Movie WHERE director IS NOT NULL GROUP BY director HAVING COUNT(*) = 1;	movie_1
SELECT director FROM Movie GROUP BY director HAVING COUNT(*) = 1;	movie_1
SELECT title FROM Movie WHERE year = (SELECT MAX(year) FROM Movie);	movie_1
SELECT title, year FROM Movie WHERE director IN (SELECT director FROM Movie GROUP BY director HAVING count(*) > 1);	movie_1
SELECT title FROM Movie WHERE director = 'steven spielberg';	movie_1
SELECT m.director, m.title, r.stars FROM Movie AS m JOIN Rating AS r ON m.mID = r.mID WHERE m.director IS NOT NULL AND r.stars = (SELECT MAX(r2.stars) FROM Movie AS m2 JOIN Rating AS r2 ON m2.mID = r2.mID WHERE m2.director = m.director);	movie_1
SELECT rID FROM Rating WHERE stars != 4;	movie_1
SELECT title, director FROM Movie WHERE mID IN (SELECT mID FROM Rating WHERE stars > (SELECT avg(stars) FROM Rating WHERE mID IN (SELECT mID FROM Movie WHERE director = 'James Cameron')));	movie_1
SELECT title, year FROM Movie WHERE director IN (SELECT director FROM Movie GROUP BY director HAVING COUNT(*) > 1);	movie_1
SELECT title FROM Movie WHERE mID NOT IN (SELECT mID FROM Rating);	movie_1
SELECT DISTINCT T1.director FROM Movie AS T1 JOIN Rating AS T2 ON T1.mID = T2.mID JOIN Reviewer AS T3 ON T2.rID = T3.rID WHERE T3.name = 'Sarah Martinez';	movie_1
SELECT title FROM Movie WHERE director = 'James Cameron' AND year > 2000;	movie_1
SELECT name FROM Reviewer JOIN Rating ON Reviewer.rID = Rating.rID GROUP BY name HAVING count(*) >= 3;	movie_1
SELECT T1.name FROM Reviewer AS T1 JOIN Rating AS T2 ON T1.rID = T2.rID WHERE T2.stars > 3;	movie_1
