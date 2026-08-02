select count(*) from Highschooler	network_1
select count(*) from Highschooler	network_1
select name, grade from Highschooler	network_1
select name, grade from Highschooler	network_1
select grade from Highschooler	network_1
select name, grade from Highschooler	network_1
select grade from Highschooler where name = "Kyle"	network_1
select grade from Highschooler where name = "Kyle"	network_1
select name from Highschooler where grade = 10	network_1
select name from Highschooler where grade = 10	network_1
select ID from Highschooler where name = "Kyle"	network_1
select ID from Highschooler where name = "Kyle"	network_1
select count(ID) from Highschooler where grade = 9 or grade = 10	network_1
select count(ID) from Highschooler where grade = 9 or grade = 10	network_1
select grade, count(ID) from Highschooler group by grade	network_1
select grade, count(ID) from Highschooler group by grade	network_1
select grade from Highschooler group by grade order by count(ID) desc limit 1	network_1
select grade from Highschooler group by grade order by count(ID) desc limit 1	network_1
select grade from Highschooler group by grade having count(ID) >= 4	network_1
select grade from Highschooler group by grade having count(*) >= 4	network_1
select student_id, count(friend_id) from Friend group by student_id	network_1
select student_id, count(friend_id) from Friend group by student_id	network_1
select T1.name, count(T2.friend_id) from Highschooler as T1 left join Friend as T2 on T1.ID = T2.student_id group by T1.ID, T1.name	network_1
select T1.name, count(T2.friend_id) from Highschooler as T1 left join Friend as T2 on T1.ID = T2.student_id group by T1.ID, T1.name	network_1
select T1.name from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id group by T1.ID order by count(T2.friend_id) desc limit 1	network_1
select T1.name from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id group by T1.ID order by count(T2.friend_id) desc limit 1	network_1
select T1.name from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id group by T1.ID having count(T2.friend_id) >= 3	network_1
select T1.name from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id group by T1.ID having count(T2.friend_id) >= 3	network_1
select T2.name from Friend as T1 join Highschooler as T2 on T1.friend_id = T2.ID join Highschooler as T3 on T1.student_id = T3.ID where T3.name = "Kyle"	network_1
select T2.name from Friend as T1 join Highschooler as T2 on T1.friend_id = T2.ID join Highschooler as T3 on T1.student_id = T3.ID where T3.name = "Kyle"	network_1
select count(T1.friend_id) from Friend as T1 inner join Highschooler as T2 on T1.student_id = T2.ID where T2.name = "Kyle"	network_1
select count(T1.friend_id) from Friend as T1 inner join Highschooler as T2 on T1.student_id = T2.ID where T2.name = "Kyle"	network_1
select ID from Highschooler except select student_id from Friend	network_1
select ID from Highschooler except select student_id from Friend	network_1
select name from Highschooler where ID not in (select student_id from Friend)	network_1
select T1.name from Highschooler as T1 where T1.ID not in ( select student_id from Friend union select friend_id from Friend )	network_1
select student_id from Friend intersect select liked_id from Likes	network_1
select T1.student_id from Friend as T1 intersect select T2.liked_id from Likes as T2	network_1
select distinct T1.name from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id join Likes as T3 on T1.ID = T3.liked_id	network_1
select distinct T1.name from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id join Likes as T3 on T1.ID = T3.liked_id	network_1
select student_id, count(*) from Likes group by student_id	network_1
select student_id, count(*) from Likes group by student_id	network_1
select T1.name, count(T2.liked_id) from Highschooler as T1 join Likes as T2 on T1.ID = T2.liked_id group by T1.ID	network_1
select T1.name, count(T2.liked_id) from Highschooler as T1 join Likes as T2 on T1.ID = T2.liked_id group by T1.ID	network_1
ite select T1.name from Highschooler as T1 join Likes as T2 on T1.ID = T2.liked_id group by T1.ID order by count(T2.student_id) desc limit 1	network_1
select T1.name from Highschooler as T1 inner join Likes as T2 on T1.ID = T2.liked_id group by T1.ID order by count(T2.liked_id) desc limit 1	network_1
select T1.name from Highschooler as T1 join Likes as T2 on T1.ID = T2.liked_id group by T1.ID having count(T2.student_id) >= 2	network_1
select T1.name from Highschooler as T1 join Likes as T2 on T1.ID = T2.liked_id group by T1.ID having count(T2.student_id) >= 2	network_1
select T1.name from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id where T1.grade > 5 group by T1.ID having count(T2.friend_id) >= 2	network_1
select T1.name from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id where T1.grade > 5 group by T1.ID having count(T2.friend_id) >= 2	network_1
select count(T1.liked_id) from Likes as T1 join Highschooler as T2 on T1.student_id = T2.ID where T2.name = "Kyle"	network_1
select count(T1.student_id) from Likes as T1 inner join Highschooler as T2 on T1.student_id = T2.ID where T2.name = "Kyle"	network_1
select avg(T1.grade) from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id	network_1
select avg(T1.grade) from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id	network_1
select min(T1.grade) from Highschooler as T1 where T1.ID not in ( select student_id from Friend )	network_1
select min(T1.grade) from Highschooler as T1 where T1.ID not in ( select student_id from Friend )	network_1
