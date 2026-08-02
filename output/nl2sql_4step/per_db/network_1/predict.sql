select count(ID) from Highschooler	network_1
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
select count(*) from Highschooler where grade in (9, 10)	network_1
select count(*) from Highschooler where grade in (9, 10)	network_1
select grade, count(*) from Highschooler group by grade	network_1
select grade, count(*) from Highschooler group by grade	network_1
select grade from Highschooler group by grade order by count(*) desc limit 1	network_1
select grade from Highschooler group by grade order by count(*) desc limit 1	network_1
select grade from Highschooler group by grade having count(*) >= 4	network_1
select grade from Highschooler group by grade having count(*) >= 4	network_1
select T1.ID, count(T2.friend_id) from Highschooler as T1 left join Friend as T2 on T1.ID = T2.student_id group by T1.ID	network_1
select Highschooler.name, count(Friend.friend_id) from Highschooler left join Friend on Highschooler.ID = Friend.student_id group by Highschooler.ID, Highschooler.name	network_1
select Highschooler.name, count(Friend.student_id) from Highschooler left join Friend on Highschooler.ID = Friend.student_id group by Highschooler.name	network_1
select Highschooler.name, count(Friend.friend_id) from Highschooler left join Friend on Highschooler.ID = Friend.student_id group by Highschooler.name	network_1
select H.name from Highschooler as H join Friend as F on H.ID = F.student_id group by H.ID order by count(*) desc limit 1	network_1
select Highschooler.name from Highschooler join Friend on Highschooler.ID = Friend.student_id group by Highschooler.ID, Highschooler.name order by count(*) desc limit 1	network_1
select T1.name from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id group by T1.ID having count(T2.friend_id) >= 3	network_1
select name from Highschooler where ID in (select student_id from Friend group by student_id having count(*) >= 3)	network_1
select T2.name from Highschooler as T1 join Friend as T3 on T1.ID = T3.student_id join Highschooler as T2 on T3.friend_id = T2.ID where T1.name = "Kyle"	network_1
select H2.name from Highschooler H1 join Friend F on H1.ID = F.student_id join Highschooler H2 on F.friend_id = H2.ID where H1.name = "Kyle"	network_1
select count(*) from Friend join Highschooler on Highschooler.ID = Friend.student_id where Highschooler.name = "Kyle"	network_1
select count(*) from Friend join Highschooler on Friend.student_id = Highschooler.ID where Highschooler.name = "Kyle"	network_1
select Highschooler.ID from Highschooler where Highschooler.ID not in (select student_id from Friend)	network_1
select Highschooler.ID from Highschooler left join Friend on (Highschooler.ID = Friend.student_id or Highschooler.ID = Friend.friend_id) where Friend.student_id is null and Friend.friend_id is null	network_1
select T1.name from Highschooler as T1 left join Friend as T2 on T1.ID = T2.student_id where T2.friend_id is null	network_1
select name from Highschooler where ID not in (select student_id from Friend)	network_1
select H.ID from Highschooler H where EXISTS (select 1 from Friend F where F.student_id = H.ID) and EXISTS (select 1 from Likes L where L.liked_id = H.ID)	network_1
select Highschooler.ID from Highschooler where Highschooler.ID in (select student_id from Friend) and Highschooler.ID in (select liked_id from Likes)	network_1
select distinct T1.name from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id join Likes as T3 on T1.ID = T3.liked_id	network_1
select name from Highschooler where ID in (select student_id from Friend) and ID in (select liked_id from Likes)	network_1
select student_id, count(*) from Likes group by student_id	network_1
select student_id, count(*) from Likes group by student_id	network_1
select Highschooler.name, count(Likes.liked_id) from Highschooler join Likes on Highschooler.ID = Likes.student_id group by Highschooler.name	network_1
select Highschooler.name, count(Likes.student_id) from Highschooler join Likes on Highschooler.ID = Likes.student_id group by Highschooler.ID	network_1
select Highschooler.name from Highschooler join Likes on Highschooler.ID = Likes.student_id group by Highschooler.ID order by count(*) desc limit 1	network_1
select name from Highschooler join Likes on ID = liked_id group by name order by count(*) desc limit 1	network_1
select Highschooler.name from Highschooler join Likes on Highschooler.ID = Likes.student_id group by Highschooler.ID, Highschooler.name having count(*) >= 2	network_1
select Highschooler.name from Highschooler join Likes on Highschooler.ID = Likes.student_id group by Highschooler.ID having count(*) >= 2	network_1
select name from Highschooler where grade > 5 and ID in (select student_id from Friend group by student_id having count(friend_id) >= 2)	network_1
select name from Highschooler where grade > 5 and ID in (select student_id from Friend group by student_id having count(friend_id) >= 2)	network_1
select count(*) from Likes join Highschooler on Likes.student_id = Highschooler.ID where Highschooler.name = "Kyle"	network_1
select count(*) from Likes join Highschooler on Likes.student_id = Highschooler.ID where Highschooler.name = "Kyle"	network_1
select avg(grade) from Highschooler where ID in (select student_id from Friend union select friend_id from Friend)	network_1
select avg(grade) from Highschooler where ID in (select student_id from Friend) or ID in (select friend_id from Friend)	network_1
select min(grade) from Highschooler where ID not in (select student_id from Friend)	network_1
select min(T1.grade) from Highschooler as T1 left join Friend as T2 on T1.ID = T2.student_id where T2.student_id is null	network_1
