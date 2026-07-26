select count(*) from teacher	course_teach
select count(*) from teacher	course_teach
select Name from teacher order by Age asc	course_teach
select Name from teacher order by Age asc	course_teach
select Age, Hometown from teacher	course_teach
select Age, Hometown from teacher	course_teach
select name from teacher where hometown != "little lever urban district"	course_teach
select name from teacher where hometown != "little lever urban district"	course_teach
SELECT Name FROM teacher WHERE Age  =  32 OR Age  =  33	course_teach
SELECT Name FROM teacher WHERE Age  =  32 OR Age  =  33	course_teach
select Hometown from teacher order by Age asc limit 1	course_teach
select Hometown from teacher order by Age asc limit 1	course_teach
select Hometown, count(*) from teacher group by Hometown	course_teach
SELECT Hometown ,  COUNT(*) FROM teacher GROUP BY Hometown	course_teach
select Hometown from teacher group by Hometown order by count(*) desc limit 1	course_teach
select Hometown from teacher group by Hometown order by count(*) desc	course_teach
select Hometown from teacher group by Hometown having count(*) >= 2	course_teach
select Hometown from teacher group by Hometown having count(*) >= 2	course_teach
select teacher.Name, course.Course from course_arrange join teacher on course_arrange.Teacher_ID = teacher.Teacher_ID join course on course_arrange.Course_ID = course.Course_ID	course_teach
select teacher.Name, course.Course from teacher join course_arrange on teacher.Teacher_ID = course_arrange.Teacher_ID join course on course.Course_ID = course_arrange.Course_ID	course_teach
select T1.Name, T3.Course from teacher as T1 join course_arrange as T2 on T1.Teacher_ID = T2.Teacher_ID join course as T3 on T2.Course_ID = T3.Course_ID order by T1.Name asc	course_teach
select teacher.Name, course.Course from course_arrange join teacher on course_arrange.Teacher_ID = teacher.Teacher_ID join course on course_arrange.Course_ID = course.Course_ID order by teacher.Name asc	course_teach
select teacher.Name from teacher join course_arrange on course_arrange.Teacher_ID = teacher.Teacher_ID join course on course_arrange.Course_ID = course.Course_ID where course.Course = "Math"	course_teach
select T1.Name from course as T2 join course_arrange as T3 on T2.Course_ID = T3.Course_ID join teacher as T1 on T3.Teacher_ID = T1.Teacher_ID where T2.Course = "Math"	course_teach
select teacher.Name, count(course_arrange.Course_ID) from teacher join course_arrange on teacher.Teacher_ID = course_arrange.Teacher_ID group by teacher.Teacher_ID	course_teach
SELECT T2.Name ,  COUNT(*) FROM course_arrange AS T1 JOIN teacher AS T2 ON T1.Teacher_ID  =  T2.Teacher_ID GROUP BY T2.Name	course_teach
SELECT T2.Name FROM course_arrange AS T1 JOIN teacher AS T2 ON T1.Teacher_ID  =  T2.Teacher_ID GROUP BY T2.Name HAVING COUNT(*)  >=  2	course_teach
select teacher.Name from teacher join course_arrange on teacher.Teacher_ID = course_arrange.Teacher_ID group by teacher.Name having count(*) >= 2	course_teach
select Name from teacher where Teacher_ID not in (select Teacher_ID from course_arrange)	course_teach
select teacher.Name from teacher left join course_arrange on teacher.Teacher_ID = course_arrange.Teacher_ID where course_arrange.Course_ID is null	course_teach
