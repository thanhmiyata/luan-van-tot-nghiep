select count(*) from teacher	course_teach
select count(*) from teacher	course_teach
select Name from teacher order by Age asc	course_teach
select Name from teacher order by Age asc	course_teach
select Age, Hometown from teacher	course_teach
select Age, Hometown from teacher	course_teach
select Name from teacher where Hometown != "Little Lever Urban District"	course_teach
select Name from teacher where Hometown != "Little Lever Urban District"	course_teach
select Name from teacher where Age = "32" or Age = "33"	course_teach
select Name from teacher where Age = "32" or Age = "33"	course_teach
select Hometown from teacher order by Age limit 1	course_teach
select Hometown from teacher order by Age limit 1	course_teach
select Hometown, count(*) from teacher group by Hometown	course_teach
select count(*) , Hometown from teacher group by Hometown	course_teach
select Hometown from teacher group by Hometown order by count(Hometown) desc limit 1	course_teach
select Hometown from teacher group by Hometown order by count(*) desc limit 1	course_teach
select Hometown from teacher group by Hometown having count(*) >= 2	course_teach
select Hometown from teacher group by Hometown having count(*) >= 2	course_teach
select T1.Name, T3.Course from teacher as T1 join course_arrange as T2 on T1.Teacher_ID = T2.Teacher_ID join course as T3 on T2.Course_ID = T3.Course_ID	course_teach
select T1.Name, T3.Course from teacher as T1 join course_arrange as T2 on T1.Teacher_ID = T2.Teacher_ID join course as T3 on T2.Course_ID = T3.Course_ID	course_teach
select T1.Name, T3.Course from teacher as T1 join course_arrange as T2 on T1.Teacher_ID = T2.Teacher_ID join course as T3 on T2.Course_ID = T3.Course_ID order by T1.Name asc	course_teach
select T2.Name, T3.Course from course_arrange as T1 join teacher as T2 on T1.Teacher_ID = T2.Teacher_ID join course as T3 on T1.Course_ID = T3.Course_ID order by T2.Name asc	course_teach
select T2.Name from course as T1 join course_arrange as T3 on T1.Course_ID = T3.Course_ID join teacher as T2 on T3.Teacher_ID = T2.Teacher_ID where T1.Course = "math"	course_teach
select T2.Name from course as T1 join course_arrange as T3 on T1.Course_ID = T3.Course_ID join teacher as T2 on T3.Teacher_ID = T2.Teacher_ID where T1.Course = "math"	course_teach
select T2.Name, count(T1.Course_ID) from course_arrange as T1 join teacher as T2 on T1.Teacher_ID = T2.Teacher_ID group by T2.Name	course_teach
select T2.Name, count(T1.Course_ID) from course_arrange as T1 join teacher as T2 on T1.Teacher_ID = T2.Teacher_ID group by T2.Name	course_teach
select T2.Name from course_arrange as T1 join teacher as T2 on T1.Teacher_ID = T2.Teacher_ID group by T1.Teacher_ID having count(T1.Course_ID) >= 2	course_teach
select T2.Name from course_arrange as T1 join teacher as T2 on T1.Teacher_ID = T2.Teacher_ID group by T1.Teacher_ID having count(T1.Course_ID) >= 2	course_teach
select Name from teacher where Teacher_ID not in (select Teacher_ID from course_arrange)	course_teach
select Name from teacher where Teacher_ID not in ( select Teacher_ID from course_arrange )	course_teach
