select line_1, line_2 from Addresses	student_transcripts_tracking
select line_1, line_2 from Addresses	student_transcripts_tracking
select count(course_id) from Courses	student_transcripts_tracking
select count(*) from Courses	student_transcripts_tracking
select course_description from Courses where course_name = "math"	student_transcripts_tracking
select course_description from Courses where course_name like "%Math%" or course_name like "%mathematics%"	student_transcripts_tracking
select zip_postcode from Addresses where city = "Port Chelsea"	student_transcripts_tracking
select zip_postcode from Addresses where city = "Port Chelsea"	student_transcripts_tracking
select T1.department_name, T1.department_id from Departments as T1 inner join Degree_Programs as T2 on T1.department_id = T2.department_id group by T1.department_id order by count(T2.degree_program_id) desc limit 1	student_transcripts_tracking
select T1.department_name, T1.department_id from Departments as T1 inner join Degree_Programs as T2 on T1.department_id = T2.department_id group by T1.department_id order by count(T2.degree_program_id) desc limit 1	student_transcripts_tracking
select count(distinct T1.department_id) from Departments as T1 inner join Degree_Programs as T2 on T1.department_id = T2.department_id	student_transcripts_tracking
select count(distinct department_id) from Degree_Programs	student_transcripts_tracking
select count(distinct degree_summary_name) from Degree_Programs	student_transcripts_tracking
select count(distinct degree_summary_name) from Degree_Programs	student_transcripts_tracking
select count(T1.degree_program_id) from Degree_Programs as T1 inner join Departments as T2 on T1.department_id = T2.department_id where T2.department_name = "Engineering"	student_transcripts_tracking
select count(T1.degree_program_id) from Degree_Programs as T1 inner join Departments as T2 on T1.department_id = T2.department_id where T2.department_name = "Engineering"	student_transcripts_tracking
select section_name, section_description from Sections	student_transcripts_tracking
select section_name, section_description from Sections	student_transcripts_tracking
select T1.course_name, T1.course_id from Courses as T1 join Sections as T2 on T1.course_id = T2.course_id group by T1.course_id having count(T2.section_id) <= 2	student_transcripts_tracking
select T1.course_name, T1.course_id from Courses as T1 join Sections as T2 on T1.course_id = T2.course_id group by T1.course_id having count(T2.section_id) < 2	student_transcripts_tracking
select section_name from Sections order by section_name desc	student_transcripts_tracking
select section_name from Sections order by section_name desc	student_transcripts_tracking
select T1.semester_name, T1.semester_id from Semesters as T1 join Student_Enrolment as T2 on T1.semester_id = T2.semester_id group by T1.semester_id order by count(T2.student_id) desc limit 1	student_transcripts_tracking
ite select T1.semester_name, T1.semester_id from Semesters as T1 inner join Student_Enrolment as T2 on T1.semester_id = T2.semester_id group by T1.semester_id order by count(T2.student_id) desc limit 1	student_transcripts_tracking
select department_description from Departments where department_name like "%the computer%"	student_transcripts_tracking
select department_description from Departments where department_name like "%computer%"	student_transcripts_tracking
select T1.first_name, T1.middle_name, T1.last_name, T1.student_id from Students as T1 inner join Student_Enrolment as T2 on T1.student_id = T2.student_id group by T1.student_id, T2.semester_id having count(distinct T2.degree_program_id) = 2	student_transcripts_tracking
select T1.first_name, T1.middle_name, T1.last_name, T1.student_id from Students as T1 inner join Student_Enrolment as T2 on T1.student_id = T2.student_id group by T1.student_id, T2.semester_id having count(distinct T2.degree_program_id) = 2	student_transcripts_tracking
select T1.first_name, T1.middle_name, T1.last_name from Students as T1 inner join Student_Enrolment as T2 on T1.student_id = T2.student_id inner join Degree_Programs as T3 on T2.degree_program_id = T3.degree_program_id where T3.degree_summary_name like "%Bachelor%"	student_transcripts_tracking
select T1.first_name, T1.middle_name, T1.last_name from Students as T1 inner join Student_Enrolment as T2 on T1.student_id = T2.student_id inner join Degree_Programs as T3 on T2.degree_program_id = T3.degree_program_id where T3.degree_summary_name like "%Bachelors%"	student_transcripts_tracking
select T2.degree_summary_name from Student_Enrolment as T1 inner join Degree_Programs as T2 on T1.degree_program_id = T2.degree_program_id group by T1.degree_program_id order by count(T1.student_id) desc limit 1	student_transcripts_tracking
ite select T2.degree_summary_name from Student_Enrolment as T1 inner join Degree_Programs as T2 on T1.degree_program_id = T2.degree_program_id group by T2.degree_summary_name order by count(T1.student_id) desc limit 1	student_transcripts_tracking
select T1.degree_program_id, T1.degree_summary_name from Degree_Programs as T1 join Student_Enrolment as T2 on T1.degree_program_id = T2.degree_program_id group by T1.degree_program_id order by count(T2.student_id) desc limit 1	student_transcripts_tracking
ite select T1.degree_program_id, T1.degree_summary_name from Degree_Programs as T1 inner join Student_Enrolment as T2 on T1.degree_program_id = T2.degree_program_id group by T1.degree_program_id, T1.degree_summary_name order by count(T2.student_id) desc limit 1	student_transcripts_tracking
ite select T1.student_id, T1.first_name, T1.middle_name, T1.last_name, count(T2.student_enrolment_id), T1.student_id from Students as T1 inner join Student_Enrolment as T2 on T1.student_id = T2.student_id group by T1.student_id, T1.first_name, T1.middle_name, T1.last_name order by num_enrollments desc limit 1	student_transcripts_tracking
select T1.first_name, T1.middle_name, T1.last_name, T1.student_id, count(T2.student_enrolment_id) from Students as T1 inner join Student_Enrolment as T2 on T1.student_id = T2.student_id group by T1.student_id order by num_enrollments desc limit 1	student_transcripts_tracking
select semester_name from Semesters where semester_id not in ( select semester_id from Student_Enrolment )	student_transcripts_tracking
select T1.semester_name from Semesters as T1 where T1.semester_id not in (select T2.semester_id from Student_Enrolment as T2)	student_transcripts_tracking
select distinct T1.course_name from Courses as T1 inner join Student_Enrolment_Courses as T2 on T1.course_id = T2.course_id	student_transcripts_tracking
select distinct T1.course_name from Courses as T1 inner join Student_Enrolment_Courses as T2 on T1.course_id = T2.course_id	student_transcripts_tracking
select T1.course_name from Courses as T1 join Student_Enrolment_Courses as T2 on T1.course_id = T2.course_id group by T1.course_id order by count(T2.course_id) desc limit 1	student_transcripts_tracking
select T1.course_name from Courses as T1 join Student_Enrolment_Courses as T2 on T1.course_id = T2.course_id group by T1.course_id order by count(T2.student_course_id) desc limit 1	student_transcripts_tracking
ite select T1.last_name from Students as T1 inner join Addresses as T2 on T1.current_address_id = T2.address_id where T2.state_province_county = "North Carolina" and T1.student_id not in ( select student_id from Student_Enrolment )	student_transcripts_tracking
select T1.last_name from Students as T1 inner join Addresses as T2 on T1.current_address_id = T2.address_id where T2.state_province_county = "North Carolina" and T1.student_id not in ( select student_id from Student_Enrolment )	student_transcripts_tracking
select T1.transcript_date, T1.transcript_id from Transcripts as T1 inner join Transcript_Contents as T2 on T1.transcript_id = T2.transcript_id group by T1.transcript_id having count(T2.student_course_id) >= 2	student_transcripts_tracking
select T1.transcript_date, T1.transcript_id from Transcripts as T1 join Transcript_Contents as T2 on T1.transcript_id = T2.transcript_id group by T1.transcript_id having count(T2.student_course_id) >= 2	student_transcripts_tracking
select cell_mobile_number from Students where first_name = "Timmothy" and last_name = "Ward"	student_transcripts_tracking
select cell_mobile_number from Students where first_name = "Timmothy" and last_name = "Ward"	student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_first_registered asc limit 1	student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_first_registered asc limit 1	student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_left asc limit 1	student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_left asc limit 1	student_transcripts_tracking
select first_name from Students where permanent_address_id != current_address_id	student_transcripts_tracking
select first_name from Students where permanent_address_id != current_address_id	student_transcripts_tracking
select T1.address_id, T1.line_1, T1.line_2, T1.line_3 from Addresses as T1 inner join Students as T2 on T1.address_id = T2.current_address_id group by T1.address_id order by count(T2.student_id) desc limit 1	student_transcripts_tracking
select T1.address_id, T1.line_1, T1.line_2 from Addresses as T1 join ( select current_address_id from Students where current_address_id is not null union ALL select permanent_address_id from Students where permanent_address_id is not null ) on T1.address_id = T2.address_id group by T1.address_id order by count(T2.address_id) desc limit 1	student_transcripts_tracking
select datetime(avg(julianday(transcript_date))) from Transcripts	student_transcripts_tracking
select avg(transcript_date) from Transcripts	student_transcripts_tracking
select transcript_date, other_details from Transcripts order by transcript_date asc limit 1	student_transcripts_tracking
select * from Transcripts order by transcript_date asc limit 1	student_transcripts_tracking
select count(*) from Transcripts	student_transcripts_tracking
select count(transcript_id) from Transcripts	student_transcripts_tracking
select max(transcript_date) from Transcripts	student_transcripts_tracking
select max(transcript_date) from Transcripts	student_transcripts_tracking
select student_course_id, count(transcript_id) from Transcript_Contents group by student_course_id order by num_transcripts desc limit 1	student_transcripts_tracking
ite select count(T1.transcript_id), T2.student_enrolment_id from Transcript_Contents as T1 inner join Student_Enrolment_Courses as T2 on T1.student_course_id = T2.student_course_id group by T2.course_id order by count(T1.transcript_id) desc limit 1	student_transcripts_tracking
ite select T1.transcript_date, T1.transcript_id from Transcripts as T1 inner join Transcript_Contents as T2 on T1.transcript_id = T2.transcript_id group by T1.transcript_id order by count(T2.student_course_id) limit 1	student_transcripts_tracking
select T1.transcript_date, T1.transcript_id from Transcripts as T1 join Transcript_Contents as T2 on T1.transcript_id = T2.transcript_id group by T1.transcript_id order by count(T2.student_course_id) asc limit 1	student_transcripts_tracking
select T1.semester_name from Semesters as T1 join Student_Enrolment as T2 on T1.semester_id = T2.semester_id join Degree_Programs as T3 on T2.degree_program_id = T3.degree_program_id where T3.degree_summary_name like "%Master%" intersect select T1.semester_name from Semesters as T1 join Student_Enrolment as T2 on T1.semester_id = T2.semester_id join Degree_Programs as T3 on T2.degree_program_id = T3.degree_program_id where T3.degree_summary_name like "%Bachelor%"	student_transcripts_tracking
select T1.semester_id from Student_Enrolment as T1 inner join Degree_Programs as T2 on T1.degree_program_id = T2.degree_program_id where T2.degree_summary_name like "%Masters%" intersect select T1.semester_id from Student_Enrolment as T1 inner join Degree_Programs as T2 on T1.degree_program_id = T2.degree_program_id where T2.degree_summary_name like "%Bachelors%"	student_transcripts_tracking
select count(distinct current_address_id) from Students	student_transcripts_tracking
ite select distinct T1.* from Addresses as T1 join Students as T2 on T1.address_id = T2.current_address_id or T1.address_id = T2.permanent_address_id	student_transcripts_tracking
select * from Students order by first_name desc, last_name desc	student_transcripts_tracking
select other_student_details from Students order by first_name desc	student_transcripts_tracking
select section_description from Sections where section_name = "h"	student_transcripts_tracking
select section_description from Sections where section_name = "h"	student_transcripts_tracking
select T1.first_name from Students as T1 inner join Addresses as T2 on T1.permanent_address_id = T2.address_id where T2.country = "Haiti" or T1.cell_mobile_number = "09700166582"	student_transcripts_tracking
select T1.first_name from Students as T1 inner join Addresses as T2 on T1.permanent_address_id = T2.address_id where T2.country = "Haiti" or T1.cell_mobile_number = "09700166582"	student_transcripts_tracking
