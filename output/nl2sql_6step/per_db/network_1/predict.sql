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
