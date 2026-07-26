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
select C.course_name, C.course_id from Courses as C left join Sections as S on C.course_id = S.course_id group by C.course_id, C.course_name having count(*) < 2	student_transcripts_tracking
select section_name from Sections order by section_name desc	student_transcripts_tracking
select section_name from Sections order by section_name desc	student_transcripts_tracking
SELECT T1.semester_name ,  T1.semester_id FROM Semesters AS T1 JOIN Student_Enrolment AS T2 ON T1.semester_id  =  T2.semester_id GROUP BY T1.semester_id ORDER BY count(*) DESC LIMIT 1	student_transcripts_tracking
SELECT T1.semester_name ,  T1.semester_id FROM Semesters AS T1 JOIN Student_Enrolment AS T2 ON T1.semester_id  =  T2.semester_id GROUP BY T1.semester_id ORDER BY count(*) DESC LIMIT 1	student_transcripts_tracking
select department_description from Departments where department_name like "%the computer%"	student_transcripts_tracking
select department_description from Departments where department_name like "%computer%"	student_transcripts_tracking
select T1.first_name, T1.middle_name, T1.last_name, T1.student_id from Students as T1 where T1.student_id in (select student_id from Student_Enrolment group by student_id, semester_id having count(distinct degree_program_id) = 2)	student_transcripts_tracking
select T1.first_name, T1.middle_name, T1.last_name, T1.student_id from Students as T1 join Student_Enrolment as T2 on T1.student_id = T2.student_id group by T1.student_id, T1.first_name, T1.middle_name, T1.last_name, T2.semester_id having count(distinct T2.degree_program_id) = 2	student_transcripts_tracking
select Students.first_name, Students.middle_name, Students.last_name from Students join Student_Enrolment on Students.student_id = Student_Enrolment.student_id join Degree_Programs on Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id where Degree_Programs.degree_summary_name = "Bachelor"	student_transcripts_tracking
select Students.first_name, Students.middle_name, Students.last_name from Students join Student_Enrolment on Students.student_id = Student_Enrolment.student_id join Degree_Programs on Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id where Degree_Programs.degree_summary_name = "Bachelor"	student_transcripts_tracking
SELECT T1.degree_summary_name FROM Degree_Programs AS T1 JOIN Student_Enrolment AS T2 ON T1.degree_program_id  =  T2.degree_program_id GROUP BY T1.degree_summary_name ORDER BY count(*) DESC LIMIT 1	student_transcripts_tracking
SELECT T1.degree_summary_name FROM Degree_Programs AS T1 JOIN Student_Enrolment AS T2 ON T1.degree_program_id  =  T2.degree_program_id GROUP BY T1.degree_summary_name ORDER BY count(*) DESC LIMIT 1	student_transcripts_tracking
select Degree_Programs.degree_program_id, Degree_Programs.degree_summary_description from Degree_Programs join Student_Enrolment on Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id group by Degree_Programs.degree_program_id order by count(*) desc limit 1	student_transcripts_tracking
select Degree_Programs.degree_program_id, Degree_Programs.degree_summary_description from Degree_Programs join Student_Enrolment on Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id group by Degree_Programs.degree_program_id, Degree_Programs.degree_summary_description order by count(*) desc limit 1	student_transcripts_tracking
select Students.student_id, Students.first_name, Students.middle_name, Students.last_name, count(Student_Enrolment.student_id), Students.student_id from Students join Student_Enrolment on Students.student_id = Student_Enrolment.student_id group by Students.student_id, Students.first_name, Students.middle_name, Students.last_name order by number_of_enrollments desc limit 1	student_transcripts_tracking
select T1.first_name, T1.middle_name, T1.last_name, T1.student_id, count(T2.student_id) from Students as T1 join Student_Enrolment as T2 on T1.student_id = T2.student_id group by T1.student_id order by number_of_enrollments desc limit 1	student_transcripts_tracking
select semester_name from Semesters where semester_id not in (select semester_id from Student_Enrolment)	student_transcripts_tracking
select semester_name from Semesters left join Student_Enrolment on Semesters.semester_id = Student_Enrolment.semester_id where Student_Enrolment.semester_id is null	student_transcripts_tracking
select distinct Courses.course_name from Courses join Student_Enrolment_Courses on Courses.course_id = Student_Enrolment_Courses.course_id where EXISTS (select 1 from Student_Enrolment where Student_Enrolment.student_enrolment_id = Student_Enrolment_Courses.student_enrolment_id)	student_transcripts_tracking
select distinct T1.course_name from Courses as T1 join Student_Enrolment_Courses as T2 on T1.course_id = T2.course_id	student_transcripts_tracking
select T1.course_name from Courses as T1 join Student_Enrolment_Courses as T2 on T1.course_id = T2.course_id group by T1.course_id, T1.course_name order by count(*) desc limit 1	student_transcripts_tracking
select T1.course_name from Courses as T1 join Student_Enrolment_Courses as T2 on T1.course_id = T2.course_id group by T1.course_id order by count(*) desc limit 1	student_transcripts_tracking
select T1.last_name from Students as T1 join Addresses as T2 on T1.current_address_id = T2.address_id left join Student_Enrolment as T3 on T1.student_id = T3.student_id where T2.state_province_county = "North Carolina" and T3.degree_program_id is null	student_transcripts_tracking
select T1.last_name from Students as T1 join Addresses as T2 on T1.current_address_id = T2.address_id left join Student_Enrolment as T3 on T1.student_id = T3.student_id where T2.state_province_county = "North Carolina" and T3.student_id is null	student_transcripts_tracking
SELECT T2.transcript_date ,  T1.transcript_id FROM Transcript_Contents AS T1 JOIN Transcripts AS T2 ON T1.transcript_id  =  T2.transcript_id GROUP BY T1.transcript_id HAVING count(*)  >=  2	student_transcripts_tracking
SELECT T2.transcript_date ,  T1.transcript_id FROM Transcript_Contents AS T1 JOIN Transcripts AS T2 ON T1.transcript_id  =  T2.transcript_id GROUP BY T1.transcript_id HAVING count(*)  >=  2	student_transcripts_tracking
select cell_mobile_number from Students where first_name = "Timmothy" and last_name = "Ward"	student_transcripts_tracking
select cell_mobile_number from Students where first_name = "Timmothy" and last_name = "Ward"	student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_first_registered asc limit 1	student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_first_registered asc limit 1	student_transcripts_tracking
SELECT first_name ,  middle_name ,  last_name FROM Students ORDER BY date_left ASC LIMIT 1	student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_left asc limit 1	student_transcripts_tracking
SELECT first_name FROM Students WHERE current_address_id != permanent_address_id	student_transcripts_tracking
SELECT first_name FROM Students WHERE current_address_id != permanent_address_id	student_transcripts_tracking
select A.address_id, A.line_1, A.line_2, A.line_3 from Addresses as A join (select current_address_id, count(*) from Students group by current_address_id) on A.address_id = S.current_address_id order by S.student_count desc limit 1	student_transcripts_tracking
SELECT T1.address_id ,  T1.line_1 ,  T1.line_2 FROM Addresses AS T1 JOIN Students AS T2 ON T1.address_id  =  T2.current_address_id GROUP BY T1.address_id ORDER BY count(*) DESC LIMIT 1	student_transcripts_tracking
select avg(transcript_date) from Transcripts	student_transcripts_tracking
select avg(transcript_date) from Transcripts	student_transcripts_tracking
select transcript_date, other_details from Transcripts order by transcript_date asc limit 1	student_transcripts_tracking
select transcript_date, other_details from Transcripts order by transcript_date asc limit 1	student_transcripts_tracking
select count(*) from Transcripts	student_transcripts_tracking
select count(*) from Transcripts	student_transcripts_tracking
select transcript_date from Transcripts order by transcript_date desc limit 1	student_transcripts_tracking
select transcript_date from Transcripts order by transcript_date desc limit 1	student_transcripts_tracking
select Student_Enrolment_Courses.student_course_id , count(*) from Student_Enrolment_Courses join Transcript_Contents on Student_Enrolment_Courses.student_course_id = Transcript_Contents.student_course_id group by Student_Enrolment_Courses.student_course_id order by max_count desc limit 1	student_transcripts_tracking
select count(*), T2.student_enrolment_id from Transcript_Contents as T1 join Student_Enrolment_Courses as T2 on T1.student_course_id = T2.student_course_id group by T2.student_enrolment_id order by course_count desc limit 1	student_transcripts_tracking
select T.transcript_date, T.transcript_id from Transcripts as T join Transcript_Contents as TC on T.transcript_id = TC.transcript_id group by T.transcript_id order by count(*) asc limit 1	student_transcripts_tracking
select 1	student_transcripts_tracking
select semester_name from Semesters where semester_id in (select semester_id from Student_Enrolment join Degree_Programs on Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id where Degree_Programs.degree_summary_name = "Master" intersect select semester_id from Student_Enrolment join Degree_Programs on Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id where Degree_Programs.degree_summary_name = "Bachelor")	student_transcripts_tracking
select T1.semester_id from Student_Enrolment as T1 inner join Degree_Programs as T2 on T1.degree_program_id = T2.degree_program_id where T2.degree_summary_name = "Master" intersect select T1.semester_id from Student_Enrolment as T1 inner join Degree_Programs as T2 on T1.degree_program_id = T2.degree_program_id where T2.degree_summary_name = "Bachelor"	student_transcripts_tracking
select count(distinct address_id) from Addresses where address_id in (select current_address_id from Students)	student_transcripts_tracking
select distinct Addresses.line_1, Addresses.line_2, Addresses.line_3, Addresses.city, Addresses.zip_postcode, Addresses.state_province_county, Addresses.country from Addresses join Students on Addresses.address_id = Students.current_address_id or Addresses.address_id = Students.permanent_address_id	student_transcripts_tracking
select student_id, current_address_id, permanent_address_id, first_name, middle_name, last_name, cell_mobile_number, email_address, ssn, date_first_registered, date_left, other_student_details from Students order by student_id desc	student_transcripts_tracking
select student_id, first_name, middle_name, last_name, cell_mobile_number, email_address, ssn, date_first_registered, date_left, other_student_details from Students order by last_name desc	student_transcripts_tracking
select section_id, course_id, section_name, section_description, other_details from Sections where section_name = "h"	student_transcripts_tracking
select section_description from Sections where section_name = "h"	student_transcripts_tracking
select Students.first_name from Students join Addresses on Students.permanent_address_id = Addresses.address_id where Addresses.country = "Haiti" or Students.cell_mobile_number = "09700166582"	student_transcripts_tracking
select t1.first_name from students as t1 join addresses as t2 on t1.permanent_address_id  =  t2.address_id where t2.country  =  'haiti' or t1.cell_mobile_number  =  '09700166582'	student_transcripts_tracking
