select line_1, line_2 from Addresses	student_transcripts_tracking
select line_1, line_2 from Addresses	student_transcripts_tracking
select count(*) from Courses	student_transcripts_tracking
select count(course_id) from Courses	student_transcripts_tracking
select course_description from Courses where course_name = "math"	student_transcripts_tracking
select course_description from Courses where course_name like "%math%"	student_transcripts_tracking
select zip_postcode from Addresses where city = "Port Chelsea"	student_transcripts_tracking
select zip_postcode from Addresses where city = "Port Chelsea"	student_transcripts_tracking
select T1.department_name, T1.department_id from Departments as T1 join Degree_Programs as T2 on T1.department_id = T2.department_id group by T1.department_id order by count(*) desc limit 1	student_transcripts_tracking
select d.department_name, d.department_id from Departments d join Degree_Programs dp on d.department_id = dp.department_id group by d.department_id order by count(*) desc limit 1	student_transcripts_tracking
select count(distinct Departments.department_id) from Departments join Degree_Programs on Departments.department_id = Degree_Programs.department_id	student_transcripts_tracking
select count(distinct department_id) from Degree_Programs	student_transcripts_tracking
select count(distinct degree_summary_name) from Degree_Programs	student_transcripts_tracking
select count(distinct degree_summary_name) from Degree_Programs	student_transcripts_tracking
select count(*) from Degree_Programs join Departments on Degree_Programs.department_id = Departments.department_id where Departments.department_name = "engineering"	student_transcripts_tracking
select count(*) from Degree_Programs join Departments on Degree_Programs.department_id = Departments.department_id where Departments.department_name = "engineering"	student_transcripts_tracking
select section_name, section_description from Sections	student_transcripts_tracking
select section_name, section_description from Sections	student_transcripts_tracking
select course_name, course_id from Courses where course_id in (select course_id from Sections group by course_id having count(*) <= 2)	student_transcripts_tracking
select course_name, course_id from Courses where course_id not in (select course_id from Sections group by course_id having count(section_id) >= 2)	student_transcripts_tracking
select section_name from Sections order by section_name desc	student_transcripts_tracking
select section_name from Sections order by section_name desc	student_transcripts_tracking
select Semesters.semester_name, Semesters.semester_id from Student_Enrolment join Semesters on Student_Enrolment.semester_id = Semesters.semester_id group by Semesters.semester_name, Semesters.semester_id order by count(*) desc limit 1	student_transcripts_tracking
select s.semester_name, s.semester_id from Semesters s join Student_Enrolment se on s.semester_id = se.semester_id group by s.semester_id, s.semester_name order by count(se.student_id) desc limit 1	student_transcripts_tracking
select department_description from Departments where department_name like "%the computer%"	student_transcripts_tracking
select department_description from Departments where department_name like "%computer%"	student_transcripts_tracking
select distinct T1.first_name, T1.middle_name, T1.last_name, T1.student_id from Students as T1 join Student_Enrolment as T2 on T1.student_id = T2.student_id group by T1.student_id, T1.first_name, T1.middle_name, T1.last_name, T2.semester_id having count(distinct T2.degree_program_id) = 2	student_transcripts_tracking
select T1.first_name, T1.middle_name, T1.last_name, T1.student_id from Students as T1 join (select distinct student_id from Student_Enrolment group by student_id, semester_id having count(distinct degree_program_id) = 2) on T1.student_id = T2.student_id	student_transcripts_tracking
select Students.first_name, Students.middle_name, Students.last_name from Students join Student_Enrolment on Students.student_id = Student_Enrolment.student_id join Degree_Programs on Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id where Degree_Programs.degree_summary_name = "Bachelor"	student_transcripts_tracking
select T1.first_name, T1.middle_name, T1.last_name from Students as T1 join Student_Enrolment as T2 on T1.student_id = T2.student_id join Degree_Programs as T3 on T2.degree_program_id = T3.degree_program_id where T3.degree_summary_name = "Bachelor"	student_transcripts_tracking
select degree_summary_name from Degree_Programs join Student_Enrolment on Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id group by degree_summary_name order by count(*) desc limit 1	student_transcripts_tracking
select degree_summary_name from Degree_Programs join Student_Enrolment on Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id group by degree_summary_name order by count(*) desc limit 1	student_transcripts_tracking
select Degree_Programs.degree_program_id, Degree_Programs.degree_summary_description from Degree_Programs join Student_Enrolment on Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id group by Degree_Programs.degree_program_id, Degree_Programs.degree_summary_description order by count(*) desc limit 1	student_transcripts_tracking
select Degree_Programs.degree_program_id, Degree_Programs.degree_summary_name from Degree_Programs join Student_Enrolment on Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id group by Degree_Programs.degree_program_id, Degree_Programs.degree_summary_name order by count(*) desc limit 1	student_transcripts_tracking
select s.student_id, s.first_name, s.middle_name, s.last_name, count(se.student_id), s.student_id from Students s join Student_Enrolment se on s.student_id = se.student_id group by s.student_id, s.first_name, s.middle_name, s.last_name order by number_of_enrollments desc limit 1	student_transcripts_tracking
select S.first_name, S.middle_name, S.last_name, S.student_id, count(SE.student_enrolment_id) from Students as S join Student_Enrolment as SE on S.student_id = SE.student_id group by S.student_id, S.first_name, S.middle_name, S.last_name order by count(SE.student_enrolment_id) desc limit 1	student_transcripts_tracking
select semester_name from Semesters where semester_id not in (select semester_id from Student_Enrolment)	student_transcripts_tracking
select semester_name from Semesters where semester_id not in (select semester_id from Student_Enrolment)	student_transcripts_tracking
select course_name from Courses where course_id in (select course_id from Student_Enrolment_Courses)	student_transcripts_tracking
select course_name from Courses where course_id in (select distinct course_id from Student_Enrolment_Courses)	student_transcripts_tracking
select T1.course_name from Courses as T1 join Student_Enrolment_Courses as T2 on T1.course_id = T2.course_id group by T1.course_name order by count(T2.student_course_id) desc limit 1	student_transcripts_tracking
select T1.course_name from Courses as T1 join Student_Enrolment_Courses as T2 on T1.course_id = T2.course_id group by T1.course_name order by count(*) desc limit 1	student_transcripts_tracking
select Students.last_name from Students where Students.current_address_id in (select address_id from Addresses where state_province_county = "North Carolina") and Students.student_id not in (select student_id from Student_Enrolment)	student_transcripts_tracking
select S.last_name from Students S join Addresses A on S.current_address_id = A.address_id where A.state_province_county = "North Carolina" and S.student_id not in (select student_id from Student_Enrolment)	student_transcripts_tracking
select T1.transcript_date, T1.transcript_id from Transcripts as T1 join Transcript_Contents as T2 on T1.transcript_id = T2.transcript_id group by T1.transcript_id, T1.transcript_date having count(*) >= 2	student_transcripts_tracking
select T.transcript_date, T.transcript_id from Transcripts as T join Transcript_Contents as TC on T.transcript_id = TC.transcript_id group by T.transcript_id, T.transcript_date having count(*) >= 2	student_transcripts_tracking
select cell_mobile_number from Students where first_name = "Timmothy" and last_name = "Ward"	student_transcripts_tracking
select cell_mobile_number from Students where first_name = "Timmothy" and last_name = "Ward"	student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_first_registered asc limit 1	student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_first_registered asc limit 1	student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_first_registered asc limit 1	student_transcripts_tracking
select T1.first_name, T1.middle_name, T1.last_name from Students as T1 join Student_Enrolment as T2 on T1.student_id = T2.student_id join Student_Enrolment_Courses as T3 on T2.student_enrolment_id = T3.student_enrolment_id join Transcript_Contents as T4 on T3.student_course_id = T4.student_course_id join Transcripts as T5 on T4.transcript_id = T5.transcript_id order by T5.transcript_date asc limit 1	student_transcripts_tracking
select first_name from Students where current_address_id <> permanent_address_id	student_transcripts_tracking
select first_name from Students where current_address_id <> permanent_address_id	student_transcripts_tracking
select T1.address_id, T1.line_1, T1.line_2, T1.line_3 from Addresses as T1 join Students as T2 on T2.current_address_id = T1.address_id group by T1.address_id, T1.line_1, T1.line_2, T1.line_3 order by count(*) desc limit 1	student_transcripts_tracking
select T1.address_id, T1.line_1, T1.line_2 from Addresses as T1 join Students as T2 on T1.address_id = T2.current_address_id group by T1.address_id, T1.line_1, T1.line_2 order by count(T2.student_id) desc limit 1	student_transcripts_tracking
select avg(transcript_date) from Transcripts	student_transcripts_tracking
select avg(transcript_date) from Transcripts	student_transcripts_tracking
select transcript_date, other_details from Transcripts order by transcript_date asc limit 1	student_transcripts_tracking
select transcript_date, other_details from Transcripts where transcript_date = (select min(transcript_date) from Transcripts)	student_transcripts_tracking
select count(*) from Transcripts	student_transcripts_tracking
select count(*) from Transcripts	student_transcripts_tracking
select max(transcript_date) from Transcripts	student_transcripts_tracking
select max(transcript_date) from Transcripts	student_transcripts_tracking
select count(t2.transcript_id), t1.student_course_id from Student_Enrolment_Courses as t1 join Transcript_Contents as t2 on t1.student_course_id = t2.student_course_id group by t1.student_course_id order by max_count desc limit 1	student_transcripts_tracking
select count(*), T1.student_enrolment_id from Student_Enrolment_Courses as T1 join Transcript_Contents as T2 on T1.student_course_id = T2.student_course_id group by T1.course_id, T1.student_enrolment_id order by count(*) desc limit 1	student_transcripts_tracking
select T.transcript_date, T.transcript_id from Transcripts as T join Transcript_Contents as TC on T.transcript_id = TC.transcript_id group by T.transcript_id order by count(TC.transcript_id) asc limit 1	student_transcripts_tracking
select T.transcript_date, T.transcript_id from Transcripts as T join Transcript_Contents as TC on T.transcript_id = TC.transcript_id group by T.transcript_date, T.transcript_id order by count(*) asc limit 1	student_transcripts_tracking
select T1.semester_name from Semesters as T1 join Student_Enrolment as T2 on T1.semester_id = T2.semester_id join Degree_Programs as T3 on T2.degree_program_id = T3.degree_program_id where T3.degree_summary_name = "Master" intersect select T1.semester_name from Semesters as T1 join Student_Enrolment as T2 on T1.semester_id = T2.semester_id join Degree_Programs as T3 on T2.degree_program_id = T3.degree_program_id where T3.degree_summary_name = "Bachelor"	student_transcripts_tracking
select semester_id from Student_Enrolment join Degree_Programs on Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id where degree_summary_name = "Master" intersect select semester_id from Student_Enrolment join Degree_Programs on Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id where degree_summary_name = "Bachelor"	student_transcripts_tracking
select count(distinct T1.address_id) from Addresses as T1 join Students as T2 on T1.address_id = T2.current_address_id	student_transcripts_tracking
select distinct A.line_1, A.line_2, A.line_3, A.city, A.zip_postcode, A.state_province_county, A.country, A.other_address_details from Addresses as A join Students as S on A.address_id = S.current_address_id or A.address_id = S.permanent_address_id	student_transcripts_tracking
select student_id, current_address_id, permanent_address_id, first_name, middle_name, last_name, cell_mobile_number, email_address, ssn, date_first_registered, date_left, other_student_details from Students order by first_name desc	student_transcripts_tracking
select student_id, current_address_id, permanent_address_id, first_name, middle_name, last_name, cell_mobile_number, email_address, ssn, date_first_registered, date_left, other_student_details from Students order by last_name desc	student_transcripts_tracking
select section_name, section_description, other_details from Sections where section_name = "h"	student_transcripts_tracking
select section_description from Sections where section_name = "h"	student_transcripts_tracking
select T1.first_name from Students as T1 join Addresses as T2 on T1.permanent_address_id = T2.address_id where T2.country = "Haiti" or T1.cell_mobile_number = "09700166582"	student_transcripts_tracking
select first_name from Students where permanent_address_id in (select address_id from Addresses where country = "Haiti") or cell_mobile_number = "09700166582"	student_transcripts_tracking
