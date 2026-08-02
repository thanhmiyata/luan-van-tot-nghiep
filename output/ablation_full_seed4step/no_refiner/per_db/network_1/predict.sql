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
