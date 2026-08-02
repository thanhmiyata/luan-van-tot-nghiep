select line_1, line_2 from Addresses	student_transcripts_tracking
select line_1, line_2 from Addresses	student_transcripts_tracking
select count(*) from Courses	student_transcripts_tracking
select count(*) from Courses	student_transcripts_tracking
select course_description from Courses where course_name = "math"	student_transcripts_tracking
SELECT course_description FROM Courses WHERE course_name  =  'math'	student_transcripts_tracking
select zip_postcode from Addresses where city = "Port Chelsea"	student_transcripts_tracking
select zip_postcode from Addresses where city = "Port Chelsea"	student_transcripts_tracking
SELECT T2.department_name ,  T1.department_id FROM Degree_Programs AS T1 JOIN Departments AS T2 ON T1.department_id  =  T2.department_id GROUP BY T1.department_id ORDER BY count(*) DESC LIMIT 1	student_transcripts_tracking
select t2.department_name ,  t1.department_id from degree_programs as t1 join departments as t2 on t1.department_id  =  t2.department_id group by t1.department_id order by count(*) desc limit 1	student_transcripts_tracking
select count(distinct department_id) from Degree_Programs	student_transcripts_tracking
select count(distinct T1.department_id) from Departments as T1 join Degree_Programs as T2 on T1.department_id = T2.department_id	student_transcripts_tracking
select count(distinct degree_summary_name) from Degree_Programs	student_transcripts_tracking
select count(distinct degree_summary_name) from Degree_Programs	student_transcripts_tracking
select count(*) as "Number of Degrees" from Degree_Programs join Departments on Degree_Programs.department_id = Departments.department_id where Departments.department_name = "engineering"	student_transcripts_tracking
select count(*) from Degree_Programs join Departments on Degree_Programs.department_id = Departments.department_id where Departments.department_name = "engineering"	student_transcripts_tracking
select section_name, section_description from Sections	student_transcripts_tracking
select section_name, section_description from Sections	student_transcripts_tracking
SELECT T1.course_name ,  T1.course_id FROM Courses AS T1 JOIN Sections AS T2 ON T1.course_id  =  T2.course_id GROUP BY T1.course_id HAVING count(*)  <=  2	student_transcripts_tracking
SELECT course_name, course_id FROM Courses WHERE NOT course_id IN (SELECT course_id FROM Sections GROUP BY course_id HAVING COUNT(section_id) >= 2)	student_transcripts_tracking
select section_name from Sections order by section_name desc	student_transcripts_tracking
select section_name from Sections order by section_name desc	student_transcripts_tracking
SELECT T1.semester_name ,  T1.semester_id FROM Semesters AS T1 JOIN Student_Enrolment AS T2 ON T1.semester_id  =  T2.semester_id GROUP BY T1.semester_id ORDER BY count(*) DESC LIMIT 1	student_transcripts_tracking
SELECT T1.semester_name ,  T1.semester_id FROM Semesters AS T1 JOIN Student_Enrolment AS T2 ON T1.semester_id  =  T2.semester_id GROUP BY T1.semester_id ORDER BY count(*) DESC LIMIT 1	student_transcripts_tracking
SELECT department_description FROM Departments WHERE department_name LIKE '%the computer%'	student_transcripts_tracking
select department_description from Departments where department_name like "%computer%"	student_transcripts_tracking
SELECT s.first_name, s.middle_name, s.last_name, s.student_id FROM Students AS s JOIN Student_Enrolment AS se ON s.student_id = se.student_id GROUP BY s.first_name, s.middle_name, s.last_name, s.student_id HAVING COUNT(DISTINCT se.degree_program_id) = 2	student_transcripts_tracking
SELECT Students.first_name, Students.middle_name, Students.last_name, Students.student_id FROM Students JOIN Student_Enrolment ON Students.student_id = Student_Enrolment.student_id JOIN (SELECT student_id, semester_id FROM Student_Enrolment GROUP BY student_id, semester_id HAVING COUNT(DISTINCT degree_program_id) = 2) AS EnrolledTwice ON Students.student_id = EnrolledTwice.student_id AND Student_Enrolment.semester_id = EnrolledTwice.semester_id	student_transcripts_tracking
select Students.first_name, Students.middle_name, Students.last_name from Students join Student_Enrolment on Students.student_id = Student_Enrolment.student_id join Degree_Programs on Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id where Degree_Programs.degree_summary_name = "Bachelor"	student_transcripts_tracking
select Students.first_name, Students.middle_name, Students.last_name from Students join Student_Enrolment on Students.student_id = Student_Enrolment.student_id join Degree_Programs on Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id where Degree_Programs.degree_summary_name = "Bachelor"	student_transcripts_tracking
SELECT T1.degree_summary_name FROM Degree_Programs AS T1 JOIN Student_Enrolment AS T2 ON T1.degree_program_id  =  T2.degree_program_id GROUP BY T1.degree_summary_name ORDER BY count(*) DESC LIMIT 1	student_transcripts_tracking
SELECT T1.degree_summary_name FROM Degree_Programs AS T1 JOIN Student_Enrolment AS T2 ON T1.degree_program_id  =  T2.degree_program_id GROUP BY T1.degree_summary_name ORDER BY count(*) DESC LIMIT 1	student_transcripts_tracking
SELECT Degree_Programs.degree_program_id, Degree_Programs.degree_summary_description FROM Degree_Programs JOIN Student_Enrolment ON Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id GROUP BY Degree_Programs.degree_program_id, Degree_Programs.degree_summary_description ORDER BY COUNT(Student_Enrolment.student_id) DESC LIMIT 1	student_transcripts_tracking
SELECT Degree_Programs.degree_program_id, Degree_Programs.degree_summary_name FROM Degree_Programs JOIN Student_Enrolment ON Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id GROUP BY Degree_Programs.degree_program_id, Degree_Programs.degree_summary_name ORDER BY COUNT(*) DESC LIMIT 1	student_transcripts_tracking
SELECT s.student_id, s.first_name, s.middle_name, s.last_name, COUNT(*) AS number_of_enrollments, s.student_id AS student_id_duplicate FROM Students AS s JOIN Student_Enrolment AS se ON s.student_id = se.student_id GROUP BY s.student_id, s.first_name, s.middle_name, s.last_name ORDER BY number_of_enrollments DESC LIMIT 1	student_transcripts_tracking
SELECT S.first_name, S.middle_name, S.last_name, S.student_id, COUNT(*) AS number_of_enrollments FROM Students AS S JOIN Student_Enrolment AS SE ON S.student_id = SE.student_id GROUP BY S.student_id, S.first_name, S.middle_name, S.last_name ORDER BY number_of_enrollments DESC LIMIT 1	student_transcripts_tracking
select semester_name from Semesters where semester_id not in (select semester_id from Student_Enrolment)	student_transcripts_tracking
select semester_name from Semesters left join Student_Enrolment on Semesters.semester_id = Student_Enrolment.semester_id where Student_Enrolment.semester_id is null	student_transcripts_tracking
select distinct Courses.course_name from Courses join Student_Enrolment_Courses on Courses.course_id = Student_Enrolment_Courses.course_id where EXISTS (select 1 from Student_Enrolment where Student_Enrolment.student_enrolment_id = Student_Enrolment_Courses.student_enrolment_id)	student_transcripts_tracking
select distinct T1.course_name from Courses as T1 join Student_Enrolment_Courses as T2 on T1.course_id = T2.course_id	student_transcripts_tracking
SELECT Courses.course_name FROM Courses JOIN Student_Enrolment_Courses ON Courses.course_id = Student_Enrolment_Courses.course_id GROUP BY Student_Enrolment_Courses.course_id ORDER BY COUNT(*) DESC LIMIT 1	student_transcripts_tracking
SELECT course_name FROM Courses JOIN Student_Enrolment_Courses ON Courses.course_id = Student_Enrolment_Courses.course_id GROUP BY course_name ORDER BY COUNT(*) DESC LIMIT 1	student_transcripts_tracking
SELECT Students.last_name FROM Students WHERE Students.current_address_id IN (SELECT address_id FROM Addresses WHERE state_province_county = 'North Carolina') AND NOT Students.student_id IN (SELECT student_id FROM Student_Enrolment)	student_transcripts_tracking
SELECT S.last_name FROM Students AS S JOIN Addresses AS A ON S.current_address_id = A.address_id WHERE A.state_province_county = 'NorthCarolina' AND NOT S.student_id IN (SELECT student_id FROM Student_Enrolment)	student_transcripts_tracking
SELECT T2.transcript_date ,  T1.transcript_id FROM Transcript_Contents AS T1 JOIN Transcripts AS T2 ON T1.transcript_id  =  T2.transcript_id GROUP BY T1.transcript_id HAVING count(*)  >=  2	student_transcripts_tracking
SELECT T2.transcript_date ,  T1.transcript_id FROM Transcript_Contents AS T1 JOIN Transcripts AS T2 ON T1.transcript_id  =  T2.transcript_id GROUP BY T1.transcript_id HAVING count(*)  >=  2	student_transcripts_tracking
select cell_mobile_number from Students where first_name = "Timmothy" and last_name = "Ward"	student_transcripts_tracking
SELECT cell_mobile_number FROM Students WHERE first_name = 'Timmothy' AND last_name = 'Ward'	student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_first_registered asc limit 1	student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_first_registered asc limit 1	student_transcripts_tracking
SELECT first_name ,  middle_name ,  last_name FROM Students ORDER BY date_left ASC LIMIT 1	student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_left asc limit 1	student_transcripts_tracking
SELECT first_name FROM Students WHERE current_address_id != permanent_address_id	student_transcripts_tracking
SELECT first_name FROM Students WHERE current_address_id != permanent_address_id	student_transcripts_tracking
SELECT Addresses.address_id, Addresses.line_1, Addresses.line_2, Addresses.line_3 FROM Addresses JOIN Students ON Students.current_address_id = Addresses.address_id GROUP BY Addresses.address_id, Addresses.line_1, Addresses.line_2, Addresses.line_3 ORDER BY COUNT(*) DESC LIMIT 1	student_transcripts_tracking
SELECT T1.address_id ,  T1.line_1 ,  T1.line_2 FROM Addresses AS T1 JOIN Students AS T2 ON T1.address_id  =  T2.current_address_id GROUP BY T1.address_id ORDER BY count(*) DESC LIMIT 1	student_transcripts_tracking
select avg(transcript_date) from Transcripts	student_transcripts_tracking
select avg(transcript_date) from Transcripts	student_transcripts_tracking
select transcript_date, other_details from Transcripts order by transcript_date asc limit 1	student_transcripts_tracking
select transcript_date, other_details from Transcripts order by transcript_date asc limit 1	student_transcripts_tracking
select count(*) from Transcripts	student_transcripts_tracking
select count(*) from Transcripts	student_transcripts_tracking
select transcript_date from Transcripts order by transcript_date desc limit 1	student_transcripts_tracking
select transcript_date from Transcripts order by transcript_date desc limit 1	student_transcripts_tracking
SELECT COUNT(t2.transcript_id) AS max_count, t2.student_course_id FROM Student_Enrolment_Courses AS t1 JOIN Transcript_Contents AS t2 ON t1.student_course_id = t2.student_course_id GROUP BY t2.student_course_id ORDER BY max_count DESC LIMIT 1	student_transcripts_tracking
SELECT COUNT(*), student_enrolment_id FROM Student_Enrolment_Courses GROUP BY student_enrolment_id ORDER BY COUNT(*) DESC LIMIT 1	student_transcripts_tracking
select T.transcript_date, T.transcript_id from Transcripts as T join Transcript_Contents as TC on T.transcript_id = TC.transcript_id group by T.transcript_id order by count(*) asc limit 1	student_transcripts_tracking
SELECT T.transcript_date, T.transcript_id FROM Transcripts AS T JOIN Transcript_Contents AS TC ON T.transcript_id = TC.transcript_id GROUP BY T.transcript_id ORDER BY COUNT(TC.student_course_id) ASC LIMIT 1	student_transcripts_tracking
SELECT semester_name FROM Semesters WHERE semester_id IN (SELECT semester_id FROM Student_Enrolment WHERE degree_program_id IN (SELECT degree_program_id FROM Degree_Programs WHERE degree_summary_name = 'Master') INTERSECT SELECT semester_id FROM Student_Enrolment WHERE degree_program_id IN (SELECT degree_program_id FROM Degree_Programs WHERE degree_summary_name = 'Bachelor'))	student_transcripts_tracking
select T1.semester_id from Student_Enrolment as T1 inner join Degree_Programs as T2 on T1.degree_program_id = T2.degree_program_id where T2.degree_summary_name = "Master" intersect select T1.semester_id from Student_Enrolment as T1 inner join Degree_Programs as T2 on T1.degree_program_id = T2.degree_program_id where T2.degree_summary_name = "Bachelor"	student_transcripts_tracking
SELECT COUNT(DISTINCT address_id) AS count FROM Addresses JOIN Students ON Addresses.address_id = Students.current_address_id	student_transcripts_tracking
SELECT DISTINCT A.line_1, A.line_2, A.line_3, A.city, A.zip_postcode, A.state_province_county, A.country, A.other_address_details FROM Addresses AS A JOIN Students AS S ON A.address_id = S.current_address_id OR A.address_id = S.permanent_address_id	student_transcripts_tracking
SELECT student_id, current_address_id, permanent_address_id, first_name, middle_name, last_name, cell_mobile_number, email_address, ssn, date_first_registered, date_left, other_student_details FROM Students ORDER BY first_name DESC	student_transcripts_tracking
SELECT student_id, current_address_id, permanent_address_id, first_name, middle_name, last_name, cell_mobile_number, email_address, ssn, date_first_registered, date_left, other_student_details FROM Students ORDER BY last_name DESC	student_transcripts_tracking
SELECT section_name, section_description, other_details FROM Sections WHERE section_name = 'h'	student_transcripts_tracking
select section_description from Sections where section_name = "h"	student_transcripts_tracking
SELECT s.first_name FROM Students AS s INNER JOIN Addresses AS a ON s.permanent_address_id = a.address_id WHERE s.cell_mobile_number = '09700166582' OR a.country = 'Haiti'	student_transcripts_tracking
select t1.first_name from students as t1 join addresses as t2 on t1.permanent_address_id  =  t2.address_id where t2.country  =  'haiti' or t1.cell_mobile_number  =  '09700166582'	student_transcripts_tracking
