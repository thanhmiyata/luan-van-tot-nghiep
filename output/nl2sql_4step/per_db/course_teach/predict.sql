select count(Teacher_ID) from teacher	course_teach
select count(Teacher_ID) from teacher	course_teach
select Name from teacher order by Age asc	course_teach
select Name from teacher order by Age asc	course_teach
select Age, Hometown from teacher	course_teach
select Age, Hometown from teacher	course_teach
select Name from teacher where Hometown <> "Little Lever Urban District"	course_teach
select Name from teacher where Hometown <> "Little Lever Urban District"	course_teach
select Name from teacher where Age in (32, 33)	course_teach
select Name from teacher where Age = "32" or Age = "33"	course_teach
select Hometown from teacher order by Age asc limit 1	course_teach
select Hometown from teacher order by Age asc limit 1	course_teach
select Hometown, count(*) from teacher group by Hometown	course_teach
select Hometown, count(Teacher_ID) from teacher group by Hometown	course_teach
select Hometown from teacher group by Hometown order by count(*) desc limit 1	course_teach
select Hometown from teacher group by Hometown order by count(*) desc	course_teach
select Hometown from teacher group by Hometown having count(*) >= 2	course_teach
select Hometown from teacher group by Hometown having count(*) >= 2	course_teach
select teacher.Name, course.Course from teacher join course_arrange on teacher.Teacher_ID = course_arrange.Teacher_ID join course on course_arrange.Course_ID = course.Course_ID	course_teach
select T1.Name, T3.Course from teacher as T1 join course_arrange as T2 on T1.Teacher_ID = T2.Teacher_ID join course as T3 on T2.Course_ID = T3.Course_ID	course_teach
select t.Name, c.Course from teacher as t join course_arrange as ca on t.Teacher_ID = ca.Teacher_ID join course as c on ca.Course_ID = c.Course_ID order by t.Name asc	course_teach
select T1.Name, T3.Course from teacher as T1 join course_arrange as T2 on T1.Teacher_ID = T2.Teacher_ID join course as T3 on T2.Course_ID = T3.Course_ID order by T1.Name asc	course_teach
select T2.Name from course as T1 join course_arrange as T3 on T1.Course_ID = T3.Course_ID join teacher as T2 on T3.Teacher_ID = T2.Teacher_ID where T1.Course = "Math"	course_teach
select teacher.Name from course join course_arrange on course.Course_ID = course_arrange.Course_ID join teacher on course_arrange.Teacher_ID = teacher.Teacher_ID where course.Course = "Math"	course_teach
select teacher.Name, count(course_arrange.Course_ID) from teacher join course_arrange on teacher.Teacher_ID = course_arrange.Teacher_ID group by teacher.Name	course_teach
select T1.Name, count(T2.Course_ID) from teacher as T1 join course_arrange as T2 on T1.Teacher_ID = T2.Teacher_ID group by T1.Name	course_teach
select teacher.Name from teacher join course_arrange on teacher.Teacher_ID = course_arrange.Teacher_ID group by teacher.Teacher_ID, teacher.Name having count(course_arrange.Course_ID) >= 2	course_teach
select teacher.Name from teacher join course_arrange on teacher.Teacher_ID = course_arrange.Teacher_ID group by teacher.Teacher_ID having count(course_arrange.Course_ID) >= 2	course_teach
select Name from teacher where Teacher_ID not in (select Teacher_ID from course_arrange)	course_teach
select teacher.Name from teacher left join course_arrange on teacher.Teacher_ID = course_arrange.Teacher_ID where course_arrange.Course_ID is null	course_teach
